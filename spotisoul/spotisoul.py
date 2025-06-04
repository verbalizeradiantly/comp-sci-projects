import spotipy
from spotipy.oauth2 import SpotifyOAuth
import json
import time
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
import logging

# Setup logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('spotisoul.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Spotify credentials (replace with your own)
SPOTIFY_CLIENT_ID = "your_spotify_client_id"
SPOTIFY_CLIENT_SECRET = "your_spotify_client_secret"
SPOTIFY_REDIRECT_URI = "http://localhost:8888/callback"
SPOTIFY_SCOPE = "playlist-read-private playlist-read-collaborative"

# Nicotine+ JSON-RPC settings
NICOTINE_RPC_URL = "http://localhost:5030"
NICOTINE_AUTH_TOKEN = "your_secure_token_12345"

# Retry settings for robustness
MAX_RETRIES = 3
BACKOFF_FACTOR = 2

def create_session():
    """Create a requests session with retry logic."""
    session = requests.Session()
    retries = Retry(total=MAX_RETRIES, backoff_factor=BACKOFF_FACTOR, status_forcelist=[500, 502, 503, 504])
    session.mount("http://", HTTPAdapter(max_retries=retries))
    return session

def nicotine_rpc_request(method, params=None):
    """Send a JSON-RPC request to Nicotine+ and log detailed response."""
    headers = {"Content-Type": "application/json", "Authorization": f"Bearer {NICOTINE_AUTH_TOKEN}"}
    payload = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": method,
        "params": params or []
    }
    session = create_session()
    try:
        logger.debug(f"Sending RPC request: {json.dumps(payload, indent=2)}")
        response = session.post(NICOTINE_RPC_URL, json=payload, headers=headers, timeout=10)
        response.raise_for_status()
        result = response.json()
        logger.debug(f"RPC response: {json.dumps(result, indent=2)}")
        if "error" in result:
            logger.error(f"RPC error: {result['error']}")
            return None
        return result.get("result")
    except requests.RequestException as e:
        logger.error(f"RPC request failed: {e}")
        return None

def test_rpc_connection():
    """Test JSON-RPC connection to Nicotine+."""
    logger.info("Testing RPC connection...")
    result = nicotine_rpc_request("get_status")
    if result is not None:
        logger.info("RPC connection successful.")
        return True
    else:
        logger.error("RPC connection failed. Check Nicotine+ logs in ./logs.")
        return False

def get_spotify_playlists(sp):
    """Retrieve user's Spotify playlists."""
    playlists = []
    try:
        results = sp.current_user_playlists()
        while results:
            playlists.extend(results["items"])
            results = sp.next(results) if results["next"] else None
        return playlists
    except spotipy.SpotifyException as e:
        logger.error(f"Failed to fetch playlists: {e}")
        return []

def get_playlist_tracks(sp, playlist_id):
    """Retrieve tracks from a Spotify playlist."""
    tracks = []
    try:
        results = sp.playlist_items(playlist_id, fields="items(track(name,artists(name))),next")
        while results:
            for item in results["items"]:
                track = item["track"]
                artists = ", ".join(artist["name"] for artist in track["artists"])
                tracks.append({"name": track["name"], "artists": artists})
            results = sp.next(results) if results["next"] else None
        return tracks
    except spotipy.SpotifyException as e:
        logger.error(f"Failed to fetch tracks: {e}")
        return []

def search_and_download_track(track_name, artists):
    """Search for a track in Nicotine+ and download the best result."""
    query = f"{artists} {track_name}".strip()
    logger.info(f"Searching for: {query}")
    
    # Simplified search
    search_result = nicotine_rpc_request("search_for_files", [query, 10])
    if not search_result or not search_result.get("files"):
        logger.warning(f"No results found for: {query}")
        return False

    # Select first valid file (prioritize simplicity for debugging)
    best_file = next((file for file in search_result["files"] if file.get("filename")), None)
    if not best_file:
        logger.warning(f"No valid file found for: {query}")
        return False

    # Download the file
    logger.info(f"Downloading: {best_file['filename']}")
    download_result = nicotine_rpc_request("download_file", [best_file["user"], best_file["filename"]])
    if download_result:
        logger.info(f"Download started for: {best_file['filename']}")
        return True
    else:
        logger.error(f"Failed to start download for: {best_file['filename']}")
        return False

def main():
    # Initialize Spotify client
    sp = spotipy.Spotify(auth_manager=SpotifyOAuth(
        client_id=SPOTIFY_CLIENT_ID,
        client_secret=SPOTIFY_CLIENT_SECRET,
        redirect_uri=SPOTIFY_REDIRECT_URI,
        scope=SPOTIFY_SCOPE
    ))

    # Test Nicotine+ RPC connection
    if not test_rpc_connection():
        logger.error("Aborting due to RPC connection failure.")
        return

    # Get playlists
    playlists = get_spotify_playlists(sp)
    if not playlists:
        logger.error("No playlists found.")
        return

    # Display playlists and get user selection
    print("Available playlists:")
    for i, playlist in enumerate(playlists, 1):
        print(f"{i}. {playlist['name']}")
    try:
        choice = int(input("Select a playlist (number): ")) - 1
        if choice < 0 or choice >= len(playlists):
            logger.error("Invalid playlist selection.")
            return
    except ValueError:
        logger.error("Invalid input. Please enter a number.")
        return

    playlist_id = playlists[choice]["id"]
    logger.info(f"Selected playlist: {playlists[choice]['name']}")

    # Get tracks
    tracks = get_playlist_tracks(sp, playlist_id)
    if not tracks:
        logger.error("No tracks found in playlist.")
        return

    # Process each track
    for track in tracks:
        success = search_and_download_track(track["name"], track["artists"])
        if success:
            logger.info(f"Successfully processed: {track['name']} by {track['artists']}")
        else:
            logger.warning(f"Failed to process: {track['name']} by {track['artists']}")
        time.sleep(1)  # Minimal delay for stability

if __name__ == "__main__":
    main()