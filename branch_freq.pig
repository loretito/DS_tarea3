-- Carga el dataset desde HDFS
raw_data = LOAD '/user/hadoop/datasets/dataset1.csv' USING PigStorage(',') AS 
    (branch_addr:chararray, branch_type:chararray, taken:int, target:chararray);

-- Contar la frecuencia de cada tipo de branch
branch_freq = FOREACH (GROUP raw_data BY branch_type) GENERATE 
    group AS branch_type, 
    COUNT(raw_data) AS frequency;

--STORE branch_freq INTO 'hdfs:///user/hadoop/output/branch_freq' USING PigStorage(',');
STORE branch_freq INTO 'file:///home/output/branch_freq' USING PigStorage(',');
DUMP branch_freq;
