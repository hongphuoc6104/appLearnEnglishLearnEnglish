const axios = require('axios');
const env = require('../config/env');
const ApiError = require('../utils/ApiError');

const aiClient = axios.create({
  baseURL: env.aiServiceUrl,
  timeout: 60000, // 60s for AI operations
});

const analyzeSpeech = async (audioBuffer, targetText) => {
  try {
    const FormData = require('form-data');
    const form = new FormData();
    form.append('audio', audioBuffer, { filename: 'recording.wav', contentType: 'audio/wav' });
    form.append('target_text', targetText);

    const response = await aiClient.post('/analyze-speech', form, {
      headers: form.getHeaders(),
    });
    return response.data;
  } catch (error) {
    if (error.response) {
      throw ApiError.badRequest(error.response.data.detail || 'Speech analysis failed');
    }
    throw ApiError.internal('AI service unavailable');
  }
};

const correctWriting = async (text, context = '') => {
  try {
    const response = await aiClient.post('/correct-writing', { text, context });
    return response.data;
  } catch (error) {
    if (error.response) {
      throw ApiError.badRequest(error.response.data.detail || 'Writing correction failed');
    }
    throw ApiError.internal('AI service unavailable');
  }
};

const generateQuiz = async ({ topic, type = 'mcq', count = 5, difficulty = 'intermediate' }) => {
  try {
    const response = await aiClient.post('/generate-quiz', { topic, type, count, difficulty });
    return response.data;
  } catch (error) {
    if (error.response) {
      throw ApiError.badRequest(error.response.data.detail || 'Quiz generation failed');
    }
    throw ApiError.internal('AI service unavailable');
  }
};

module.exports = { analyzeSpeech, correctWriting, generateQuiz };
