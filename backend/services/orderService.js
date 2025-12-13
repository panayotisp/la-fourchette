const { getConnection, sql } = require('../config/database');

/**
 * Create a new order
 */
async function createOrder(orderData) {
    const pool = await getConnection();

    const result = await pool.request()
        .input('user_email', sql.NVarChar(255), orderData.user_email)
        .input('user_name', sql.NVarChar(100), orderData.user_name)
        .input('user_surname', sql.NVarChar(100), orderData.user_surname)
        .input('schedule_id', sql.UniqueIdentifier, orderData.schedule_id)
        .input('quantity', sql.Int, orderData.quantity)
        .input('order_type', sql.VarChar(50), orderData.order_type || 'restaurant')
        .query(`
            INSERT INTO dbo.Menu_Orders (user_email, user_name, user_surname, schedule_id, quantity, order_type)
            OUTPUT INSERTED.*
            VALUES (@user_email, @user_name, @user_surname, @schedule_id, @quantity, @order_type)
        `);

    return result.recordset[0];
}

/**
 * Get orders for a specific user
 */
async function getOrdersByUser(userEmail) {
    const pool = await getConnection();

    const result = await pool.request()
        .input('user_email', sql.NVarChar(255), userEmail)
        .query(`
            SELECT 
                o.id,
                o.user_email,
                o.user_name,
                o.user_surname,
                o.quantity,
                o.order_type,
                o.status,
                o.created_at,
                s.date as menu_date,
                s.price,
                c.name as food_name,
                c.name_en as food_name_en,
                c.image_url
            FROM dbo.Menu_Orders o
            JOIN dbo.Menu_Schedule s ON o.schedule_id = s.id
            JOIN dbo.Menu_Catalog c ON s.food_item_id = c.id
            WHERE o.user_email = @user_email
              AND o.status = 'confirmed'
            ORDER BY s.date, o.created_at
        `);

    return result.recordset;
}

/**
 * Update order quantity
 */
async function updateOrder(orderId, quantity) {
    const pool = await getConnection();

    const result = await pool.request()
        .input('order_id', sql.UniqueIdentifier, orderId)
        .input('quantity', sql.Int, quantity)
        .query(`
            UPDATE dbo.Menu_Orders
            SET quantity = @quantity
            OUTPUT INSERTED.*
            WHERE id = @order_id
        `);

    return result.recordset[0];
}

/**
 * Cancel an order
 */
async function cancelOrder(orderId) {
    const pool = await getConnection();

    const result = await pool.request()
        .input('order_id', sql.UniqueIdentifier, orderId)
        .query(`
            UPDATE dbo.Menu_Orders
            SET status = 'cancelled'
            OUTPUT INSERTED.*
            WHERE id = @order_id
        `);

    return result.recordset[0];
}

/**
 * Delete an order (alternative to cancel)
 */
async function deleteOrder(orderId) {
    const pool = await getConnection();

    await pool.request()
        .input('order_id', sql.UniqueIdentifier, orderId)
        .query(`DELETE FROM dbo.Menu_Orders WHERE id = @order_id`);

    return { success: true };
}

module.exports = {
    createOrder,
    getOrdersByUser,
    updateOrder,
    cancelOrder,
    deleteOrder
};
