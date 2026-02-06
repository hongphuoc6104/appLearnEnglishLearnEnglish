const User = require('../models/User');
const asyncHandler = require('../utils/asyncHandler');

const getLeaderboard = asyncHandler(async (req, res) => {
  const limit = Math.min(parseInt(req.query.limit) || 20, 100);
  const users = await User.find()
    .sort({ xp: -1 })
    .limit(limit)
    .select('displayName xp level streak');

  const leaderboard = users.map((user, index) => ({
    rank: index + 1,
    ...user.toJSON(),
  }));

  res.status(200).json({ success: true, data: leaderboard });
});

module.exports = { getLeaderboard };
