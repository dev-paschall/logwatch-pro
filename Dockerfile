FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN chmod +x ./bin/logwatch.sh 

RUN mkdir reports

VOLUME /app/reports
VOLUME /app/logs/app.log

CMD ["./bin/logwatch.sh", "--report"]