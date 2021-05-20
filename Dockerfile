FROM ruby:2.7-alpine

ENV DOC_BASE_FOLDER=${DOC_BASE_FOLDER:-"/usr/src/doc"}

RUN echo ${DOC_BASE_FOLDER}
RUN echo ${TEMP}

WORKDIR /usr/src/app

COPY scripts/*.sh /usr/src/scripts/
COPY source/* /usr/src/app/

RUN gem install bundler

RUN apk --no-cache --update add nodejs g++ make coreutils git zip && \
    git clone https://github.com/slatedocs/slate.git /usr/src/app && \
    bundle install && \
    chmod +x /usr/src/scripts/*.sh

VOLUME ["/usr/src/doc"]

CMD ["sh", "/usr/src/scripts/build.sh"]