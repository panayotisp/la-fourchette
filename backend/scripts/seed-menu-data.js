const sql = require('mssql');
const path = require('path');
const { transliterate } = require('transliteration');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE || 'MENU',
    port: parseInt(process.env.DB_PORT || '1433'),
    options: {
        encrypt: process.env.DB_ENCRYPT === 'true',
        trustServerCertificate: process.env.DB_TRUST_SERVER_CERTIFICATE === 'true',
    }
};

const menuData = {
    'Monday': [
        { name: 'Φιλέτο κοτόπουλο σχάρας με μουστάρδα, flakes παρμεζάνας και ρύζι βουτύρου', name_en: 'Grilled chicken fillet with mustard, parmesan flakes and butter rice', price: 3.90 },
        { name: 'Σπαγγέτι μπολονέζ', name_en: 'Spaghetti Beef Bolognese', price: 3.70 },
        { name: 'Κρεατόσουπα με λαχανικά', name_en: 'Beef soup with vegetables', price: 3.70 },
        { name: 'Μαυρομάτικα με χόρτα και μυρωδικά – live', name_en: 'Black-eyed peas with greens and herbs', price: 3.40 }
    ],
    'Tuesday': [
        { name: 'Ρολό κιμά γεμιστό με πατάτες φούρνου', name_en: 'Stuffed Meatloaf with baked potatoes', price: 3.90 },
        { name: 'Παστίτσιο', name_en: 'Pastitsio', price: 3.60 },
        { name: 'Γλώσσα λεμονάτη με ζεστή πατατοσαλάτα', name_en: 'Lemon Sole with warm potato salad', price: 4.70 },
        { name: 'Μπάμιες Λαδερές', name_en: 'Okra in oil (Ladere)', price: 3.50 }
    ],
    'Wednesday': [
        { name: 'Σνίτσελ κοτόπουλο με πατάτες dauphinois', name_en: 'Chicken Schnitzel with potatoes dauphinoise', price: 3.90 },
        { name: 'Χοιρινή τηγανιά με ρύζι πιλάφι', name_en: 'Pork fry with rice pilaf', price: 3.90 }
    ],
    'Friday': [
        { name: 'Χοιρινά μπριζολάκια σχάρας με ψητά λαχανικά', name_en: 'Grilled pork steaks with grilled vegetables', price: 3.90 },
        { name: 'Κανελόνια με κιμά', name_en: 'Cannelloni with minced meat', price: 3.90 }
    ]
};

async function seedDatabase() {
    let pool;
    try {
        console.log('Connecting to database:', config.database);
        pool = await sql.connect(config);

        // 1. Calculate dates for current week
        const today = new Date();
        const dayOfWeek = today.getDay(); // 0=Sun, 1=Mon
        const monday = new Date(today);
        // Adjust to this week's Monday (or last Monday if today is Sun)
        const diff = today.getDate() - dayOfWeek + (dayOfWeek === 0 ? -6 : 1);
        monday.setDate(diff);

        const daysMap = {
            'Monday': new Date(monday),
            'Tuesday': new Date(monday.valueOf() + 24 * 60 * 60 * 1000),
            'Wednesday': new Date(monday.valueOf() + 2 * 24 * 60 * 60 * 1000),
            'Thursday': new Date(monday.valueOf() + 3 * 24 * 60 * 60 * 1000), // No menu provided, but logic valid
            'Friday': new Date(monday.valueOf() + 4 * 24 * 60 * 60 * 1000),
        };

        // Clear existing WeekMenu for this week to avoid duplicates? 
        // Or just clear everything for clean testing since it's a new DB.
        console.log('Clearing existing WeekMenu and FoodLibrary tables (TRUNCATE/DELETE restricted, using DELETE)...');
        // Order matters due to FKs
        await pool.request().query('DELETE FROM dbo.Orders');
        await pool.request().query('DELETE FROM dbo.WeekMenu');
        await pool.request().query('DELETE FROM dbo.FoodLibrary');

        console.log('Inserting data...');

        for (const [dayName, items] of Object.entries(menuData)) {
            const date = daysMap[dayName];
            console.log(`Processing ${dayName} (${date.toISOString().split('T')[0]})...`);

            for (const item of items) {
                // Generate filename slug
                const slug = transliterate(item.name_en || item.name).toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_+|_+$/g, '');
                const imageUrl = `/images/${slug}.jpg`;

                // 1. Insert into FoodLibrary
                const foodLibResult = await pool.request()
                    .input('name_greek', sql.NVarChar, item.name)
                    .input('name_en', sql.NVarChar, item.name_en)
                    .input('image_url', sql.NVarChar, imageUrl)
                    .query(`
                        INSERT INTO dbo.FoodLibrary (name_greek, name_en, image_url)
                        OUTPUT INSERTED.id
                        VALUES (@name_greek, @name_en, @image_url)
                    `);

                const foodLibId = foodLibResult.recordset[0].id;

                // 2. Insert into WeekMenu
                await pool.request()
                    .input('date', sql.Date, date)
                    .input('name_greek_imported', sql.NVarChar, item.name) // Using same name as exact match
                    .input('price', sql.Decimal(10, 2), item.price)
                    .input('food_library_id', sql.UniqueIdentifier, foodLibId)
                    .query(`
                        INSERT INTO dbo.WeekMenu (date, name_greek_imported, price, food_library_id)
                        VALUES (@date, @name_greek_imported, @price, @food_library_id)
                    `);

                console.log(`  -> Added: ${item.name} (${slug}.jpg)`);
            }
        }

        console.log('Seeding completed successfully!');

    } catch (err) {
        console.error('Error seeding database:', err);
    } finally {
        if (pool) await pool.close();
    }
}

seedDatabase();
