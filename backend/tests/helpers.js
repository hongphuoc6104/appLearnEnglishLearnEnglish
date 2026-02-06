const User = require('../src/models/User');
const Course = require('../src/models/Course');
const Unit = require('../src/models/Unit');
const Lesson = require('../src/models/Lesson');
const Challenge = require('../src/models/Challenge');
const { generateToken } = require('../src/services/authService');

const createTestUser = async (overrides = {}) => {
  const userData = {
    email: 'test@example.com',
    passwordHash: 'password123',
    displayName: 'Test User',
    ...overrides,
  };
  const user = await User.create(userData);
  const token = generateToken(user._id);
  return { user, token };
};

const createTestCourse = async () => {
  const course = await Course.create({
    title: 'Test Course',
    description: 'A test course',
    language: 'en',
    difficulty: 'beginner',
  });

  const unit = await Unit.create({
    courseId: course._id,
    title: 'Test Unit',
    description: 'A test unit',
    order: 1,
  });

  const lesson = await Lesson.create({
    unitId: unit._id,
    title: 'Test Lesson',
    order: 1,
    type: 'reading',
    xpReward: 50,
  });

  const challenges = await Challenge.insertMany([
    {
      lessonId: lesson._id,
      type: 'SELECT',
      question: 'What is 1+1?',
      options: ['1', '2', '3', '4'],
      correctAnswer: '2',
      order: 1,
    },
    {
      lessonId: lesson._id,
      type: 'FILL_BLANK',
      question: 'The cat is on the ___',
      options: ['table', 'sky', 'water', 'fire'],
      correctAnswer: 'table',
      order: 2,
    },
  ]);

  return { course, unit, lesson, challenges };
};

module.exports = { createTestUser, createTestCourse };
