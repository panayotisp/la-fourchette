const { getConnection, sql } = require('../config/database');

/**
 * Get weekly menu starting from a specific date
 * @param {Date} startDate - Monday of the week
 * @returns {Promise<Array>} Menu items grouped by date
 */
async function getWeeklyMenu(startDate) {
    const pool = await getConnection();

    const result = await pool.request()
        .input('startDate', sql.Date, startDate)
        .query(`
            SELECT 
                w.id as schedule_id,
                w.date,
                w.price,
                w.quantity_available as stock_quantity,
                w.name_greek_imported as name,
                f.id as food_library_id,
                f.name_en,
                f.image_url
            FROM dbo.WeekMenu w
            LEFT JOIN dbo.FoodLibrary f ON w.food_library_id = f.id
            WHERE w.date >= @startDate 
              AND w.date < DATEADD(DAY, 7, @startDate)
            ORDER BY w.date
        `);

    // Group by date
    const grouped = result.recordset.reduce((acc, item) => {
        const dateStr = item.date.toISOString().split('T')[0];
        if (!acc[dateStr]) {
            acc[dateStr] = [];
        }
        acc[dateStr].push({
            schedule_id: item.schedule_id,
            food_item: {
                id: item.schedule_id, // Use schedule/week_menu ID derived
                name: item.name,
                name_en: item.name_en || '',
                image_url: item.image_url || 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c', // Default placeholder
                image_source: 'database'
            },
            price: parseFloat(item.price),
            stock_quantity: item.stock_quantity
        });
        return acc;
    }, {});

    return Object.entries(grouped).map(([date, items]) => ({
        date,
        items
    }));
}

module.exports = {
    getWeeklyMenu
};
