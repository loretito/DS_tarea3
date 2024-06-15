-- Load the CSV file from HDFS
branches = LOAD '/user/hadoop/datasets/dataset1.csv' 
    USING PigStorage(',')
    AS (branch_addr:chararray, branch_type:chararray, taken:int, target:chararray);

-- Display the schema of the data
DESCRIBE branches;

-- Count the number of each branch type
branch_type_count = GROUP branches BY branch_type;
branch_type_frequency = FOREACH branch_type_count GENERATE group AS branch_type, COUNT(branches) AS frequency;

-- Store the result in HDFS
STORE branch_type_frequency INTO '/tmp/output/branch_type_frequency' USING PigStorage(',');

-- Analyze the relationship between branch types and 'taken' value
taken_analysis = GROUP branches BY (branch_type, taken);
taken_analysis_count = FOREACH taken_analysis GENERATE FLATTEN(group) AS (branch_type, taken), COUNT(branches) AS count;

-- Store the result in HDFS
STORE taken_analysis_count INTO '/tmp/output/taken_analysis_count' USING PigStorage(',');

-- Calculate the proportion of 'taken' equal to 1 for each branch type
taken_one = FILTER branches BY taken == 1;
group_by_branch_type = GROUP taken_one BY branch_type;
proportion_taken_one = FOREACH group_by_branch_type GENERATE group AS branch_type, COUNT(taken_one) AS taken_count;
join_with_total = JOIN proportion_taken_one BY branch_type, branch_type_frequency BY branch_type;
proportion = FOREACH join_with_total GENERATE proportion_taken_one::branch_type, 
                (double)proportion_taken_one::taken_count / branch_type_frequency::frequency AS proportion_taken;

-- Store the result in HDFS
STORE proportion INTO '/tmp/output/proportion_taken_one' USING PigStorage(',');