-- Given the two tables, write a SQL query that creates a cumulative distribution of the number of comments per user. Assume bin buckets class intervals of one.

-- Example:

-- Input:

-- users table

-- Columns	Type
-- id	INTEGER
-- name	VARCHAR
-- created_at	DATETIME
-- neighborhood_id	INTEGER
- sex	VARCHAR
-- comments table

-- Columns	Type
-- user_id	INTEGER
-- body	VARCHAR
-- created_at	DATETIME

-- Output:

-- Columns	Type
-- frequency	INTEGER
-- cum_total	FLOAT

-- Solution:

-- get comment count for each user
WITH hist AS (
SELECT 
  users.id, 
  COUNT(c.user_id) as comment_by_user_count
FROM users 
LEFT JOIN comments as c
  ON users.id = c.user_id
GROUP BY users.id
)

-- get number of users for each comment frequency
WITH frequency AS(
SELECT 
  comment_by_user_count,
	COUNT(*) as user_count
FROM hist
GROUP BY comment_by_user_count
)

-- get cumulative count of comment frequency

SELECT 
	f1.comment_by_user_count,
	SUM(f2.user_count)
FROM frequency AS f1
LEFT JOIN frequency AS f2
	ON ON f1.frequency >= f2.frequency
GROUP BY f1.comment_by_user_count
