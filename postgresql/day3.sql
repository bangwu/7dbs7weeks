CREATE TABLE genres (
  name text UNIQUE,
  position integer
);

CREATE TABLE movies (
  movie_id SERIAL PRIMARY KEY,
  title text,
  genre cube
);

CREATE TABLE actors (
  actor_id SERIAL PRIMARY KEY,
  name text
);

CREATE TABLE movies_actors (
  movie_id integer REFERENCES movies NOT NULL,
  actor_id integer REFERENCES actors NOT NULL,
  UNIQUE (movie_id, actor_id)
);

CREATE INDEX movies_actors_movie_id ON movies_actors (movie_id);

CREATE INDEX movies_actors_actor_id ON movies_actors (actor_id);

CREATE INDEX movies_genres_cube ON movies USING gist (genre);

SELECT title FROM movies WHERE title ILIKE 'stardust_%';

SELECT count(*) FROM movies WHERE title !~* '^the.*';

/* fuzzystrmatch extension */

SELECT levenshtein('bat', 'fads');

SELECT movie_id, title FROM movies
WHERE levenshtein(lower(title), lower('a hard day nght')) <= 3;

/* pg_trgm extension */

SELECT show_trgm('Avatar');

CREATE INDEX movies_title_trigram ON movies
USING gist (title gist_trgm_ops);

SELECT * FROM movies WHERE title % 'Avatre';

SELECT title FROM movies
WHERE title @@ 'night & day';

SELECT title FROM movies
WHERE to_tsvector('english', title) @@ to_tsquery('english', 'night & day');

SELECT to_tsvector('A Hard Day''s Night'), to_tsquery('english', 'night & day');

CREATE INDEX movies_title_search ON movies
USING gin(to_tsvector('english', title));

SELECT title, name FROM movies
NATURAL JOIN movies_actors NATURAL JOIN actors
WHERE metaphone(name,7) = metaphone('Broos Wils',7);

SELECT name, dmetaphone(name), dmetaphone_alt(name),
  metaphone(name, 8), soundex(name)
FROM actors;

SELECT * FROM actors
WHERE metaphone(name, 8) % metaphone('Robin Williams', 8)
ORDER BY levenshtein(lower('Robin Williams'), lower(name));

SELECT * FROM actors WHERE dmetaphone(name) % dmetaphone('Ron');

/* cube extension */

SELECT name, cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) as score
FROM genres g
WHERE cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) > 0;

SELECT title, cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') dist
FROM movies
WHERE cube_enlarge('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)'::cube, 5, 18) @> genre
ORDER BY dist;

SELECT m.movie_id, m.title FROM movies m, (SELECT genre, title FROM movies WHERE title = 'Mad Max') s
WHERE cube_enlarge(s.genre, 5, 18) @> m.genre AND s.title <> m.title
ORDER BY cube_distance(m.genre, s.genre) LIMIT 10;

