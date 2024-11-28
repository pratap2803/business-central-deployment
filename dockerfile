# Use the Business Central Workbench image as base
FROM quay.io/kiegroup/business-central-workbench:latest

# Set environment variables
ENV JBOSS_HOME=/opt/jboss/wildfly
ENV USER=jboss

# Install expect to automate interactive add-user.sh script
RUN apt-get update && apt-get install -y expect

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

# Run the add-user.sh script with the provided inputs using expect
RUN /bin/expect -c "
spawn /opt/jboss/wildfly/bin/add-user.sh
expect \"What type of user do you wish to add?\"
send \"b\r\"
expect \"Username: \"
send \"swati\r\"
expect \"Password: \"
send \"Swati@123\r\"
expect \"Re-enter Password: \"
send \"Swati@123\r\"
expect \"Are you sure you want to use the password entered yes/no?\"
send \"yes\r\"
expect \"What groups do you want this user to belong to? (comma-separated)\"
send \"admin,kie-server,rest-all,analyst,developer\r\"
expect \"Is this correct yes/no?\"
send \"yes\r\"
expect \"Is this new user going to be used for one AS process to connect to another AS process?\"
send \"no\r\"
expect eof
"

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
