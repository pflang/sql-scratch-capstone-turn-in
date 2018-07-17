-- 1. Select all columns from the first 10 rows. What columns does the table have?

SELECT *
FROM survey
LIMIT 10;

-- 2. What is the number of responses for each question?

SELECT question, COUNT(DISTINCT user_id)
FROM survey
GROUP BY question
ORDER BY question ASC;


-- 4. What are the column names?

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

-- 5. Use a LEFT JOIN to combine the three tables, starting with the top of the funnel (browse) and ending with the bottom of the funnel (purchase).

SELECT DISTINCT quiz.user_id,
   home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
   home_try_on.number_of_pairs,
   purchase.user_id IS NOT NULL AS 'is_purchase'
FROM quiz
LEFT JOIN home_try_on
   ON quiz.user_id = home_try_on.user_id
LEFT JOIN purchase
   ON purchase.user_id = quiz.user_id
LIMIT 10;

-- 6. What are some actionable insights for Warby Parker?


--COnversion Rate by shape

WITH funnels AS (
  SELECT DISTINCT quiz.shape,
   quiz.user_id, 
   home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
   purchase.user_id IS NOT NULL AS 'is_purchase'
FROM quiz
LEFT JOIN home_try_on
   ON quiz.user_id = home_try_on.user_id
LEFT JOIN purchase
   ON purchase.user_id = quiz.user_id)
SELECT shape, COUNT(*) AS 'num_quiz',
   SUM(is_home_try_on) AS 'num_home_try_on',
   SUM(is_purchase) AS 'num_purchase',
   1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'quizto_try_on',
   1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'checkout_to_purchase'
FROM funnels
GROUP BY shape
ORDER BY shape;

--Most popular options for quiz
SELECT shape, Count(shape)
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT fit, Count(fit)
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT color, Count(color)
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT style, Count(style)
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;
