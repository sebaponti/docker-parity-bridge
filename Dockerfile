FROM ubuntu:14.04
WORKDIR /build

# install tools and dependencies
RUN apt-get update \
        && apt-get install -y \
        g++ \
        build-essential \
        curl \
        git \
        file \
        binutils \
        libssl-dev \
        pkg-config \
        libudev-dev \
        && apt-get clean \
        && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# show backtraces and info logs
ENV RUST_BACKTRACE 1
ENV RUST_LOG info

# show tools
RUN rustc -vV \
        && cargo -V \
        && gcc -v \
        && g++ -v

# build parity
RUN git clone git@github.com:paritytech/parity-bridge.git \
        && cargo build -p parity-bridge --release

RUN file /build/parity/target/release/parity-bridge

EXPOSE 8080 8545 8180

ENTRYPOINT ["/build/parity/target/release/parity-bridge"]
