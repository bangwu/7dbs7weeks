INSERT INTO events (title, starts, ends, venue_id)
  VALUES ('Moby', '2012-02-06 21:00', '2012-02-06 23:00', (
    SELECT venue_id FROM venues
    WHERE name = 'Crystal Ballroom'
  )
);

INSERT INTO events (title, starts, ends, venue_id)
  VALUES ('Wedding', '2013-03-24 11:00', '2013-03-24 15:00', (
    SELECT venue_id FROM venues
    WHERE name = 'Voodoo Donuts'
  )
);

INSERT INTO venues (name, postal_code, country_code)
VALUES ('My Place', '97205', 'us') RETURNING venue_id;

INSERT INTO events (title, starts, ends, venue_id)
  VALUES ('Dinner with Mom', '2012-03-26 18:00', '2013-03-26 20:30', (
    SELECT venue_id FROM venues
    WHERE name = 'My Place'
  )
);

INSERT INTO events (title, starts, ends)
VALUES ('Valentine Day', '2013-02-14 00:00', '2013-02-14 23:59';

SELECT count(title) FROM events
WHERE title LIKE '%Day%';

SELECT min(starts), max(ends) FROM events INNER JOIN venues
ON events.venue_id = venues.venue_id
WHERE venues.name = 'Crystal Ballroom';

SELECT count(*) FROM events WHERE venue_id IS NULL;

SELECT venue_id, count(*) FROM events GROUP BY venue_id;

SELECT venue_id, count(*) FROM events GROUP BY venue_id
HAVING count(*) >= 2 AND venue_id IS NOT NULL;

SELECT DISTINCT venue_id FROM events;

SELECT venue_id, title, count(*)
OVER (PARTITION BY venue_id) FROM events
ORDER BY venue_id;

CREATE TABLE logs (
  event_id integer,
  old_title varchar(255),
  old_starts timestamp,
  old_ends timestamp,
  logged_at timestamp DEFAULT current_timestamp
);

ALTER TABLE events ADD colors text ARRAY;

CREATE OR REPLACE VIEW holidays AS
  SELECT event_id AS holiday_id, title AS name, starts AS date, colors
  FROM events WHERE title LIKE '%Day%' AND venue_id IS NULL;

CREATE RULE insert_holidays AS ON INSERT TO holidays DO INSTEAD
  INSERT INTO events (title, starts)
  VALUES (NEW.name, NEW.date);

SELECT extract(year from starts) as year,
  extract(month from starts) as month, count(*)
FROM events GROUP BY year, month;
