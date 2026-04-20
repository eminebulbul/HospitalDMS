-- 0. Önce her şeyi temizleyip ID sayaçlarını 1'e sıfırlayalım (Güvenlik önlemi)
TRUNCATE TABLE prescriptions, lab_results, emergency_contacts, admissions, patients, doctors, province_names RESTART IDENTITY CASCADE;

-- 1. Eyalet/Şehir Verilerini Ekleme
INSERT INTO province_names (province_id, province_name) VALUES 
('ON', 'Ontario'), ('QC', 'Quebec'), ('NS', 'Nova Scotia'), 
('NB', 'New Brunswick'), ('MB', 'Manitoba'), ('BC', 'British Columbia');

-- 2. 50 Gerçekçi Doktor Ekleme
INSERT INTO doctors (first_name, last_name, specialty)
SELECT 
    (ARRAY['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda', 'William', 'Elizabeth'])[floor(random() * 10 + 1)],
    (ARRAY['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez'])[floor(random() * 10 + 1)],
    (ARRAY['Cardiology', 'Neurology', 'Pediatrics', 'Oncology', 'Dermatology', 'Psychiatry', 'Orthopedics', 'General Surgery', 'Internal Medicine'])[floor(random() * 9 + 1)]
FROM generate_series(1, 50);

-- 3. 50.000 Gerçekçi Hasta Ekleme
INSERT INTO patients (first_name, last_name, gender, birth_date, city, province_id, weight, height)
SELECT 
    (ARRAY['David', 'Sarah', 'Joseph', 'Karen', 'Charles', 'Nancy', 'Thomas', 'Lisa', 'Daniel', 'Margaret', 'Matthew', 'Betty', 'Anthony', 'Sandra', 'Mark', 'Ashley'])[floor(random() * 16 + 1)],
    (ARRAY['Taylor', 'Anderson', 'Thomas', 'Jackson', 'White', 'Harris', 'Martin', 'Thompson', 'Moore', 'Young'])[floor(random() * 10 + 1)],
    CASE WHEN random() < 0.5 THEN 'M' ELSE 'F' END,
    NOW() - (random() * interval '80 years') - interval '18 years',
    (ARRAY['Toronto', 'Montreal', 'Vancouver', 'Calgary', 'Ottawa', 'Halifax'])[floor(random() * 6 + 1)],
    (ARRAY['ON', 'QC', 'NS', 'NB', 'MB', 'BC'])[floor(random() * 6 + 1)],
    (random() * 50 + 50)::numeric(5,2),
    (random() * 50 + 150)::numeric(5,2)
FROM generate_series(1, 50000);

-- 4. 500.000 Gerçekçi Yatış (Admissions) Kaydı Ekleme
INSERT INTO admissions (patient_id, admission_date, discharge_date, diagnosis, attending_doctor_id)
SELECT 
    (random() * 49999 + 1)::INT, 
    (NOW() - (random() * interval '5 years'))::DATE,
    (NOW() - (random() * interval '4 years'))::DATE,
    (ARRAY['Hypertension', 'Diabetes Type 2', 'Asthma', 'Migraine', 'Pneumonia', 'Appendicitis', 'Fractured Femur', 'Concussion', 'COVID-19', 'Heart Failure', 'Anemia', 'Bronchitis'])[floor(random() * 12 + 1)],
    (random() * 49 + 1)::INT
FROM generate_series(1, 500000)
ON CONFLICT (patient_id, admission_date) DO NOTHING;

-- 5. 50.000 Acil Durum Kişisi (Her hastaya 1 tane)
INSERT INTO emergency_contacts (patient_id, full_name, relationship, phone)
SELECT 
    patient_id,
    'Contact ' || patient_id,
    (ARRAY['Spouse', 'Parent', 'Sibling', 'Child', 'Friend'])[floor(random() * 5 + 1)],
    '555-' || (random() * 8999 + 1000)::INT
FROM patients;

-- 6. 200.000 Laboratuvar Sonucu (Glucose, Cholesterol vb.)
INSERT INTO lab_results (patient_id, test_name, test_value, test_date)
SELECT 
    (random() * 49999 + 1)::INT,
    (ARRAY['Glucose', 'Cholesterol', 'Thyroxine', 'Haemoglobin', 'Urea', 'Albumin'])[floor(random() * 6 + 1)],
    (random() * 200)::numeric(10,2),
    NOW() - (random() * interval '2 years')
FROM generate_series(1, 200000);

-- 7. 300.000 Reçete (İlaç yazımları)
INSERT INTO prescriptions (patient_id, doctor_id, medication_name, dosage, issue_date)
SELECT 
    (random() * 49999 + 1)::INT,
    (random() * 49 + 1)::INT,
    (ARRAY['Amoxicillin', 'Lisinopril', 'Metformin', 'Ibuprofen', 'Omeprazole', 'Aspirin'])[floor(random() * 6 + 1)],
    (ARRAY['10mg', '20mg', '50mg', '100mg', '500mg'])[floor(random() * 5 + 1)],
    NOW() - (random() * interval '3 years')
FROM generate_series(1, 300000);