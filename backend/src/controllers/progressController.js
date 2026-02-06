const progressService = require('../services/progressService');
const gamificationService = require('../services/gamificationService');
const asyncHandler = require('../utils/asyncHandler');

const submitAnswer = asyncHandler(async (req, res) => {
  const { challengeId, answer, accuracy } = req.body;
  const result = await progressService.submitAnswer(req.userId, {
    challengeId,
    answer,
    accuracy,
  });
  res.status(200).json({ success: true, data: result });
});

const getUserProgress = asyncHandler(async (req, res) => {
  const progress = await progressService.getUserProgress(
    req.userId,
    req.params.courseId
  );
  res.status(200).json({ success: true, data: progress });
});

const refillHearts = asyncHandler(async (req, res) => {
  const result = await gamificationService.refillHearts(req.userId);
  res.status(200).json({ success: true, data: result });
});

module.exports = { submitAnswer, getUserProgress, refillHearts };
