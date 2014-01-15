/* Select all the tables we created (and only those) from pg_class */
/* http://www.postgresql.org/docs/9.0/static/catalog-pg-class.html */
SELECT c.relname FROM pg_class c JOIN pg_roles r
ON c.relowner = r.oid WHERE c.relkind = 'r' AND r.rolname <> 'postgres';

/* Finds the country name of LARP Club event */
SELECT c.country_name FROM countries c
JOIN venues v ON c.country_code = v.country_code
JOIN events e ON v.venue_id = e.event_id
WHERE e.title = 'LARP Club';

/* Alter the venues table to contain a boolean column called active, with the default value of TRUE */
ALTER TABLE venues ADD active boolean DEFAULT TRUE;
