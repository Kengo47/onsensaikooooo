FROM ruby:2.6.6

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# 作業ディレクトリの作成、設定
RUN mkdir /myapp
WORKDIR /myapp
# ローカルのGemfileとGemfile.lockをコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
# Gemのインストール実行
RUN bundle install
COPY . /myapp