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
echo ""


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
echo ""


# Update core-site.xml with the new properties
cat <<EOL > "$CORE_SITE_PATH"
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://<container ID>:9000</value>
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
echo ""


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
echo ""

# Update yarn-site.xml with the new properties
cat <<EOL > "$YARN_SITE_PATH"
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>

    <property>
      <name>yarn.application.classpath</name>
      <value>/usr/local/hadoop/etc/hadoop, /usr/local/hadoop/share/hadoop/common/*, /usr/local/hadoop/share/hadoop/common/lib/*, /usr/local/hadoop/share/hadoop/hdfs/*, /usr/local/hadoop/share/hadoop/hdfs/lib/*, /usr/local/hadoop/share/hadoop/mapreduce/*, /usr/local/hadoop/share/hadoop/mapreduce/lib/*, /usr/local/hadoop/share/hadoop/yarn/*, /usr/local/hadoop/share/hadoop/yarn/lib/*</value>
    </property>

    <property>
    <description>
      Number of seconds after an application finishes before the nodemanager's
      DeletionService will delete the application's localized file directory
      and log directory.

      To diagnose Yarn application problems, set this property's value large
      enough (for example, to 600 = 10 minutes) to permit examination of these
      directories. After changing the property's value, you must restart the
      nodemanager in order for it to have an effect.

      The roots of Yarn applications' work directories is configurable with
      the yarn.nodemanager.local-dirs property (see below), and the roots
      of the Yarn applications' log directories is configurable with the
      yarn.nodemanager.log-dirs property (see also below).
    </description>
    <name>yarn.nodemanager.delete.debug-delay-sec</name>
    <value>600</value>
    </property>
    
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
echo ""

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
echo ""

# Update mapred-site.xml with the new properties
cat <<EOL > "$MAPRED_SITE_PATH"
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
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
echo ""

# Restart Hadoop services
/usr/local/hadoop/sbin/stop-dfs.sh
if [ $? -eq 0 ]; then
    echo "Hadoop DFS stopped successfully."
else
    echo "Failed to stop Hadoop DFS."
    exit 1
fi
echo ""

/usr/local/hadoop/sbin/stop-yarn.sh
if [ $? -eq 0 ]; then
    echo "Hadoop YARN stopped successfully."
else
    echo "Failed to stop Hadoop YARN."
    exit 1
fi
echo ""

/usr/local/hadoop/sbin/start-dfs.sh
if [ $? -eq 0 ]; then
    echo "Hadoop DFS started successfully."
else
    echo "Failed to start Hadoop DFS."
    exit 1
fi
echo ""

/usr/local/hadoop/sbin/start-yarn.sh
if [ $? -eq 0 ]; then
    echo "Hadoop YARN started successfully."
else
    echo "Failed to start Hadoop YARN."
    exit 1
fi
echo ""

echo "Hadoop services restarted successfully."
