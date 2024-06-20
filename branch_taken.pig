-- Carga el dataset desde HDFS
raw_data = LOAD '/user/hadoop/datasets/dataset1.csv' USING PigStorage(',') AS 
    (branch_addr:chararray, branch_type:chararray, taken:int, target:chararray);

-- Analizar la relación entre los tipos de branch y el valor de 'taken'
branch_taken = FOREACH (GROUP raw_data BY (branch_type, taken)) GENERATE 
    FLATTEN(group) AS (branch_type, taken), 
    COUNT(raw_data) AS frequency;

--STORE branch_taken INTO 'hdfs:///user/hadoop/output/branch_taken' USING PigStorage(',');
STORE branch_taken INTO 'file:///home/output/branch_taken' USING PigStorage(',');
DUMP branch_taken;