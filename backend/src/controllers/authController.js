const authService = require('../services/authService');
const asyncHandler = require('../utils/asyncHandler');

const register = asyncHandler(async (req, res) => {
  const { email, password, displayName } = req.body;
  const result = await authService.register({ email, password, displayName });
  res.status(201).json({ success: true, data: result });
});

const login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  const result = await authService.login({ email, password });
  res.status(200).json({ success: true, data: result });
});

const getProfile = asyncHandler(async (req, res) => {
  const user = await authService.getProfile(req.userId);
  res.status(200).json({ success: true, data: user });
});

module.exports = { register, login, getProfile };
