-- ============================================
-- La Fourchette Database Schema
-- MS SQL Server
-- ============================================

-- Table 1: Menu_Catalog (Food Library)
CREATE TABLE Menu_Catalog (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name NVARCHAR(500) NOT NULL,
    name_en NVARCHAR(500),
    image_url NVARCHAR(1000),
    image_source VARCHAR(50) CHECK (image_source IN ('preloaded', 'cache', 'unsplash')),
    created_at DATETIME2 DEFAULT GETDATE()
);

-- Table 2: Menu_Image_Caches (Tier 2 Cache)
CREATE TABLE Menu_Image_Caches (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    dish_name NVARCHAR(500) NOT NULL UNIQUE,
    dish_name_en NVARCHAR(500),
    image_url NVARCHAR(1000) NOT NULL,
    unsplash_photo_id VARCHAR(100),
    created_at DATETIME2 DEFAULT GETDATE()
);

-- Index for fast lookups by dish name
CREATE INDEX IX_Menu_Image_Caches_DishName ON Menu_Image_Caches(dish_name);

-- Table 3: Menu_Schedule (Weekly Menu)
CREATE TABLE Menu_Schedule (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    date DATE NOT NULL,
    food_item_id UNIQUEIDENTIFIER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 50,
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Menu_Schedule_Catalog FOREIGN KEY (food_item_id) 
        REFERENCES Menu_Catalog(id) ON DELETE CASCADE
);

-- Index for fast weekly queries
CREATE INDEX IX_Menu_Schedule_Date ON Menu_Schedule(date);
CREATE INDEX IX_Menu_Schedule_FoodItem ON Menu_Schedule(food_item_id);

-- Table 4: Menu_Orders (Reservations)
CREATE TABLE Menu_Orders (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    user_email NVARCHAR(255) NOT NULL,
    user_name NVARCHAR(100) NOT NULL,
    user_surname NVARCHAR(100) NOT NULL,
    schedule_id UNIQUEIDENTIFIER NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    order_type VARCHAR(50) NOT NULL DEFAULT 'restaurant'
        CHECK (order_type IN ('to_go', 'restaurant')),
    status VARCHAR(50) NOT NULL DEFAULT 'confirmed' 
        CHECK (status IN ('confirmed', 'cancelled', 'picked_up')),
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Menu_Orders_Schedule FOREIGN KEY (schedule_id) 
        REFERENCES Menu_Schedule(id) ON DELETE CASCADE
);

-- Indexes for fast user queries and reporting
CREATE INDEX IX_Menu_Orders_UserEmail ON Menu_Orders(user_email);
CREATE INDEX IX_Menu_Orders_CreatedAt ON Menu_Orders(created_at);
CREATE INDEX IX_Menu_Orders_ScheduleId ON Menu_Orders(schedule_id);

-- ============================================
-- Sample Data Insertion
-- ============================================

-- Insert sample food items
INSERT INTO Menu_Catalog (name, name_en, image_source)
VALUES 
    (N'Μουσακάς', 'Moussaka', 'preloaded'),
    (N'Σουβλάκι κοτόπουλο', 'Chicken Souvlaki', 'preloaded'),
    (N'Παστίτσιο', 'Pastitsio', 'preloaded'),
    (N'Κρεατόσουπα με λαχανικά', 'Meat soup with vegetables', 'preloaded'),
    (N'Γιουβέτσι', 'Giouvetsi', 'preloaded');

-- Insert sample weekly schedule (current week Monday-Friday)
DECLARE @Monday DATE = DATEADD(DAY, 1 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE));

INSERT INTO Menu_Schedule (date, food_item_id, price, stock_quantity)
SELECT 
    @Monday,
    id,
    8.50,
    50
FROM Menu_Catalog
WHERE name = N'Μουσακάς';

INSERT INTO Menu_Schedule (date, food_item_id, price, stock_quantity)
SELECT 
    DATEADD(DAY, 1, @Monday),
    id,
    7.50,
    50
FROM Menu_Catalog
WHERE name = N'Σουβλάκι κοτόπουλο';

INSERT INTO Menu_Schedule (date, food_item_id, price, stock_quantity)
SELECT 
    DATEADD(DAY, 2, @Monday),
    id,
    8.00,
    50
FROM Menu_Catalog
WHERE name = N'Παστίτσιο';

PRINT 'Database schema created successfully!';
