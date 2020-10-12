FROM registry.redhat.io/rhdm-7/rhdm-decisioncentral-rhel8
USER jboss
COPY application-roles.properties /opt/eap/standalone/configuration/application-roles.properties
COPY application-users.properties /opt/eap/standalone/configuration/application-users.properties
COPY mgmt-groups.properties /opt/eap/standalone/configuration/mgmt-groups.properties
COPY mgmt-users.properties /opt/eap/standalone/configuration/mgmt-users.properties
COPY standalone-full.xml /opt/eap/standalone/configuration/standalone.xml
COPY standalone.sh /opt/eap/bin/standalone.sh
EXPOSE 9990 9999 8080
ENTRYPOINT ["/opt/eap/bin/standalone.sh"]
CMD ["-c","standalone.xml","-b", "0.0.0.0","-bmanagement","0.0.0.0"]