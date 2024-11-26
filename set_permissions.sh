#!/bin/bash

# Set permissions for important directories to ensure proper write access
chmod -R 777 /opt/jboss/wildfly/standalone/data
chmod -R 777 /opt/jboss/wildfly/standalone/log
chmod -R 777 /opt/jboss/wildfly/standalone/tmp
chmod -R 777 /opt/jboss/wildfly/standalone/deployments
chmod -R 755 /opt/jboss/wildfly/standalone/configuration
chmod -R u+w,g+w,o+w /opt/jboss/wildfly/standalone/data/kernel

# Now execute the command passed as arguments to the entrypoint
exec "$@"
