-- 1. Şehirler / Eyaletler Tablosu
CREATE TABLE province_names (
    province_id CHAR(2) PRIMARY KEY,
    province_name VARCHAR(50) NOT NULL
);

-- 2. Doktorlar Tablosu
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(50) NOT NULL
);

-- 3. Hastalar Tablosu
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    birth_date DATE NOT NULL,
    city VARCHAR(50),
    province_id CHAR(2) REFERENCES province_names(province_id),
    allergies VARCHAR(100),
    height DECIMAL(5,2),
    weight DECIMAL(5,2)
);

-- 4. Kabul / Yatış Tablosu (Admissions)
CREATE TABLE admissions (
    patient_id INT REFERENCES patients(patient_id),
    admission_date DATE NOT NULL,
    discharge_date DATE,
    diagnosis VARCHAR(150) NOT NULL,
    attending_doctor_id INT REFERENCES doctors(doctor_id),
    PRIMARY KEY (patient_id, admission_date)
);

-- 5. Acil Durum Kişileri Tablosu (Emergency Contacts)
CREATE TABLE emergency_contacts (
    contact_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    full_name VARCHAR(100),
    relationship VARCHAR(50),
    phone VARCHAR(20)
);

-- 6. Laboratuvar Sonuçları Tablosu (Lab Results)
CREATE TABLE lab_results (
    result_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    test_name VARCHAR(50) NOT NULL, 
    test_value DECIMAL(10,2),
    test_date DATE
);

-- 7. Reçeteler Tablosu (Prescriptions)
CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    medication_name VARCHAR(100),
    dosage VARCHAR(50),
    issue_date DATE
);