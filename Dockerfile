FROM ruby:3.3.6

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

WORKDIR /app

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  curl \
  ca-certificates \
  gnupg \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
    > /etc/apt/sources.list.d/nodesource.list \
  && apt-get update -qq && apt-get install -y nodejs \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN gem install rails -v 7.2.0


COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["bash"]
