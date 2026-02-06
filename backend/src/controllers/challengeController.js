const Challenge = require('../models/Challenge');
const asyncHandler = require('../utils/asyncHandler');
const ApiError = require('../utils/ApiError');

const getChallengeById = asyncHandler(async (req, res) => {
  const challenge = await Challenge.findById(req.params.id);
  if (!challenge) {
    throw ApiError.notFound('Challenge not found');
  }
  res.status(200).json({ success: true, data: challenge });
});

module.exports = { getChallengeById };
