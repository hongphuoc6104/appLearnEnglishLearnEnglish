const User = require('../models/User');
const ApiError = require('../utils/ApiError');

const XP_PER_CORRECT = 10;
const XP_LESSON_BONUS = 50;
const MAX_HEARTS = 5;
const HEART_REFILL_COST = 50;
const XP_PER_LEVEL = 500;

const calculateLevel = (xp) => Math.floor(xp / XP_PER_LEVEL) + 1;

const isYesterday = (date) => {
  if (!date) return false;
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  return (
    date.getFullYear() === yesterday.getFullYear() &&
    date.getMonth() === yesterday.getMonth() &&
    date.getDate() === yesterday.getDate()
  );
};

const isToday = (date) => {
  if (!date) return false;
  const today = new Date();
  return (
    date.getFullYear() === today.getFullYear() &&
    date.getMonth() === today.getMonth() &&
    date.getDate() === today.getDate()
  );
};

const awardXP = async (userId, amount) => {
  const user = await User.findById(userId);
  if (!user) throw ApiError.notFound('User not found');

  user.xp += amount;
  user.level = calculateLevel(user.xp);
  await user.save();

  return { xp: user.xp, level: user.level };
};

const deductHeart = async (userId) => {
  const user = await User.findById(userId);
  if (!user) throw ApiError.notFound('User not found');

  if (user.hearts <= 0) {
    throw ApiError.badRequest('No hearts remaining. Wait for refill or spend XP.');
  }

  user.hearts = Math.max(0, user.hearts - 1);
  await user.save();

  return { hearts: user.hearts };
};

const refillHearts = async (userId) => {
  const user = await User.findById(userId);
  if (!user) throw ApiError.notFound('User not found');

  if (user.hearts >= MAX_HEARTS) {
    throw ApiError.badRequest('Hearts are already full');
  }

  if (user.xp < HEART_REFILL_COST) {
    throw ApiError.badRequest(`Need at least ${HEART_REFILL_COST} XP to refill hearts. Current: ${user.xp}`);
  }

  user.xp -= HEART_REFILL_COST;
  user.hearts = MAX_HEARTS;
  user.level = calculateLevel(user.xp);
  await user.save();

  return { xp: user.xp, hearts: user.hearts, level: user.level };
};

const updateStreak = async (userId) => {
  const user = await User.findById(userId);
  if (!user) throw ApiError.notFound('User not found');

  const now = new Date();

  if (isToday(user.lastActivityDate)) {
    // Already active today, no streak change
    return { streak: user.streak };
  }

  if (isYesterday(user.lastActivityDate)) {
    user.streak += 1;
  } else {
    // Streak broken or first activity
    user.streak = 1;
  }

  user.lastActivityDate = now;
  await user.save();

  return { streak: user.streak };
};

const processCorrectAnswer = async (userId) => {
  const user = await User.findById(userId);
  if (!user) throw ApiError.notFound('User not found');

  user.xp += XP_PER_CORRECT;
  user.level = calculateLevel(user.xp);
  await user.save();

  return { xp: user.xp, hearts: user.hearts, level: user.level };
};

const processWrongAnswer = async (userId) => {
  const user = await User.findById(userId);
  if (!user) throw ApiError.notFound('User not found');

  if (user.hearts <= 0) {
    throw ApiError.badRequest('No hearts remaining');
  }

  user.hearts = Math.max(0, user.hearts - 1);
  await user.save();

  return { xp: user.xp, hearts: user.hearts, level: user.level };
};

const processLessonComplete = async (userId) => {
  const user = await User.findById(userId);
  if (!user) throw ApiError.notFound('User not found');

  user.xp += XP_LESSON_BONUS;
  user.level = calculateLevel(user.xp);

  // Update streak
  if (!isToday(user.lastActivityDate)) {
    if (isYesterday(user.lastActivityDate)) {
      user.streak += 1;
    } else {
      user.streak = 1;
    }
  }
  user.lastActivityDate = new Date();
  await user.save();

  return { xp: user.xp, hearts: user.hearts, level: user.level, streak: user.streak };
};

module.exports = {
  XP_PER_CORRECT,
  XP_LESSON_BONUS,
  MAX_HEARTS,
  HEART_REFILL_COST,
  XP_PER_LEVEL,
  calculateLevel,
  awardXP,
  deductHeart,
  refillHearts,
  updateStreak,
  processCorrectAnswer,
  processWrongAnswer,
  processLessonComplete,
};
