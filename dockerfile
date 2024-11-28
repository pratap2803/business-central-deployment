# Use the Business Central Workbench image as base
FROM quay.io/kiegroup/business-central-workbench:latest

# Set environment variables
ENV JBOSS_HOME=/opt/jboss/wildfly
ENV USER=jboss

# Install required tools
RUN apt-get update && apt-get install -y sed

# Disable authentication by modifying configuration files
RUN sed -i '/<security-realm.*>/d' $JBOSS_HOME/standalone/configuration/standalone.xml && \
    sed -i '/<security-domain.*>/d' $JBOSS_HOME/standalone/configuration/standalone.xml && \
    echo -n "" > $JBOSS_HOME/standalone/configuration/application-users.properties && \
    echo -n "" > $JBOSS_HOME/standalone/configuration/application-roles.properties

# Adjust file permissions
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
