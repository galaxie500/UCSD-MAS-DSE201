/* SCHEMA AND TABLES */
CREATE SCHEMA cats;

CREATE TABLE cats.users(
  user_id serial primary key NOT NULL,
  f_name varchar(50) NOT NULL,
  l_name varchar(50) NOT NULL,
  facebook_id varchar(50) NOT NULL
);

CREATE TABLE cats.videos(
  video_id serial primary key NOT NULL,
  name character varying(50) NOT NULL
);

CREATE TABLE cats.logins(
  login_id serial primary key NOT NULL,
  user_id integer references cats.users(user_id) NOT NULL,
  "time" timestamp without time zone NOT NULL
);

CREATE TABLE cats.watches(
  watch_id serial primary key NOT NULL,
  video_id integer references cats.videos(video_id) NOT NULL,
  user_id integer references cats.users(user_id) NOT NULL,
  "time" timestamp without time zone NOT NULL
);

CREATE TABLE cats.friends(
  user_id integer references cats.users (user_id) NOT NULL,
  friend_id integer references cats.users (user_id) NOT NULL
);

CREATE TABLE cats.likes(
  like_id serial primary key NOT NULL,
  user_id integer references cats.users (user_id) NOT NULL,
  video_id integer references cats.videos (video_id) NOT NULL,
  "time" timestamp without time zone NOT NULL,
  CONSTRAINT like_const UNIQUE(user_id,video_id)
);

CREATE TABLE cats.suggestions(
  suggestion_id serial primary key NOT NULL,
  login_id integer references cats.logins(login_id) NOT NULL,
  video_id integer references cats.videos(video_id) NOT NULL
);

/* QUERY 1 */
SELECT video_id, COUNT(*) AS num_like 
FROM cats.likes 
GROUP BY video_id 
ORDER BY num_like DESC 
LIMIT 10;
            
/* QUERY 2 */
SELECT l.video_id, COUNT(*) AS num_like 
FROM cats.friends f, cats.likes l
WHERE f.user_id=1 
	AND f.friend_id=l.user_id 
GROUP BY l.video_id 
ORDER BY num_like DESC 
LIMIT 10;
            
/* QUERY 3 */
SELECT l.vl, COUNT(*)
FROM
	(SELECT l.video_id AS vl, l.user_id AS ul 
	FROM cats.friends f, cats.likes l 
	WHERE f.user_id=1 AND f.friend_id=l.user_id 
	UNION
	SELECT l.video_id AS vl, l.user_id AS ul 
	FROM cats.friends f, cats.friends ff, cats.likes l 
	WHERE f.user_id=1 AND f.friend_id=ff.user_id AND ff.user_id=l.user_id
	) AS l
GROUP BY l.vl
ORDER BY COUNT(*) DESC 
LIMIT 10;
            
/* QUERY 4 */
SELECT l.video_id, COUNT(*) 
FROM cats.likes l
WHERE l.user_id 
IN 
	(SELECT lb.user_id 
	FROM cats.likes la, cats.likes lb 
	WHERE la.user_id=1 AND la.video_id=lb.video_id
	) 
GROUP BY l.video_id
ORDER BY COUNT(*) DESC 
LIMIT 10;
            
/* QUERY 5 */
WITH UserWeight AS
	(SELECT lb.user_id, LOG(1+COUNT(*)) AS weight 
	FROM cats.likes la, cats.likes lb
	WHERE la.user_id=1 AND la.video_id=lb.video_id 
	GROUP BY lb.user_id
	)
SELECT l.video_id, SUM(w.weight) AS sum_weight FROM cats.likes l,  UserWeight w
WHERE l.user_id=w.user_id 
GROUP BY l.video_id
ORDER BY sum_weight DESC 
LIMIT 10;