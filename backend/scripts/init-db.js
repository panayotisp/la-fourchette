const sql = require('mssql');
const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    // Connect to the target database directly
    database: process.env.DB_DATABASE || 'MENU',
    port: parseInt(process.env.DB_PORT || '1433'),
    options: {
        encrypt: process.env.DB_ENCRYPT === 'true',
        trustServerCertificate: true
    }
};

async function initializeDatabase() {
    try {
        console.log('Connecting to database:', config.database);
        const pool = await sql.connect(config);

        const schemaPath = path.join(__dirname, '../../database/create_menu_schema.sql');
        console.log('Reading schema from:', schemaPath);

        // Read file but remove the "USE MENU; GO" parts because node-mssql can be picky 
        // about GO statements and context switching if not in CLI mode.
        // We will execute the CREATE TABLE statements.
        let schemaSql = fs.readFileSync(schemaPath, 'utf8');

        // Split by 'GO' to execute batches
        const batches = schemaSql
            .split(/^GO\s*$/m) // Regex to match GO on its own line
            .map(batch => batch.trim())
            .filter(batch => batch.length > 0);

        console.log(`Found ${batches.length} batches to execute.`);

        for (let i = 0; i < batches.length; i++) {
            const batch = batches[i];
            // Skip "USE MENU" if we are already connected to it, or just run it. 
            // node-mssql generally handles T-SQL but USE statements might confuse the pool if it expects a specific DB.
            // However, since we connected with the right DB in config, we can likely skip USE.
            if (batch.toLowerCase().startsWith('use ')) {
                console.log('Skipping USE statement (already connected)');
                continue;
            }

            console.log(`Executing batch ${i + 1}...`);
            await pool.request().query(batch);
        }

        console.log('Database initialized successfully!');
        await pool.close();
    } catch (err) {
        console.error('Error initializing database:', err);
        process.exit(1);
    }
}

initializeDatabase();
