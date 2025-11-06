#!/bin/bash
# redact-har.sh
# Redact sensitive information from HAR files before committing
#
# Usage: bash scripts/redact-har.sh path/to/file.har
#
# Creates: path/to/file-REDACTED.har (original preserved)

set -e

if [ $# -eq 0 ]; then
  echo "Usage: bash scripts/redact-har.sh path/to/file.har"
  exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
  echo "[ERROR] File not found: $INPUT_FILE"
  exit 1
fi

# Generate output filename
OUTPUT_FILE="${INPUT_FILE%.har}-REDACTED.har"

echo "=================================================="
echo "HAR Redaction Tool"
echo "=================================================="
echo "Input:  $INPUT_FILE"
echo "Output: $OUTPUT_FILE"
echo ""

# Redact sensitive fields
echo "[INFO] Redacting sensitive information..."

jq '
  # Redact Authorization headers
  .log.entries[].request.headers[] |= (
    if .name == "Authorization" or .name == "authorization" then
      .value = "Bearer REDACTED"
    else
      .
    end
  ) |

  # Redact Authorization in response headers (if any)
  .log.entries[].response.headers[] |= (
    if .name == "Authorization" or .name == "authorization" then
      .value = "Bearer REDACTED"
    else
      .
    end
  ) |

  # Redact cookies
  .log.entries[].request.headers[] |= (
    if .name == "Cookie" or .name == "cookie" then
      .value = "REDACTED"
    else
      .
    end
  ) |
  .log.entries[].response.headers[] |= (
    if .name == "Set-Cookie" or .name == "set-cookie" then
      .value = "REDACTED"
    else
      .
    end
  ) |

  # Redact any tokens in request bodies (JSON)
  .log.entries[].request.postData.text |= (
    if . != null then
      . | gsub("Bearer [A-Za-z0-9\\-_]+"; "Bearer REDACTED") |
          gsub("\"token\"\\s*:\\s*\"[^\"]+\""; "\"token\": \"REDACTED\"") |
          gsub("\"apiKey\"\\s*:\\s*\"[^\"]+\""; "\"apiKey\": \"REDACTED\"")
    else
      .
    end
  ) |

  # Redact any tokens in response bodies (JSON)
  .log.entries[].response.content.text |= (
    if . != null then
      . | gsub("Bearer [A-Za-z0-9\\-_]+"; "Bearer REDACTED") |
          gsub("\"token\"\\s*:\\s*\"[^\"]+\""; "\"token\": \"REDACTED\"") |
          gsub("\"apiKey\"\\s*:\\s*\"[^\"]+\""; "\"apiKey\": \"REDACTED\"")
    else
      .
    end
  )
' "$INPUT_FILE" > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
  echo "[SUCCESS] Redacted HAR file created"
  echo ""
  echo "File sizes:"
  echo "  Original: $(du -h "$INPUT_FILE" | awk '{print $1}')"
  echo "  Redacted: $(du -h "$OUTPUT_FILE" | awk '{print $1}')"
  echo ""
  echo "Verification:"

  # Check for remaining tokens
  BEARER_COUNT=$(grep -c "Bearer [A-Za-z0-9]" "$OUTPUT_FILE" | grep -v "Bearer REDACTED" || echo "0")

  if [ "$BEARER_COUNT" -eq 0 ]; then
    echo "  ✓ No exposed Bearer tokens"
  else
    echo "  ⚠ WARNING: $BEARER_COUNT potential Bearer tokens found"
    echo "    Manual review recommended"
  fi

  echo ""
  echo "Original file preserved at: $INPUT_FILE"
  echo "Safe to commit: $OUTPUT_FILE"
  echo ""
  echo "Next steps:"
  echo "  git add $OUTPUT_FILE"
  echo "  git commit -m \"exp: Add EXP-001 evidence (redacted HAR)\""
else
  echo "[ERROR] Redaction failed"
  exit 1
fi
