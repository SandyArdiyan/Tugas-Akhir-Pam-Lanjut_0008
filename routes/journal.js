const express = require('express');
const router = express.Router();
const Journal = require('../models/Journal');

// GET dengan proteksi agar tidak crash jika data kosong
router.get('/', async (req, res) => {
    try {
        const journals = await Journal.find();
        res.status(200).json({ data: journals || [] });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// POST dengan validasi data
router.post('/', async (req, res) => {
    const journal = new Journal({
        bookTitle: req.body.bookTitle || 'Tanpa Judul',
        review: req.body.review || '',
        rating: req.body.rating || 5
    });

    try {
        const newJournal = await journal.save();
        res.status(201).json(newJournal);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

module.exports = router;