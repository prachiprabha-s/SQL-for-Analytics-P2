--Advanced Analysis with Subqueries and CTEs

--How does each patient's appointment count compare to the clinic's average?"
WITH AvgAppointmentCount AS (
    SELECT CAST(AVG(appointment_count) AS INT) AS avg_appointment_count --avg_app
    FROM (
        SELECT COUNT(*) AS appointment_count --finding the app count for each patient
        FROM AppointmentDetails
        GROUP BY PatientID
    ) AS counts
)
SELECT 
    p.FullName AS PatientName,
    COUNT(ad.AppointmentID) AS AppointmentCount,
    CASE 
        WHEN COUNT(ad.AppointmentID) > avg_count.avg_appointment_count THEN 'Above Average'
        WHEN COUNT(ad.AppointmentID) < avg_count.avg_appointment_count THEN 'Below Average'
        ELSE 'Equal to Average'
    END AS AppointmentComparison
FROM 
    Patients p
INNER JOIN 
    AppointmentDetails ad ON p.PatientID = ad.PatientID
INNER JOIN 
    AvgAppointmentCount avg_count ON 1=1
GROUP BY 
    p.PatientID, p.FullName, avg_count.avg_appointment_count
ORDER BY 
    AppointmentComparison ASC;

--For patients without transactions, can we ensure their total charged amount shows up as zero instead of NULL?
SELECT 
    p.FullName AS PatientName,
    COALESCE(SUM(t.AmountCharged), 0) AS TotalChargedAmount
FROM 
    Patients p
LEFT JOIN 
    Transactionst t ON p.PatientID = t.PatientID
GROUP BY 
    p.PatientID, p.FullName;

--What's the most common medication for each type of diabetes we treat?
WITH MedicationCounts AS ( 
    SELECT
        pr.DiabetesType,
        mp.MedicationName,
        COUNT(*) AS MedicationCount
    FROM
        PatientRecords pr
    JOIN
        AppointmentDetails ad ON pr.PatientID = ad.PatientID
    JOIN
        MedicationsPrescribed mp ON ad.AppointmentID = mp.AppointmentID
    GROUP BY
        pr.DiabetesType, mp.MedicationName
),
RankedMedications AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY DiabetesType ORDER BY MedicationCount DESC) AS ra_nk
    FROM
        MedicationCounts
)
SELECT
    DiabetesType,
    MedicationName AS MostCommonMedication
FROM
    RankedMedications
WHERE
    ra_nk = 1
ORDER BY
    medicationcount DESC

--Can we see the growth in appointment numbers from month to month?"
WITH MonthlyAppointmentCounts AS (  --app count per month
    SELECT 
        CAST(DATE_TRUNC('month', AppointmentDate) AS date) AS Month_,
        COUNT(*) AS AppointmentCount
    FROM 
        AppointmentDetails
    GROUP BY 
        CAST(DATE_TRUNC('month', AppointmentDate) AS date)
    ORDER BY 
        Month_
)
SELECT 
    Month_,
    AppointmentCount AS appointment_count_per_month,
    LAG(AppointmentCount) OVER (ORDER BY Month_) AS PreviousMonthAppointmentCount, --prev app_date count using lag()
	AppointmentCount - LAG(AppointmentCount) OVER (ORDER BY Month_) AS Countdifference --difference between them
FROM 
    MonthlyAppointmentCounts
ORDER BY Countdifference DESC;

--How do healthcare professionals' appointments and revenue compare?"
WITH countofappointment AS 
                  (SELECT COUNT(*) AS appointmentcount,
				      healthcareprofessional
                   FROM 
				      appointmentdetails
                   GROUP BY 
				      healthcareprofessional),
revenuegenerated AS 
                  (SELECT SUM(t.amountcharged) AS amountcharged , 
				          ap.healthcareprofessional
					 FROM 
				          appointmentdetails ap
					 INNER JOIN 
				          transactionst t ON t.transactionid = ap.appointmentid
					 GROUP BY 
				          ap.healthcareprofessional)
SELECT c.Healthcareprofessional,
       c.appointmentcount,
       r.amountcharged, 
CASE WHEN 
         r.amountcharged < 100 THEN 'low amount charged'
		 WHEN r.amountcharged BETWEEN 100 AND 600 THEN 'Medium amount charged'
		 ELSE 'High amount charged'
		 END AS amount_charged_category
FROM 
      countofappointment c
JOIN 
      revenuegenerated r ON r.Healthcareprofessional = c.Healthcareprofessional
GROUP BY 
      c.Healthcareprofessional,
	  c.appointmentcount,
	  r.amountcharged
ORDER BY 
      amount_charged_category 
	  
--Which medications have seen a change in their prescribing rank from month to month?"
-- This Common Table Expression (CTE) calculates the rank of each medication by month based on the number of prescriptions
WITH MonthlyMedicationRanks AS (
    SELECT 
        -- Truncate the appointment date to the month level and cast it as a date type
        CAST(DATE_TRUNC('month', AD.AppointmentDate) AS Date) AS Month,
        MP.MedicationName,
        COUNT(*) AS PrescriptionCount,
        -- Calculate the rank of each medication within the month based on prescription count
        DENSE_RANK() OVER (PARTITION BY CAST(DATE_TRUNC('month', AD.AppointmentDate) AS Date) ORDER BY COUNT(*) DESC) AS Rank
    FROM 
        MedicationsPrescribed MP
    JOIN 
        AppointmentDetails AD ON MP.AppointmentID = AD.AppointmentID
    GROUP BY 
        CAST(DATE_TRUNC('month', AD.AppointmentDate) AS Date), MP.MedicationName
),
-- This CTE calculates the ranks for the current and previous months for each medication
PreviousMonthRanks AS (
    SELECT 
        MMR1.Month AS CurrentMonth,
        MMR1.MedicationName,
        MMR1.Rank AS CurrentRank,
        -- Select the previous month's rank, using COALESCE to handle cases where there is no previous rank (assign 0)
        COALESCE(MMR2.Rank, 0) AS PreviousRank
    FROM 
        MonthlyMedicationRanks MMR1
    LEFT JOIN 
        -- Reference the MonthlyMedicationRanks CTE again to find the previous month's ranks
        MonthlyMedicationRanks MMR2 ON MMR1.MedicationName = MMR2.MedicationName
        -- Match the previous month by subtracting one month from the current month
        AND DATE_TRUNC('month', MMR1.Month - INTERVAL '1 month') = DATE_TRUNC('month', MMR2.Month)
)
-- Select the final results with the rank change status
SELECT DISTINCT
    PMR.CurrentMonth,
    PMR.MedicationName,
    -- Determine the rank change status based on the comparison between current and previous ranks
    CASE 
        WHEN PMR.CurrentRank > PMR.PreviousRank THEN 'Rank Increased'
        WHEN PMR.CurrentRank < PMR.PreviousRank THEN 'Rank Decreased'
    END AS RankChangeStatus
FROM 
    -- Reference the PreviousMonthRanks CTE
    PreviousMonthRanks PMR
-- Filter out rows where the rank change status is NULL (no change)
WHERE 
    CASE 
        WHEN PMR.CurrentRank > PMR.PreviousRank THEN 'Rank Increased'
        WHEN PMR.CurrentRank < PMR.PreviousRank THEN 'Rank Decreased'
    END IS NOT NULL
ORDER BY 
    PMR.CurrentMonth ASC, RankChangeStatus;

	
--Can we identify our top 3 most expensive services for each patient?"
WITH RankedServices AS (
    SELECT 
        p.PatientID,
        t.ServiceProvided,
        t.AmountCharged,
        DENSE_RANK() OVER (PARTITION BY p.PatientID ORDER BY t.AmountCharged DESC) AS ServiceRank
    FROM 
        Transactionst t
    INNER JOIN 
        Patients p ON t.PatientID = p.PatientID
)
SELECT 
    PatientID,
    ServiceProvided,
    AmountCharged
FROM 
    RankedServices
WHERE 
    ServiceRank <= 3
ORDER BY 
    amountcharged DESC
LIMIT 3;

--Who is our most frequently seen patient in terms of prescriptions, and what medications have they been prescribed?
WITH MostFrequentPatient AS (
    SELECT 
        p.PatientID,
        p.FullName AS PatientName,
        COUNT(mp.PrescriptionID) AS PrescriptionCount
    FROM 
        Patients p
    JOIN 
        AppointmentDetails ad ON p.PatientID = ad.PatientID
    JOIN 
        MedicationsPrescribed mp ON ad.AppointmentID = mp.AppointmentID
    GROUP BY 
        p.PatientID, p.FullName
    ORDER BY 
        PrescriptionCount DESC
    LIMIT 1
)
SELECT 
    mfp.PatientName,
    mp.MedicationName,
	ad.healthcareprofessional
FROM 
    MostFrequentPatient mfp
JOIN 
    AppointmentDetails ad ON mfp.PatientID = ad.PatientID
JOIN 
    MedicationsPrescribed mp ON ad.AppointmentID = mp.AppointmentID;

--How does our monthly revenue compare to the previous month?"
WITH total_revenue AS (SELECT 
        CAST(DATE_TRUNC('month', ad.AppointmentDate) AS date) AS Month,
        SUM(t.amountcharged) AS totalrevenue--total_revenue 
    FROM 
        AppointmentDetails ad
	INNER JOIN transactionst t ON t.transactionid = ad.appointmentid
    GROUP BY 
        CAST(DATE_TRUNC('month', ad.AppointmentDate) AS date) 
    ORDER BY 
        Month)
SELECT 
    Month,
    totalrevenue ,
    LAG(totalrevenue) OVER (order by Month) AS PreviousMonthrevenue,
	totalrevenue - LAG(totalrevenue) OVER (order by Month) AS Revenuedifference --diff between total(current) and previous
FROM 
    total_revenue;


