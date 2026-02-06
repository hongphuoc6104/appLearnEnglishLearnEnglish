const { body } = require('express-validator');

const submitAnswerValidator = [
  body('challengeId')
    .notEmpty()
    .withMessage('Challenge ID is required')
    .isMongoId()
    .withMessage('Invalid challenge ID'),
  body('answer')
    .notEmpty()
    .withMessage('Answer is required'),
  body('accuracy')
    .optional()
    .isFloat({ min: 0, max: 100 })
    .withMessage('Accuracy must be between 0 and 100'),
];

module.exports = { submitAnswerValidator };
