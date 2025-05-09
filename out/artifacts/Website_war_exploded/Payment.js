const express = require('express');
const multer = require('multer');
const path = require('path');
const app = express();

// Configure multer for file upload
const storage = multer.diskStorage({
    destination: './uploads/',
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});

const upload = multer({ storage: storage });

// Simple in-memory storage (replace with database in production)
const payments = [];
const notifications = [];

// Middleware
app.use(express.json());
app.use(express.static('public')); // Serve frontend files

// Upload endpoint
app.post('/upload', upload.single('slip'), (req, res) => {
    const paymentData = {
        email: req.body.email,
        bikeId: req.body.bikeId,
        name: req.body.name,
        note: req.body.note,
        slipPath: req.file.path,
        status: 'pending',
        timestamp: new Date()
    };

    payments.push(paymentData);

    // Simulate sending notification to bike owner
    notifications.push({
        bikeId: req.body.bikeId,
        message: `New payment slip from ${req.body.name} needs approval`
    });

    res.json({ success: true });
});

// Admin endpoint to get all payments
app.get('/admin/payments', (req, res) => {
    res.json(payments);
});

// Bike owner endpoint to get notifications
app.get('/notifications/:bikeId', (req, res) => {
    const bikeNotifications = notifications.filter(n => n.bikeId === req.params.bikeId);
    res.json(bikeNotifications);
});

// Accept/Decline payment
app.post('/payment/:id/status', (req, res) => {
    const paymentId = req.params.id;
    const { status } = req.body; // 'accepted' or 'declined'

    const payment = payments[paymentId];
    if (payment) {
        payment.status = status;
        res.json({ success: true });
    } else {
        res.status(404).json({ error: 'Payment not found' });
    }
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});