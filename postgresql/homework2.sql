/* CREATE a rule that captures DELETE on venues and instead sets the active flag to FALSE */
CREATE OR REPLACE RULE delete_venues AS ON DELETE TO venues DO INSTEAD
  UPDATE venues SET active = FALSE
  WHERE venue_id = OLD.venue_id;

/* build monthly calendar of events */
SELECT * FROM crosstab(
  'SELECT extract(year from starts) as year,
     extract(month from starts) as month, count(*)
   FROM events GROUP BY year, month ORDER BY year',
  'select m from generate_series(1,12) m'
) AS (
  year int, jan int, feb int, mar int, apr int, may int,
  jun int, jul int, aug int, sep int, oct int, nov int, int dec
);

/* pivot table displays every day in a single month
http://www.postgresql.org/docs/9.3/static/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT */
SELECT * FROM crosstab(
  'SELECT extract(week from starts) as week,
     extract(dow from starts) as dow, count(*)
   FROM events GROUP by week, dow ORDER BY week',
  'SELECT d from generate_series(0,6) d'
) AS (
  week int, sun int, mon int, tue int,
  wed int, thu int, fri int, sat int
);

