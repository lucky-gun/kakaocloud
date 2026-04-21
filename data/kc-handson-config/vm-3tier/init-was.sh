#!/bin/bash

init()
{
    sudo apt-get update
    sudo apt-get install git -y
    sudo apt-get install openjdk-8-jdk -y
    sudo apt-get install maven -y
    sudo mkdir -p /data/petclinic
    sudo mkdir -p /app/logs
    sudo chown $USER /data/*
    sudo chown $USER /data
    sudo chown $USER /app/*
    sudo chown $USER /app
}

killProcess()
{
    sudo kill -9 $(sudo lsof -t -i:8080)
}

cloneRepository()
{
    cd /data || exit
    git clone https://github.com/spring-petclinic/spring-petclinic-reactjs.git
    cd /data/spring-petclinic-reactjs || exit
    rm pom.xml
    curl -o pom.xml https://raw.githubusercontent.com/kakaoicloud/hands-on-examples/docs/vm-3tier/pom.xml

    cat <<EOF > /data/spring-petclinic-reactjs/src/main/resources/application.properties
    # database init, supports mysql too
    database=mysql
    spring.datasource.url= jdbc:mysql://$1:3306/petclinic
    spring.datasource.username=admin
    spring.datasource.password=root1234
    spring.datasource.driver-class-name=com.mysql.jdbc.Driver
    spring.datasource.schema=classpath*:db/${database}/schema.sql
    spring.datasource.data=classpath*:db/${database}/data.sql

    # Web
    spring.mvc.view.prefix=/WEB-INF/jsp/
    spring.mvc.view.suffix=.jsp

    # JPA
    spring.jpa.hibernate.ddl-auto=none

    # Internationalization
    spring.messages.basename=messages/messages

    # Actuator / Management
    management.contextPath=/manage

    # Logging
    logging.level.org.springframework=INFO

    # Active Spring profiles
    spring.profiles.active=production

    spring.jackson.serialization.write_dates_as_timestamps=false
EOF
}

buildRepository()
{
    mvn clean package spring-boot:repackage
    cp /data/spring-petclinic-reactjs/target/petclinic.jar /app
}

runPackage()
{
    java -jar /app/petclinic.jar >> /app/logs/logfile.log &
}

init
cloneRepository $1
buildRepository
runPackage
