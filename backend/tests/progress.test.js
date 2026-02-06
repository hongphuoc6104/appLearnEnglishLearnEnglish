require('./setup');
const request = require('supertest');
const app = require('../src/app');
const { createTestUser, createTestCourse } = require('./helpers');

describe('Progress API', () => {
  let token, userId;

  beforeEach(async () => {
    const testUser = await createTestUser();
    token = testUser.token;
    userId = testUser.user._id;
  });

  describe('POST /api/progress/submit-answer', () => {
    it('should process correct answer and award XP', async () => {
      const { challenges } = await createTestCourse();

      const res = await request(app)
        .post('/api/progress/submit-answer')
        .set('Authorization', `Bearer ${token}`)
        .send({
          challengeId: challenges[0]._id.toString(),
          answer: '2',
        });

      expect(res.status).toBe(200);
      expect(res.body.data.isCorrect).toBe(true);
      expect(res.body.data.xp).toBe(10);
    });

    it('should process wrong answer and deduct heart', async () => {
      const { challenges } = await createTestCourse();

      const res = await request(app)
        .post('/api/progress/submit-answer')
        .set('Authorization', `Bearer ${token}`)
        .send({
          challengeId: challenges[0]._id.toString(),
          answer: 'wrong',
        });

      expect(res.status).toBe(200);
      expect(res.body.data.isCorrect).toBe(false);
      expect(res.body.data.hearts).toBe(4);
    });

    it('should reject without authentication', async () => {
      const { challenges } = await createTestCourse();

      const res = await request(app)
        .post('/api/progress/submit-answer')
        .send({
          challengeId: challenges[0]._id.toString(),
          answer: '2',
        });

      expect(res.status).toBe(401);
    });
  });

  describe('GET /api/progress/course/:courseId', () => {
    it('should return empty progress for new user', async () => {
      const { course } = await createTestCourse();

      const res = await request(app)
        .get(`/api/progress/course/${course._id}`)
        .set('Authorization', `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data.completedLessons).toHaveLength(0);
    });
  });

  describe('POST /api/progress/refill-hearts', () => {
    it('should refill hearts with enough XP', async () => {
      const User = require('../src/models/User');
      await User.findByIdAndUpdate(userId, { xp: 100, hearts: 2 });

      const res = await request(app)
        .post('/api/progress/refill-hearts')
        .set('Authorization', `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data.hearts).toBe(5);
      expect(res.body.data.xp).toBe(50);
    });
  });
});
