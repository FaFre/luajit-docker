FROM debian:stable-slim as lua_builder
LABEL maintainer="github@fabi.online"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    make \
    libc6-dev \
    g++ \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b v2.1 https://github.com/LuaJIT/LuaJIT.git

WORKDIR /LuaJIT
RUN make && make install

FROM scratch

COPY --from=lua_builder /usr/local/lib/libluajit* /usr/local/lib/
COPY --from=lua_builder /usr/local/include/luajit-2.1/ /usr/local/include/luajit-2.1/