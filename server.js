const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const connectDB = require('./config/db');

// Muat variabel dari .env
dotenv.config();

// Konek ke MongoDB
connectDB();

const app = express();

// Middleware dasar
app.use(cors());
app.use(express.json()); // Agar bisa menerima body berformat JSON dari Flutter

app.get('/', (req, res) => {
  res.send('API PustakaSiswa Backend Berjalan!');
});

// --- RUTE API ---
const authRoutes = require('./routes/auth');
app.use('/auth', authRoutes); 

const journalRoutes = require('./routes/journal'); // Pastikan file ./routes/journal.js sudah ada
app.use('/journals', journalRoutes);
// ----------------

// Bikin variabel PORT dulu, baru jalankan app.listen
const PORT = process.env.PORT || 3000;

// Tambahkan '0.0.0.0' agar backend bisa diakses oleh emulator Android
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server nyala di port ${PORT}`);
});