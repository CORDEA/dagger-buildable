FROM openjdk:8-jdk-alpine

MAINTAINER Yoshihiro Tanaka <contact@cordea.jp>

ADD https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip /tmp/sdk.zip
ADD https://raw.githubusercontent.com/davido/bazel-alpine-package/master/david@ostrovsky.org-5a0369d6.rsa.pub \
    /etc/apk/keys/david@ostrovsky.org-5a0369d6.rsa.pub
ADD https://github.com/davido/bazel-alpine-package/releases/download/0.22.0/bazel-0.22.0-r0.apk \
    /tmp/bazel.apk

RUN \
        apk add --no-cache curl && \
        apk add --no-cache --virtual=.build-dependencies git unzip gcc && \
        apk add /tmp/bazel.apk && \
        mkdir /sdk && \
        unzip -q -d /sdk /tmp/sdk.zip && \
        rm /tmp/sdk.zip && \
        yes | ./sdk/tools/bin/sdkmanager "platforms;android-26" && \
        rm /tmp/bazel.apk && \
        git clone "https://github.com/google/dagger" && \
        apk del .build-dependencies

ENV ANDROID_HOME /sdk

WORKDIR /dagger
