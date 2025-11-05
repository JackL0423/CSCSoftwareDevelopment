# FlutterFlow YAML Editing Scripts

These scripts provide command-line tools for managing YAML files in the FlutterFlow project programmatically using the Growth Plan API.

## Prerequisites

- **GCP Secret Manager**: FLUTTERFLOW_LEAD_API_TOKEN must be configured
- **gcloud CLI**: Authenticated and configured
- **jq**: JSON processor (`sudo apt install jq`)
- **curl**: HTTP client (pre-installed on most systems)

## Available Scripts

### 1. list-yaml-files.sh

Lists all editable YAML files in the FlutterFlow project.

**Usage:**
```bash
./scripts/list-yaml-files.sh
```

**Output:**
- Sorted list of all 591 YAML files
- Total file count
- Project version information

**Example:**
```bash
$ ./scripts/list-yaml-files.sh
Retrieving API token from Secret Manager...
Fetching YAML file list from FlutterFlow...

Available YAML files:
====================
ad-mob
app-bar
app-details
app-state
...
Total files: 591
```

### 2. download-yaml.sh

Downloads YAML files from FlutterFlow and saves them locally.

**Usage:**
```bash
# Download all YAML files
./scripts/download-yaml.sh

# Download a specific file
./scripts/download-yaml.sh --file app-details
```

**Options:**
- `--file <file-key>`: Download only the specified file

**Output:**
- Creates `flutterflow-yamls/` directory
- Saves YAML files maintaining directory structure
- Progress indicator for bulk downloads

**Example:**
```bash
$ ./scripts/download-yaml.sh --file app-details
Retrieving API token from Secret Manager...
Downloading: app-details...
  Saved to: flutterflow-yamls/app-details.yaml

Download complete! Files saved to: flutterflow-yamls/
```

### 3. validate-yaml.sh

Validates YAML changes before applying them to FlutterFlow.

**Usage:**
```bash
./scripts/validate-yaml.sh <file-key> <yaml-file-path>
```

**Arguments:**
- `file-key`: The FlutterFlow file identifier (e.g., "app-details")
- `yaml-file-path`: Path to local YAML file

**Output:**
- ✅ Success: Validation passed
- ❌ Error: Detailed error messages from API

**Example:**
```bash
$ ./scripts/validate-yaml.sh app-details ./flutterflow-yamls/app-details.yaml
Retrieving API token from Secret Manager...
Validating YAML file: ./flutterflow-yamls/app-details.yaml
File key: app-details

Calling validation API...
✅ Validation successful!
```

### 4. update-yaml.sh

Updates the FlutterFlow project with modified YAML files.

**Usage:**
```bash
./scripts/update-yaml.sh <file-key> <yaml-file-path>

# Skip validation (not recommended)
./scripts/update-yaml.sh --skip-validation <file-key> <yaml-file-path>
```

**Arguments:**
- `--skip-validation`: Skip pre-update validation check
- `file-key`: The FlutterFlow file identifier
- `yaml-file-path`: Path to local YAML file

**Safety Features:**
- Auto-validation before update (unless skipped)
- Interactive confirmation prompt
- Detailed success/error reporting

**Example:**
```bash
$ ./scripts/update-yaml.sh app-details ./flutterflow-yamls/app-details.yaml
Retrieving API token from Secret Manager...
Step 1: Validating YAML...
✅ Validation passed

Step 2: Updating FlutterFlow project...
File key: app-details
YAML file: ./flutterflow-yamls/app-details.yaml

Are you sure you want to update the FlutterFlow project? (yes/no): yes
Applying update...
✅ Update successful!

⚠️  Remember to:
1. Verify changes in FlutterFlow UI
2. Test your app thoroughly
3. Commit your local YAML changes to git
```

## Typical Workflow

### Scenario: Edit App Details

1. **Download current YAML:**
   ```bash
   ./scripts/download-yaml.sh --file app-details
   ```

2. **Edit the file:**
   ```bash
   nano flutterflow-yamls/app-details.yaml
   ```

3. **Validate changes:**
   ```bash
   ./scripts/validate-yaml.sh app-details flutterflow-yamls/app-details.yaml
   ```

4. **Apply update:**
   ```bash
   ./scripts/update-yaml.sh app-details flutterflow-yamls/app-details.yaml
   ```

5. **Verify in FlutterFlow UI and commit:**
   ```bash
   git add flutterflow-yamls/app-details.yaml
   git commit -m "Update app details configuration"
   ```

## FlutterFlow API Endpoints

These scripts use the following Growth Plan API endpoints:

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/v2/listPartitionedFileNames` | GET | List all YAML files |
| `/v2/projectYamls` | GET | Download YAML content |
| `/v2/validateProjectYaml` | POST | Validate YAML changes |
| `/v2/updateProjectByYaml` | POST | Apply YAML updates |

## Project Configuration

**Project ID:** `c-s-c305-capstone-khj14l`
**API Base:** `https://api.flutterflow.io/v2/`
**Authentication:** Bearer token from Secret Manager
**Total YAML Files:** 591

## File Structure

The FlutterFlow project uses a partitioned file system with the following categories:

- **Root files:** `app-details`, `app-state`, `authentication`, `theme`, etc.
- **Collections:** `collections/id-*`
- **Pages:** `page/id-*`
- **Components:** `component/id-*`
- **Widget trees:** `*/component-widget-tree-outline/node/*`
- **Actions:** `*/trigger_actions/*/action/*`
- **Custom code:** `custom-code/actions/*`, `custom-code/widgets/*`

## Security Notes

1. **Never commit API tokens** - Tokens are fetched from Secret Manager at runtime
2. **Review changes carefully** - YAML updates modify your live FlutterFlow project
3. **Test thoroughly** - Always verify changes in FlutterFlow UI after updates
4. **Version control** - Commit downloaded YAMLs to git for change tracking
5. **Validation** - Always validate before updating (don't skip validation)

## Troubleshooting

### "Unauthorized" Error
- Verify Secret Manager access: `gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN"`
- Check GCP account is authenticated: `gcloud auth list`

### "Validation Failed"
- Check YAML syntax: `yamllint flutterflow-yamls/your-file.yaml`
- Compare with original downloaded file
- Review error details in API response

### "jq: command not found"
```bash
sudo apt install jq
```

## Additional Resources

- **FlutterFlow API Documentation:** [api.flutterflow.io](https://api.flutterflow.io)
- **Project Documentation:** See `CLAUDE.md` in repository root
- **GCP Secret Manager:** [cloud.google.com/secret-manager](https://cloud.google.com/secret-manager)
