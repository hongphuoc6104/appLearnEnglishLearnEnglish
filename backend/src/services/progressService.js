const Challenge = require('../models/Challenge');
const ChallengeProgress = require('../models/ChallengeProgress');
const UserProgress = require('../models/UserProgress');
const Lesson = require('../models/Lesson');
const Unit = require('../models/Unit');
const gamificationService = require('./gamificationService');
const ApiError = require('../utils/ApiError');

const submitAnswer = async (userId, { challengeId, answer, accuracy }) => {
  const challenge = await Challenge.findById(challengeId);
  if (!challenge) {
    throw ApiError.notFound('Challenge not found');
  }

  const isCorrect = challenge.correctAnswer.toLowerCase().trim() === answer.toLowerCase().trim();

  // Update or create challenge progress
  let progress = await ChallengeProgress.findOne({ userId, challengeId });
  if (!progress) {
    progress = new ChallengeProgress({ userId, challengeId });
  }

  progress.attempts += 1;
  progress.lastAttemptDate = new Date();
  if (accuracy !== undefined) {
    progress.accuracy = accuracy;
  }

  let userStats;
  if (isCorrect) {
    progress.completed = true;
    userStats = await gamificationService.processCorrectAnswer(userId);
  } else {
    userStats = await gamificationService.processWrongAnswer(userId);
  }

  await progress.save();

  // Check if lesson is completed
  const lessonChallenges = await Challenge.find({ lessonId: challenge.lessonId });
  const completedChallenges = await ChallengeProgress.find({
    userId,
    challengeId: { $in: lessonChallenges.map((c) => c._id) },
    completed: true,
  });

  const lessonCompleted = completedChallenges.length >= lessonChallenges.length;

  if (lessonCompleted) {
    const bonusStats = await gamificationService.processLessonComplete(userId);
    userStats = bonusStats;

    // Update user progress
    const lesson = await Lesson.findById(challenge.lessonId);
    if (lesson) {
      let userProgress = await UserProgress.findOne({
        userId,
        courseId: (await Unit.findById(lesson.unitId))?.courseId,
      });

      if (!userProgress) {
        const unit = await Unit.findById(lesson.unitId);
        userProgress = new UserProgress({
          userId,
          courseId: unit.courseId,
        });
      }

      if (!userProgress.completedLessons.includes(challenge.lessonId)) {
        userProgress.completedLessons.push(challenge.lessonId);
      }

      // Check if unit is completed
      const unitLessons = await Lesson.find({ unitId: lesson.unitId });
      const allUnitLessonsCompleted = unitLessons.every((l) =>
        userProgress.completedLessons.some((cl) => cl.toString() === l._id.toString())
      );

      if (allUnitLessonsCompleted && !userProgress.completedUnits.includes(lesson.unitId)) {
        userProgress.completedUnits.push(lesson.unitId);
      }

      await userProgress.save();
    }
  }

  return {
    isCorrect,
    xp: userStats.xp,
    hearts: userStats.hearts,
    level: userStats.level,
    challengeCompleted: progress.completed,
    lessonCompleted,
  };
};

const getUserProgress = async (userId, courseId) => {
  let progress = await UserProgress.findOne({ userId, courseId });
  if (!progress) {
    progress = { completedLessons: [], completedUnits: [] };
  }
  return progress;
};

module.exports = { submitAnswer, getUserProgress };
