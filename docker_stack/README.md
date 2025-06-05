# docker_stack

This folder contains the `docker_stack` project.

> **Note**: This project was developed with assistance from AI tools (e.g., ChatGPT), but the architecture, intent, and integration were authored by me.

## Overview
A full Docker Compose setup for a home server running Jellyfin, Pi-hole, Home Assistant, Nextcloud, and more, with external access via reverse proxy.

## Setup
1. Install Docker and Docker Compose.
2. Clone the directory and configure `.env` and secrets.
3. Run `docker-compose up -d`.

## Usage
Your services will be available at the configured domain/subdomains. You can manage them via Dashy or port-based access.
