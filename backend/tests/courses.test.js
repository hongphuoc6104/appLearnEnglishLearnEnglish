require('./setup');
const request = require('supertest');
const app = require('../src/app');
const { createTestUser, createTestCourse } = require('./helpers');

describe('Courses API', () => {
  let token;

  beforeEach(async () => {
    const testUser = await createTestUser();
    token = testUser.token;
  });

  describe('GET /api/courses', () => {
    it('should return list of courses', async () => {
      await createTestCourse();

      const res = await request(app)
        .get('/api/courses')
        .set('Authorization', `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data).toHaveLength(1);
      expect(res.body.data[0].title).toBe('Test Course');
    });

    it('should require authentication', async () => {
      const res = await request(app).get('/api/courses');
      expect(res.status).toBe(401);
    });
  });

  describe('GET /api/courses/:id', () => {
    it('should return course by ID', async () => {
      const { course } = await createTestCourse();

      const res = await request(app)
        .get(`/api/courses/${course._id}`)
        .set('Authorization', `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data.title).toBe('Test Course');
    });

    it('should return 404 for non-existent course', async () => {
      const fakeId = '507f1f77bcf86cd799439011';
      const res = await request(app)
        .get(`/api/courses/${fakeId}`)
        .set('Authorization', `Bearer ${token}`);

      expect(res.status).toBe(404);
    });
  });

  describe('GET /api/courses/:id/units', () => {
    it('should return units with lessons', async () => {
      const { course } = await createTestCourse();

      const res = await request(app)
        .get(`/api/courses/${course._id}/units`)
        .set('Authorization', `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveLength(1);
      expect(res.body.data[0].title).toBe('Test Unit');
      expect(res.body.data[0].lessons).toHaveLength(1);
    });
  });
});
