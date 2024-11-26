# Start from the base image
FROM quay.io/kiegroup/business-central-workbench:latest

# Set environment variables (adjust as needed for your setup)
ENV JBOSS_HOME=/opt/jboss/wildfly
ENV USER=jboss

# Create the necessary directories and set appropriate permissions
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
    chmod -R u+w,g+w,o+w $JBOSS_HOME/standalone/data/kernel && \
    chmod 777 $JBOSS_HOME/standalone/data && \
    chmod 777 $JBOSS_HOME/standalone/log && \
    chmod 777 $JBOSS_HOME/standalone/tmp && \
    chmod 777 $JBOSS_HOME/standalone/deployments

# Define volumes for persistent data
VOLUME ["$JBOSS_HOME/standalone/data", \
        "$JBOSS_HOME/standalone/deployments", \
        "$JBOSS_HOME/standalone/log", \
        "$JBOSS_HOME/standalone/tmp", \
        "$JBOSS_HOME/standalone/configuration"]

# Expose necessary ports
EXPOSE 8080 9990

# Set the entrypoint to run the server directly
ENTRYPOINT ["sh", "-c", "$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0"]

# Command to run the Business Central Workbench
CMD ["sh", "-c", "$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0"]
