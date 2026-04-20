
CREATE TABLE patient_secrets (
    patient_id INT PRIMARY KEY REFERENCES patients(patient_id),
    national_id_encoded VARCHAR(255) -- Şifrelenmiş veri alanı
);




INSERT INTO patient_secrets (patient_id, national_id_encoded)
SELECT 
    patient_id,
    encode((floor(random() * 89999999999 + 10000000000))::TEXT::bytea, 'base64')
FROM patients 
ORDER BY patient_id
LIMIT 100; -- Test amaçlı ilk 100 hastayı ekliyoruz.




SELECT * FROM patient_secrets LIMIT 5;



  
SELECT 
    p.first_name, 
    p.last_name,
    convert_from(decode(s.national_id_encoded, 'base64'), 'UTF8') AS tc_kimlik_no
FROM patients p
JOIN patient_secrets s ON p.patient_id = s.patient_id;