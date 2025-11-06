# Video Transcriber Skill - Risk Register

**Date:** 2025-11-06
**Status:** Active
**Project:** Claude Code Skills - Video Transcriber
**Owner:** Juan Vallejo ([REDACTED]@example.edu)

---

## Purpose

This document tracks all identified risks for the video transcription skill implementation, including impact assessment, mitigation strategies, ownership, and review cadence.

---

## Risk Assessment Matrix

**Impact Levels:**
- **High:** Project failure, data loss, security breach, cost overrun >$100
- **Medium:** Feature degradation, user frustration, cost overrun $10-$100
- **Low:** Minor inconvenience, acceptable workaround available

**Probability Levels:**
- **High:** >50% likelihood
- **Medium:** 10-50% likelihood
- **Low:** <10% likelihood

---

## Active Risks

### R01: Request Exceeds 20MB After Compression

**Category:** Technical
**Impact:** High (upload fails, user cannot process video)
**Probability:** Medium (depends on video length and quality)

**Description:**
Compressed audio file may exceed Gemini API's 20,000,000 byte request limit due to:
- Very long videos (>2 hours at minimum bitrate)
- High background noise preventing effective compression
- Encoding overhead adding unexpected bytes

**Mitigation Strategy:**
1. Target ≤18,000,000 bytes (10% safety margin)
2. Assert payload size before upload
3. Auto-chunk files that exceed limit
4. Segment length calculated as: `floor((18_000_000*8)/(BITRATE*1000))` seconds
5. Test with 90-minute, 120-minute, and 180-minute videos

**Owner:** Juan Vallejo
**Status:** Mitigated (design includes auto-chunking)
**Review Date:** 2025-11-13
**Acceptance Criteria:** Zero upload failures on test suite; chunking triggers correctly for >2-hour videos

**Evidence:**
- Test logs showing size assertions
- No HTTP 413 errors in API logs
- Successful processing of 3-hour test video

---

### R02: Model API Version Mismatch

**Category:** Technical
**Impact:** Medium (runtime errors, API call failures)
**Probability:** Medium (documentation used both 2.0 and 2.5)

**Description:**
Initial debrief referenced both `gemini-2.0-flash` and `gemini-2.5-flash`, creating ambiguity. Using wrong model version causes:
- API endpoint not found (404 errors)
- Unexpected response format
- Incorrect cost calculations

**Mitigation Strategy:**
1. Standardize to `gemini-2.5-flash` throughout codebase
2. Doctor command verifies model availability:
   ```bash
   GET /v1beta/models/gemini-2.5-flash
   ```
3. Fail fast with clear error if model unreachable
4. Document model version in all configs and docs
5. Add integration test hitting actual API

**Owner:** Tools Engineer
**Status:** Resolved (standardized to 2.5)
**Review Date:** 2025-11-07
**Acceptance Criteria:** Doctor validates model; no 404 errors in logs; all docs consistent

**Evidence:**
- Doctor output showing model check pass
- Grep for "gemini-" returns only 2.5-flash
- API success logs from integration tests

---

### R03: Cost Overrun on Long Videos

**Category:** Business
**Impact:** Medium (unexpected charges, budget exceeded)
**Probability:** Low (mitigation in place)

**Description:**
Users may not realize transcription costs scale with video length:
- 1 hour video ≈ $0.16 (115,200 tokens)
- 10 hour video ≈ $1.60
- Batch of 100 hours ≈ $16.00

Without warnings, users could accidentally exceed budget or personal limits.

**Mitigation Strategy:**
1. Pre-flight cost estimation:
   ```python
   tokens = 32 * duration_seconds
   cost_usd = (tokens / 1000) * 0.000075
   ```
2. Display estimate and require confirmation (or `--yes`)
3. Support `--max-cost USD` flag
4. Exit with code 2 if estimated cost > max
5. Post-run reporting of actual spend
6. Batch processing shows cumulative cost

**Owner:** PM
**Status:** Mitigated (design includes cost gates)
**Review Date:** 2025-11-13
**Acceptance Criteria:** Cost warnings display; --max-cost prevents overrun; actual spend within 5% of estimate

**Evidence:**
- Test logs showing cost gates
- User confirmation prompts
- No budget overruns in beta testing

---

### R04: Poor Speaker Detection Accuracy

**Category:** Quality
**Impact:** Medium (mislabeled speakers, user frustration)
**Probability:** Medium (depends on audio quality)

**Description:**
Gemini's speaker diarization may not always be accurate:
- Single speaker incorrectly split into multiple
- Multiple speakers merged into one
- Background noise misidentified as speaker
- Low audio quality reduces accuracy

**Mitigation Strategy:**
1. Make `--speakers` opt-in (not default)
2. Clearly document limitations in README
3. Speaker labels are hints, not ground truth
4. JSON structure supports manual correction:
   ```json
   "speakers": {"S1": {"name": "Alice"}}
   ```
5. Include confidence scores if available from API
6. Test with known multi-speaker samples

**Owner:** QA Lead
**Status:** Mitigated (optional feature with documentation)
**Review Date:** 2025-11-20
**Acceptance Criteria:** Accuracy ≥70% on test set; users aware of limitations; manual correction supported

**Evidence:**
- Test results on multi-speaker samples
- User documentation includes disclaimers
- JSON supports name overrides

---

### R05: FFmpeg Codec Compatibility Issues

**Category:** Technical
**Impact:** Low (extraction fails, but error is clear)
**Probability:** Low (MP4/AAC widely supported)

**Description:**
Some video files may use exotic codecs not supported by FFmpeg:
- Proprietary codecs requiring licenses
- Corrupted video files
- DRM-protected content

**Mitigation Strategy:**
1. Support common formats: MP4, AVI, MOV, MKV
2. Fallback to WAV if MP3 encoding fails
3. Clear error messages with codec information:
   ```
   Error: Unsupported video codec 'xyz'
   Run: ffmpeg -i video.mp4 (to see details)
   ```
4. Test with variety of codecs and formats
5. Document supported formats in README

**Owner:** Juan Vallejo
**Status:** Acknowledged (will handle common cases)
**Review Date:** 2025-11-13
**Acceptance Criteria:** Common formats work; clear errors for unsupported; fallback succeeds for 95% of files

**Evidence:**
- Test matrix of codecs
- Error message examples
- Fallback logic in code

---

### R06: API Rate Limiting

**Category:** Technical
**Impact:** Medium (batch processing blocked, delays)
**Probability:** Medium (depends on user quota and batch size)

**Description:**
Gemini API enforces rate limits per user/project:
- Too many parallel requests → HTTP 429 errors
- Large batch jobs may exceed quota
- Retry storms exacerbate problem

**Mitigation Strategy:**
1. Default to 4 parallel jobs (conservative)
2. Implement exponential backoff on 429:
   - Initial delay: 1 second
   - Max backoff: 60 seconds
   - Jitter: ±20%
3. Max 3 retries before permanent failure
4. Log rate limit encounters
5. Allow user to tune `--jobs N` for their quota
6. Test with simulated 429 responses

**Owner:** Juan Vallejo
**Status:** Mitigated (retry logic + conservative defaults)
**Review Date:** 2025-11-09
**Acceptance Criteria:** Batch processing completes despite occasional 429s; no retry storms; ≥99% success rate

**Evidence:**
- Retry logs from batch processing
- No permanent failures on rate limits
- Success rate metrics

---

### R07: Network Failures During Upload

**Category:** Technical
**Impact:** Low (retry handles most cases)
**Probability:** Low (modern networks are reliable)

**Description:**
Network issues may interrupt API calls:
- Temporary connection drops
- DNS resolution failures
- Proxy/firewall interference
- Timeout on slow connections

**Mitigation Strategy:**
1. Retry logic handles transient failures:
   - 3 retries with exponential backoff
   - Timeout: 60 seconds per request
2. Resume capability for batch jobs
3. Clear error messages distinguishing network vs API errors
4. Keep temporary files on error for retry
5. Test with network interruption simulation

**Owner:** Tools Engineer
**Status:** Mitigated (retry logic)
**Review Date:** 2025-11-13
**Acceptance Criteria:** ≥99% upload success with retries; graceful failures after 3 attempts

**Evidence:**
- Network failure simulation tests
- Retry success logs
- No data loss on interrupted uploads

---

### R08: Disk Space Exhaustion

**Category:** Technical
**Impact:** Low (process crashes, but recoverable)
**Probability:** Low (temp files are small)

**Description:**
Processing may fill disk if:
- Many large videos processed without cleanup
- Chunked files left behind on error
- User enables `--keep-temp` indefinitely

**Mitigation Strategy:**
1. Check available disk space before extraction:
   ```python
   required = video_size * 0.2  # 20% of video size
   if available < required: raise DiskSpaceError
   ```
2. Clean up temps by default
3. Delete temps even on error (unless `--keep-temp`)
4. Warn if disk space <1GB
5. Test with limited disk space

**Owner:** Juan Vallejo
**Status:** Mitigated (cleanup + pre-flight checks)
**Review Date:** 2025-11-07
**Acceptance Criteria:** No orphaned files; space check prevents crashes; warning at 1GB threshold

**Evidence:**
- Disk usage before/after tests
- Cleanup verification logs
- Low-space simulation results

---

### R09: Invalid or Missing API Key

**Category:** Security
**Impact:** High (all operations fail)
**Probability:** Low (key stored in Secret Manager)

**Description:**
API key issues prevent any transcription:
- Key not found in Secret Manager
- gcloud not authenticated
- Key revoked or expired
- Permissions insufficient to read secret

**Mitigation Strategy:**
1. Doctor command validates key access:
   ```bash
   gcloud secrets versions access latest \
     --secret=GEMINI_API_KEY \
     --project=[GCP_SECRETS_PROJECT_ID]
   ```
2. Test API key with lightweight call before processing
3. Clear error messages:
   ```
   Error: Cannot access GEMINI_API_KEY from Secret Manager
   Ensure: gcloud auth login completed
   Verify: Secret exists in project [GCP_SECRETS_PROJECT_ID]
   ```
4. Document setup requirements
5. Fallback to `GEMINI_API_KEY` environment variable

**Owner:** Tools Engineer
**Status:** Mitigated (doctor + fallback)
**Review Date:** 2025-11-07
**Acceptance Criteria:** Doctor detects missing key; clear setup instructions; fallback works

**Evidence:**
- Doctor output on invalid setup
- Documentation includes auth steps
- Env var fallback tested

---

### R10: Memory Overflow on Large Videos

**Category:** Technical
**Impact:** Low (crashes, but rare)
**Probability:** Low (streaming processing prevents this)

**Description:**
Very large videos (4K, >2 hours) may consume excessive memory if:
- Entire file loaded into memory
- FFmpeg buffers too much data
- JSON response is huge (rare)

**Mitigation Strategy:**
1. Stream processing for FFmpeg operations
2. Write chunks to disk incrementally
3. Limit JSON segment count (max 10,000 segments)
4. Monitor memory in tests:
   - Target: <2GB for 2-hour 4K video
5. Test with 4K and 8K videos
6. Document memory requirements

**Owner:** Juan Vallejo
**Status:** Acknowledged (design uses streaming)
**Review Date:** 2025-11-13
**Acceptance Criteria:** Memory stays <2GB for 2-hour 4K video; no OOM crashes

**Evidence:**
- Memory profiling logs
- 4K video test results
- Resource usage documentation

---

## Risk Summary Statistics

**By Impact:**
- High: 2 risks (R01, R09)
- Medium: 5 risks (R02, R03, R04, R06, R07)
- Low: 3 risks (R05, R08, R10)

**By Probability:**
- High: 0 risks
- Medium: 5 risks (R01, R02, R04, R06)
- Low: 5 risks (R03, R05, R07, R08, R09, R10)

**By Status:**
- Resolved: 1 risk (R02)
- Mitigated: 7 risks (R01, R03, R06, R07, R08, R09, R10)
- Acknowledged: 2 risks (R04, R05)

**Overall Risk Exposure:** Medium

---

## Risk Monitoring Schedule

**Weekly Check-ins (Every Monday 10:00):**
- Review new risks identified during implementation
- Update mitigation status
- Escalate high-impact risks not progressing

**Milestone Reviews:**
- 2025-11-07: After Phase 1 (documentation and scaffolding)
- 2025-11-09: After Phase 2 (core implementation)
- 2025-11-13: After Phase 3 (testing and validation)

**Post-Launch:**
- 2025-11-20: 1-week post-launch review
- 2025-12-06: 1-month post-launch review
- Quarterly thereafter

---

## Escalation Criteria

**Immediate Escalation:**
- High impact + High probability risk identified
- Mitigation fails during testing
- Security vulnerability discovered
- Cost overrun >$50 in testing

**Standard Escalation:**
- Risk status unchanged for 2 weeks
- New dependency identified
- External API changes

**Escalation Path:**
1. Juan Vallejo (Technical Lead)
2. PM (if budget/scope impact)
3. Course instructor (if project timeline at risk)

---

## Risk Change Log

| Date | Risk | Change | Reason |
|------|------|--------|--------|
| 2025-11-06 | R02 | Resolved: Standardized to gemini-2.5-flash | GPT-5 analysis identified inconsistency |
| 2025-11-06 | All | Initial risk register created | Based on GPT-5 analysis and technical review |

---

## Acceptance Criteria for Risk Management

**Process Success:**
- [x] All identified risks documented
- [x] Mitigation strategies defined
- [x] Owners assigned
- [x] Review schedule established
- [ ] Mitigation tests created (by 2025-11-07)
- [ ] All high-impact risks resolved or mitigated (by 2025-11-13)

**Outcome Success:**
- Zero high-impact risks unmitigated at launch
- ≥99% upload success rate in production
- No security incidents in first 30 days
- Cost overruns <5% vs estimates

---

**Approval:**

- [x] Juan Vallejo (Technical Lead) - 2025-11-06
- [ ] PM (Budget Authority) - Pending
- [ ] QA Lead (Quality Review) - Pending
- [ ] Tools Engineer (Infrastructure Review) - Pending

---

**End of Risk Register**

*Living document - update as new risks identified or status changes.*
