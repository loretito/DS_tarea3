# Hadoop, Spark, Pig, Hive Docker Setup

This repository is a Docker setup for Hadoop, Spark, Pig, and Hive, created by [Suhothayan](https://github.com/suhothayan).

## Docker Container Setup

To run the container with Hadoop, Spark, Pig, and Hive, use the following command:

```sh
docker run -it --name my-hadoop-container -p 50070:50070 -p 8089:8088 -p 8080:8080 --memory="5g" --memory-swap="6g" --cpus="4" suhothayan/hadoop-spark-pig-hive:2.9.2 bash
```

## Copying the Dataset to the Container

To copy your dataset into the Docker container, use the following command:

```sh
docker cp <dataset_path> my-hadoop-container:/home/dataset1
```

Replace `<dataset_path>` with the path to your dataset.

## HDFS Setup

1. **Create a Directory in HDFS:**

    ```sh
    hdfs dfs -mkdir -p /user/hadoop/datasets
    ```

2. **Upload the CSV File to HDFS:**

    ```sh
    hdfs dfs -put /home/dataset1 /user/hadoop/datasets/
    ```

## Pig Script for Exploratory Analysis

To copy and execute a Pig script for exploratory data analysis, follow these steps:

1. **Copy the Pig Script to the Container:**

    ```sh
    docker cp analisis_exploratorio.pig my-hadoop-container:/home/analisis_exploratorio.pig
    ```

2. **Run the Pig Script:**

    Inside the container, navigate to the home directory and run the Pig script:

    ```sh
    pig /home/analisis_exploratorio.pig
    ```

## Notes

- Hay que cambiar el .pig, el codigo que subi esta malo no funciona pipipi

- Repo, cretidos a esta persona
https://github.com/suhothayan/hadoop-spark-pig-hive?tab=readme-ov-file

- Docker run del container
docker run -it --name my-hadoop-container -p 50070:50070 -p 8089:8088 -p 8080:8080 --memory="5g" --memory-swap="6g" --cpus="4" suhothayan/hadoop-spark-pig-hive:2.9.2 bash

- Copiar el dataset
docker cp <dataset_path> my-hadoop-container:/home/dataset1

- Crear un directorio en HDFS para almacenar el dataset
     dfs -mkdir -p /user/hadoop/datasets

- Subir el archivo CSV a HDFS
hdfs dfs -put dataset1 /user/hadoop/datasets/

- Copiar pig file para analisis exploratorio -> AQUI HAY Q CAMBIAR EL SCRIPT PQ ESTA MALOOOOOO
docker cp analisis_exploratorio.pig my-hadoop-container:/home/analisis_exploratorio.pig

hdfs dfs -get /user/hadoop/datasets/average_taken_by_type /home/output/average_taken_by_type
hdfs dfs -get /user/hadoop/datasets/count_by_type /home/output/count_by_type
hdfs dfs -get /user/hadoop/datasets/taken_branches /home/output/taken_branches

docker cp my-hadoop-container:/home/output/average_taken_by_type /home/cmunoz/Desktop/U/2024-1/DS/DS_tarea3/output/average_taken_by_type
docker cp my-hadoop-container:/home/output/count_by_type /home/cmunoz/Desktop/U/2024-1/DS/DS_tarea3/output/count_by_type
docker cp my-hadoop-container:/home/output/taken_branches /home/cmunoz/Desktop/U/2024-1/DS/DS_tarea3/output/taken_branches