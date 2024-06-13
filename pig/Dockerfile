# Usa una imagen base de Hadoop
FROM bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8

# Establecer las variables de entorno para Pig
ENV PIG_VERSION=0.17.0

# Descargar y descomprimir Apache Pig
RUN wget http://apache.mirrors.tds.net/pig/pig-${PIG_VERSION}/pig-${PIG_VERSION}.tar.gz \
    && tar -xzvf pig-${PIG_VERSION}.tar.gz \
    && mv pig-${PIG_VERSION} /opt/ \
    && rm pig-${PIG_VERSION}.tar.gz

# Establecer las variables de entorno para Pig
ENV PIG_HOME=/opt/pig-${PIG_VERSION}
ENV PATH=$PATH:$PIG_HOME/bin

# Comando por defecto para ejecutar Pig
CMD ["pig"]
