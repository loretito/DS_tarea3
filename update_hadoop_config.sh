#!/bin/bash

# Variables
CORE_SITE_PATH="/usr/local/hadoop/etc/hadoop/core-site.xml"
YARN_SITE_PATH="/usr/local/hadoop/etc/hadoop/yarn-site.xml"
MAPRED_SITE_PATH="/usr/local/hadoop/etc/hadoop/mapred-site.xml"

# Function to check if a file exists
check_file_exists() {
    if [ ! -f "$1" ]; then
        echo "$1 not found."
        exit 1
    else
        echo "$1 found."
    fi
}

# Check if core-site.xml exists
check_file_exists "$CORE_SITE_PATH"

# Backup core-site.xml
cp "$CORE_SITE_PATH" "$CORE_SITE_PATH.bak"
if [ $? -eq 0 ]; then
    echo "Backup of core-site.xml created at $CORE_SITE_PATH.bak."
else
    echo "Failed to create backup of core-site.xml."
    exit 1
fi

# Update core-site.xml with the new properties
cat <<EOL > "$CORE_SITE_PATH"
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://d7634826ca49:9000</value>
    </property>
    <property>
        <name>ipc.client.connect.max.retries</name>
        <value>1</value>
    </property>
    <property>
        <name>ipc.client.connect.retry.interval</name>
        <value>1000</value>
    </property>
    <property>
        <name>ipc.client.connect.max.retries.on.timeouts</name>
        <value>1</value>
    </property>
    <property>
        <name>ipc.client.connect.timeout</name>
        <value>2000</value>
    </property>
    <!-- Optionally, you can disable retries completely -->
    <property>
        <name>ipc.client.connect.max.retries</name>
        <value>0</value>
    </property>
    <property>
        <name>ipc.client.connect.max.retries.on.timeouts</name>
        <value>0</value>
    </property>
</configuration>
EOL

if [ $? -eq 0 ]; then
    echo "core-site.xml updated successfully."
else
    echo "Failed to update core-site.xml."
    exit 1
fi

# Check if yarn-site.xml exists
check_file_exists "$YARN_SITE_PATH"

# Backup yarn-site.xml
cp "$YARN_SITE_PATH" "$YARN_SITE_PATH.bak"
if [ $? -eq 0 ]; then
    echo "Backup of yarn-site.xml created at $YARN_SITE_PATH.bak."
else
    echo "Failed to create backup of yarn-site.xml."
    exit 1
fi

# Update yarn-site.xml with the new properties
cat <<EOL > "$YARN_SITE_PATH"
<configuration>
    <property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>30720</value> <!-- 30 GB en MB -->
    </property>
    <property>
        <name>yarn.scheduler.maximum-allocation-mb</name>
        <value>30720</value> <!-- 30 GB en MB -->
    </property>
    <property>
        <name>yarn.scheduler.minimum-allocation-mb</name>
        <value>1024</value> <!-- 1 GB en MB -->
    </property>
</configuration>
EOL

if [ $? -eq 0 ]; then
    echo "yarn-site.xml updated successfully."
else
    echo "Failed to update yarn-site.xml."
    exit 1
fi

# Check if mapred-site.xml exists
check_file_exists "$MAPRED_SITE_PATH"

# Backup mapred-site.xml
cp "$MAPRED_SITE_PATH" "$MAPRED_SITE_PATH.bak"
if [ $? -eq 0 ]; then
    echo "Backup of mapred-site.xml created at $MAPRED_SITE_PATH.bak."
else
    echo "Failed to create backup of mapred-site.xml."
    exit 1
fi

# Update mapred-site.xml with the new properties
cat <<EOL > "$MAPRED_SITE_PATH"
<configuration>
    <property>
        <name>mapreduce.map.memory.mb</name>
        <value>30720</value> <!-- 30 GB en MB -->
    </property>
    <property>
        <name>mapreduce.reduce.memory.mb</name>
        <value>30720</value> <!-- 30 GB en MB -->
    </property>
    <property>
        <name>mapreduce.map.java.opts</name>
        <value>-Xmx24576m</value> <!-- 24 GB en MB -->
    </property>
    <property>
        <name>mapreduce.reduce.java.opts</name>
        <value>-Xmx24576m</value> <!-- 24 GB en MB -->
    </property>
    <property>
        <name>mapreduce.task.io.sort.mb</name>
        <value>1024</value> <!-- 1 GB -->
    </property>
</configuration>
EOL

if [ $? -eq 0 ]; then
    echo "mapred-site.xml updated successfully."
else
    echo "Failed to update mapred-site.xml."
    exit 1
fi

# Restart Hadoop services
/usr/local/hadoop/sbin/stop-dfs.sh
if [ $? -eq 0 ]; then
    echo "Hadoop DFS stopped successfully."
else
    echo "Failed to stop Hadoop DFS."
    exit 1
fi

/usr/local/hadoop/sbin/stop-yarn.sh
if [ $? -eq 0 ]; then
    echo "Hadoop YARN stopped successfully."
else
    echo "Failed to stop Hadoop YARN."
    exit 1
fi

/usr/local/hadoop/sbin/start-dfs.sh
if [ $? -eq 0 ]; then
    echo "Hadoop DFS started successfully."
else
    echo "Failed to start Hadoop DFS."
    exit 1
fi

/usr/local/hadoop/sbin/start-yarn.sh
if [ $? -eq 0 ]; then
    echo "Hadoop YARN started successfully."
else
    echo "Failed to start Hadoop YARN."
    exit 1
fi

echo "Hadoop services restarted successfully."
