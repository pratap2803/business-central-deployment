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



service:
  name: business-central-service  # Name of the service
  type: NodePort  # Expose service using NodePort (for external access)
  ports:
    - name: http  # Name of the first port
      port: 8080   # Business Central UI port
      targetPort: 8080
      nodePort: 30001  # NodePort on the host for Business Central UI
    - name: management  # Name of the second port
      port: 9990   # Management Console port
      targetPort: 9990
      nodePort: 30002  # NodePort on the host for Management Console
 
