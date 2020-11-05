FROM registry.redhat.io/rhdm-7/rhdm-decisioncentral-rhel8
ENV HOME /opt
ENV KIE_HOME $HOME/kie
ENV KIE_DATA $KIE_HOME/data
ENV JBOSS_HOME $HOME/eap
ENV JBOSS_CONFIG /opt/eap/standalone/configuration
ENV JBOSS_BIN $JBOSS_HOME/bin
ENV MAVEN_REPO $KIE_DATA/.m2
ENV GIT_REPO $KIE_DATA/git
ENV GITHOOKS $KIE_DATA/githooks
RUN mkdir $KIE_DATA
RUN mkdir $MAVEN_REPO
RUN mkdir $GIT_REPO
RUN mkdir $GITHOOKS
COPY etc/settings.xml $MAVEN_REPO
COPY etc/application-roles.properties $JBOSS_CONFIG/application-roles.properties
COPY etc/application-users.properties $JBOSS_CONFIG/application-users.properties
COPY etc/mgmt-groups.properties $$JBOSS_CONFIG/mgmt-groups.properties
COPY etc/mgmt-users.properties $JBOSS_CONFIG/mgmt-users.properties
COPY etc/standalone-full.xml $JBOSS_CONFIG/standalone.xml
COPY etc/standalone.sh $JBOSS_BIN/standalone.sh
USER root
RUN chown -R jboss:root $JBOSS_CONFIG/standalone.xml $JBOSS_BIN/standalone.sh $KIE_DATA $MAVEN_REPO $GIT_REPO $GITHOOKS
USER jboss
#EXPOSE 9990 9999 8080 8001
EXPOSE 8080 8001
ENTRYPOINT ["/opt/eap/bin/standalone.sh"]
#CMD ["-c","standalone.xml","-b","0.0.0.0","-bmanagement","0.0.0.0"]
CMD ["-c","standalone.xml","-b","0.0.0.0"]