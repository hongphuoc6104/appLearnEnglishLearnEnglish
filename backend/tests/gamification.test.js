require('./setup');
const User = require('../src/models/User');
const gamificationService = require('../src/services/gamificationService');
const { createTestUser } = require('./helpers');

describe('Gamification Service', () => {
  describe('processCorrectAnswer', () => {
    it('should award 10 XP for correct answer', async () => {
      const { user } = await createTestUser();
      const result = await gamificationService.processCorrectAnswer(user._id);

      expect(result.xp).toBe(10);
      expect(result.level).toBe(1);
    });

    it('should level up at 500 XP', async () => {
      const { user } = await createTestUser();
      user.xp = 495;
      await user.save();

      const result = await gamificationService.processCorrectAnswer(user._id);
      expect(result.xp).toBe(505);
      expect(result.level).toBe(2);
    });
  });

  describe('processWrongAnswer', () => {
    it('should deduct 1 heart for wrong answer', async () => {
      const { user } = await createTestUser();
      const result = await gamificationService.processWrongAnswer(user._id);

      expect(result.hearts).toBe(4);
    });

    it('should throw error when no hearts remaining', async () => {
      const { user } = await createTestUser();
      user.hearts = 0;
      await user.save();

      await expect(
        gamificationService.processWrongAnswer(user._id)
      ).rejects.toThrow('No hearts remaining');
    });
  });

  describe('refillHearts', () => {
    it('should refill hearts and deduct 50 XP', async () => {
      const { user } = await createTestUser();
      user.xp = 100;
      user.hearts = 2;
      await user.save();

      const result = await gamificationService.refillHearts(user._id);
      expect(result.hearts).toBe(5);
      expect(result.xp).toBe(50);
    });

    it('should throw error if not enough XP', async () => {
      const { user } = await createTestUser();
      user.hearts = 2;
      user.xp = 10;
      await user.save();

      await expect(
        gamificationService.refillHearts(user._id)
      ).rejects.toThrow('Need at least 50 XP');
    });

    it('should throw error if hearts already full', async () => {
      const { user } = await createTestUser();
      user.xp = 100;
      await user.save();

      await expect(
        gamificationService.refillHearts(user._id)
      ).rejects.toThrow('Hearts are already full');
    });
  });

  describe('processLessonComplete', () => {
    it('should award 50 XP bonus and update streak', async () => {
      const { user } = await createTestUser();
      const result = await gamificationService.processLessonComplete(user._id);

      expect(result.xp).toBe(50);
      expect(result.streak).toBe(1);
    });

    it('should increment streak on consecutive days', async () => {
      const { user } = await createTestUser();
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      user.lastActivityDate = yesterday;
      user.streak = 3;
      await user.save();

      const result = await gamificationService.processLessonComplete(user._id);
      expect(result.streak).toBe(4);
    });

    it('should reset streak after missed day', async () => {
      const { user } = await createTestUser();
      const twoDaysAgo = new Date();
      twoDaysAgo.setDate(twoDaysAgo.getDate() - 3);
      user.lastActivityDate = twoDaysAgo;
      user.streak = 10;
      await user.save();

      const result = await gamificationService.processLessonComplete(user._id);
      expect(result.streak).toBe(1);
    });
  });

  describe('calculateLevel', () => {
    it('should calculate correct level', () => {
      expect(gamificationService.calculateLevel(0)).toBe(1);
      expect(gamificationService.calculateLevel(499)).toBe(1);
      expect(gamificationService.calculateLevel(500)).toBe(2);
      expect(gamificationService.calculateLevel(1000)).toBe(3);
      expect(gamificationService.calculateLevel(2500)).toBe(6);
    });
  });
});
