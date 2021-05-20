FROM ruby:2.7-alpine

ENV DOC_BASE_FOLDER=${DOC_BASE_FOLDER:-"/usr/src/doc"}

RUN echo ${DOC_BASE_FOLDER}
RUN echo ${TEMP}

WORKDIR /usr/src/app

COPY scripts/*.sh /usr/src/scripts/

RUN gem install bundler

RUN apk --no-cache --update add nodejs g++ make coreutils git zip && \
    git clone https://github.com/slatedocs/slate.git /usr/src/app && \
    bundle install && \
    chmod +x /usr/src/scripts/*.sh

COPY source/includes/*.md /usr/src/app/source/includes/
COPY source/images/* /usr/src/app/source/images/
COPY source/index.html.md /usr/src/app/source/

VOLUME ["/usr/src/doc"]

CMD ["sh", "/usr/src/scripts/build.sh"]