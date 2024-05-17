CREATE TABLE PatientRecords (
    PatientID INTEGER PRIMARY KEY,
    Name TEXT,
    Age INTEGER,
    Gender TEXT,
    DiabetesType TEXT,
    LastConsultation DATE,
    HbA1c FLOAT
);

INSERT INTO PatientRecords (PatientID, Name, Age, Gender, DiabetesType, LastConsultation, HbA1c)
VALUES
    (1, 'John Doe', 45, 'Male', 'Type 2', '2024-03-25', 7.2),
    (2, 'Jane Smith', 52, 'Female', 'Type 1', '2024-03-20', 6.5),
    (3, 'Emily Davis', 38, 'Female', 'Type 2', '2024-03-22', 8.1),
    (4, 'Michael Brown', 60, 'Male', 'Type 2', '2024-02-28', 7.5),
    (5, 'Jessica Wilson', 44, 'Female', 'Type 1', '2024-03-15', 6.8),
    (6, 'William Johnson', 35, 'Male', 'Type 1', '2024-03-30', 7.0),
    (7, 'Olivia Martin', 29, 'Female', 'Type 1', '2024-03-05', 7.3),
    (8, 'James Taylor', 48, 'Male', 'Type 2', '2024-01-29', 8.4),
    (9, 'Laura Anderson', 55, 'Female', 'Gestational', '2024-03-11', 5.9),
    (10, 'Robert Thomas', 50, 'Male', 'Type 2', '2024-03-18', 7.6);

INSERT INTO PatientRecords (PatientID, Name, Age, Gender, DiabetesType, LastConsultation, HbA1c)
VALUES
    (11, 'JD', 45, 'Male', 'Type 3', '2024-03-25', 7.2)

DELETE FROM PATIENTRECORDS WHERE PATIENTID = 11

CREATE TABLE AppointmentDetails (
    AppointmentID INTEGER PRIMARY KEY,
    PatientID INTEGER,
    AppointmentDate DATE,
    HealthcareProfessional TEXT,
    VisitPurpose TEXT,
    ConsultationNotes TEXT,
    FOREIGN KEY (PatientID) REFERENCES PatientRecords(PatientID)
);

INSERT INTO AppointmentDetails (AppointmentID, PatientID, AppointmentDate, HealthcareProfessional, VisitPurpose, ConsultationNotes)
VALUES
    (1, 1, '2024-04-05', 'Dr. Sarah Lee', 'Routine Check-up', 'Patient managing well, continue current medication'),
    (2, 2, '2024-04-03', 'Dr. Mike Brown', 'Routine Check-up', 'Adjust insulin dosage'),
    (3, 3, '2024-04-10', 'Dr. Sarah Lee', 'Follow-up', 'Check blood pressure and adjust medication'),
    (4, 4, '2024-03-29', 'Dr. Emily Clark', 'Routine Check-up', 'Recommend dietary changes'),
    (5, 5, '2024-04-15', 'Dr. Mike Brown', 'Emergency', 'Hypoglycemic event, provided treatment'),
    (6, 6, '2024-04-08', 'Dr. Sarah Lee', 'Follow-up', 'Good progress, keep up with the exercise'),
    (7, 7, '2024-04-12', 'Dr. Emily Clark', 'Routine Check-up', 'Adjust medication, monitor closely'),
    (8, 8, '2024-03-25', 'Dr. Mike Brown', 'Routine Check-up', 'Stable condition, continue treatment'),
    (9, 9, '2024-04-20', 'Dr. Sarah Lee', 'Follow-up', 'Gestational diabetes management'),
    (10, 10, '2024-04-18', 'Dr. Emily Clark', 'Routine Check-up', 'Encouraged weight management'),
    (11, 1, '2024-05-05', 'Dr. Sarah Lee', 'Follow-up', 'Continue with current plan, next checkup in 3 months'),
    (12, 2, '2024-05-03', 'Dr. Mike Brown', 'Emergency', 'Advised hospital visit for further tests'),
    (13, 3, '2024-05-10', 'Dr. Sarah Lee', 'Routine Check-up', 'Stable HbA1c, review in 6 months'),
    (14, 5, '2024-05-15', 'Dr. Mike Brown', 'Follow-up', 'Positive response to new insulin'),
    (15, 7, '2024-05-12', 'Dr. Emily Clark', 'Routine Check-up', 'Continue monitoring glucose levels');

INSERT INTO AppointmentDetails (AppointmentID, PatientID, AppointmentDate, HealthcareProfessional, VisitPurpose, ConsultationNotes)
VALUES
    (16, 1, '2024-06-05', 'Dr. Emily Clark', 'Routine Check-up', 'Patient managing well, continue current medication')

DELETE FROM APPOINTMENTDETAILS WHERE APPOINTMENTID = 16

select * from patients
select * from appointmentdetails

CREATE TABLE HealthcareProfessionals (
    ProfessionalID INTEGER PRIMARY KEY,
    Name TEXT,
    Specialty TEXT,
    ContactInfo TEXT
);

INSERT INTO HealthcareProfessionals (ProfessionalID, Name, Specialty, ContactInfo)
VALUES
    (1, 'Dr. Sarah Lee', 'Endocrinology', 'sarah.lee@example.com'),
    (2, 'Dr. Mike Brown', 'General Practice', 'mike.brown@example.com'),
    (3, 'Dr. Emily Clark', 'Endocrinology', 'emily.clark@example.com'),
    (4, 'Dr. John Carter', 'Cardiology', 'john.carter@example.com'),
    (5, 'Dr. Olivia White', 'Nephrology', 'olivia.white@example.com'),
    (6, 'Dr. Lucas Graham', 'Endocrinology', 'lucas.graham@example.com'),
    (7, 'Dr. Sophia Taylor', 'General Practice', 'sophia.taylor@example.com'),
    (8, 'Dr. Mason Scott', 'Cardiology', 'mason.scott@example.com'),
    (9, 'Dr. Isabella Hall', 'Nephrology', 'isabella.hall@example.com'),
    (10, 'Dr. Ethan King', 'Endocrinology', 'ethan.king@example.com');

CREATE TABLE MedicationsPrescribed (
    PrescriptionID INTEGER PRIMARY KEY,
    AppointmentID INTEGER,
    MedicationName TEXT,
    Dosage TEXT,
    Instructions TEXT,
    FOREIGN KEY (AppointmentID) REFERENCES AppointmentDetails(AppointmentID)
);

INSERT INTO MedicationsPrescribed (PrescriptionID, AppointmentID, MedicationName, Dosage, Instructions)
VALUES
    (1, 1, 'Metformin', '500mg', 'Twice a day with meals'),
    (2, 2, 'Insulin Glargine', '20 units', 'Once a day at bedtime'),
    (3, 3, 'Lisinopril', '10mg', 'Once a day in the morning'),
    (4, 4, 'Atorvastatin', '40mg', 'Once a day in the evening'),
    (5, 5, 'Metformin', '850mg', 'Twice a day with meals'),
    (6, 6, 'Humalog', 'As per need', 'Before meals'),
    (7, 7, 'Metformin', '1000mg', 'Twice a day with meals'),
    (8, 8, 'Insulin Aspart', '25 units', 'Twice a day'),
    (9, 9, 'Simvastatin', '20mg', 'Once a day in the evening'),
    (10, 10, 'Amlodipine', '5mg', 'Once a day in the morning'),
    (11, 11, 'Metformin', '750mg', 'Twice a day with meals'),
    (12, 12, 'Insulin Detemir', '18 units', 'Once a day at bedtime'),
    (13, 13, 'Hydrochlorothiazide', '25mg', 'Once a day in the morning'),
    (14, 14, 'Glipizide', '10mg', 'Twice a day, 30 minutes before meals'),
    (15, 15, 'Insulin Lispro', 'As per need', 'Before meals');

CREATE TABLE Transactionst (
    TransactionID INTEGER PRIMARY KEY,
    PatientID INTEGER,
    TransactionDate DATE,
    ServiceProvided TEXT,
    AmountCharged FLOAT,
    FOREIGN KEY (PatientID) REFERENCES PatientRecords(PatientID)
);

INSERT INTO Transactionst (TransactionID, PatientID, TransactionDate, ServiceProvided, AmountCharged)
VALUES
    (1, 1, '2024-04-05', 'Consultation', 100.00),
    (2, 2, '2024-04-03', 'Lab Test: Blood Panel', 200.00),
    (3, 3, '2024-04-10', 'Medication: Insulin', 50.00),
    (4, 4, '2024-03-29', 'Consultation', 100.00),
    (5, 5, '2024-04-15', 'Emergency Service', 300.00),
    (6, 6, '2024-04-08', 'Consultation', 100.00),
    (7, 7, '2024-04-12', 'Lab Test: HbA1c', 150.00),
    (8, 8, '2024-03-25', 'Medication: Metformin', 30.00),
    (9, 9, '2024-04-20', 'Consultation', 100.00),
    (10, 10, '2024-04-18', 'Lab Test: Cholesterol', 180.00),
    (11, 1, '2024-05-05', 'Medication: Blood Pressure', 60.00),
    (12, 2, '2024-05-03', 'Emergency Service', 300.00),
    (13, 3, '2024-05-10', 'Consultation', 100.00),
    (14, 5, '2024-05-15', 'Medication: Insulin', 50.00),
    (15, 7, '2024-05-12', 'Lab Test: Kidney Function', 170.00);

INSERT INTO Transactionst (TransactionID, PatientID, TransactionDate, ServiceProvided, AmountCharged)
VALUES 
 (16, 11, '2024-05-12', 'Lab Test: Kidney Function', NULL )
 
DELETE FROM TRANSACTIONST WHERE TRANSACTIONID = 16
 
CREATE TABLE Patients (
    PatientID INTEGER PRIMARY KEY,
    FullName TEXT,
    DateOfBirth DATE,
    Address TEXT,
    PhoneNumber TEXT,
    Email TEXT,
    MedicalHistorySummary TEXT
);

INSERT INTO Patients (PatientID, FullName, DateOfBirth, Address, PhoneNumber, Email, MedicalHistorySummary)
VALUES
    (1, 'John Doe', '1979-02-15', '123 Elm St, Springfield', '555-0101', 'johndoe@email.com', 'Type 2 Diabetes, Hypertension'),
    (2, 'Jane Smith', '1971-07-24', '456 Oak St, Rivertown', '555-0202', 'janesmith@email.com', 'Type 1 Diabetes'),
    (3, 'Emily Davis', '1985-05-30', '789 Pine St, Lakeview', '555-0303', 'emilydavis@email.com', 'Type 2 Diabetes, High Cholesterol'),
    (4, 'Michael Brown', '1964-04-12', '101 Maple Ave, Hillside', '555-0404', 'michaelbrown@email.com', 'Type 2 Diabetes, Cardiopathy'),
    (5, 'Jessica Wilson', '1976-08-09', '202 Birch Rd, Seaside', '555-0505', 'jessicawilson@email.com', 'Type 1 Diabetes, Thyroid disorder'),
    (6, 'William Johnson', '1988-03-15', '303 Cedar Ln, Greenwood', '555-0606', 'williamjohnson@email.com', 'Type 1 Diabetes'),
    (7, 'Olivia Martin', '1994-12-22', '404 Spruce St, Westfield', '555-0707', 'oliviamartin@email.com', 'Type 1 Diabetes, Asthma'),
    (8, 'James Taylor', '1975-06-05', '505 Elm St, Easton', '555-0808', 'jamestaylor@email.com', 'Type 2 Diabetes, Obesity'),
    (9, 'Laura Anderson', '1969-11-08', '606 Oak St, Brookside', '555-0909', 'lauraanderson@email.com', 'Gestational Diabetes'),
    (10, 'Robert Thomas', '1974-01-20', '707 Pine St, Cliffside', '555-1010', 'robertthomas@email.com', 'Type 2 Diabetes, Hypertension');

INSERT INTO Patients (PatientID, FullName, DateOfBirth, Address, PhoneNumber, Email, MedicalHistorySummary)
VALUES
    (11, 'JD', '1979-02-15', '123 Elm St, Springfield', '555-0101', 'johndoe@email.com', 'Type 3 Diabetes, Hypertension')
DELETE FROM PATIENTS WHERE PATIENTID = 11

select * from Patients
select * from Transactionst
select * from AppointmentDetails
select * from HealthcareProfessionals
select * from MedicationsPrescribed

--Can we see a list of all our patients along with the date of their last appointment?
SELECT p.fullname AS patientname, MAX(a.appointmentdate) as lastappointmentdate 
FROM Patients p
LEFT JOIN AppointmentDetails a ON p.patientid = a.patientid
GROUP BY p.patientid,p.fullname
ORDER BY patientname ASC;

--What's the total amount we've charged each patient?"
SELECT p.fullname, SUM(t.amountcharged) AS totalamountcharged
FROM patients p
JOIN transactionst t ON p.patientid = t.patientid
GROUP BY p.fullname ,p.patientid
ORDER BY totalamountcharged DESC

--Which medication do we prescribe the most, and how often?
SELECT MAX(m.medicationname) AS MEDICATIONNAME,COUNT(m.medicationname) AS numberoftimesprescribed
FROM MedicationSprescribed M
GROUP BY m.medicationname
ORDER BY numberoftimesprescribed DESC
LIMIT 1;

--How do we rank our patients by the number of their appointments?
SELECT FullName AS PatientName,
       ROW_NUMBER() OVER (ORDER BY AppointmentCount DESC) AS AppointmentRank --using dense_rank()
FROM (SELECT p.FullName, COUNT(a.AppointmentID) AS AppointmentCount
      FROM Patients p
      LEFT JOIN AppointmentDetails a ON p.PatientID = a.PatientID
      GROUP BY p.FullName) AS AppointmentCounts;
	  
	                      
--Who are our patients that haven't booked any appointments yet?"
SELECT p.fullname AS patientlist
FROM patients p
LEFT JOIN appointmentdetails a ON p.patientid = a.patientid
WHERE a.appointmentID IS NULL;


--Can we track the next appointment date for each patient?" 
WITH PreviousAppointment AS (
    SELECT PatientID, AppointmentDate, Nextappointmentdate, rn
FROM (
    SELECT PatientID, AppointmentDate,
           LEAD(AppointmentDate) OVER (PARTITION BY PatientID ORDER BY AppointmentDate) AS NextAppointmentDate,--used lead to find the next then rank() to rank them to filter the top 1
           RANK() OVER (PARTITION BY PatientID ORDER BY AppointmentDate) AS rn
    FROM AppointmentDetails
) AS Subquery
WHERE rn = 1
)
SELECT p.FullName AS PatientName, 
       pa.NextAppointmentDate AS NextAppointmentDate
FROM Patients p
LEFT JOIN PreviousAppointment pa ON p.PatientID = pa.PatientID
WHERE nextappointmentdate IS NOT NULL
ORDER BY
      NextAppointmentdate;

--Which healthcare professionals haven't seen any patients?"
SELECT h.NAME AS health_care_professional,
       COALESCE(CAST(a.appointmentid AS text), 'No appointment scheduled') AS appointmentstatus 
FROM 
       appointmentdetails a
RIGHT JOIN
       healthcareprofessionals h ON a.healthcareprofessional = h.NAME
WHERE 
       a.appointmentid IS NULL;

--Can we identify patients who had back-to-back appointments within a 30-day period?"
WITH AppointmentGaps AS (
    SELECT 
        ap.PatientID,p.fullname,
        ap.AppointmentDate,
        LEAD(ap.AppointmentDate) OVER (PARTITION BY ap.PatientID ORDER BY ap.AppointmentDate) AS NextAppointmentDate,--to find the next app date to compare with the actual app date to find the difference falling in <=30
        LEAD(AppointmentDate) OVER (PARTITION BY ap.PatientID ORDER BY ap.AppointmentDate) - ap.AppointmentDate AS Gap-- difference between next and previous(org app date)
    FROM AppointmentDetails ap
	JOIN patients P ON p.patientid = ap.patientid
)
SELECT 
    fullname AS Patientname
FROM 
    AppointmentGaps
WHERE 
    Gap <= 30
ORDER BY patientname;

WITH patients_next_appointmentdate AS (
    SELECT 
        a.patientid,p.fullname As patientname,
        a.appointmentdate AS current_appointmentdate,
        LEAD(a.appointmentdate) OVER(PARTITION BY a.patientid ORDER BY a.appointmentdate) AS next_appointmentdate
    FROM appointmentdetails a
	INNER JOIN patients p ON p.patientid = a.patientid
)
                                                     --OR(Using date_trunc())--

WITH PatientAppointments AS (
    SELECT 
        PatientID,
        AppointmentDate,
        LEAD(AppointmentDate) OVER (PARTITION BY PatientID ORDER BY AppointmentDate) AS NextAppointmentDate
    FROM 
        AppointmentDetails
)
SELECT 
    PatientID,
    AppointmentDate AS PreviousAppointmentDate,
    NextAppointmentDate,
    EXTRACT(day FROM DATE_TRUNC('day', NextAppointmentDate) - DATE_TRUNC('day', AppointmentDate)) AS GapInDays
FROM 
    PatientAppointments
WHERE 
    EXTRACT(day FROM DATE_TRUNC('day', NextAppointmentDate) - DATE_TRUNC('day', AppointmentDate)) <= 30;


--What's the average charge per appointment for each healthcare professional?"
SELECT hp.name AS healthcareproffesional, 
       CAST(AVG(t.AmountCharged) AS int) AS AC
FROM 
       transactionst t
INNER JOIN 
       appointmentdetails ap ON ap.patientid = t.patientid
INNER JOIN 
       healthcareprofessionals hp ON hp.name = ap.healthcareprofessional
GROUP BY hp.name;



