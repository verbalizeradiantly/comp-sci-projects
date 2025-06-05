# spotisoul

## Overview
Spotisoul is a Dockerized tool that converts Spotify Playlists into Soulseek/Nicotine+ downloads by giving you a selection of your playlists to choose from then auto-downloading from selected playlist.

I’ve faced various hurdles with it not working, so I’ve introduced rate limiters as a precaution, even though it should be able to handle it as is. 
I’ve had issues with JSON-RPC server setting- perhaps due to MacOS limitations, next step is to try this on a linux distro instead, to see if 
  I can make the process more efficient/accessible.

## Setup
1. Ensure Docker and Docker Compose are installed.
2. Clone the repo and navigate into the `spotisoul` folder.
3. Run `docker-compose -f docker-compose.nicotine.yaml up`.
4. Configure your Soulseek client to download into the `downloads` volume.

## Usage
Once running, Spotisoul will monitor your Soulseek downloads and organize the files. You can customize metadata filters and access a lightweight frontend for browsing and exporting tracks.
