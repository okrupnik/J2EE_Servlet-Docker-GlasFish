# Example of multi-staged build
# First stage used for building artifacts from application source codes
# Second stage is used for deployment

# Build stage
FROM maven:3.6.0-jdk-11-slim AS build

LABEL MAINTAINER="Fisher"

# TODO Consider replacing that with git clone in a case of using cloud-based CI environment
COPY src /home/app/src
COPY pom.xml /home/app

RUN mvn -f /home/app/pom.xml clean package

# Package stage
FROM java:8-jdk

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV GLASSFISH_HOME /usr/local/glassfish4
ENV PATH $PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin
ENV GF_PASSWORD=glassfish

RUN curl -L -o /tmp/glassfish-4.1.zip http://download.java.net/glassfish/4.1/release/glassfish-4.1.zip && \
  unzip /tmp/glassfish-4.1.zip -d /usr/local && \
  rm -f /tmp/glassfish-4.1.zip
  
# Change Glassfish admin password
RUN \
    echo "AS_ADMIN_PASSWORD=" > $GLASSFISH_HOME/asadmin_passwd && \
    echo "AS_ADMIN_NEWPASSWORD=${GF_PASSWORD}" >> $GLASSFISH_HOME/asadmin_passwd && \
    asadmin --user=admin --passwordfile=$GLASSFISH_HOME/asadmin_passwd change-admin-password --domain_name domain1 && \
    asadmin start-domain && \
    echo "AS_ADMIN_PASSWORD=${GF_PASSWORD}" > $GLASSFISH_HOME/asadmin_passwd && \
    asadmin --user=admin --passwordfile=$GLASSFISH_HOME/asadmin_passwd enable-secure-admin && \
    asadmin --user=admin stop-domain

EXPOSE 8080 4848 8181

WORKDIR /usr/local/glassfish4

COPY --from=build /home/app/target/javaee-showcase.war $GLASSFISH_HOME/glassfish/domains/domain1/autodeploy

# verbose causes the process to remain in the foreground so that docker can track it
CMD asadmin start-domain --verbose