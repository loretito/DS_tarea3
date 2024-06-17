-- Carga el dataset desde HDFS
raw_data = LOAD '/user/hadoop/datasets/dataset1.csv' USING PigStorage(',') AS 
    (branch_addr:chararray, branch_type:chararray, taken:int, target:chararray);

-- Obtener estadísticas básicas
stats = FOREACH (GROUP raw_data ALL) GENERATE 
    COUNT(raw_data) AS total_records;

STORE stats INTO 'file:///home/output/stats' USING PigStorage(',');
DUMP stats;