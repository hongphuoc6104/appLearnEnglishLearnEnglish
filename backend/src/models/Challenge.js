const mongoose = require('mongoose');

const challengeSchema = new mongoose.Schema({
  lessonId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Lesson',
    required: true,
  },
  type: {
    type: String,
    enum: ['SELECT', 'ASSIST', 'LISTEN', 'SPEAK', 'FILL_BLANK', 'WRITE', 'ARRANGE'],
    required: true,
  },
  question: { type: String, required: true },
  options: [{ type: String }],
  correctAnswer: { type: String, required: true },
  audioUrl: { type: String, default: '' },
  targetText: { type: String, default: '' },
  order: { type: Number, required: true },
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

challengeSchema.index({ lessonId: 1, order: 1 });

module.exports = mongoose.model('Challenge', challengeSchema);
