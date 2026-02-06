require('dotenv').config();
const mongoose = require('mongoose');
const env = require('../src/config/env');
const Course = require('../src/models/Course');
const Unit = require('../src/models/Unit');
const Lesson = require('../src/models/Lesson');
const Challenge = require('../src/models/Challenge');

const seedData = async () => {
  try {
    await mongoose.connect(env.mongoUri);
    console.log('Connected to MongoDB for seeding...');

    // Clear existing data
    await Promise.all([
      Course.deleteMany({}),
      Unit.deleteMany({}),
      Lesson.deleteMany({}),
      Challenge.deleteMany({}),
    ]);
    console.log('Cleared existing data');

    // Create Course
    const course = await Course.create({
      title: 'English Basics',
      description: 'Learn fundamental English skills through interactive lessons',
      language: 'en',
      difficulty: 'beginner',
      imageUrl: '',
    });
    console.log('Created course:', course.title);

    // Unit 1: Greetings
    const unit1 = await Unit.create({
      courseId: course._id,
      title: 'Greetings & Introductions',
      description: 'Learn how to greet people and introduce yourself',
      order: 1,
    });

    // Unit 2: Daily Life
    const unit2 = await Unit.create({
      courseId: course._id,
      title: 'Daily Life',
      description: 'Talk about your daily routine and activities',
      order: 2,
    });

    // Unit 3: Travel
    const unit3 = await Unit.create({
      courseId: course._id,
      title: 'Travel & Directions',
      description: 'Navigate and communicate while traveling',
      order: 3,
    });
    console.log('Created 3 units');

    // ----- UNIT 1 LESSONS -----

    // Lesson 1.1: Basic Greetings (Reading)
    const lesson1_1 = await Lesson.create({
      unitId: unit1._id,
      title: 'Basic Greetings',
      order: 1,
      type: 'reading',
      xpReward: 50,
    });

    await Challenge.insertMany([
      {
        lessonId: lesson1_1._id,
        type: 'SELECT',
        question: 'What is the correct way to greet someone in the morning?',
        options: ['Good morning', 'Good night', 'Goodbye', 'See you later'],
        correctAnswer: 'Good morning',
        order: 1,
      },
      {
        lessonId: lesson1_1._id,
        type: 'SELECT',
        question: 'Which phrase means "How are you?"',
        options: ['How do you do?', 'What is your name?', 'Where are you from?', 'How old are you?'],
        correctAnswer: 'How do you do?',
        order: 2,
      },
      {
        lessonId: lesson1_1._id,
        type: 'FILL_BLANK',
        question: 'Nice to ___ you!',
        options: ['meet', 'see', 'know', 'have'],
        correctAnswer: 'meet',
        order: 3,
      },
      {
        lessonId: lesson1_1._id,
        type: 'ASSIST',
        question: 'Translate: "Xin chào" to English',
        options: ['Hello', 'Goodbye', 'Thank you', 'Sorry'],
        correctAnswer: 'Hello',
        order: 4,
      },
    ]);

    // Lesson 1.2: Introducing Yourself (Speaking)
    const lesson1_2 = await Lesson.create({
      unitId: unit1._id,
      title: 'Introducing Yourself',
      order: 2,
      type: 'speaking',
      xpReward: 50,
    });

    await Challenge.insertMany([
      {
        lessonId: lesson1_2._id,
        type: 'SPEAK',
        question: 'Say this sentence out loud:',
        targetText: 'My name is John and I am from Vietnam',
        correctAnswer: 'My name is John and I am from Vietnam',
        order: 1,
      },
      {
        lessonId: lesson1_2._id,
        type: 'SPEAK',
        question: 'Say this sentence out loud:',
        targetText: 'Nice to meet you. How are you today?',
        correctAnswer: 'Nice to meet you. How are you today?',
        order: 2,
      },
      {
        lessonId: lesson1_2._id,
        type: 'SPEAK',
        question: 'Say this sentence out loud:',
        targetText: 'I am a student and I love learning English',
        correctAnswer: 'I am a student and I love learning English',
        order: 3,
      },
    ]);

    // Lesson 1.3: Greetings Conversation (Listening)
    const lesson1_3 = await Lesson.create({
      unitId: unit1._id,
      title: 'Greetings Conversation',
      order: 3,
      type: 'listening',
      xpReward: 50,
    });

    await Challenge.insertMany([
      {
        lessonId: lesson1_3._id,
        type: 'LISTEN',
        question: 'What did the speaker say?',
        options: ['Good morning, how are you?', 'Good night, see you later', 'Hello, my name is', 'Goodbye, take care'],
        correctAnswer: 'Good morning, how are you?',
        order: 1,
      },
      {
        lessonId: lesson1_3._id,
        type: 'SELECT',
        question: 'When do you say "Good evening"?',
        options: ['After 5 PM', 'In the morning', 'At midnight', 'At noon'],
        correctAnswer: 'After 5 PM',
        order: 2,
      },
      {
        lessonId: lesson1_3._id,
        type: 'FILL_BLANK',
        question: 'See you ___! Have a great day.',
        options: ['later', 'morning', 'yesterday', 'never'],
        correctAnswer: 'later',
        order: 3,
      },
    ]);

    // ----- UNIT 2 LESSONS -----

    // Lesson 2.1: Daily Routine (Reading)
    const lesson2_1 = await Lesson.create({
      unitId: unit2._id,
      title: 'My Daily Routine',
      order: 1,
      type: 'reading',
      xpReward: 50,
    });

    await Challenge.insertMany([
      {
        lessonId: lesson2_1._id,
        type: 'SELECT',
        question: 'What do you usually do first in the morning?',
        options: ['Wake up', 'Go to bed', 'Eat dinner', 'Watch TV'],
        correctAnswer: 'Wake up',
        order: 1,
      },
      {
        lessonId: lesson2_1._id,
        type: 'FILL_BLANK',
        question: 'I ___ breakfast at 7 AM every morning.',
        options: ['eat', 'sleep', 'drive', 'sing'],
        correctAnswer: 'eat',
        order: 2,
      },
      {
        lessonId: lesson2_1._id,
        type: 'SELECT',
        question: 'Which word means "going to work"?',
        options: ['Commute', 'Sleep', 'Cook', 'Dance'],
        correctAnswer: 'Commute',
        order: 3,
      },
      {
        lessonId: lesson2_1._id,
        type: 'ARRANGE',
        question: 'Put in order: "school / I / to / go / every day"',
        options: ['I go to school every day'],
        correctAnswer: 'I go to school every day',
        order: 4,
      },
    ]);

    // Lesson 2.2: At School/Work (Writing)
    const lesson2_2 = await Lesson.create({
      unitId: unit2._id,
      title: 'At School and Work',
      order: 2,
      type: 'writing',
      xpReward: 50,
    });

    await Challenge.insertMany([
      {
        lessonId: lesson2_2._id,
        type: 'WRITE',
        question: 'Write a sentence about what you do at school or work.',
        correctAnswer: 'I study English at school',
        targetText: 'Write at least 5 words about your school or work activities.',
        order: 1,
      },
      {
        lessonId: lesson2_2._id,
        type: 'FILL_BLANK',
        question: 'I ___ English every Monday and Wednesday.',
        options: ['study', 'fly', 'swim', 'build'],
        correctAnswer: 'study',
        order: 2,
      },
      {
        lessonId: lesson2_2._id,
        type: 'SELECT',
        question: 'What does "homework" mean?',
        options: ['Work done at home for school', 'Building a house', 'Cleaning the house', 'Going home'],
        correctAnswer: 'Work done at home for school',
        order: 3,
      },
    ]);

    // ----- UNIT 3 LESSONS -----

    // Lesson 3.1: At the Airport (Reading)
    const lesson3_1 = await Lesson.create({
      unitId: unit3._id,
      title: 'At the Airport',
      order: 1,
      type: 'reading',
      xpReward: 50,
    });

    await Challenge.insertMany([
      {
        lessonId: lesson3_1._id,
        type: 'SELECT',
        question: 'What do you need to show at the airport?',
        options: ['Passport', 'Library card', 'Shopping list', 'Recipe'],
        correctAnswer: 'Passport',
        order: 1,
      },
      {
        lessonId: lesson3_1._id,
        type: 'FILL_BLANK',
        question: 'The ___ will depart at 3 PM from gate B5.',
        options: ['flight', 'boat', 'train', 'bicycle'],
        correctAnswer: 'flight',
        order: 2,
      },
      {
        lessonId: lesson3_1._id,
        type: 'SELECT',
        question: 'Where do you pick up your luggage?',
        options: ['Baggage claim', 'Boarding gate', 'Check-in counter', 'Security'],
        correctAnswer: 'Baggage claim',
        order: 3,
      },
    ]);

    // Lesson 3.2: Asking for Directions (Speaking)
    const lesson3_2 = await Lesson.create({
      unitId: unit3._id,
      title: 'Asking for Directions',
      order: 2,
      type: 'speaking',
      xpReward: 50,
    });

    await Challenge.insertMany([
      {
        lessonId: lesson3_2._id,
        type: 'SPEAK',
        question: 'Say this sentence out loud:',
        targetText: 'Excuse me, how do I get to the train station?',
        correctAnswer: 'Excuse me, how do I get to the train station?',
        order: 1,
      },
      {
        lessonId: lesson3_2._id,
        type: 'SPEAK',
        question: 'Say this sentence out loud:',
        targetText: 'Turn left at the intersection and go straight',
        correctAnswer: 'Turn left at the intersection and go straight',
        order: 2,
      },
      {
        lessonId: lesson3_2._id,
        type: 'SELECT',
        question: 'What does "Turn right" mean?',
        options: ['Go to the right side', 'Go to the left side', 'Go straight', 'Go back'],
        correctAnswer: 'Go to the right side',
        order: 3,
      },
    ]);

    // Lesson 3.3: Hotel Check-in (Mixed)
    const lesson3_3 = await Lesson.create({
      unitId: unit3._id,
      title: 'Hotel Check-in',
      order: 3,
      type: 'mixed',
      xpReward: 50,
    });

    await Challenge.insertMany([
      {
        lessonId: lesson3_3._id,
        type: 'SELECT',
        question: 'What do you say when arriving at a hotel?',
        options: ['I have a reservation', 'I want to fly', 'I need a doctor', 'I lost my phone'],
        correctAnswer: 'I have a reservation',
        order: 1,
      },
      {
        lessonId: lesson3_3._id,
        type: 'FILL_BLANK',
        question: 'Can I have the ___ to my room, please?',
        options: ['key', 'food', 'ticket', 'passport'],
        correctAnswer: 'key',
        order: 2,
      },
      {
        lessonId: lesson3_3._id,
        type: 'SPEAK',
        question: 'Say this sentence out loud:',
        targetText: 'I would like to check in please. My name is John.',
        correctAnswer: 'I would like to check in please. My name is John.',
        order: 3,
      },
      {
        lessonId: lesson3_3._id,
        type: 'WRITE',
        question: 'Write a sentence asking about the WiFi password at the hotel.',
        correctAnswer: 'What is the WiFi password?',
        targetText: 'Ask about the WiFi at the hotel.',
        order: 4,
      },
    ]);

    const totalLessons = await Lesson.countDocuments();
    const totalChallenges = await Challenge.countDocuments();
    console.log(`Seed data created successfully!`);
    console.log(`- 1 Course`);
    console.log(`- 3 Units`);
    console.log(`- ${totalLessons} Lessons`);
    console.log(`- ${totalChallenges} Challenges`);

    await mongoose.disconnect();
    console.log('Disconnected from MongoDB');
    process.exit(0);
  } catch (error) {
    console.error('Seeding error:', error);
    process.exit(1);
  }
};

seedData();
