const mongoose = require('mongoose');

const shelfSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: false 
  },
  bookId: { type: String, required: true },
  title: { type: String, required: true },
  authors: { type: String, default: 'Unknown Author' },
  thumbnail: { type: String, default: '' },
  previewLink: { type: String, default: '' }, // <-- TAMBAHAN UNTUK LINK BACA
  status: {
    type: String,
    enum: ['Ingin Dibaca', 'Sedang Dibaca', 'Selesai'],
    default: 'Ingin Dibaca'
  }
}, { timestamps: true });

module.exports = mongoose.model('Shelf', shelfSchema);