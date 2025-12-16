const { getConnection, sql } = require('../config/database');

/**
 * Create a new order
 */
async function createOrder(orderData) {
    const pool = await getConnection();

    // 1. Check if similar order exists
    const checkResult = await pool.request()
        .input('user_email', sql.NVarChar, orderData.user_email)
        .input('menu_item_id', sql.UniqueIdentifier, orderData.schedule_id) // Map schedule_id to menu_item_id
        .input('order_type', sql.NVarChar, orderData.order_type)
        .query(`
            SELECT id, quantity 
            FROM dbo.Orders 
            WHERE user_email = @user_email 
              AND menu_item_id = @menu_item_id 
              AND order_type = @order_type 
              AND status = 'cart'
        `);

    if (checkResult.recordset.length > 0) {
        // 2. Update existing: Merge logic
        const existingOrder = checkResult.recordset[0];
        const newQuantity = existingOrder.quantity + (orderData.quantity || 1);

        await pool.request()
            .input('id', sql.UniqueIdentifier, existingOrder.id)
            .input('quantity', sql.Int, newQuantity)
            .query(`UPDATE dbo.Orders SET quantity = @quantity WHERE id = @id`);

        return {
            id: existingOrder.id,
            ...orderData,
            quantity: newQuantity,
            status: 'cart'
        };
    } else {
        // 3. Insert new: Existing logic
        const result = await pool.request()
            .input('user_email', sql.NVarChar, orderData.user_email)
            .input('user_name', sql.NVarChar, orderData.user_name)
            .input('user_surname', sql.NVarChar, orderData.user_surname)
            .input('menu_item_id', sql.UniqueIdentifier, orderData.schedule_id)
            .input('quantity', sql.Int, orderData.quantity)
            .input('order_type', sql.NVarChar, orderData.order_type)
            .input('status', sql.NVarChar, 'cart')
            .query(`
                INSERT INTO dbo.Orders (user_email, user_name, user_surname, menu_item_id, quantity, order_type, status)
                OUTPUT INSERTED.id
                VALUES (@user_email, @user_name, @user_surname, @menu_item_id, @quantity, @order_type, @status)
            `);

        return result.recordset[0];
    }
}

async function getOrdersByUser(userEmail) {
    const pool = await getConnection();

    // Auto-cleanup: Delete 'cart' items from the past
    await pool.request()
        .input('user_email_del', sql.NVarChar, userEmail)
        .query(`
            DELETE o
            FROM dbo.Orders o
            JOIN dbo.WeekMenu w ON o.menu_item_id = w.id
            WHERE o.user_email = @user_email_del
              AND o.status = 'cart'
              AND w.date < CAST(GETDATE() AS DATE)
        `);

    const result = await pool.request()
        .input('user_email', sql.NVarChar, userEmail)
        .query(`
            SELECT 
                o.id,
                o.user_email,
                o.user_name,
                o.user_surname,
                o.menu_item_id as schedule_id,
                o.quantity,
                o.order_type,
                o.status,
                o.created_at,
                w.date as menu_date,
                w.price,
                w.name_greek_imported as food_name,
                f.name_en as food_name_en,
                f.image_url
            FROM dbo.Orders o
            JOIN dbo.WeekMenu w ON o.menu_item_id = w.id
            LEFT JOIN dbo.FoodLibrary f ON w.food_library_id = f.id
            WHERE o.user_email = @user_email
            ORDER BY o.created_at DESC
        `);

    return result.recordset;
}

async function updateOrder(orderId, updates) {
    const pool = await getConnection();

    const request = pool.request()
        .input('id', sql.UniqueIdentifier, orderId);

    let setClauses = [];

    if (updates.quantity !== undefined) {
        request.input('quantity', sql.Int, updates.quantity);
        setClauses.push('quantity = @quantity');
    }

    if (updates.order_type !== undefined) {
        request.input('order_type', sql.NVarChar, updates.order_type);
        setClauses.push('order_type = @order_type');
    }

    if (setClauses.length === 0) return { id: orderId }; // Nothing to update

    const query = `
        UPDATE dbo.Orders
        SET ${setClauses.join(', ')}
        WHERE id = @id
    `;

    await request.query(query);

    return { id: orderId, ...updates };
}

async function deleteOrder(orderId) {
    const pool = await getConnection();

    await pool.request()
        .input('order_id', sql.UniqueIdentifier, orderId)
        .query(`DELETE FROM dbo.Orders WHERE id = @order_id`);

    return { success: true };
}

module.exports = {
    createOrder,
    getOrdersByUser,
    updateOrder, // Export updated function
    deleteOrder
};
