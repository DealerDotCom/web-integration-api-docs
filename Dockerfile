FROM ruby:2.7-alpine

ENV DOC_BASE_FOLDER=${DOC_BASE_FOLDER:-"/usr/src/doc"}

RUN echo ${DOC_BASE_FOLDER}
RUN echo ${TEMP}

WORKDIR /usr/src/app

COPY scripts/*.sh /usr/src/scripts/
COPY source/index.html.md /usr/src

RUN apk --no-cache --update add nodejs g++ make coreutils git zip && \
    git clone https://github.com/lord/slate.git /usr/src/app && \
    bundle install && \
    chmod +x /usr/src/scripts/*.sh

VOLUME ["/usr/src/doc"]

ENTRYPOINT ["sh", "/usr/src/scripts/prepare_doc.sh" ]
CMD ["sh", "/usr/src/scripts/build.sh"]