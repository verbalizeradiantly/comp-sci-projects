# spotisoul

## Overview
Spotisoul is a Dockerized tool that converts Spotify Playlists into Soulseek/Nicotine+ downloads by giving you a selection of your playlists to choose from then auto-downloading from selected playlist.

I’ve faced various hurdles with it not working, so I’ve introduced rate limiters as a precaution, even though it should be able to handle it as is. 
I’ve had issues with JSON-RPC server setting- perhaps due to MacOS limitations, next step is to try this on a linux distro instead, to see if 
  I can make the process more efficient/accessible.
 
 ## SETUP

    Ensure Docker and Docker Compose are installed.

    Clone the repository and navigate into the folder:
    git clone https://github.com/verbalizeradiantly/spotisoul.git
    cd spotisoul

    Install Python dependencies:
    pip install -r requirements.txt

    Create a .env file in the project root with the following contents:
    SPOTIFY_CLIENT_ID=your_client_id
    SPOTIFY_CLIENT_SECRET=your_client_secret
    NICOTINE_RPC_URL=http://localhost:PORT_HERE

    Start Nicotine+ using Docker Compose:
    docker-compose -f docker-compose.nicotine.yaml up

    Configure your Soulseek client to use the downloads volume as the download directory.

## USAGE

Once running, Spotisoul will connect to your Spotify account, display your playlists, and allow you to select one for download. It then sends track requests to Nicotine+ via its JSON-RPC interface.

You can customize metadata matching and filters, and optionally enable a lightweight interface for browsing or exporting track data.

## OUTPUT

    Downloaded files will appear in the directory configured in your Nicotine+ settings.

    Optional post-processing (such as tagging or renaming) may be supported in future updates.
