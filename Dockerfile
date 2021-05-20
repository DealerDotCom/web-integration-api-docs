FROM ruby:2.7-alpine

WORKDIR /usr/src/app

COPY bin/*.sh /usr/src/bin/

RUN gem install bundler

RUN apk --no-cache --update add nodejs g++ make coreutils git zip && \
    git clone https://github.com/slatedocs/slate.git /usr/src/app && \
    bundle install && \
    chmod +x /usr/src/bin/*.sh

# COPY source/includes/*.md /usr/src/app/source/includes/
# COPY source/images/* /usr/src/app/source/images/
# COPY source/index.html.md /usr/src/app/source/

RUN rm -rf /usr/src/app/source
COPY source/* /usr/src/app/source/

VOLUME ["/usr/src/doc"]

CMD ["sh", "/usr/src/bin/build.sh"]