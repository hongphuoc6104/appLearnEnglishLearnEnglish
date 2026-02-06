const Lesson = require('../models/Lesson');
const Challenge = require('../models/Challenge');
const asyncHandler = require('../utils/asyncHandler');
const ApiError = require('../utils/ApiError');

const getLessonById = asyncHandler(async (req, res) => {
  const lesson = await Lesson.findById(req.params.id);
  if (!lesson) {
    throw ApiError.notFound('Lesson not found');
  }

  const challenges = await Challenge.find({ lessonId: lesson._id }).sort({ order: 1 });
  res.status(200).json({
    success: true,
    data: { ...lesson.toJSON(), challenges },
  });
});

const getChallengesByLesson = asyncHandler(async (req, res) => {
  const challenges = await Challenge.find({ lessonId: req.params.id }).sort({ order: 1 });
  res.status(200).json({ success: true, data: challenges });
});

module.exports = { getLessonById, getChallengesByLesson };
