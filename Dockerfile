FROM elixir:1.5.1
MAINTAINER Will Sheehan

COPY . /voltrader
WORKDIR /voltrader
RUN mix local.hex --force
RUN mix deps.get