SELECT * FROM Bank_loan_data;

SELECT COUNT(Id) as Toal_loan_applications FROM Bank_loan_data;

SELECT COUNT(Id) as MTD_loan_applications 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT COUNT(Id) as PMTD_loan_applications 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- MOM = (MTD - PMTD)/PMTD

SELECT SUM(loan_amount) as Total_Funded_Amount 
FROM bank_loan_data;

SELECT SUM(loan_amount) as MTD_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT SUM(loan_amount) as PMTD_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

SELECT SUM(total_payment) as Total_received_amount 
FROM bank_loan_data;

SELECT SUM(total_payment) as MTD_Total_received_amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT SUM(total_payment) as PMTD_Total_received_amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

SELECT AVG(int_rate) * 100 as Avg_Interest_Rate
FROM bank_loan_data;

SELECT ROUND(AVG(int_rate),4) * 100 as Avg_Interest_Rate
FROM bank_loan_data;

SELECT ROUND(AVG(int_rate),4) * 100 MTD_Interest_Rate
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT ROUND(AVG(int_rate),4) * 100 PMTD_Interest_Rate
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

SELECT ROUND(AVG(dti),4) * 100 as Avg_DTI
FROM bank_loan_data;

SELECT ROUND(AVG(dti),4) * 100 as MTD_Avg_DTI
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT ROUND(AVG(dti),4) * 100 as PMTD_Avg_DTI
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

SELECT loan_status , COUNT(DISTINCT id) as id_count 
FROM bank_loan_data
Group BY loan_status;

/* Total Good Loan applications */
SELECT COUNT(id) as Total_Good_Loan_applications 
FROM bank_loan_data 
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

/* Good Loan Applications Percentage */

SELECT (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100)
		/ COUNT(id) as Good_laon_Percentage
FROM bank_loan_data;

SELECT SUM(loan_amount) as Good_Loan_Funded_Amount 
FROM bank_loan_data 
WHERE loan_status in ('Fully Paid','Current');

SELECT SUM(total_payment) as Good_Loan_Amount_Received
FROM bank_loan_data
WHERE loan_status in ('Fully Paid','Current');

SELECT (COUNT(CASE WHEN loan_status in ('Fully Paid','Current') THEN id END) * 100)
		/ COUNT(id) as Good_laon_Percentage
FROM bank_loan_data;

SELECT ROUND((COUNT(CASE WHEN loan_status ='Charged Off' THEN id END) * 100),4)/ COUNT(id) as Bad_Loan_Percentage
FROM bank_loan_data;

SELECT COUNT(id) as Bad_Loan_Applications 
FROM bank_loan_data
WHERE loan_status = 'Charged Off';

SELECT SUM(loan_amount) as Bad_Loan_Funded_Amount
FROM bank_loan_data
WHERE loan_status = 'Charged Off';

SELECT * FROM Bank_loan_data;

SELECT SUM(total_payment) as Bad_Loan_Received_Amount 
FROM bank_loan_data
WHERE loan_status = 'Charged Off'

SELECT * FROM Bank_loan_data;

SELECT 
	loan_status,
	COUNT(id) as Total_Loan_Applications,
	SUM(total_payment) as Total_Received_Amount,
	SUM(loan_amount) as Total_Funded_Amount,
	ROUND(AVG(int_rate),4) * 100 as Interest_Rate,
	ROUND(AVG(dti),4) * 100 as DTI
FROM 
	bank_loan_data
GROUP BY
	loan_status;

SELECT
	loan_status,
	COUNT(id) as MTD_Total_Loan_Applications,
	SUM(total_payment) as MTD_Total_Received_Amount,
	SUM(loan_amount) as MTD_Total_Funded_Amount
FROM 
	bank_loan_data
WHERE
	MONTH(issue_date) = 12
GROUP BY
	loan_status;

/* Metric : total_loan_application, Total_received_amount, total_funded_amount */
/*Monthly Trend By issue date : Retrive the Month name */
SELECT
	MONTH(issue_date) as Month_Number,
	DATENAME(MONTH,issue_date) as Month_Name,
	COUNT(id) as Total_Loan_application,
	SUM(loan_amount) as Toal_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM
	bank_loan_data
GROUP BY MONTH(issue_date),DATENAME(MONTH,issue_date)
ORDER BY MONTH(issue_date);

/* Regional trend */


SELECT
	address_state,
	COUNT(id) as Total_Loan_Application,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM
	bank_loan_data
GROUP BY address_state
ORDER BY COUNT(id) DESC;


/* Loan Term Analysis */
SELECT
	term,
	COUNT(id) as Total_Loan_Application,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM
	bank_loan_data
GROUP BY term
ORDER BY term;

SELECT * FROM Bank_loan_data;

/* Employee length */
SELECT 
	emp_length,
	COUNT(id)  as Toal_loan_applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM
	bank_loan_data
GROUP BY emp_length
ORDER BY COUNT(id) DESC;

/* Loan Purpose */
SELECT 
	purpose,
	COUNT(id)  as Toal_loan_applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM
	bank_loan_data
GROUP BY purpose
ORDER BY COUNT(id) DESC;

/* home_ownership */
SELECT 
	home_ownership,
	COUNT(id)  as Toal_loan_applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
FROM
	bank_loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;