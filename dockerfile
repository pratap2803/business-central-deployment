# Use the official Business Central Workbench image as the base image
FROM quay.io/kiegroup/business-central-workbench:latest

# Create all necessary directories for WildFly
RUN mkdir -p \
    /opt/jboss/wildfly/standalone/log \
    /opt/jboss/wildfly/standalone/tmp \
    /opt/jboss/wildfly/standalone/data/content \
    /opt/jboss/wildfly/standalone/configuration \
    /opt/jboss/wildfly/standalone/deployments

# Set permissions to ensure WildFly can access all directories
# 777 provides full access (read, write, execute) to all users
RUN chmod -R 777 /opt/jboss/wildfly/standalone

# Ensure the user running the container has the correct ownership of directories
RUN chown -R jboss:jboss /opt/jboss/wildfly/standalone

# Expose ports for HTTP, management console, and other necessary endpoints
EXPOSE 8080 9990

# Declare persistent volumes for critical data and logs
VOLUME ["/opt/jboss/wildfly/standalone/log", "/opt/jboss/wildfly/standalone/data", "/opt/jboss/wildfly/standalone/deployments"]

# Start WildFly in standalone mode, binding it to all network interfaces
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
