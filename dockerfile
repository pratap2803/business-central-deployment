# Use the base image for Business Central
FROM quay.io/kiegroup/business-central-workbench:latest

# Set environment variables
ENV JBOSS_HOME=/opt/jboss/wildfly
ENV USER=jboss

# Switch to root user to ensure all operations can modify directories
USER root

# Create necessary directories and set permissions
RUN mkdir -p \
    $JBOSS_HOME/standalone/data/content \
    $JBOSS_HOME/standalone/data/kernel \
    $JBOSS_HOME/standalone/data/log \
    $JBOSS_HOME/standalone/data/tmp \
    $JBOSS_HOME/standalone/deployments \
    $JBOSS_HOME/standalone/log \
    $JBOSS_HOME/standalone/tmp \
    $JBOSS_HOME/standalone/configuration && \
    chmod -R 777 $JBOSS_HOME/standalone && \
    echo "Directories created and permissions set."

# Debugging step: Show the directory structure after setup
RUN ls -lR $JBOSS_HOME/standalone

# Expose necessary ports for Business Central
EXPOSE 8080 9990

# Define the entry point to run the application
CMD ["sh", "-c", "$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0"]
