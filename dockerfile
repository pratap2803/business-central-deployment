# Use the Business Central Workbench image as base
FROM quay.io/kiegroup/business-central-workbench:latest

# Set environment variables
ENV JBOSS_HOME=/opt/jboss/wildfly
ENV USER=jboss

# Switch to root user to perform administrative tasks
USER root

# Update existing packages and install Maven, Gradle, and Curl
RUN yum update -y && \
    yum install -y curl maven gradle

# Add a new user 'kabir' with admin and users group
RUN $JBOSS_HOME/bin/add-user.sh -a -u kabir -p kabir123 -g users,admin -s

# Adjust file permissions for necessary directories
RUN mkdir -p \
    $JBOSS_HOME/standalone/data/content \
    $JBOSS_HOME/standalone/data/kernel \
    $JBOSS_HOME/standalone/data/log \
    $JBOSS_HOME/standalone/data/tmp \
    $JBOSS_HOME/standalone/deployments \
    $JBOSS_HOME/standalone/log \
    $JBOSS_HOME/standalone/tmp \
    $JBOSS_HOME/standalone/configuration && \
    chown -R $USER:$USER $JBOSS_HOME/standalone && \
    chmod -R 755 $JBOSS_HOME/standalone && \
    chmod -R 777 $JBOSS_HOME/standalone

# Switch back to the 'jboss' user for security
USER jboss

# Define volumes for persistent data
VOLUME ["$JBOSS_HOME/standalone/data", \
        "$JBOSS_HOME/standalone/deployments", \
        "$JBOSS_HOME/standalone/log", \
        "$JBOSS_HOME/standalone/tmp", \
        "$JBOSS_HOME/standalone/configuration"]

# Expose necessary ports
EXPOSE 8080 9990

# Command to run the Business Central Workbench
CMD ["sh", "-c", "$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0"]
