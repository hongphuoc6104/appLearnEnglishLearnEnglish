const express = require('express');
const router = express.Router();
const lessonController = require('../controllers/lessonController');
const auth = require('../middleware/auth');

router.get('/:id', auth, lessonController.getLessonById);
router.get('/:id/challenges', auth, lessonController.getChallengesByLesson);

module.exports = router;
