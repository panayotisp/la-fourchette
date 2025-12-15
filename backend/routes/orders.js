const express = require('express');
const orderService = require('../services/orderService');

const router = express.Router();

/**
 * POST /api/orders
 * Create a new order
 */
router.post('/', async (req, res) => {
    try {
        const { user_email, user_name, user_surname, schedule_id, quantity, order_type } = req.body;

        if (!user_email || !user_name || !user_surname || !schedule_id) {
            return res.status(400).json({
                error: 'Missing required fields: user_email, user_name, user_surname, schedule_id'
            });
        }

        const order = await orderService.createOrder({
            user_email,
            user_name,
            user_surname,
            schedule_id,
            quantity: quantity || 1,
            order_type: order_type || 'restaurant'
        });

        res.status(201).json(order);
    } catch (error) {
        console.error('Error creating order:', error);
        res.status(500).json({ error: error.message });
    }
});

/**
 * GET /api/orders?user_email=user@example.com
 * Get all orders for a user
 */
router.get('/', async (req, res) => {
    try {
        const { user_email } = req.query;

        if (!user_email) {
            return res.status(400).json({ error: 'user_email parameter is required' });
        }

        const orders = await orderService.getOrdersByUser(user_email);
        res.json(orders);
    } catch (error) {
        console.error('Error fetching orders:', error);
        res.status(500).json({ error: error.message });
    }
});

/**
 * PATCH /api/orders/:id
 * Update order (quantity or order_type)
 */
router.patch('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { quantity, order_type } = req.body;

        if (quantity === undefined && order_type === undefined) {
            return res.status(400).json({ error: 'At least one field (quantity, order_type) is required' });
        }

        const updates = {};
        if (quantity !== undefined) updates.quantity = quantity;
        if (order_type !== undefined) {
            updates.order_type = order_type;
        }

        const order = await orderService.updateOrder(id, updates);
        res.json(order);
    } catch (error) {
        console.error('Error updating order:', error);
        res.status(500).json({ error: error.message });
    }
});

/**
 * DELETE /api/orders/:id
 * Delete an order
 */
router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        await orderService.deleteOrder(id);
        res.json({ success: true, message: 'Order deleted successfully' });
    } catch (error) {
        console.error('Error deleting order:', error);
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
