const express = require('express');
const router = express.Router();
const Shelf = require('../models/Shelf');

// 1. IMPORT YANG BENAR
const { protect } = require('../middleware/authMiddleware'); 

router.get('/', protect, async (req, res) => {
    try {
        const items = await Shelf.find({ userId: req.user.id });
        res.status(200).json({ data: items });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

router.post('/', protect, async (req, res) => {
    try {
        const { bookId, title, authors, thumbnail, previewLink, status } = req.body; 
        
        const existingBook = await Shelf.findOne({ bookId: bookId, userId: req.user.id });
        if (existingBook) {
            return res.status(400).json({ message: 'Buku sudah ada di rak virtual!' });
        }

        const shelfItem = new Shelf({ 
            userId: req.user.id, 
            bookId, title, authors, thumbnail, previewLink, status 
        });
        const savedItem = await shelfItem.save();
        res.status(201).json(savedItem);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

router.delete('/:id', protect, async (req, res) => {
    try {
        await Shelf.findOneAndDelete({ _id: req.params.id, userId: req.user.id });
        res.status(200).json({ message: 'Buku berhasil dihapus dari rak!' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;