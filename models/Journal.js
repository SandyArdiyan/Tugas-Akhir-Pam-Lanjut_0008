const mongoose = require('mongoose');

const journalSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: false // Agar tidak error saat simpan tanpa ID user
  },
  bookId: {
    type: String,
    required: false, // Agar tidak error saat simpan tanpa ID buku
  },
  bookTitle: {
    type: String,
    required: true,
  },
  review: {
    type: String,
    required: true,
  },
  rating: {
    type: Number,
    required: true,
    min: 1,
    max: 5
  }
}, { timestamps: true });

module.exports = mongoose.model('Journal', journalSchema);