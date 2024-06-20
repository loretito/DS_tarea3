#!/bin/bash

# Variables
CORE_SITE_PATH="/usr/local/hadoop/etc/hadoop/core-site.xml"

# Check if core-site.xml exists
if [ ! -f "$CORE_SITE_PATH" ]; then
    echo "core-site.xml not found at $CORE_SITE_PATH"
    exit 1
fi
echo "core-site.xml found."
echo ""

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


/usr/local/hadoop/sbin/start-dfs.sh
if [ $? -eq 0 ]; then
    echo "Hadoop DFS started successfully."
else
    echo "Failed to start Hadoop DFS."
    exit 1
fi
echo ""

echo "Hadoop services restarted successfully."