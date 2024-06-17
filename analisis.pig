-- Carga el dataset desde HDFS
raw_data = LOAD '/user/hadoop/datasets/dataset1.csv' USING PigStorage(',') AS 
    (branch_addr:chararray, branch_type:chararray, taken:int, target:chararray);

-- Obtener estadísticas básicas
stats = FOREACH (GROUP raw_data ALL) GENERATE 
    COUNT(raw_data) AS total_records;

STORE stats INTO 'file:///home/output/stats' USING PigStorage(',');
DUMP stats;

-- Contar la frecuencia de cada tipo de branch
branch_freq = FOREACH (GROUP raw_data BY branch_type) GENERATE 
    group AS branch_type, 
    COUNT(raw_data) AS frequency;

--STORE branch_freq INTO 'hdfs:///user/hadoop/output/branch_freq' USING PigStorage(',');
STORE branch_freq INTO 'file:///home/output/branch_freq' USING PigStorage(',');
DUMP branch_freq;

-- Analizar la relación entre los tipos de branch y el valor de 'taken'
branch_taken = FOREACH (GROUP raw_data BY (branch_type, taken)) GENERATE 
    FLATTEN(group) AS (branch_type, taken), 
    COUNT(raw_data) AS frequency;

--STORE branch_taken INTO 'hdfs:///user/hadoop/output/branch_taken' USING PigStorage(',');
STORE branch_taken INTO 'file:///home/output/branch_taken' USING PigStorage(',');
DUMP branch_taken;

-- Calcular la proporción de registros con 'taken' igual a 1 para cada tipo de branch
branch_taken_ratio = FOREACH (GROUP raw_data BY branch_type) GENERATE 
    group AS branch_type, 
    (double)SUM(raw_data.taken) / COUNT(raw_data) AS taken_ratio;

DUMP branch_taken_ratio;

--STORE branch_taken_ratio INTO 'hdfs:///user/hadoop/output/branch_taken_ratio' USING PigStorage(',');
STORE branch_taken_ratio INTO 'file:///home/output/branch_taken_ratio' USING PigStorage(',');
DUMP branch_taken_ratio;
