FROM elixir:1.5.1
MAINTAINER Will Sheehan

COPY . /voltrader
WORKDIR /voltrader
ENV MIX_ENV prod
RUN mix local.hex --force
RUN mix deps.get
