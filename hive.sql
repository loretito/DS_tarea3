CREATE TABLE branches (
    branch_addr STRING,
    branch_type STRING,
    taken INT,
    target STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA INPATH '/user/hadoop/datasets/dataset1.csv' INTO TABLE branches;

--Obtener estadísticas básicas
SELECT COUNT(*) AS total_records FROM branches;

--Contar la frecuencia de cada tipo de branch
SELECT branch_type, COUNT(*) AS frequency
FROM branches
GROUP BY branch_type;

--Analizar la relación entre branch_type y taken
SELECT branch_type, taken, COUNT(*) AS count
FROM branches
GROUP BY branch_type, taken;

--Calcular la proporción de registros con taken igual a 1 para cada tipo de branch
SELECT branch_type, 
       SUM(CASE WHEN taken = 1 THEN 1 ELSE 0 END) / COUNT(*) AS proportion_taken
FROM branches
GROUP BY branch_type;

--Crear una tabla para almacenar las frecuencias de branch_type
CREATE TABLE branch_type_frequency AS
SELECT branch_type, COUNT(*) AS frequency
FROM branches
GROUP BY branch_type;

--Crear una tabla para almacenar la relación entre branch_type y taken
CREATE TABLE branch_type_taken_relation AS
SELECT branch_type, taken, COUNT(*) AS count
FROM branches
GROUP BY branch_type, taken;

--Crear una tabla para almacenar la proporción de taken igual a 1 por branch_type
CREATE TABLE branch_type_taken_proportion AS
SELECT branch_type, 
       SUM(CASE WHEN taken = 1 THEN 1 ELSE 0 END) / COUNT(*) AS proportion_taken
FROM branches
GROUP BY branch_type;

--Tomar muestras y realizar los análisis
-- Crear una tabla para almacenar muestras
CREATE TABLE branch_sampled_data AS
SELECT * FROM branches TABLESAMPLE(10 PERCENT);

-- Repetir los analisis anteriores pero en esta tabla
-- Ejemplo de análisis en muestra
SELECT branch_type, COUNT(*) AS frequency
FROM branch_sampled_data
GROUP BY branch_type;