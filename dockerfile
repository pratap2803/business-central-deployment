# Start from the base image
FROM quay.io/kiegroup/business-central-workbench:latest

# Set environment variables
ENV JBOSS_HOME=/opt/jboss/wildfly
ENV USER=jboss

# Create necessary directories, set ownership, and permissions
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
    chmod -R ugo+w $JBOSS_HOME/standalone/data/kernel && \
    chmod -R 777 $JBOSS_HOME/standalone/data && \
    chmod -R 777 $JBOSS_HOME/standalone/log && \
    chmod -R 777 $JBOSS_HOME/standalone/tmp && \
    chmod -R 777 $JBOSS_HOME/standalone/deployments

# Verify application user and ownership
RUN whoami && ls -ld $JBOSS_HOME/standalone/data/kernel && \
    chown -R $USER:$USER $JBOSS_HOME/standalone/data/kernel && \
    chmod -R u+w,g+w,o+w $JBOSS_HOME/standalone/data/kernel

# Debugging: Output permissions and ownership
RUN ls -ld $JBOSS_HOME/standalone && \
    ls -ld $JBOSS_HOME/standalone/data && \
    ls -ld $JBOSS_HOME/standalone/data/kernel

# Create an Application Realm user
RUN $JBOSS_HOME/bin/add-user.sh -a User1 admin@123 -g admin,kie-server

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
