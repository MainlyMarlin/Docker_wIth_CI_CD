FROM python:3.8.14-slim

# Do not use env as this would persist after the build and would impact your containers, children images
ARG DEBIAN_FRONTEND=noninteractive

# Force the stdout and stderr streams to be unbuffered.
ENV PYTHONUNBUFFERED 1

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 10000 -ms /bin/bash runner

WORKDIR /home/runner/app

USER root

# Explicitly set permissions for the working directory
RUN chown -R runner:runner /home/runner/app

USER 10000

ENV PATH="${PATH}:/home/runner/.local/bin"

COPY ./  ./

# Switch to root temporarily to perform actions that require elevated privileges
USER root

RUN pip install --upgrade pip \
    && pip install --no-cache-dir poetry \
    && poetry install --only main

# Switch back to the non-root user
USER 10000

EXPOSE 8000

ENTRYPOINT [ "poetry", "run" ]

# $CHALLENGIFY_BEGIN
CMD uvicorn app.main:app --host 0.0.0.0 --port $PORT
# $CHALLENGIFY_END
#CMD uvicorn app.main:app --host 0.0.0.0 --port 8000
