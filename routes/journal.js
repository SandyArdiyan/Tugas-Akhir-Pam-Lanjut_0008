const express = require('express');
const router = express.Router();
const Journal = require('../models/Journal');

router.get('/', async (req, res) => {
    try {
        const journals = await Journal.find();
        res.status(200).json({ data: journals });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

router.post('/', async (req, res) => {
    try {
        const { bookTitle, review, rating, bookId } = req.body;
        const newJournal = new Journal({
            bookTitle: bookTitle,
            review: review,
            rating: rating || 5,
            bookId: bookId || 'default-id' // ID cadangan
        });

        const savedJournal = await newJournal.save();
        res.status(201).json(savedJournal);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;