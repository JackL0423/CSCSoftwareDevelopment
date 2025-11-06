# Video Transcriber Skill - Decision Register

**Date:** 2025-11-06
**Status:** Execution-Ready
**Project:** Claude Code Skills - Video Transcriber
**Owner:** Juan Vallejo (juan_vallejo@uri.edu)

---

## Purpose

This document records all design decisions for the video transcription skill, including rationale, ownership, target dates, and acceptance criteria. All 20 decisions from the GPT-5 questionnaire have been resolved with concrete defaults.

---

## Decision Summary Table

| ID | Decision | Status | Owner | Target Date | Review Date |
|----|----------|--------|-------|-------------|-------------|
| D01 | Audio Compression Strategy | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D02 | Chunking Overlap Strategy | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D03 | Chunk Merge Algorithm | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D04 | Output Format Priority | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D05 | Speaker Detection Toggle | ✅ Resolved | QA Lead | 2025-11-07 | 2025-11-20 |
| D06 | JSON Output Structure | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D07 | Deployment Strategy | ✅ Resolved | Tools Engineer | 2025-11-09 | 2025-11-13 |
| D08 | Cost Warning UX | ✅ Resolved | PM | 2025-11-07 | 2025-11-13 |
| D09 | Error Handling Strategy | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D10 | Timestamp Format Standard | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D11 | SRT/VTT Speaker Labels | ✅ Resolved | QA Lead | 2025-11-07 | 2025-11-13 |
| D12 | Temporary File Management | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D13 | Retry Logic | ✅ Resolved | Tools Engineer | 2025-11-09 | 2025-11-13 |
| D14 | CLI Command Structure | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D15 | Transcription Quality Validation | ✅ Resolved | QA Lead | 2025-11-09 | 2025-11-20 |
| D16 | Model Version Standardization | ✅ Resolved | Tools Engineer | 2025-11-07 | 2025-11-07 |
| D17 | Request Size Limit | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D18 | Parallel Job Configuration | ✅ Resolved | Juan Vallejo | 2025-11-09 | 2025-11-13 |
| D19 | Audio Codec Selection | ✅ Resolved | Juan Vallejo | 2025-11-07 | 2025-11-13 |
| D20 | API Key Management | ✅ Resolved | Tools Engineer | 2025-11-07 | 2025-11-13 |

---

## Detailed Decisions

### D01: Audio Compression Strategy

**Question:** What bitrate should we target for audio compression?

**Decision:** Dynamic bitrate with {64, 48, 32, 24} kbps steps

**Rationale:** Optimizes for 18MB limit without unnecessary chunking. Calculates maximum allowed bitrate for the video duration, then selects nearest supported value. Forces 32 kbps minimum and triggers chunking for very long files.

**Algorithm:**
```python
allowed_kbps = floor((18_000_000 * 8) / duration_seconds / 1000)
pick = max(min(allowed_kbps, 64), 24)
# Round to {64, 48, 32, 24}
if pick < 32: force 32 kbps and chunk
```

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** Pass tests on 10, 60, 90-minute inputs without exceeding 18MB
**Evidence Required:** Log file sizes for test suite, confirm no upload failures

---

### D02: Chunking Overlap Strategy

**Question:** What overlap strategy prevents sentence cutoffs while minimizing redundancy?

**Decision:** 5-second textual overlap with deduplication at merge

**Rationale:** Simple implementation that avoids cutting mid-sentence. Overlap is textual only (not audio duplication), handled during merge phase. 5 seconds provides sufficient context for natural language boundaries.

**Implementation:**
- Audio chunks have no overlap (reset timestamps)
- Transcripts include 5s context window
- Merge algorithm deduplicates overlapping text

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** ≤1 duplicate sentence per hour on 75-minute file at 32 kbps
**Evidence Required:** Manual spot-check on long video, automated duplicate detection in tests

---

### D03: Chunk Merge Algorithm

**Question:** How should we merge chunked transcripts?

**Decision:** Timestamp-based deduplication

**Rationale:** Deterministic and reliable. Drop any segment where `[start, end]` is entirely ≤ `last_merged_end + 5.0`. For partial overlaps, keep later segment and adjust timestamps by chunk offset.

**Rule:**
```python
def should_drop_segment(segment, last_end):
    return segment.start <= last_end + 5.0 and segment.end <= last_end + 5.0
```

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** No duplicate lines across chunk boundaries; manual spot-check ≤1 duplicate/hour
**Evidence Required:** Test logs showing merge statistics, human review of merged output

---

### D04: Output Format Priority

**Question:** Which output formats should v1.0 support?

**Decision:** JSON + SRT (core formats)

**Rationale:** Covers 80% of use cases. JSON for machine parsing and programmatic use. SRT for video subtitling and accessibility. TXT and VTT deferred to v2.0.

**Formats:**
- JSON: Complete structured data with segments, speakers, metadata
- SRT: Standard subtitle format for video players

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** Valid SRT plays in VLC; JSON validates against schema
**Evidence Required:** Schema validation logs, VLC screenshot showing subtitles

---

### D05: Speaker Detection Toggle

**Question:** How should speaker detection be controlled?

**Decision:** `--speakers` opt-in flag

**Rationale:** Avoids mislabeling single-speaker files. Speaker detection adds complexity and potential errors. Users explicitly enable when needed for multi-speaker content.

**Default Behavior:**
- No `--speakers` flag: Speaker field omitted from JSON
- With `--speakers`: Speaker IDs (S1, S2, ...) included in segments

**Owner:** QA Lead
**Target Date:** 2025-11-07
**Acceptance Test:** No speaker tags when flag omitted; consistent labels when enabled
**Evidence Required:** Test outputs with/without flag, validation in test suite

---

### D06: JSON Output Structure

**Question:** What JSON structure do you recommend?

**Decision:** Rich structure with processing metadata (v1.0 schema)

**Rationale:** Provides audit trail for debugging and cost tracking. Includes source metadata, segments with timestamps, speaker summaries, and processing metrics.

**Schema:**
```json
{
  "version": "1.0",
  "model": "gemini-2.5-flash",
  "source": {"file": "...", "duration_s": 600.0, "audio_bitrate_kbps": 32},
  "segments": [{"start": 0.00, "end": 3.50, "text": "...", "speaker": "S1"}],
  "speakers": {"S1": {"name": null}},
  "processing": {"chunk_count": 0, "request_bytes": 14200000, "tokens_est": 19200},
  "errors": []
}
```

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** All outputs validate against JSON Schema; no empty segments
**Evidence Required:** JSON Schema file, validation in CI pipeline

---

### D07: Deployment Strategy

**Question:** What deployment approach do you recommend?

**Decision:** Hybrid (local + Docker)

**Rationale:** Provides flexibility. Local installation for development and quick iterations. Docker for reproducible CI environments and team distribution.

**Artifacts:**
- `install-dependencies.sh` for local setup
- `Dockerfile` for containerized deployment
- Both paths pass `doctor` command

**Owner:** Tools Engineer
**Target Date:** 2025-11-09
**Acceptance Test:** Both installation methods complete successfully; doctor passes in both
**Evidence Required:** CI logs for both paths, Docker build success

---

### D08: Cost Warning UX

**Question:** How should we handle cost awareness?

**Decision:** Pre-flight warning + post-run reporting

**Rationale:** Users need awareness before committing to expensive operations. Pre-flight shows estimate with confirmation prompt. Post-run provides actual spend for tracking.

**Implementation:**
- Pre-flight: Calculate tokens, show USD estimate, require `--yes` or under `--max-cost`
- Exit code 2 if estimated cost > `--max-cost`
- Post-run: Report actual duration, tokens, cost in processing metadata

**Cost Formula:**
```python
tokens = 32 * duration_seconds
cost_usd = (tokens / 1000) * 0.000075  # $0.075 per million tokens
```

**Owner:** PM
**Target Date:** 2025-11-07
**Acceptance Test:** Command exits 2 if exceeding --max-cost; warnings display correctly
**Evidence Required:** Test logs showing cost gates, user testing feedback

---

### D09: Error Handling Strategy

**Question:** What error handling approach balances user-friendliness and debuggability?

**Decision:** Terse messages by default + `--verbose` flag

**Rationale:** Progressive disclosure. Most users want simple, actionable errors. Developers need detailed diagnostics for troubleshooting.

**Levels:**
- Default: User-friendly message with next steps
- `--verbose`: Full stack traces, FFmpeg output, API responses

**Example:**
```
Error: Failed to extract audio from video.mp4
Possible causes: Unsupported codec, corrupted file
Run with --verbose for detailed diagnostics
```

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** User-friendly messages by default; full details with --verbose
**Evidence Required:** Error message catalog, user testing feedback

---

### D10: Timestamp Format Standard

**Question:** What timestamp format should JSON output use?

**Decision:** Seconds as float from start (canonical format)

**Rationale:** Simplest for computation and comparison. Easy to convert to other formats (SRT, VTT). No ambiguity about precision or timezones.

**Format:**
- JSON: `{"start": 90.500, "end": 93.750}` (seconds, 3 decimal places)
- SRT conversion: Standard `HH:MM:SS,mmm` format
- Conversion accuracy: ≤±50ms drift per 10 minutes

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** Roundtrip JSON ⇄ SRT with cumulative drift ≤±50ms per 10 min
**Evidence Required:** Conversion test logs, drift measurements

---

### D11: SRT/VTT Speaker Labels

**Question:** How should speakers appear in SRT/VTT?

**Decision:** Prefix each cue with `[Speaker N]`

**Rationale:** Standard, readable approach that works across video players. Maintains compatibility with subtitle format specifications.

**Format:**
```
1
00:00:00,000 --> 00:00:03,500
[Speaker 1] Hello, welcome to the meeting.

2
00:00:03,500 --> 00:00:07,900
[Speaker 2] Thanks for joining everyone.
```

**Owner:** QA Lead
**Target Date:** 2025-11-07
**Acceptance Test:** Subtitles display correctly in VLC, YouTube, other players
**Evidence Required:** Screenshots from multiple video players

---

### D12: Temporary File Management

**Question:** What cleanup policy should we implement?

**Decision:** Delete by default, `--keep-temp` flag to preserve

**Rationale:** Clean system by default saves disk space. Optional flag enables debugging when needed.

**Files Cleaned:**
- Extracted audio (WAV/MP3)
- Compressed audio
- Chunked segments
- Intermediate JSON files

**Exception:** Keep temps on error for post-mortem analysis

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** No orphaned files after successful run; preserved with --keep-temp
**Evidence Required:** Disk scan before/after runs, test logs

---

### D13: Retry Logic

**Question:** Should we implement automatic retries?

**Decision:** 3 retries with exponential backoff

**Rationale:** Handles transient network failures and rate limits. Standard pattern for reliable operations. Exponential backoff prevents thundering herd.

**Implementation:**
- Initial delay: 1 second
- Backoff multiplier: 2x (1s, 2s, 4s)
- Max retries: 3 attempts total (4 including initial)
- Jitter: ±20% randomization

**Owner:** Tools Engineer
**Target Date:** 2025-11-09
**Acceptance Test:** ≥99% upload success rate over n=200 requests with simulated failures
**Evidence Required:** Retry logs, success rate metrics from CI

---

### D14: CLI Command Structure

**Question:** What CLI command structure should we use?

**Decision:** Typer-based CLI with 4 primary commands

**Commands:**
1. `doctor` - Verify dependencies and environment
2. `transcribe` - Single file transcription with options
3. `batch` - Parallel batch processing
4. `extract-audio` - Audio extraction only (optional utility)

**Parameters:**
- Common: `--verbose`, `--yes`
- Transcribe-specific: `--format`, `--timestamps`, `--speakers`, `--max-cost`, `--keep-temp`
- Batch-specific: `--pattern`, `--jobs`, `--continue-on-error`, `--report`

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** All commands documented in --help; examples in README work
**Evidence Required:** Help text screenshots, integration test logs

---

### D15: Transcription Quality Validation

**Question:** How should we validate transcription quality?

**Decision:** Basic sanity checks + optional confidence extraction

**Rationale:** Cannot verify accuracy without ground truth. Focus on structural validation and basic quality metrics.

**Checks:**
- Non-empty transcript
- Segments cover expected duration
- No duplicate timestamps
- Start < end for all segments
- Text fields not empty
- Extract confidence scores if available in Gemini response

**Owner:** QA Lead
**Target Date:** 2025-11-09
**Acceptance Test:** Validation catches malformed outputs; confidence scores logged when available
**Evidence Required:** Test suite with intentionally malformed inputs

---

### D16: Model Version Standardization

**Question:** Which Gemini model should we use?

**Decision:** `gemini-2.5-flash` (standardized)

**Rationale:** Fixes inconsistency found in debrief (2.0 vs 2.5). Latest stable Flash model with optimal speed/cost balance for transcription.

**Verification:**
- Doctor command validates model availability
- Hit `/v1beta/models/gemini-2.5-flash` endpoint
- Fail with clear error if HTTP ≠ 200

**Owner:** Tools Engineer
**Target Date:** 2025-11-07
**Acceptance Test:** Doctor verifies model reachable; all API calls use correct endpoint
**Evidence Required:** Doctor output showing model check, API logs

---

### D17: Request Size Limit

**Question:** What is the maximum request size?

**Decision:** Target ≤18,000,000 bytes (10% headroom under 20MB limit)

**Rationale:** Gemini API hard limit is 20,000,000 bytes (SI). Use 10% safety margin for encoding overhead and metadata. Auto-chunk if compressed audio exceeds target.

**Verification:**
- Assert `request_bytes < 18_000_000` before upload
- Log actual payload size
- Reject with exit code 2 if `--no-chunk` set and size exceeded

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** No upload failures due to size; chunking triggers correctly
**Evidence Required:** Size logs for test suite, no 413 errors in API logs

---

### D18: Parallel Job Configuration

**Question:** How many parallel jobs should batch processing use?

**Decision:** Default 4 jobs, user-configurable via `--jobs N`

**Rationale:** Balances throughput and API rate limits. 4 concurrent requests unlikely to hit rate limits for typical use. Users can adjust based on their quota.

**Constraints:**
- Minimum: 1 job (sequential)
- Maximum: 16 jobs (safety limit)
- Default: 4 jobs

**Owner:** Juan Vallejo
**Target Date:** 2025-11-09
**Acceptance Test:** Batch completes without 429 errors at default 4 jobs
**Evidence Required:** Batch processing logs, no rate limit errors

---

### D19: Audio Codec Selection

**Question:** What audio codec should we use?

**Decision:** MP3 with libmp3lame encoder

**Rationale:** Universal compatibility across platforms and media players. Good compression ratio for speech. Well-supported by FFmpeg and Gemini API.

**Specifications:**
- Codec: libmp3lame (MP3)
- Channels: 1 (mono)
- Sample rate: 16,000 Hz
- Bitrate: Dynamic (24-64 kbps)

**Fallback:** WAV (PCM) if MP3 encoding fails

**Owner:** Juan Vallejo
**Target Date:** 2025-11-07
**Acceptance Test:** MP3 files play in all major media players; Gemini accepts format
**Evidence Required:** Compatibility matrix, API acceptance logs

---

### D20: API Key Management

**Question:** How should we source the Gemini API key?

**Decision:** Fetch from GCP Secret Manager at runtime

**Rationale:** Secure, centralized credential management. No hardcoded secrets. Leverages existing infrastructure.

**Implementation:**
```bash
gcloud secrets versions access latest \
  --secret=GEMINI_API_KEY \
  --project=csc305project-475802
```

**Fallback:** Check `GEMINI_API_KEY` environment variable if gcloud unavailable

**Owner:** Tools Engineer
**Target Date:** 2025-11-07
**Acceptance Test:** Doctor validates key accessible; no hardcoded credentials in code
**Evidence Required:** Code review, security scan, doctor output

---

## Decision Dependencies

**Critical Path (Must Complete by 2025-11-07):**
- D01, D02, D03, D04, D05, D06, D08, D09, D10, D11, D12, D14, D16, D17, D19, D20

**Phase 2 (Complete by 2025-11-09):**
- D07, D13, D15, D18

**Decision Relationships:**
- D01 → D17 (bitrate affects size limit)
- D02 → D03 (overlap informs merge)
- D06 → D04 (schema drives format output)
- D16 → D20 (model affects API key usage)

---

## Change Log

| Date | Decision | Change | Reason |
|------|----------|--------|--------|
| 2025-11-06 | D16 | Changed from gemini-2.0-flash to gemini-2.5-flash | Fix version inconsistency from GPT-5 analysis |
| 2025-11-06 | All | Initial decisions resolved | Based on GPT-5 questionnaire responses |

---

## Review Schedule

- **Weekly Review:** Every Monday at 10:00, review outstanding decisions
- **Post-Implementation Review:** 2025-11-13, validate all acceptance tests
- **Quarterly Review:** 2025-12-01, assess if decisions need revision based on usage

---

**Approval:**

- [x] Juan Vallejo (Technical Lead) - 2025-11-06
- [ ] PM (Product Review) - Pending
- [ ] QA Lead (Quality Review) - Pending
- [ ] Tools Engineer (Infrastructure Review) - Pending

---

**End of Decision Register**

*All decisions execution-ready with concrete defaults and measurable acceptance criteria.*
