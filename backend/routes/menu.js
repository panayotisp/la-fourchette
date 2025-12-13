const express = require('express');
const menuService = require('../services/menuService');

const router = express.Router();

/**
 * GET /api/menu/week?date=2024-12-13
 * Get weekly menu starting from the specified date
 */
router.get('/week', async (req, res) => {
    try {
        const dateParam = req.query.date;

        if (!dateParam) {
            return res.status(400).json({ error: 'Date parameter is required' });
        }

        const requestedDate = new Date(dateParam);

        // Calculate Monday of that week
        const dayOfWeek = requestedDate.getDay();
        const monday = new Date(requestedDate);
        monday.setDate(requestedDate.getDate() - (dayOfWeek === 0 ? 6 : dayOfWeek - 1));

        const menuData = await menuService.getWeeklyMenu(monday);

        res.json({
            week_start: monday.toISOString().split('T')[0],
            days: menuData
        });
    } catch (error) {
        console.error('Error fetching weekly menu:', error);
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
