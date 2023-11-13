#!/bin/bash

# Define the content of the .gitlab-ci.yml file
config_content=$(cat <<EOF
image: gradle:6.7.1
image: openjdk:8

stages:
  - build
  - test
  - run
  - deploy

cache:
  paths:
    - lu.uni.e4l.platform.api.dev/target/
    - lu.uni.e4l.platform.api.dev/.gradle/

build_app:
  stage: build
  script:
    - cd lu.uni.e4l.platform.api.dev/
    - ./gradlew wrapper
    - chmod +x gradlew
    - ./gradlew clean
    - ./gradlew build

test_app:
  stage: test
  script:
    - cd lu.uni.e4l.platform.api.dev/
    - ./gradlew test

run_app:
  stage: run
  script:
    - cd lu.uni.e4l.platform.api.dev/
    - gradle package
    - gradle exec:java -Dexec.mainClass="com.jcg.maven.App"

deploy:
    stage: deploy
    tags:
    - docker
    script:
    - cd lu.uni.e4l.platform.api.dev/
    - sudo mkdir /home/vagrant/artefact
    - sudo cp build/libs/*.jar /home/vagrant/artefact

EOF
)

# Create the .gitlab-ci.yml file with the specified content
echo "$config_content" > /home/vagrant/e4l/.gitlab-ci.yml