const express = require('express');
const router = express.Router();
const Journal = require('../models/Journal');

// 1. IMPORT YANG BENAR: Panggil 'protect' menggunakan kurung kurawal
const { protect } = require('../middleware/authMiddleware'); 

// 2. Gunakan 'protect' sebagai middleware di setiap rute
router.get('/', protect, async (req, res) => {
    try {
        const journals = await Journal.find({ userId: req.user.id }); 
        res.status(200).json({ data: journals });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

router.post('/', protect, async (req, res) => {
    try {
        const { bookTitle, review, rating, bookId } = req.body;
        const newJournal = new Journal({
            userId: req.user.id, 
            bookTitle: bookTitle,
            review: review,
            rating: rating || 5,
            bookId: bookId || 'default-id'
        });

        const savedJournal = await newJournal.save();
        res.status(201).json(savedJournal);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;