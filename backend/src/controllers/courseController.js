const Course = require('../models/Course');
const Unit = require('../models/Unit');
const Lesson = require('../models/Lesson');
const asyncHandler = require('../utils/asyncHandler');
const ApiError = require('../utils/ApiError');

const getAllCourses = asyncHandler(async (req, res) => {
  const courses = await Course.find().sort({ createdAt: 1 });
  res.status(200).json({ success: true, data: courses });
});

const getCourseById = asyncHandler(async (req, res) => {
  const course = await Course.findById(req.params.id);
  if (!course) {
    throw ApiError.notFound('Course not found');
  }
  res.status(200).json({ success: true, data: course });
});

const getCourseUnits = asyncHandler(async (req, res) => {
  const units = await Unit.find({ courseId: req.params.id }).sort({ order: 1 });

  // Populate lessons for each unit
  const unitsWithLessons = await Promise.all(
    units.map(async (unit) => {
      const lessons = await Lesson.find({ unitId: unit._id }).sort({ order: 1 });
      return { ...unit.toJSON(), lessons };
    })
  );

  res.status(200).json({ success: true, data: unitsWithLessons });
});

module.exports = { getAllCourses, getCourseById, getCourseUnits };
