FROM elixir:1.5.1
MAINTAINER Will Sheehan

COPY . /voltrader
WORKDIR /voltrader
RUN chmod 777 wait-for-it.sh run.sh
ENV MIX_ENV prod
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
