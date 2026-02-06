const express = require('express');
const router = express.Router();
const progressController = require('../controllers/progressController');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');
const { submitAnswerValidator } = require('../validators/progressValidator');

router.post('/submit-answer', auth, validate(submitAnswerValidator), progressController.submitAnswer);
router.get('/course/:courseId', auth, progressController.getUserProgress);
router.post('/refill-hearts', auth, progressController.refillHearts);

module.exports = router;
