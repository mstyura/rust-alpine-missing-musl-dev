FROM rust:1.54-alpine3.14 as builder

# Project is failed to built within 1.54-alpine3.14 with next line commented
# RUN apk add --no-cache musl-dev
RUN USER=root cargo new rust-alpine-missing-musl-dev
WORKDIR /rust-alpine-missing-musl-dev

COPY Cargo.toml Cargo.lock ./
RUN cargo build --release

COPY ./src ./src

RUN cargo build --release

FROM alpine:3.14
RUN apk add --no-cache htop iproute2 perf \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/rust-alpine-missing-musl-dev
COPY --from=builder rust-alpine-missing-musl-dev/target/release/rust-alpine-missing-musl-dev ./
RUN chmod +x rust-alpine-missing-musl-dev
CMD ["./rust-alpine-missing-musl-dev"]