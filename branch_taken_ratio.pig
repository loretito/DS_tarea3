-- Carga el dataset desde HDFS
raw_data = LOAD '/user/hadoop/datasets/dataset1.csv' USING PigStorage(',') AS 
    (branch_addr:chararray, branch_type:chararray, taken:int, target:chararray);

-- Calcular la proporción de registros con 'taken' igual a 1 para cada tipo de branch
branch_taken_ratio = FOREACH (GROUP raw_data BY branch_type) GENERATE 
    group AS branch_type, 
    (double)SUM(raw_data.taken) / COUNT(raw_data) AS taken_ratio;

--STORE branch_taken_ratio INTO 'hdfs:///user/hadoop/output/branch_taken_ratio' USING PigStorage(',');
STORE branch_taken_ratio INTO 'file:///home/output/branch_taken_ratio' USING PigStorage(',');
DUMP branch_taken_ratio;