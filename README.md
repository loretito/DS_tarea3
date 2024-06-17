# Hadoop, Spark, Pig, Hive Docker Setup

This repository is a Docker setup for Hadoop, Spark, Pig, and Hive, created by [Suhothayan](https://github.com/suhothayan).

## Docker Container Setup

To download the image:

```sh
docker pull suhothayan/hadoop-spark-pig-hive:2.9.2
```

To run the container with Hadoop, Spark, Pig, and Hive, use the following command:

```sh
docker run -it --name my-hadoop-container -p 50070:50070 -p 8089:8088 -p 8080:8080 suhothayan/hadoop-spark-pig-hive:2.9.2 bash
```

Restart the container and open a bash:
```sh
docker exec -it my-hadoop-container /bin/bash
```

## Copying the Dataset to the Container

To copy your dataset into the Docker container, use the following command:

```sh
docker cp <dataset_path> my-hadoop-container:/home/dataset1.csv
```

Replace `<dataset_path>` with the path to your dataset.

## HDFS Setup

1. **Create a Directory in HDFS:**

    ```sh
    hdfs dfs -mkdir -p /user/hadoop/datasets
    ```

2. **Upload the CSV File to HDFS:**

    ```sh
    hdfs dfs -put /home/dataset1.csv /user/hadoop/datasets/
    ```

3. **Check the file:**
    ```sh
    hdfs dfs -ls /user/hadoop/datasets/
    ```

## Pig Script for Exploratory Analysis

To copy and execute a Pig script for exploratory data analysis, follow these steps:

1. **Copy the Pig Script to the Container:**

    ```sh
    docker cp <pig_script_path> my-hadoop-container:/home/analisis_exploratorio.pig
    ```
    Replace `<pig_script_path>` with your preference path.
2. **Run the Pig Script:**

    Inside the container, navigate to the home directory and run the Pig script:

    ```sh
    pig analisis_exploratorio.pig
    ```
## Retrieving Output from container to Local Machine

Inside the container, navigate to the home directory and run:

```sh
docker cp my-hadoop-container:/home/output <local_path>
```

Replace `<dataset_path>` with your preference path.

## Hive

Run the next command to run hive:

```sh
hive
```

## Notes

- Si no funciona hive, reiniciar el container.