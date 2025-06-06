CREATE DATABASE conservation_monitoring_db;

CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(50),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(ranger_id),
    species_id INT REFERENCES species(species_id),
    sighting_time TIMESTAMP,
    location VARCHAR(50),
    notes TEXT
);

INSERT INTO rangers (name, region)
VALUES
    ('Alice Green', 'Northern Hills'),
    ('Bob White', 'River Delta'),
    ('Carol King', 'Mountain Range');

SELECT * FROM rangers;

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status)
VALUES
    ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
    ('Snow Leopard', 'Panthera tigris', '1758-01-01', 'Endangered'),
    ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable' ),
    ('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered')

SELECT * FROM species;

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes )
VALUES
    (1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
    (2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
    (3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
    (1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

SELECT * FROM sightings;

-- 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- 2️⃣ Count unique species ever sighted.
SELECT count(DISTINCT common_name) as unique_species_count FROM species;

-- 3️⃣ Find all sightings where the location includes "Pass".
SELECT * FROM sightings
WHERE location ILIKE '%pass';

-- 4️⃣ List each ranger's name and their total number of sightings.
SELECT name, count(*) as total_sightings FROM rangers
JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY rangers.ranger_id;

-- 5️⃣ List species that have never been sighted.
SELECT common_name FROM species
LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE sightings.species_id IS NULL;


-- 6️⃣ Show the most recent 2 sightings.
SELECT common_name, sighting_time, name from sightings
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
JOIN species ON sightings.species_id = species.species_id
ORDER BY sighting_time DESC LIMIT 2;

-- 7️⃣ Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
    SET conservation_status = 'Historic'
    WHERE extract(year from discovery_date) < 1800;

-- 8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
SELECT sighting_id,
CASE
    WHEN extract(hour from sighting_time) < 12 THEN 'Morning'
    WHEN extract(hour from sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN extract(hour from sighting_time) > 17 THEN 'Evening'
END AS time_of_day
FROM sightings;


-- 9️⃣ Delete rangers who have never sighted any species
DELETE FROM rangers
WHERE ranger_id = (SELECT rangers.ranger_id FROM rangers
LEFT JOIN sightings ON rangers.ranger_id = sightings.ranger_id
WHERE sightings.ranger_id IS NULL);