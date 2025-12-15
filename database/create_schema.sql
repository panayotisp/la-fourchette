USE MENU;
GO

-- Drop tables if they exist (Order matters due to FKs)
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.WeekMenu', 'U') IS NOT NULL DROP TABLE dbo.WeekMenu;
IF OBJECT_ID('dbo.FoodLibrary', 'U') IS NOT NULL DROP TABLE dbo.FoodLibrary;
GO

-- 1. Food Library (The "Knowledge Base")
-- Stores common food information to be reused.
CREATE TABLE dbo.FoodLibrary (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    name_greek NVARCHAR(255) NOT NULL, -- e.g., "Μουσακάς"
    name_en NVARCHAR(255),             -- e.g., "Moussaka"
    image_url NVARCHAR(MAX),           -- Local path "/images/moussaka.jpg" or URL
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 2. Week Menu (The "Active Schedule")
-- Represents the specific menu for a date, imported from Excel.
CREATE TABLE dbo.WeekMenu (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    date DATE NOT NULL,
    name_greek_imported NVARCHAR(255) NOT NULL, -- Exact name from Excel: "Μουσακάς στο φούρνο"
    price DECIMAL(10, 2) NOT NULL,              -- Price for this specific week
    food_library_id UNIQUEIDENTIFIER NULL,      -- Link to generic "Moussaka" image
    quantity_available INT DEFAULT 50,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (food_library_id) REFERENCES dbo.FoodLibrary(id)
);
GO

-- 3. Orders
-- Users' orders linked to the specific WeekMenu item.
CREATE TABLE dbo.Orders (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    user_email NVARCHAR(255) NOT NULL,
    user_name NVARCHAR(255),
    user_surname NVARCHAR(255),
    menu_item_id UNIQUEIDENTIFIER NOT NULL, -- References WeekMenu
    quantity INT NOT NULL DEFAULT 1,
    order_type NVARCHAR(50) DEFAULT 'restaurant', -- 'restaurant' or 'pickup'
    status NVARCHAR(50) DEFAULT 'confirmed',
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (menu_item_id) REFERENCES dbo.WeekMenu(id)
);
GO

-- Optional: Seed some initial data for testing
INSERT INTO dbo.FoodLibrary (name_greek, name_en, image_url)
VALUES 
(N'Μουσακάς', 'Moussaka', 'https://images.unsplash.com/photo-1596708173468-4a6c4b26759c'), -- Placeholder from Unsplash
(N'Πατίτσιο', 'Pastitsio', 'https://images.unsplash.com/photo-1627308595229-7830a5c91f9f');

-- Insert a menu item for TODAY (so it shows up in the app)
DECLARE @MoussakaId UNIQUEIDENTIFIER = (SELECT TOP 1 id FROM dbo.FoodLibrary WHERE name_en = 'Moussaka');
INSERT INTO dbo.WeekMenu (date, name_greek_imported, price, food_library_id)
VALUES (CAST(GETDATE() AS DATE), N'Μουσακάς Παραδοσιακός', 8.50, @MoussakaId);
GO
