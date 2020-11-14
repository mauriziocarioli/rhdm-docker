FROM registry.redhat.io/rhdm-7/rhdm-decisioncentral-rhel8
ENV KIE_HOME /opt/kie
ENV KIE_DATA $KIE_HOME/data
ENV JBOSS_HOME /opt/eap
ENV JBOSS_CONFIG /opt/eap/standalone/configuration
ENV JBOSS_BIN $JBOSS_HOME/bin
ENV M2 $KIE_DATA/.m2
ENV MAVEN_REPO $M2/repository
ENV GITHOOKS $KIE_DATA/githooks
ENV GITHOOKS_CONFIG_DIR $HOME/.bcgithook
ENV GITHOOKS_CONFIG default.conf
RUN mkdir $KIE_DATA
RUN mkdir $GITHOOKS
RUN mkdir $GITHOOKS_CONFIG_DIR
RUN mkdir $M2
RUN mkdir $MAVEN_REPO
#Setting JAVA_OPTS causes error at start up.
#ENV JAVA_OPTS -Xms2G -Xmx2G -XX:MaxMetaspaceSize=500m -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8
COPY etc/settings.xml $M2/settings.xml
#The post-commit file is not copied. Using persistent volume instead.
#COPY etc/post-commit $GITHOOKS/post-commit
COPY etc/$GITHOOKS_CONFIG $GITHOOKS_CONFIG_DIR
COPY etc/application-roles.properties $JBOSS_CONFIG/application-roles.properties
COPY etc/application-users.properties $JBOSS_CONFIG/application-users.properties
COPY etc/mgmt-groups.properties $$JBOSS_CONFIG/mgmt-groups.properties
COPY etc/mgmt-users.properties $JBOSS_CONFIG/mgmt-users.properties
COPY etc/standalone-full.xml $JBOSS_CONFIG/standalone.xml
COPY etc/standalone.sh $JBOSS_BIN/standalone.sh
USER root
RUN chown -R jboss:root $KIE_DATA 
RUN chown jboss:root $JBOSS_BIN/standalone.sh
RUN chown jboss:root $JBOSS_CONFIG/standalone.xml
RUN chown jboss:root $JBOSS_CONFIG/application-roles.properties
RUN chown jboss:root $JBOSS_CONFIG/application-users.properties
RUN chown jboss:root $GITHOOKS_CONFIG_DIR/$GITHOOKS_CONFIG
#RUN chown jboss:root $GITHOOKS/post-commit
#RUN chmod 755 $GITHOOKS/post-commit
USER jboss
#do not expose jboss management ports
#EXPOSE 9990 9999 8080 8001
EXPOSE 8080 8001
ENTRYPOINT ["/opt/eap/bin/standalone.sh"]
#do not allow jboss management
#CMD ["-c","standalone.xml","-b","0.0.0.0","-bmanagement","0.0.0.0"]
#using -D to set system variables gives invalid option error
#CMD ["-c","standalone.xml","-b","0.0.0.0","-D","org.uberfire.nio.git.dir=/opt/kie/data","-D","org.guvnor.m2repo.dir=/opt/kie/data/.m2/repository","-D","kie.maven.settings.custom=/opt/kie/data/.m2/settings.xml"]
CMD ["-c","standalone.xml","-b","0.0.0.0"]
#login at localhost:8080/login
#rest server at localhost:8080/rest