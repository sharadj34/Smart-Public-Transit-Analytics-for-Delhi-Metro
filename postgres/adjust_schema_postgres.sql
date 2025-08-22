-- Adjust schema to match CSV structures

-- stations: add zone column
ALTER TABLE IF EXISTS stations
ADD COLUMN IF NOT EXISTS zone VARCHAR(50);

-- revenue: revenue_id in CSV is not numeric; change to text
ALTER TABLE IF EXISTS revenue
ALTER COLUMN revenue_id TYPE TEXT USING revenue_id::text;

-- passengers: CSV has no name column; keep column nullable and skip in copy


