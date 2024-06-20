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

STORE branch_freq INTO 'file:///home/output/branch_freq' USING PigStorage(',');
DUMP branch_freq;

-- Analizar la relación entre los tipos de branch y el valor de 'taken'
branch_taken = FOREACH (GROUP raw_data BY (branch_type, taken)) GENERATE 
    FLATTEN(group) AS (branch_type, taken), 
    COUNT(raw_data) AS frequency;

STORE branch_taken INTO 'file:///home/output/branch_taken' USING PigStorage(',');
DUMP branch_taken;

-- Calcular la proporción de registros con 'taken' igual a 1 para cada tipo de branch
branch_taken_ratio = FOREACH (GROUP raw_data BY branch_type) GENERATE 
    group AS branch_type, 
    (double)SUM(raw_data.taken) / COUNT(raw_data) AS taken_ratio;

STORE branch_taken_ratio INTO 'file:///home/output/branch_taken_ratio' USING PigStorage(',');
DUMP branch_taken_ratio;

-- Identificar el branch que hace más peticiones
branch_requests = FOREACH (GROUP raw_data BY branch_addr) GENERATE 
    group AS branch_addr, 
    COUNT(raw_data) AS requests;

ordered_branch_requests = ORDER branch_requests BY requests DESC;

top_branch_requester = LIMIT ordered_branch_requests 1;

STORE top_branch_requester INTO 'file:///home/output/top_branch_requester' USING PigStorage(',');
DUMP top_branch_requester;

-- Identificar el branch que recibe más saltos/peticiones
branch_targets = FOREACH (GROUP raw_data BY target) GENERATE 
    group AS target, 
    COUNT(raw_data) AS jumps;

ordered_branch_targets = ORDER branch_targets BY jumps DESC;

top_branch_target = LIMIT ordered_branch_targets 1;

STORE top_branch_target INTO 'file:///home/output/top_branch_target' USING PigStorage(',');
DUMP top_branch_target;

-- Dump de 10 datos aleatorios
sample_data = SAMPLE raw_data 0.1;

limited_sample_data = LIMIT sample_data 10;

STORE limited_sample_data INTO 'file:///home/output/sample_data' USING PigStorage(',');
DUMP limited_sample_data;
