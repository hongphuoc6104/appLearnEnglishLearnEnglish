const mongoose = require('mongoose');

const lessonSchema = new mongoose.Schema({
  unitId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Unit',
    required: true,
  },
  title: { type: String, required: true, trim: true },
  order: { type: Number, required: true },
  type: {
    type: String,
    enum: ['speaking', 'writing', 'reading', 'listening', 'mixed'],
    required: true,
  },
  xpReward: { type: Number, default: 50 },
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

lessonSchema.index({ unitId: 1, order: 1 });

module.exports = mongoose.model('Lesson', lessonSchema);
