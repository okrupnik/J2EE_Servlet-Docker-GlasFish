# official Docker Glassfish image
FROM glassfish:latest

LABEL MAINTAINER="Fisher"

# ADD WAR (change it accordingly to the name of your .war file)
ADD target/javaee-showcase.war /usr/local/glassfish4/glassfish/domains/domain1/autodeploy/

# SETUP/START GF
ADD init\_gf.sh /home/ RUN chmod +x /home/init\_gf.sh CMD /home/init\_gf.sh

# EXPOSE CONTAINER PORTS (8080 for the JEE application and 4848 for the Glassfish admin area)
EXPOSE 8080 4848