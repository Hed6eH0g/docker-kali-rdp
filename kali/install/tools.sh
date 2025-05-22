#!/bin/bash

set -e

apt-get update && apt-get install -y \
	vim \
	gcc \
	g++ \
	libxml2-dev \
	libxslt-dev \
	python3-dev \
	ffuf \
	crackmapexec && \
rm -rf /var/lib/apt/lists/*
	
