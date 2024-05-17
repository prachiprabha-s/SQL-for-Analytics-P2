
--Medication and Revenue Analysis

--Who's the last patient each healthcare professional saw, and when?
WITH recentlycheckedpatient AS 
           ( SELECT ap.patientid, ap.appointmentdate,ap.healthcareprofessional,p.fullname,
             DENSE_RANK() over(partition by ap.healthcareprofessional ORDER BY ap.APPOINTMENTDATE DESC) AS recentlycheckedpatient ---finding last patient by app date desc to filter the top 1 
             FROM 
			     appointmentdetails ap 
             JOIN patients P ON p.patientid = ap.patientid)
SELECT fullname AS Lastpatientchecked ,
       healthcareprofessional, appointmentdate
FROM 
    recentlycheckedpatient
WHERE 
    recentlycheckedpatient = 1;
	


--Which of our patients have been prescribed insulin?"
WITH insulinprescribedpatient AS (SELECT p.fullname, m.medicationname ,
								  CASE WHEN
                                  m.medicationname LIKE '%Insulin%' THEN 'YES' ELSE 'NO'
						          END AS 
						          insulinprescribed
						          FROM medicationsprescribed m
						          INNER JOIN appointmentdetails ap ON ap.appointmentid = m.appointmentid
								  INNER JOIN patients p ON p.patientid = ap.patientid)
SELECT fullname AS patientname, medicationname
FROM insulinprescribedpatient
WHERE  insulinprescribed = 'YES';


--How can we calculate the total amount charged and the number of appointments for each patient?

SELECT p.fullname AS patientname, 
       SUM(t.Amountcharged) AS total_amount_charged, 
       COUNT(DISTINCT ap.appointmentid) AS total_number_of_appointments
FROM 
       patients p
LEFT JOIN 
       appointmentdetails ap ON p.patientid = ap.patientid
LEFT JOIN 
       transactionst t ON t.transactionid = ap.appointmentid
GROUP BY 
       p.fullname
ORDER BY 
       total_number_of_appointments DESC, total_amount_charged DESC;
	   
--alternative using self join
SELECT t.patientid AS patientid, 
       SUM(t.Amountcharged) AS total_amount_charged, 
       COUNT(t.transactionid) AS total_number_of_appointments
FROM 
       transactionst t
LEFT JOIN 
       transactionst t1 ON t.transactionid = t1.transactionid
GROUP BY t.patientid
ORDER BY 
       patientid
	   

--Can we rank our healthcare professionals by the number of unique patients they've seen?"	

SELECT
    hp.Name AS healthcare_professional,
    RANK() OVER ( ORDER BY COUNT(DISTINCT ad.PatientID) DESC) AS professional_rank,--number of unique patients desc
    COUNT(DISTINCT ad.PatientID) AS unique_patients_seen --number of unique_patients
FROM
    AppointmentDetails ad
INNER JOIN
    healthcareprofessionals hp ON ad.HealthcareProfessional = hp.Name
GROUP BY
    hp.Name;

