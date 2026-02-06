const express = require('express');
const router = express.Router();
const courseController = require('../controllers/courseController');
const auth = require('../middleware/auth');

router.get('/', auth, courseController.getAllCourses);
router.get('/:id', auth, courseController.getCourseById);
router.get('/:id/units', auth, courseController.getCourseUnits);

module.exports = router;
