-- =========================
-- HOTEL QUERIES (1–5)
-- =========================

-- Q1: Last booked room per user
SELECT user_id, room_no
FROM (
    SELECT user_id, room_no,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) rn
    FROM bookings
) t
WHERE rn = 1;


-- Q2: Booking_id and total billing amount (November 2021)
SELECT bc.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-11-01'
  AND bc.bill_date < '2021-12-01'
GROUP BY bc.booking_id;


-- Q3: Bills > 1000 (October 2021)
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01'
  AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;


-- Q4: Most ordered item per month (2021)
WITH item_orders AS (
    SELECT EXTRACT(MONTH FROM bc.bill_date) AS month,
           i.item_name,
           SUM(bc.item_quantity) qty
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE EXTRACT(YEAR FROM bc.bill_date)=2021
    GROUP BY month, i.item_name
),
ranked AS (
    SELECT *, RANK() OVER (PARTITION BY month ORDER BY qty DESC) rnk
    FROM item_orders
)
SELECT * FROM ranked WHERE rnk = 1;


-- Q5: Least ordered item per month (2021)
WITH item_orders AS (
    SELECT EXTRACT(MONTH FROM bc.bill_date) AS month,
           i.item_name,
           SUM(bc.item_quantity) qty
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE EXTRACT(YEAR FROM bc.bill_date)=2021
    GROUP BY month, i.item_name
),
ranked AS (
    SELECT *, RANK() OVER (PARTITION BY month ORDER BY qty ASC) rnk
    FROM item_orders
)
SELECT * FROM ranked WHERE rnk = 1;


-- =========================
-- HOTEL EXTRA (6)
-- =========================

-- Q6: Second highest bill per month (2021)
WITH bills AS (
    SELECT EXTRACT(MONTH FROM bc.bill_date) AS month,
           bc.booking_id,
           SUM(bc.item_quantity * i.item_rate) total_bill
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE EXTRACT(YEAR FROM bc.bill_date)=2021
    GROUP BY month, bc.booking_id
),
ranked AS (
    SELECT *, RANK() OVER (PARTITION BY month ORDER BY total_bill DESC) rnk
    FROM bills
)
SELECT * FROM ranked WHERE rnk = 2;


-- =========================
-- CLINIC QUERIES (7–11)
-- =========================

-- Q7: Revenue per sales channel
SELECT sales_channel,
       SUM(amount) AS revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime)=2021
GROUP BY sales_channel;


-- Q8: Top 10 valuable customers
SELECT uid,
       SUM(amount) AS total_spent
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime)=2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;


-- Q9: Month-wise revenue, expense, profit, status
WITH r AS (
    SELECT EXTRACT(MONTH FROM datetime) m, SUM(amount) rev
    FROM clinic_sales
    WHERE EXTRACT(YEAR FROM datetime)=2021
    GROUP BY m
),
e AS (
    SELECT EXTRACT(MONTH FROM datetime) m, SUM(amount) exp
    FROM expenses
    WHERE EXTRACT(YEAR FROM datetime)=2021
    GROUP BY m
)
SELECT r.m, rev, exp,
       (rev-exp) profit,
       CASE WHEN (rev-exp)>0 THEN 'profitable'
            ELSE 'not-profitable'
       END status
FROM r JOIN e ON r.m=e.m;


-- Q10: Most profitable clinic per city (October 2021)
WITH p AS (
    SELECT c.city, cs.cid,
           SUM(cs.amount)-COALESCE(SUM(e.amount),0) profit
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid=c.cid
    LEFT JOIN expenses e ON cs.cid=e.cid
    WHERE EXTRACT(MONTH FROM cs.datetime)=10
      AND EXTRACT(YEAR FROM cs.datetime)=2021
    GROUP BY c.city, cs.cid
),
r AS (
    SELECT *, RANK() OVER(PARTITION BY city ORDER BY profit DESC) rnk
    FROM p
)
SELECT * FROM r WHERE rnk=1;


-- Q11: Second least profitable clinic per state (October 2021)
WITH p AS (
    SELECT c.state, cs.cid,
           SUM(cs.amount)-COALESCE(SUM(e.amount),0) profit
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid=c.cid
    LEFT JOIN expenses e ON cs.cid=e.cid
    WHERE EXTRACT(MONTH FROM cs.datetime)=10
      AND EXTRACT(YEAR FROM cs.datetime)=2021
    GROUP BY c.state, cs.cid
),
r AS (
    SELECT *, RANK() OVER(PARTITION BY state ORDER BY profit ASC) rnk
    FROM p
)
SELECT * FROM r WHERE rnk=2;
