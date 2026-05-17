const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

const router = express.Router();

// 1. API UNTUK REGISTER (DAFTAR AKUN BARU)
router.post('/register', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // Cek apakah email sudah pernah didaftarkan
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'Email sudah terdaftar!' });
    }

    // Acak (Hash) password agar aman di database
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Simpan user ke MongoDB
    const newUser = new User({ email, password: hashedPassword });
    await newUser.save();

    res.status(201).json({ message: 'Registrasi berhasil!' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// 2. API UNTUK LOGIN
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // Cari user di database
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Email tidak ditemukan!' });
    }

    // Cocokkan password yang diketik dengan password yang diacak di database
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Password salah!' });
    }

    // Jika benar, buatkan Tiket (Token JWT)
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '7d' });

    res.status(200).json({ token, message: 'Login berhasil!' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;