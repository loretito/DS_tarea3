# Hadoop, Spark, Pig, Hive Docker Setup

This repository is a Docker setup for Hadoop, Spark, Pig, and Hive, created by [Suhothayan](https://github.com/suhothayan).

## Docker Container Setup

To download the image:

```sh
docker pull suhothayan/hadoop-spark-pig-hive:2.9.2
```

To run the container with Hadoop, Spark, Pig, and Hive, use the following command:

```sh
docker run -it --name my-hadoop-container --memory 30g -p 50070:50070 -p 8089:8088 -p 8080:8080 suhothayan/hadoop-spark-pig-hive:2.9.2 bash
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
    docker cp analisis.pig my-hadoop-container:/home/
    ```

    Replace `<pig_script_path>` with your preferred path.

2. **Run the Pig Script:**

    Inside the container, navigate to the home directory and run the Pig script:

    ```sh
    pig analisis_exploratorio.pig
    ```

## Retrieving Output from Container to Local Machine

Inside the container, navigate to the home directory and run:

```sh
docker cp my-hadoop-container:/home/output <local_path>
```

Replace `<local_path>` with your preferred path.

## Hive

Run the next command to start Hive:

```sh
hive
```

## Troubleshooting

If you encounter connection issues with Pig and the Hadoop Job Server, follow these steps:

1. Find the container ID:

    ```sh
    docker ps
    ```

2. Modify `update_hadoop.sh` with your container ID on line 27:

    ```xml
    <value>hdfs://<containerID>:9000</value>
    ```

3. Copy `update_hadoop.sh` to your container:

```sh
docker cp update_hadoop.sh <container ID>:/home/
```

4. Change permissions:

    ```sh
    chmod +x update_hadoop.sh
    ```

5. Run the script:

    ```sh
    ./update_hadoop.sh
    ```

6. Run the Pig script.

## Additional Notes

- If Hive is not working, restart the container.
- For automated queries, make the script executable and run it:

    ```sh
    chmod +x automate_sampling.sh
    ./automate_sampling.sh
    ```

  Make sure to copy the `.sh` file from the host machine to the container.

- To increase RAM allocation:

    1. Find the container ID:

        ```sh
        docker ps
        ```

    2. Modify `update_hadoop_config.sh` with your container ID on line 35:

        ```xml
        <value>hdfs://<containerID>:9000</value>
        ```

    3. Copy `update_hadoop_config.sh` to your container:

      ```sh
      docker cp update_hadoop_config.sh <container ID>:/home/
      ```

    4. Change permissions and run the script:

        ```sh
        chmod +x update_hadoop_config.sh
        ./update_hadoop_config.sh
        ```

5. Run the Pig script.