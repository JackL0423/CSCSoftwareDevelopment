# GPT-5 Collaboration: Video Transcription Skill Design

**Date:** 2025-11-06
**Project:** Claude Code Skills - Video Transcriber
**Purpose:** Laser-focused debrief for GPT-5 collaboration on skill architecture and design decisions

---

## Executive Summary

**Objective:** Design and implement a video transcription skill for Claude Code that leverages the Gemini 2.0 Flash API to extract audio from video files and generate timestamped transcripts with speaker detection.

**Key Constraint:** Gemini API has 20 MB request size limit, requiring audio compression or chunking strategy.

**Confirmed Decision:** Compression-first approach for large files (compress audio, chunk only if still >20MB).

**Seeking Expertise On:**
1. Output format priority and structure
2. Deployment strategy (local vs Docker vs hybrid)
3. Feature toggle design (timestamps/speakers)
4. Error handling patterns
5. Cost estimation and user warnings
6. Quality validation framework

---

## Technical Context

### 1. Environment & Prerequisites

**Existing Infrastructure:**
- **Claude Code Skills System:** Located at `~/.claude/skills/`
- **Gemini API Key:** Pre-configured in GCP Secret Manager (`GEMINI_API_KEY`, project `[GCP_SECRETS_PROJECT_ID]`)
- **Python:** v3.12.12 installed
- **OS:** Linux 6.14.0-35-generic (Debian/Ubuntu)
- **Available Tools:** Bash, Read, Write, Glob
- **Pattern Example:** `~/.claude/skills/docx-converter/` (production-grade reference)

**Missing Dependencies (to be installed):**
- `ffmpeg` (system package for audio extraction)
- `google-genai` (new Gemini SDK, GA as of May 2025)
- `ffmpeg-python` (Python wrapper)
- `typer[all]` (CLI framework)

### 2. Gemini API Capabilities

**Audio Processing:**
- **Supported Formats:** WAV, MP3, AIFF, AAC, OGG, FLAC
- **Max Duration:** 9.5 hours per request
- **Max Request Size:** 20 MB (critical constraint)
- **Token Cost:** 32 tokens/second (1 min audio = 1,920 tokens)
- **Processing:** Auto-downsamples to 16 Kbps, converts multi-channel to mono

**Video Support:**
- Gemini can accept video files directly, but audio extraction gives us:
  - Better compression control
  - Smaller payloads
  - More predictable costs

**API Details:**
- **Model:** `gemini-2.0-flash` (recommended for speed and cost)
- **Endpoint:** `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent`
- **File Upload:** `https://generativelanguage.googleapis.com/upload/v1beta/files`
- **SDK:** `google-genai>=0.1.0` (replaces deprecated `google-generativeai`)

### 3. Existing Skill Pattern (docx-converter)

**Proven Architecture:**
```
docx-converter/
├── SKILL.md (YAML frontmatter + documentation)
├── README.md (developer guide)
├── pyproject.toml (Python packaging)
├── Dockerfile (containerized deployment)
├── activate.sh (venv helper)
├── scripts/
│   ├── docx_converter.py (Typer CLI)
│   ├── install-dependencies.sh (setup automation)
│   └── test-skill.sh (validation)
├── examples/ (sample inputs/outputs)
└── tests/ (automated testing)
```

**CLI Structure (Typer framework):**
```python
@app.command()
def doctor():
    """Verify dependencies and environment"""
    # Check: ffmpeg, Python packages, API key access

@app.command()
def transcribe(input: Path, output: Path, timestamps: bool = True):
    """Transcribe single video file"""
    # Extract audio → compress → upload → transcribe → save

@app.command()
def batch(src: Path, dst: Path, jobs: int = 4):
    """Batch transcribe directory of videos"""
    # Parallel processing with progress tracking
```

**Quality Features from docx-converter:**
- Dependency doctor command (pre-flight checks)
- JSON output for machine parsing
- Batch processing with parallel execution
- Docker support for reproducibility
- Comprehensive error handling
- Installation automation

---

## Architecture Constraints

### 1. File Size Challenge (20 MB Limit)

**Confirmed Strategy:** Compression-first, then chunk if needed

**Proposed Workflow:**
```
Video File
  ↓
Extract Audio (FFmpeg) → Raw audio (e.g., 1080p MP4 = 50-150 MB audio)
  ↓
Compress (MP3 @32kbps, mono, 16kHz) → Compressed audio (typically 5-15 MB)
  ↓
Check Size → If <20MB: Proceed | If ≥20MB: Chunk into segments
  ↓
Upload to Gemini
  ↓
Transcribe (with timestamps/speakers)
  ↓
Merge chunks (if chunked) → Final transcript
```

**Key Questions:**
- **Q1:** What bitrate should we target for compression? (32kbps, 64kbps, or dynamic?)
- **Q2:** If chunking needed, what overlap strategy? (e.g., 5-second overlap to avoid cutting mid-sentence)
- **Q3:** How to merge chunked transcripts seamlessly? (timestamp adjustment, confidence scoring?)

### 2. Cost Management

**Token Economics:**
- 1 minute audio = 1,920 tokens
- 10 minute video ≈ 19,200 tokens (~$0.01-0.02 depending on pricing tier)
- 1 hour video ≈ 115,200 tokens (~$0.10-0.20)

**User Expectations:**
- Should we warn before transcribing large files?
- Should we estimate cost upfront?
- Should we support cost-per-file reporting?

**Question:**
- **Q4:** What cost estimation/warning framework should we implement?

### 3. Output Formats

**Potential Formats:**

| Format | Use Case | Structure |
|--------|----------|-----------|
| **JSON** | Machine parsing, APIs | `{"transcript": [...], "speakers": [...], "metadata": {...}}` |
| **TXT** | Simple reading | Plain text with optional timestamps |
| **SRT** | Video subtitles | Standard subtitle format with timecodes |
| **VTT** | Web video captions | WebVTT format (HTML5 standard) |

**Questions:**
- **Q5:** Which formats should be prioritized for v1.0?
- **Q6:** Should JSON structure include confidence scores, speaker metadata, and audio metrics?
- **Q7:** For SRT/VTT, how to handle speaker labels? (e.g., `[Speaker 1]` prefix?)

### 4. Speaker Detection Strategy

**Gemini Capabilities:**
- Prompt engineering can request speaker labels
- Accuracy depends on audio quality and speaker distinctiveness
- May not always detect correctly (especially for single speakers)

**Questions:**
- **Q8:** Should speaker detection be:
  - Always-on (request by default)
  - Optional flag (`--speakers`)
  - Smart default (auto-detect based on audio analysis)?
- **Q9:** How to handle single-speaker detection? (Omit labels, or label as "Speaker 1"?)

### 5. Timestamp Precision

**Gemini Output:**
- Typically provides timestamps in `[HH:MM:SS]` or similar format
- Precision depends on prompt engineering

**Questions:**
- **Q10:** What timestamp format should we standardize on?
  - ISO 8601 duration (`PT1M30S`)
  - Subtitle format (`00:01:30,000`)
  - Seconds since start (`90.5`)
- **Q11:** Should we support configurable timestamp granularity? (second vs millisecond)

---

## Integration Points

### 1. GCP Secret Manager Integration

**Current Setup:**
```bash
# Fetch Gemini API key
gcloud secrets versions access latest \
  --secret="GEMINI_API_KEY" \
  --project=[GCP_SECRETS_PROJECT_ID] \
  --account=[REDACTED]@example.edu
```

**Implementation Options:**
- **Option A:** Fetch at runtime via subprocess (flexible, requires gcloud CLI)
- **Option B:** Cache in environment variable (faster, less secure)
- **Option C:** Pass as CLI parameter (explicit, but inconvenient)

**Question:**
- **Q12:** Which approach aligns with best practices for skill development?

### 2. Temporary File Management

**Workflow Requires:**
- Extracted audio file (intermediate)
- Compressed audio file (for upload)
- Possibly chunked segments (if >20MB)

**Cleanup Strategy:**
- Delete after successful transcription?
- Keep for debugging?
- Configurable retention policy?

**Question:**
- **Q13:** What temporary file strategy balances debuggability and disk space?

### 3. Error Handling

**Potential Failures:**
- FFmpeg extraction error (corrupted video, unsupported codec)
- Gemini API error (rate limit, network failure, invalid response)
- File I/O error (permissions, disk space)
- Audio too large even after compression

**Questions:**
- **Q14:** Should we implement retry logic? (e.g., exponential backoff for API failures)
- **Q15:** How verbose should error messages be? (User-friendly vs debug details)

---

## Open Design Questions

### High Priority (Block Implementation)

**Q1:** Compression bitrate strategy?
- 32kbps (aggressive, smallest size, lower quality)
- 64kbps (balanced)
- Dynamic based on input quality?

**Q2:** Chunking overlap strategy?
- Fixed overlap (e.g., 5 seconds)
- Silence detection for natural breaks?
- No overlap (risk: cut-off sentences)?

**Q3:** Chunk merge algorithm?
- Simple concatenation?
- Timestamp recalculation and deduplication?
- Confidence-based stitching?

**Q4:** Cost estimation framework?
- Pre-flight size estimate with cost warning?
- Post-process cost reporting?
- Both?

**Q5:** Output format priorities for v1.0?
- All formats (JSON, TXT, SRT, VTT)?
- Core formats only (JSON + TXT)?
- Most-requested format (which one)?

### Medium Priority (Affects UX)

**Q6:** JSON structure design?
```json
// Option A: Flat structure
{
  "transcript": "Full text...",
  "segments": [{"start": 0, "end": 5.2, "text": "...", "speaker": "Speaker 1"}],
  "metadata": {"duration": 300, "file_size": 15728640}
}

// Option B: Rich structure
{
  "audio_metadata": {...},
  "transcription": {
    "full_text": "...",
    "segments": [...],
    "speakers": {"Speaker 1": {"total_time": 120, "segments": 45}}
  },
  "processing": {"model": "gemini-2.0-flash", "cost_tokens": 19200}
}
```

**Q7:** SRT/VTT speaker labels?
- Prefix: `[Speaker 1] Hello there`
- Metadata line: Add speaker info in subtitle metadata?
- Separate track: One track per speaker (complex)?

**Q8:** Speaker detection toggle design?
- Always-on (simplest)
- `--speakers` flag (explicit control)
- Smart default + override flag?

**Q9:** Single-speaker handling?
- Omit speaker labels entirely?
- Label as "Speaker 1" for consistency?
- Auto-detect and adapt?

**Q10:** Timestamp format standardization?
- Primary format for JSON output?
- Conversion support between formats?

**Q11:** Timestamp granularity?
- Fixed (e.g., always millisecond precision)?
- Configurable (`--precision ms|s`)?

### Lower Priority (Nice-to-Have)

**Q12:** API key sourcing strategy?
- Runtime fetch from GCP (current approach)?
- Environment variable fallback?
- CLI parameter option?

**Q13:** Temporary file retention?
- Always delete (clean)?
- Keep on error (debugging)?
- `--keep-temp` flag?

**Q14:** Retry logic implementation?
- Exponential backoff for API failures?
- How many retries (3, 5)?
- User notification strategy?

**Q15:** Error message verbosity?
- Terse user-friendly messages by default?
- `--verbose` flag for debugging?
- Structured error codes for scripting?

---

## Deployment Strategy Options

### Option A: Local Installation Only

**Pros:**
- Fast setup (apt + pip)
- Lower complexity
- Direct system integration

**Cons:**
- Environment inconsistencies across systems
- Dependency conflicts possible
- Less reproducible

**Best For:** Personal use, quick prototyping

### Option B: Docker-First

**Pros:**
- Reproducible environment
- No system dependency conflicts
- Easy distribution to team
- Follows docx-converter pattern

**Cons:**
- Larger initial setup
- Slower iteration (rebuild for changes)
- More disk space

**Best For:** Team collaboration, production use

### Option C: Hybrid (Both)

**Pros:**
- Flexibility for users to choose
- Best of both worlds
- Wider adoption potential

**Cons:**
- Maintain two installation paths
- More documentation needed
- More testing surface

**Best For:** Open-source skills, diverse user base

**Question:**
- **Q16:** Which deployment strategy aligns with project goals and team size?

---

## Success Criteria

**Functional Requirements:**
1. Extract audio from common video formats (MP4, AVI, MOV, MKV)
2. Compress audio to stay under 20 MB when possible
3. Chunk and merge for oversized files
4. Transcribe using Gemini 2.0 Flash API
5. Support multiple output formats (at least JSON + TXT)
6. Include timestamps in output
7. Optionally detect and label speakers
8. Handle errors gracefully with informative messages

**Quality Requirements:**
1. Doctor command verifies all dependencies
2. Batch processing supports parallel execution
3. Cost estimation warns users before expensive operations
4. Temporary files cleaned up automatically
5. Installation automated via scripts
6. Docker support for reproducibility (if chosen)
7. Comprehensive documentation in SKILL.md

**Performance Requirements:**
1. Process 10-minute video in <2 minutes (excluding API time)
2. Batch processing: 4+ parallel jobs
3. Minimal disk usage (cleanup temp files)

---

## Questions for GPT-5

### Critical Path Questions (Must Answer for v1.0)

1. **Compression Strategy:** What bitrate balances quality and file size? Should it be dynamic or fixed?

2. **Chunking Algorithm:** What overlap strategy prevents sentence cutoffs while minimizing redundancy?

3. **Output Format Priority:** Which formats are most valuable for typical use cases? (JSON, TXT, SRT, VTT, or subset?)

4. **Speaker Detection Design:** Always-on, optional flag, or smart default? How handle single speakers?

5. **JSON Structure:** Flat and simple, or rich with nested metadata? (Show recommended schema)

### Design Refinement Questions

6. **Cost Warning UX:** When and how should users be warned about transcription costs?

7. **Timestamp Format:** What's the most versatile standard format for JSON output?

8. **Error Handling Pattern:** What retry logic and error verbosity aligns with best CLI practices?

9. **Deployment Recommendation:** Local-only, Docker-first, or hybrid? Why?

10. **Temporary File Policy:** Keep on error only, always clean, or user-configurable?

### Advanced Features (Phase 2 Scoping)

11. **Quality Validation:** How to validate transcription accuracy? (Confidence scores, human review flags?)

12. **Language Detection:** Should we auto-detect language or require user specification?

13. **Custom Prompts:** Should users be able to override default Gemini prompt?

14. **Batch Reporting:** What metrics are useful in batch processing? (Success rate, total cost, processing time?)

15. **Subtitle Optimization:** For SRT/VTT, how to optimize line length and reading speed?

---

## Expected GPT-5 Deliverables

**Please provide:**

1. **Prioritized Answers:** Respond to Critical Path Questions (1-5) with specific recommendations and rationale.

2. **Recommended Architecture:** Complete workflow diagram with decision points.

3. **JSON Schema:** Proposed structure for JSON output format with example.

4. **CLI Command Specification:** Detailed command signatures with parameters, defaults, and examples.

5. **Error Taxonomy:** Categorized error types with recommended handling strategies.

6. **Phase 1 Scope:** What features are essential for v1.0? What can be deferred to v2.0?

7. **Implementation Risks:** Top 3 risks in this design and mitigation strategies.

8. **Testing Strategy:** Key test cases to validate skill functionality.

---

## Context Assumptions

**Assumptions GPT-5 Should Know:**
- This is for a Claude Code skill system (AI assistant augmentation)
- Target users: Software developers and content creators
- Primary use cases: Meeting transcripts, interview transcripts, accessibility captions
- Gemini API key is already secured and accessible
- Python 3.12 environment with standard libraries available
- Linux/Unix environment (Ubuntu/Debian-based)
- Users comfortable with command-line tools
- Cost consciousness: Users expect warnings for expensive operations

**What GPT-5 Should NOT Assume:**
- Real-time transcription (this is batch processing only)
- Streaming video support (local files only)
- Multi-language simultaneously (one language per file)
- Video editing features (pure transcription, no video manipulation)

---

## Timeline Context

**Target:** Functional v1.0 within 1-2 development sessions
**Phase 1:** Core transcription (single file, basic features)
**Phase 2:** Batch processing, advanced formats, quality validation
**Phase 3:** Performance optimization, edge case handling

---

## References

**External Documentation:**
- Gemini API Audio Guide: https://ai.google.dev/gemini-api/docs/audio
- google-genai SDK: https://googleapis.github.io/python-genai/
- FFmpeg Documentation: https://ffmpeg.org/documentation.html
- Typer Framework: https://typer.tiangolo.com/

**Internal References:**
- CLAUDE.md (project context)
- ~/.claude/skills/docx-converter/ (reference implementation)
- Communication Style & Standards (CLAUDE.md sections)

---

**End of Debrief - Awaiting GPT-5 Expertise**
