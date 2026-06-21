const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: [true, 'Email wajib diisi'],
    unique: true, // Tidak boleh ada email ganda
    trim: true,
    lowercase: true, // Otomatis mengubah huruf besar jadi kecil (misal: Budi@gmail.com -> budi@gmail.com)
    match: [/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/, 'Format email tidak valid!'] // <-- INI KUNCI VALIDASINYA
  },
  password: {
    type: String,
    required: true,
  }
}, { timestamps: true }); // Otomatis menambah 'createdAt' dan 'updatedAt'

module.exports = mongoose.model('User', userSchema);