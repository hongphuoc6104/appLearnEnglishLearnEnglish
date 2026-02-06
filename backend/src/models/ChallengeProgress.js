const mongoose = require('mongoose');

const challengeProgressSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  challengeId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Challenge',
    required: true,
  },
  completed: { type: Boolean, default: false },
  attempts: { type: Number, default: 0 },
  accuracy: { type: Number, default: 0, min: 0, max: 100 },
  lastAttemptDate: { type: Date, default: Date.now },
}, {
  timestamps: true,
  toJSON: {
    transform(doc, ret) {
      ret.id = ret._id;
      delete ret._id;
      delete ret.__v;
      return ret;
    },
  },
});

challengeProgressSchema.index({ userId: 1, challengeId: 1 }, { unique: true });

module.exports = mongoose.model('ChallengeProgress', challengeProgressSchema);
