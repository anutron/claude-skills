#!/usr/bin/env bash
# Upload a local image to a Notion page as a native image block.
#
# Usage:
#   ./upload.sh <image_path> <page_id> [caption] [--after <block_id>]
#
# Options:
#   --after <block_id>  Insert the image after a specific block instead of
#                       appending to the end. Get block IDs by listing page
#                       children via the Notion API.
#
# Environment:
#   NOTION_API_KEY - Notion integration token (required)
#
# The script:
#   1. Creates a file_upload object via Notion API
#   2. Uploads the binary to the returned upload_url
#   3. Inserts an image block on the specified page (at end or after a block)
#
# Can also be used for covers/icons — see the skill doc for those flows.

set -euo pipefail

IMAGE_PATH="${1:?Usage: upload.sh <image_path> <page_id> [caption] [--after <block_id>]}"
PAGE_ID="${2:?Usage: upload.sh <image_path> <page_id> [caption] [--after <block_id>]}"
CAPTION=""
AFTER_BLOCK=""

# Parse remaining args: caption and --after flag
shift 2
while [ $# -gt 0 ]; do
  case "$1" in
    --after) AFTER_BLOCK="$2"; shift 2 ;;
    *) CAPTION="$1"; shift ;;
  esac
done
NOTION_API_KEY="${NOTION_API_KEY:?Set NOTION_API_KEY environment variable}"
NOTION_VERSION="2025-09-03"

FILENAME=$(basename "$IMAGE_PATH")
EXTENSION="${FILENAME##*.}"

case "$EXTENSION" in
  png)  CONTENT_TYPE="image/png" ;;
  jpg|jpeg) CONTENT_TYPE="image/jpeg" ;;
  gif)  CONTENT_TYPE="image/gif" ;;
  webp) CONTENT_TYPE="image/webp" ;;
  svg)  CONTENT_TYPE="image/svg+xml" ;;
  *)    echo "Unsupported image type: .$EXTENSION" >&2; exit 1 ;;
esac

# Step 1: Create file upload object
CREATE_RESPONSE=$(curl -s -X POST "https://api.notion.com/v1/file_uploads" \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: $NOTION_VERSION" \
  -H "Content-Type: application/json" \
  -d "{\"mode\":\"single_part\",\"filename\":\"$FILENAME\",\"content_type\":\"$CONTENT_TYPE\"}")

UPLOAD_URL=$(echo "$CREATE_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['upload_url'])" 2>/dev/null)
FILE_UPLOAD_ID=$(echo "$CREATE_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])" 2>/dev/null)

if [ -z "$UPLOAD_URL" ] || [ -z "$FILE_UPLOAD_ID" ]; then
  echo "Failed to create file upload:" >&2
  echo "$CREATE_RESPONSE" >&2
  exit 1
fi

echo "Created file upload: $FILE_UPLOAD_ID"

# Step 2: Upload the binary
UPLOAD_RESPONSE=$(curl -s -X POST "$UPLOAD_URL" \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: $NOTION_VERSION" \
  -F "file=@$IMAGE_PATH")

UPLOAD_STATUS=$(echo "$UPLOAD_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('status','unknown'))" 2>/dev/null)

if [ "$UPLOAD_STATUS" != "uploaded" ]; then
  echo "Upload failed (status: $UPLOAD_STATUS):" >&2
  echo "$UPLOAD_RESPONSE" >&2
  exit 1
fi

echo "Uploaded: $FILENAME"

# Step 3: Insert image block on page
if [ -n "$CAPTION" ]; then
  CAPTION_JSON=",\"caption\":[{\"type\":\"text\",\"text\":{\"content\":\"$CAPTION\"}}]"
else
  CAPTION_JSON=""
fi

if [ -n "$AFTER_BLOCK" ]; then
  AFTER_JSON="\"after\":\"$AFTER_BLOCK\","
else
  AFTER_JSON=""
fi

BLOCK_RESPONSE=$(curl -s -X PATCH "https://api.notion.com/v1/blocks/$PAGE_ID/children" \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: $NOTION_VERSION" \
  -H "Content-Type: application/json" \
  -d "{${AFTER_JSON}\"children\":[{\"type\":\"image\",\"image\":{\"type\":\"file_upload\",\"file_upload\":{\"id\":\"$FILE_UPLOAD_ID\"}$CAPTION_JSON}}]}")

BLOCK_ID=$(echo "$BLOCK_RESPONSE" | python3 -c "import sys,json; r=json.load(sys.stdin); print(r['results'][0]['id'])" 2>/dev/null)

if [ -z "$BLOCK_ID" ]; then
  echo "Failed to attach image to page:" >&2
  echo "$BLOCK_RESPONSE" >&2
  exit 1
fi

echo "Attached to page $PAGE_ID as block $BLOCK_ID"
echo ""
echo "file_upload_id=$FILE_UPLOAD_ID"
