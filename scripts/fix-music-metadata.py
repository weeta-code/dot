#!/usr/bin/env python3
"""
Fix metadata and album art for YouTube/SoundCloud downloads.
Parses filenames, writes tags, fetches cover art from iTunes.
"""

import os
import re
import sys
import requests
from pathlib import Path

try:
    from mutagen.mp3 import MP3
    from mutagen.mp4 import MP4
    from mutagen.flac import FLAC
    from mutagen.id3 import ID3, TIT2, TPE1, APIC, ID3NoHeaderError
except ImportError:
    print("Installing mutagen...")
    os.system("pip install mutagen")
    from mutagen.mp3 import MP3
    from mutagen.mp4 import MP4
    from mutagen.flac import FLAC
    from mutagen.id3 import ID3, TIT2, TPE1, APIC, ID3NoHeaderError


def parse_filename(filename):
    """Extract artist and title from messy filenames."""
    name = Path(filename).stem

    # Remove common YouTube/SoundCloud patterns
    name = re.sub(r"_\d{7,}", "", name)  # Remove _1234567890 IDs (7+ digits)
    name = re.sub(r"\(?\d{3}kbit.*\)?", "", name, flags=re.I)  # Remove bitrate info
    name = re.sub(r"\[.*?\]", "", name)  # Remove [LIVE] etc
    name = re.sub(r"\(live\)", "", name, flags=re.I)
    name = name.strip()

    # Try "## Artist - Title" pattern (numbered tracks like "01. Artist - Title")
    match = re.match(r"^(\d{1,2}\.\s+)(.+?)\s+-\s+(.+)$", name)
    if match:
        return match.group(2).strip(), match.group(3).strip()

    # Try "Artist - Title" or "Title - Artist" pattern
    if " - " in name:
        parts = [p.strip() for p in name.split(" - ")]
        if len(parts) == 2:
            # For SoundCloud/YouTube downloads: usually "Title - Artist" (artist at end)
            # Exception: if second part has (feat), etc, it's probably the title
            if any(x in parts[1].lower() for x in ["feat", "ft.", "remix", "("]):
                return parts[0], parts[1]  # First is artist, second is title
            return parts[1], parts[0]  # Second is artist, first is title
        elif len(parts) == 3:
            # Pattern: "Artist - Title - Uploader" or similar
            # Last part is usually the uploader/artist
            return parts[0], parts[1]  # First is artist, second is title

    # Fallback: look for " - Artist" at end (SoundCloud pattern: "Title_ID - Artist")
    match = re.match(r"^(.+?)\s*-\s*([^-]+)$", name)
    if match:
        title_part = match.group(1).strip()
        artist_part = match.group(2).strip()
        return artist_part, title_part  # Artist, Title

    return None, name.strip()


def fetch_cover_art(artist, title):
    """Fetch cover art from multiple sources: Deezer, iTunes, MusicBrainz."""
    if not artist and not title:
        return None

    import time

    # Clean query helper
    def clean(s):
        return "".join(c for c in s if ord(c) < 128 or c.isalnum()).strip() or s

    query = f"{artist} {title}".strip() if artist and title else (artist or title)
    clean_query = clean(query)

    # Try Deezer first (no rate limits)
    try:
        url = "https://api.deezer.com/search"
        params = {"q": clean_query, "limit": 5}
        resp = requests.get(url, params=params, timeout=10)
        data = resp.json()

        if data.get("data"):
            for track in data["data"]:
                album = track.get("album", {})
                art_url = (
                    album.get("cover_xl")
                    or album.get("cover_big")
                    or album.get("cover_medium")
                )
                if art_url:
                    img_resp = requests.get(art_url, timeout=10)
                    if img_resp.status_code == 200:
                        return img_resp.content
    except Exception as e:
        print(f"  Deezer error: {e}")

    time.sleep(0.3)  # Small delay between APIs

    # Try iTunes as fallback
    try:
        url = "https://itunes.apple.com/search"
        params = {"term": clean_query, "media": "music", "limit": 3}
        resp = requests.get(url, params=params, timeout=10)
        if resp.text.strip():  # Check not empty
            data = resp.json()
            if data.get("results"):
                for result in data["results"]:
                    art_url = result.get("artworkUrl100", "")
                    if art_url:
                        art_url = art_url.replace("100x100", "600x600")
                        img_resp = requests.get(art_url, timeout=10)
                        if img_resp.status_code == 200:
                            return img_resp.content
    except Exception as e:
        pass  # Silent fail, we have other sources

    time.sleep(0.3)

    # Try MusicBrainz Cover Art Archive (for well-known artists)
    if artist:
        try:
            # Search for artist
            mb_url = f"https://musicbrainz.org/ws/2/recording"
            params = {
                "query": f'artist:"{clean(artist)}" AND recording:"{clean(title)}"',
                "limit": 1,
                "fmt": "json",
            }
            headers = {"User-Agent": "MusicMetadataFixer/1.0"}
            resp = requests.get(mb_url, params=params, headers=headers, timeout=10)
            data = resp.json()

            if data.get("recordings"):
                for rec in data["recordings"]:
                    for release in rec.get("releases", []):
                        mbid = release.get("id")
                        if mbid:
                            art_url = (
                                f"https://coverartarchive.org/release/{mbid}/front-500"
                            )
                            img_resp = requests.get(
                                art_url, timeout=10, allow_redirects=True
                            )
                            if img_resp.status_code == 200:
                                return img_resp.content
        except Exception as e:
            pass  # Silent fail

    return None

    # Try different search strategies
    queries = []
    if artist and title:
        queries.append(f"{artist} {title}")
        queries.append(artist)  # Just artist as fallback
    elif artist:
        queries.append(artist)
    elif title:
        queries.append(title)

    for query in queries:
        # Clean query - remove non-ASCII for better results
        clean_query = "".join(c for c in query if ord(c) < 128 or c.isalnum()).strip()
        if not clean_query:
            clean_query = query  # Fall back to original if all non-ASCII

        try:
            url = "https://itunes.apple.com/search"
            params = {"term": clean_query, "media": "music", "limit": 3}
            resp = requests.get(url, params=params, timeout=10)
            data = resp.json()

            if data.get("results"):
                # Try to find best match
                for result in data["results"]:
                    art_url = result.get("artworkUrl100", "")
                    if art_url:
                        art_url = art_url.replace("100x100", "600x600")
                        img_resp = requests.get(art_url, timeout=10)
                        if img_resp.status_code == 200:
                            return img_resp.content
        except Exception as e:
            print(f"  Art fetch error for '{clean_query}': {e}")

    return None


def has_cover_art(filepath):
    """Check if file already has embedded cover art."""
    ext = filepath.suffix.lower()
    try:
        if ext == ".mp3":
            audio = MP3(filepath)
            return audio.tags and any(k.startswith("APIC") for k in audio.tags.keys())
        elif ext == ".m4a":
            audio = MP4(filepath)
            return "covr" in audio.tags if audio.tags else False
        elif ext == ".flac":
            audio = FLAC(filepath)
            return len(audio.pictures) > 0
    except:
        pass
    return False


def process_file(filepath, dry_run=False):
    """Process a single audio file."""
    filepath = Path(filepath)
    ext = filepath.suffix.lower()

    if ext not in [".mp3", ".m4a", ".flac"]:
        return False

    artist, title = parse_filename(filepath.name)
    has_art = has_cover_art(filepath)

    print(f"\n{filepath.name}")
    print(f"  Parsed: {artist or '?'} - {title}")
    print(f"  Has art: {'Yes' if has_art else 'No'}")

    if dry_run:
        return True

    try:
        if ext == ".mp3":
            try:
                audio = MP3(filepath, ID3=ID3)
            except ID3NoHeaderError:
                audio = MP3(filepath)
                audio.add_tags()

            if title:
                audio.tags.add(TIT2(encoding=3, text=title))
            if artist:
                audio.tags.add(TPE1(encoding=3, text=artist))

            if not has_art:
                art_data = fetch_cover_art(artist, title)
                if art_data:
                    audio.tags.add(
                        APIC(
                            encoding=3,
                            mime="image/jpeg",
                            type=3,
                            desc="Cover",
                            data=art_data,
                        )
                    )
                    print("  Added cover art!")

            audio.save()
            print("  Saved metadata!")

        elif ext == ".m4a":
            audio = MP4(filepath)
            if audio.tags is None:
                audio.add_tags()

            if title:
                audio.tags["\xa9nam"] = [title]
            if artist:
                audio.tags["\xa9ART"] = [artist]

            if not has_art:
                art_data = fetch_cover_art(artist, title)
                if art_data:
                    from mutagen.mp4 import MP4Cover

                    audio.tags["covr"] = [
                        MP4Cover(art_data, imageformat=MP4Cover.FORMAT_JPEG)
                    ]
                    print("  Added cover art!")

            audio.save()
            print("  Saved metadata!")

        elif ext == ".flac":
            audio = FLAC(filepath)

            if title:
                audio["title"] = title
            if artist:
                audio["artist"] = artist

            if not has_art:
                art_data = fetch_cover_art(artist, title)
                if art_data:
                    from mutagen.flac import Picture

                    pic = Picture()
                    pic.type = 3
                    pic.mime = "image/jpeg"
                    pic.data = art_data
                    audio.add_picture(pic)
                    print("  Added cover art!")

            audio.save()
            print("  Saved metadata!")

        return True
    except Exception as e:
        print(f"  Error: {e}")
        return False


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Fix music metadata and album art")
    parser.add_argument("path", help="Music directory or file")
    parser.add_argument(
        "--dry-run", "-n", action="store_true", help="Show what would be done"
    )
    parser.add_argument(
        "--retry-missing",
        "-r",
        action="store_true",
        help="Only process files without art",
    )
    args = parser.parse_args()

    path = Path(args.path).expanduser()

    if path.is_file():
        files = [path]
    else:
        files = (
            list(path.glob("*.[mM][pP]3"))
            + list(path.glob("*.[mM]4[aA]"))
            + list(path.glob("*.[fF][lL][aA][cC]"))
        )

    # Filter to only missing art if requested
    if args.retry_missing:
        files = [f for f in files if not has_cover_art(f)]
        print(f"Found {len(files)} files without art")
    else:
        print(f"Found {len(files)} audio files")

    if args.dry_run:
        print("(Dry run - no changes will be made)\n")

    success = 0
    for f in files:
        if process_file(f, args.dry_run):
            success += 1

    print(
        f"\n{'Would process' if args.dry_run else 'Processed'} {success}/{len(files)} files"
    )


if __name__ == "__main__":
    main()
