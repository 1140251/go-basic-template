FROM golang:1.18 as builder

WORKDIR /opt/app


## (Optional) remove assets and github folders
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -o  bin/app .

FROM alpine:latest
WORKDIR /opt/app

COPY --from=builder /opt/app/bin /opt/app/bin

CMD bin/app