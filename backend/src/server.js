require('dotenv').config();

const app = require('./app');
const connectDB = require('./config/database');
const env = require('./config/env');

const start = async () => {
  await connectDB();

  app.listen(env.port, () => {
    console.log(`Backend server running on port ${env.port}`);
  });
};

start().catch((err) => {
  console.error('Failed to start server:', err);
  process.exit(1);
});
