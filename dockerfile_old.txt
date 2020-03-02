# official Docker Glassfish image
FROM glassfish:latest

LABEL MAINTAINER="Fisher"

ENV GLASSFISH_LIB=$GLASSFISH_HOME/glassfish/domains/domain1/lib/ext/

ENV GF_PASSWORD=glassfish

# Switch to Glassfish Runtime User
#USER glassfish

# Change Glassfish admin password
RUN \
    echo "AS_ADMIN_PASSWORD=" > $GLASSFISH_HOME/asadmin_passwd && \
    echo "AS_ADMIN_NEWPASSWORD=${GF_PASSWORD}" >> $GLASSFISH_HOME/asadmin_passwd && \
    asadmin --user=admin --passwordfile=$GLASSFISH_HOME/asadmin_passwd change-admin-password --domain_name domain1 && \
    asadmin start-domain && \
    echo "AS_ADMIN_PASSWORD=${GF_PASSWORD}" > $GLASSFISH_HOME/asadmin_passwd && \
    asadmin --user=admin --passwordfile=$GLASSFISH_HOME/asadmin_passwd enable-secure-admin && \
    asadmin --user=admin stop-domain


# ADD WAR (change it accordingly to the name of your .war file)
#ADD target/javaee-showcase.war /usr/local/glassfish4/glassfish/domains/domain1/autodeploy/
######
# SETUP/START GF
#ADD init\_gf.sh /home/ RUN chmod +x /home/init\_gf.sh CMD /home/init\_gf.sh

# EXPOSE CONTAINER PORTS (8080 for the JEE application and 4848 for the Glassfish admin area)
EXPOSE 8080 4848

# Start asadmin console and the domain
ENTRYPOINT ["asadmin", "start-domain", "-v"]

COPY target/javaee-showcase.war $GLASSFISH_HOME/glassfish/domains/domain1/autodeploy/