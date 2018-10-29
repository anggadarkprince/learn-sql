-- STRING https://dev.mysql.com/doc/refman/8.0/en/string-functions.html

-- joining string
SELECT CONCAT(id, ' - ', title) AS title_id FROM activities;

-- change to uppercase
SELECT UCASE(title) AS title FROM activities;

-- change to lowercase
SELECT LCASE(title) AS title FROM activities;

-- take string from left
SELECT LEFT('Angga', 3) AS first_3;

-- remove leading and trailing space
SELECT TRIM(' Ari   ') AS my_name;

-- take park of string
SELECT SUBSTR('2019/03/01', 1, 4);


-- DATE https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html

-- get current data
SELECT CURDATE();

-- substract by value directly
SELECT (CURDATE() - INTERVAL 10 YEAR) AS ten_years_ago;
SELECT (CURDATE() - INTERVAL 3 MONTH) AS three_months_ago;
SELECT (CURDATE() - INTERVAL 4 WEEK) AS four_weeks_ago;
SELECT (CURDATE() + INTERVAL 2 DAY) AS two_days_ahead;

-- substract date by function
SELECT DATE_SUB(CURDATE(), INTERVAL 5 MONTH) AS past;

-- get day of date
SELECT DAYNAME('2019-01-01') AS new_year;

-- get difference between date
SELECT TIMESTAMPDIFF(YEAR, '1992-05-26', CURDATE()) AS my_age;
SELECT FROM_DAYS(DATEDIFF(CURDATE(), '1992-05-26')) AS my_age_in_detail;

-- format date
SELECT DATE_FORMAT('1992-05-26', "%Y") AS my_age;
SELECT DATE_FORMAT('1992-05-26', "%Y, in %M %D") AS my_age;
SELECT YEAR('1992-05-26') AS my_year, MONTH('1992-05-26') AS my_month, DAY('1992-05-26') AS my_day;
SELECT HOUR('2018-10-10 12:30') AS h, MINUTE('12:30:23') AS m;

-- convert unstandard date as date
SELECT STR_TO_DATE('2018, 8 - 1', '%Y, %m - %d') AS some_date;


-- CONTROL FLOW
SELECT IFNULL(NULL, 200) AS val;

SELECT IF(1 < 3, 'true result', 'false result') AS val;
SELECT IF(1 < 3, IF(FALSE, 'nest true', 'nest false'), 'false result') AS val;

SELECT CASE WHEN 2 > 3 THEN 'hello' END; 
SELECT CASE WHEN 2 > 3 THEN 'hello' ELSE 'world' END; 

SELECT 
  CASE 
    WHEN 2 > 3 THEN 'hello'
    WHEN 2 IS NULL THEN 'kitty' 
    WHEN 2 = 2 THEN 'kitty' 
    ELSE 'world' 
  END AS result; 


-- CASTING
SELECT CAST('01' AS UNSIGNED) AS num;
SELECT CAST('1.2' AS DECIMAL(3,2)) AS num;
SELECT CAST('1992-05-26' AS CHAR) AS dates;
SELECT CONCAT('Total: ', CAST(COUNT(*) AS CHAR)) AS total FROM activities;