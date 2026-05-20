const jwt = require('jsonwebtoken');

const protect = (req, res, next) => {
    let token;

    // Memeriksa apakah token ada di header 'Authorization'
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
        try {
            token = req.headers.authorization.split(' ')[1];
            
            // Verifikasi token dengan secret key (pastikan sama dengan saat login)
            const decoded = jwt.verify(token, process.env.JWT_SECRET);
            
            // Simpan info user di req agar bisa dipakai di rute selanjutnya
            req.user = decoded;
            next(); // Lanjut ke proses berikutnya
        } catch (error) {
            res.status(401).json({ message: "Token tidak valid, akses ditolak!" });
        }
    }

    if (!token) {
        res.status(401).json({ message: "Tidak ada token, akses ditolak!" });
    }
};

module.exports = { protect };