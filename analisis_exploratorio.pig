-- Load the data from HDFS
data = LOAD '/user/hadoop/datasets/dataset1.csv' 
    USING PigStorage(',')
    AS (branch_addr: chararray, branch_type: chararray, taken: int, target: chararray);

-- Display the schema of the data
DESCRIBE data;

-- Sample data to validate the load (first 10 rows)
LIMITED_DATA = LIMIT data 10;
DUMP LIMITED_DATA;

-- Group data by branch_type to count the occurrences of each type
grouped_by_type = GROUP data BY branch_type;
count_by_type = FOREACH grouped_by_type GENERATE group AS branch_type, COUNT(data) AS count;

-- Calculate the average 'taken' value for each branch_type
average_taken_by_type = FOREACH grouped_by_type GENERATE group AS branch_type, AVG(data.taken) AS avg_taken;

-- Filter data where branch is taken (taken == 1)
taken_branches = FILTER data BY taken == 1;

-- Save the results to HDFS
STORE count_by_type INTO '/user/hadoop/datasets/count_by_type' USING PigStorage(',');
STORE average_taken_by_type INTO '/user/hadoop/datasets/average_taken_by_type' USING PigStorage(',');
STORE taken_branches INTO '/user/hadoop/datasets/taken_branches' USING PigStorage(',');