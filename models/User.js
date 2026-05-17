const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true, // Tidak boleh ada email ganda
    trim: true,
  },
  password: {
    type: String,
    required: true,
  }
}, { timestamps: true }); // Otomatis menambah 'createdAt' dan 'updatedAt'

module.exports = mongoose.model('User', userSchema);