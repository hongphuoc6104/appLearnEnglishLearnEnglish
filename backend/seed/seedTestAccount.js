require('dotenv').config();
const mongoose = require('mongoose');
const env = require('../src/config/env');
const User = require('../src/models/User');
const Course = require('../src/models/Course');
const Unit = require('../src/models/Unit');
const Lesson = require('../src/models/Lesson');
const UserProgress = require('../src/models/UserProgress');
const ChallengeProgress = require('../src/models/ChallengeProgress');
const Challenge = require('../src/models/Challenge');

const TEST_EMAIL = 'tester@learnapp.com';
const TEST_PASSWORD = 'Test@123456';
const TEST_NAME = 'QA Tester';

const seedTestAccount = async () => {
  try {
    await mongoose.connect(env.mongoUri);
    console.log('Connected to MongoDB...');

    // Remove old test account if exists
    const existing = await User.findOne({ email: TEST_EMAIL });
    if (existing) {
      await ChallengeProgress.deleteMany({ userId: existing._id });
      await UserProgress.deleteMany({ userId: existing._id });
      await User.deleteOne({ _id: existing._id });
      console.log('Removed existing test account');
    }

    // Create test user with high XP and full hearts
    const user = await User.create({
      email: TEST_EMAIL,
      passwordHash: TEST_PASSWORD,
      displayName: TEST_NAME,
      xp: 5000,
      hearts: 5,
      streak: 30,
      level: 11,
      lastActivityDate: new Date(),
    });
    console.log(`Created test user: ${TEST_EMAIL} / ${TEST_PASSWORD}`);

    // Get all courses, units, lessons, and challenges
    const courses = await Course.find();
    const units = await Unit.find();
    const lessons = await Lesson.find();
    const challenges = await Challenge.find();

    // Mark all challenges as completed for the test user
    const challengeProgressDocs = challenges.map((c) => ({
      userId: user._id,
      challengeId: c._id,
      completed: true,
      attempts: 1,
      accuracy: 100,
      lastAttemptDate: new Date(),
    }));
    if (challengeProgressDocs.length > 0) {
      await ChallengeProgress.insertMany(challengeProgressDocs);
      console.log(`Marked ${challengeProgressDocs.length} challenges as completed`);
    }

    // Create user progress for each course with all lessons/units completed
    for (const course of courses) {
      const courseUnits = units.filter((u) => u.courseId.toString() === course._id.toString());
      const courseLessons = lessons.filter((l) =>
        courseUnits.some((u) => u._id.toString() === l.unitId.toString())
      );

      await UserProgress.create({
        userId: user._id,
        courseId: course._id,
        completedLessons: courseLessons.map((l) => l._id),
        completedUnits: courseUnits.map((u) => u._id),
      });
      console.log(`Completed all progress for course: ${course.title}`);
    }

    console.log('\n========================================');
    console.log('  TEST ACCOUNT CREATED SUCCESSFULLY');
    console.log('========================================');
    console.log(`  Email:    ${TEST_EMAIL}`);
    console.log(`  Password: ${TEST_PASSWORD}`);
    console.log(`  XP:       ${user.xp}`);
    console.log(`  Level:    ${user.level}`);
    console.log(`  Hearts:   ${user.hearts}/5`);
    console.log(`  Streak:   ${user.streak} days`);
    console.log('  Status:   All lessons & challenges UNLOCKED');
    console.log('========================================\n');

    await mongoose.disconnect();
    process.exit(0);
  } catch (error) {
    console.error('Error creating test account:', error);
    process.exit(1);
  }
};

seedTestAccount();
