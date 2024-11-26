# Start from the base image
FROM quay.io/kiegroup/business-central-workbench:latest

# Set environment variables
ENV JBOSS_HOME=/opt/jboss/wildfly
ENV USER=jboss

# Switch to root to fix directories and permissions
USER root

# Create and set permissions for essential directories
RUN mkdir -p \
    $JBOSS_HOME/standalone/data/kernel \
    $JBOSS_HOME/standalone/data/content \
    $JBOSS_HOME/standalone/data/log \
    $JBOSS_HOME/standalone/data/tmp \
    $JBOSS_HOME/standalone/deployments \
    $JBOSS_HOME/standalone/log \
    $JBOSS_HOME/standalone/tmp \
    $JBOSS_HOME/standalone/configuration && \
    chmod -R 777 $JBOSS_HOME/standalone/data && \
    chmod -R 777 $JBOSS_HOME/standalone/log && \
    chmod -R 777 $JBOSS_HOME/standalone/tmp && \
    chmod -R 755 $JBOSS_HOME/standalone/configuration

# Define writable volumes
VOLUME ["$JBOSS_HOME/standalone/data", \
        "$JBOSS_HOME/standalone/log", \
        "$JBOSS_HOME/standalone/tmp"]

# Expose ports
EXPOSE 8080 9990

# Switch back to non-root for running the server
USER $USER

# Command to start the server
CMD ["sh", "-c", "$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0"]
