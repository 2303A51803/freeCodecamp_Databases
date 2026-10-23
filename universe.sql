CREATE DATABASE universe;
\c universe

CREATE TABLE galaxy (
  galaxy_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT NOT NULL,
  galaxy_type VARCHAR(50) NOT NULL,
  star_count INT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE star (
  star_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  galaxy_id INT NOT NULL REFERENCES galaxy(galaxy_id),
  mass NUMERIC(10, 3) NOT NULL,
  spectral_type TEXT NOT NULL,
  is_visible BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE planet (
  planet_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  star_id INT NOT NULL REFERENCES star(star_id),
  planet_order INT NOT NULL,
  radius NUMERIC(10, 2) NOT NULL,
  has_atmosphere BOOLEAN NOT NULL,
  description TEXT NOT NULL
);

CREATE TABLE moon (
  moon_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  planet_id INT NOT NULL REFERENCES planet(planet_id),
  diameter INT NOT NULL,
  is_spherical BOOLEAN NOT NULL,
  discovery_notes TEXT NOT NULL
);

CREATE TABLE constellation (
  constellation_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  abbreviation VARCHAR(10) NOT NULL,
  area_sq_deg INT NOT NULL,
  is_zodiac BOOLEAN NOT NULL,
  description TEXT NOT NULL
);

INSERT INTO galaxy (name, description, galaxy_type, star_count, is_active) VALUES
  ('Milky Way', 'The spiral galaxy containing Earth.', 'Barred spiral', 200000, TRUE),
  ('Andromeda', 'The nearest large galaxy to the Milky Way.', 'Spiral', 1000000, TRUE),
  ('Triangulum', 'A smaller spiral galaxy in the Local Group.', 'Spiral', 40000, TRUE),
  ('Whirlpool', 'A grand-design spiral galaxy.', 'Spiral', 100000, TRUE),
  ('Sombrero', 'A bright galaxy with a prominent dust lane.', 'Unbarred spiral', 100000, TRUE),
  ('Large Magellanic Cloud', 'A satellite galaxy of the Milky Way.', 'Irregular', 30000, TRUE);

INSERT INTO star (name, galaxy_id, mass, spectral_type, is_visible) VALUES
  ('Sun', 1, 1.000, 'G2V', TRUE),
  ('Sirius', 1, 2.020, 'A1V', TRUE),
  ('Betelgeuse', 1, 11.600, 'M1-M2 Ia-ab', TRUE),
  ('Proxima Centauri', 1, 0.123, 'M5.5Ve', TRUE),
  ('Vega', 1, 2.135, 'A0V', TRUE),
  ('Polaris', 1, 5.400, 'F7Ib', TRUE);

INSERT INTO planet (name, star_id, planet_order, radius, has_atmosphere, description) VALUES
  ('Mercury', 1, 1, 2439.70, FALSE, 'The smallest planet in the Solar System.'),
  ('Venus', 1, 2, 6051.80, TRUE, 'A cloud-covered rocky planet.'),
  ('Earth', 1, 3, 6371.00, TRUE, 'The only known planet with life.'),
  ('Mars', 1, 4, 3389.50, TRUE, 'A cold desert planet.'),
  ('Jupiter', 1, 5, 69911.00, TRUE, 'The largest planet in the Solar System.'),
  ('Saturn', 1, 6, 58232.00, TRUE, 'A gas giant known for its rings.'),
  ('Uranus', 1, 7, 25362.00, TRUE, 'An ice giant rotating on its side.'),
  ('Neptune', 1, 8, 24622.00, TRUE, 'The outermost major planet.'),
  ('Aurelia', 2, 1, 7200.00, TRUE, 'A fictional world orbiting Sirius.'),
  ('Borealis', 3, 1, 5100.00, TRUE, 'A fictional world orbiting Betelgeuse.'),
  ('Cinder', 4, 1, 1800.00, FALSE, 'A fictional world orbiting Proxima Centauri.'),
  ('Lumen', 5, 1, 4600.00, TRUE, 'A fictional world orbiting Vega.');

INSERT INTO moon (name, planet_id, diameter, is_spherical, discovery_notes) VALUES
  ('Luna', 3, 3475, TRUE, 'Earth''s natural satellite.'),
  ('Phobos', 4, 23, FALSE, 'The larger moon of Mars.'),
  ('Deimos', 4, 12, FALSE, 'The smaller moon of Mars.'),
  ('Io', 5, 3643, TRUE, 'A volcanically active moon.'),
  ('Europa', 5, 3122, TRUE, 'An icy moon with a subsurface ocean.'),
  ('Ganymede', 5, 5268, TRUE, 'The largest moon in the Solar System.'),
  ('Callisto', 5, 4821, TRUE, 'A heavily cratered moon.'),
  ('Titan', 6, 5150, TRUE, 'A moon with a dense atmosphere.'),
  ('Rhea', 6, 1528, TRUE, 'An icy Saturnian moon.'),
  ('Iapetus', 6, 1469, TRUE, 'A two-toned moon of Saturn.'),
  ('Dione', 6, 1123, TRUE, 'An icy moon with bright cliffs.'),
  ('Tethys', 6, 1062, TRUE, 'A moon containing a large impact crater.'),
  ('Enceladus', 6, 504, TRUE, 'A moon with active ice geysers.'),
  ('Mimas', 6, 396, TRUE, 'A small moon with a prominent crater.'),
  ('Miranda', 7, 472, TRUE, 'An icy moon with varied terrain.'),
  ('Ariel', 7, 1158, TRUE, 'The brightest moon of Uranus.'),
  ('Umbriel', 7, 1169, TRUE, 'A dark moon of Uranus.'),
  ('Titania', 7, 1578, TRUE, 'The largest moon of Uranus.'),
  ('Oberon', 7, 1523, TRUE, 'The outermost major moon of Uranus.'),
  ('Triton', 8, 2707, TRUE, 'Neptune''s largest moon.');

INSERT INTO constellation (name, abbreviation, area_sq_deg, is_zodiac, description) VALUES
  ('Orion', 'Ori', 594, FALSE, 'A prominent constellation near the celestial equator.'),
  ('Ursa Major', 'UMa', 1280, FALSE, 'A large northern constellation.'),
  ('Scorpius', 'Sco', 497, TRUE, 'A zodiac constellation shaped like a scorpion.');
