FROM python:3.11-alpine

COPY requirements.txt ./
COPY sync.sh ./

ENV TASKRC="/.taskrc"
ENV TASKDATA="/.task"
ENV TZ=America/Los_Angeles

RUN apk --no-cache add build-base bash

RUN apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ task3

#syncall
RUN pip install --no-cache-dir -r requirements.txt

# Taskwarrior data volume
VOLUME [ "/.task", "/.taskrc", "/root/.gtasks_credentials.pickle" ]

RUN touch /var/log/cron.log

RUN touch crontab.tmp \
    && echo '*/5 * * * * "/bin/bash /sync.sh" >> /var/log/cron.log' > crontab.tmp \
    && crontab crontab.tmp \
    && rm -rf crontab.tmp

CMD (/bin/bash /sync.sh || true) && (/usr/sbin/crond -f -d 0 &) && (tail -f /var/log/cron.log)
