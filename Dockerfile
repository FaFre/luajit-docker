FROM debian:stable-slim as lua_builder
LABEL maintainer="github@fabi.online"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    wget ca-certificates unzip \
    git \
    make libc6-dev g++ \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b v2.1 https://github.com/LuaJIT/LuaJIT.git

WORKDIR /LuaJIT
RUN make && make install

WORKDIR /luarocks
RUN ln -s /usr/local/bin/luajit-* /usr/local/bin/luajit
RUN wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz && tar zxpf luarocks-3.8.0.tar.gz
WORKDIR /luarocks/luarocks-3.8.0
RUN ./configure && make && make install

FROM scratch

COPY --from=lua_builder /usr/local/bin/luajit-* /usr/local/bin/luajit
COPY --from=lua_builder /usr/local/lib/libluajit* /usr/local/lib/
COPY --from=lua_builder /usr/local/include/luajit-2.1/ /usr/local/include/luajit-2.1/
COPY --from=lua_builder /usr/local/bin/luarocks* /usr/local/bin/
COPY --from=lua_builder /usr/local/etc/luarocks/ /usr/local/etc/luarocks/
COPY --from=lua_builder /usr/local/share/lua/ /usr/local/share/lua/