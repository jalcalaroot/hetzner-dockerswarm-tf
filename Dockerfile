image: docker:latest

services:
  - docker:dind

build:
  stage: build
  script:
    - docker build -t test .