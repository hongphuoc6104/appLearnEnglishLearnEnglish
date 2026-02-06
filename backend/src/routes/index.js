const express = require('express');
const router = express.Router();

router.use('/auth', require('./auth'));
router.use('/courses', require('./courses'));
router.use('/lessons', require('./lessons'));
router.use('/progress', require('./progress'));
router.use('/leaderboard', require('./leaderboard'));

module.exports = router;
