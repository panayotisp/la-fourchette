-- Migration: Add delivered column to Orders table
-- This allows tracking which orders have been delivered by catering staff

USE MENU;
GO

-- Add delivered column with default value of 0 (not delivered)
ALTER TABLE dbo.Orders
ADD delivered BIT NOT NULL DEFAULT 0;
GO

-- Optional: Add index for faster queries filtering by delivered status
CREATE INDEX IX_Orders_Delivered ON dbo.Orders(delivered);
GO

PRINT 'Successfully added delivered column to Orders table';
