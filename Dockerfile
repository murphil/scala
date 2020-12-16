FROM ubuntu:20.04
#https://github.com/mbari-org/docker-polynote/blob/master/Dockerfile.jdk11

WORKDIR /opt

ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED TRUE

RUN apt-get update \
  && apt-get install -y \
     build-essential \
     curl \
     default-jdk \
     python3 \
     python3-pip

ENV JAVA_HOME /usr/lib/jvm/default-java/
RUN pip3 install \
  jep \
  jedi \
  pyspark==3.0.1 \
  virtualenv \
  numpy \
  pandas

# Install polynote, spark, and then cleanup
RUN curl -L https://github.com/polynote/polynote/releases/download/0.3.12/polynote-dist-2.12.tar.gz | tar -xzvpf -
RUN curl -L http://apache.claz.org/spark/spark-3.0.1/spark-3.0.1-bin-hadoop3.2.tgz | tar -xzvpf - \
  && mv spark* spark

ENV PYSPARK_ALLOW_INSECURE_GATEWAY 1
ENV SPARK_HOME /opt/spark
ENV PATH "$PATH:$JAVA_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin"

COPY config.yml ./polynote/config.yml

EXPOSE 8192

CMD polynote/polynote.py