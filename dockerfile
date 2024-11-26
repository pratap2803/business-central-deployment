# Use the official Business Central Workbench image as the base image
FROM quay.io/kiegroup/business-central-workbench:latest

# Create necessary directories for WildFly
RUN mkdir -p /opt/jboss/wildfly/standalone/log /opt/jboss/wildfly/standalone/data

# Set permissions to ensure WildFly can access these directories
RUN chmod -R 777 /opt/jboss/wildfly/standalone/log /opt/jboss/wildfly/standalone/data

# Expose ports for HTTP and management console access
EXPOSE 8080 9990

# Declare volumes for logs and persistent data
VOLUME ["/opt/jboss/wildfly/standalone/log", "/opt/jboss/wildfly/standalone/data"]

# Start WildFly in standalone mode, binding it to all network interfaces
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
