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
                s.id as schedule_id,
                s.date,
                s.price,
                s.stock_quantity,
                c.id as food_item_id,
                c.name,
                c.name_en,
                c.image_url,
                c.image_source
            FROM dbo.Menu_Schedule s
            JOIN dbo.Menu_Catalog c ON s.food_item_id = c.id
            WHERE s.date >= @startDate 
              AND s.date < DATEADD(DAY, 7, @startDate)
            ORDER BY s.date
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
                id: item.food_item_id,
                name: item.name,
                name_en: item.name_en,
                image_url: item.image_url,
                image_source: item.image_source
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
