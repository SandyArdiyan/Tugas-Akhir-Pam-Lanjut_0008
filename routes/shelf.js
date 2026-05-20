const express = require('express');
const router = express.Router();
const Shelf = require('../models/Shelf');

router.get('/', async (req, res) => {
    try {
        const items = await Shelf.find();
        res.status(200).json({ data: items });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

router.post('/', async (req, res) => {
    try {
        // Menerima previewLink dari Flutter
        const { bookId, title, authors, thumbnail, previewLink, status } = req.body; 
        
        const existingBook = await Shelf.findOne({ bookId: bookId });
        if (existingBook) {
            return res.status(400).json({ message: 'Buku sudah ada di rak virtual!' });
        }

        // Menyimpan previewLink ke MongoDB
        const shelfItem = new Shelf({ bookId, title, authors, thumbnail, previewLink, status });
        const savedItem = await shelfItem.save();
        res.status(201).json(savedItem);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

router.delete('/:id', async (req, res) => {
    try {
        await Shelf.findByIdAndDelete(req.params.id);
        res.status(200).json({ message: 'Buku berhasil dihapus dari rak!' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;