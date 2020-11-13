docker rm --force rhdm
docker run --volume /Users/mcarioli/POC/Lendage/sto:/opt/kie/data \
           --publish 8080:8080 \
           --publish 8001:8001 \
           --detach \
           --name rhdm rhdm:1
           # setting JAVA_OPTS causes error at start up
#          --env JAVA_OPTS='-Xms2G -Xmx2G -XX:MaxMetaspaceSize=500m' \