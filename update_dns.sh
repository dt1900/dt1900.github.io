#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

ZONE_ID="Z00202022A0SIIT240U3A"
DOMAIN="dan-thompson.net"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JSON_FILE="$SCRIPT_DIR/route53_changes.json"

echo "=================================================="
echo " AWS Route 53 DNS Updater for GitHub Pages"
echo "=================================================="
echo "Target Domain:  $DOMAIN"
echo "Hosted Zone ID: $ZONE_ID"
echo "Changes JSON:   $JSON_FILE"
echo "=================================================="

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ Error: 'aws' CLI is not installed or not in PATH."
    exit 1
fi

# Verify AWS CLI identity
echo "Checking AWS credentials..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ Error: AWS CLI is not configured or credentials have expired."
    exit 1
fi
echo "✅ AWS CLI is configured and verified."

if [ ! -f "$JSON_FILE" ]; then
    echo "❌ Error: Change batch file not found at $JSON_FILE"
    exit 1
fi

echo "Proposed Changes:"
cat "$JSON_FILE"
echo "=================================================="

# Dry-run option or confirmation
read -p "Would you like to execute this change on Route 53 now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Applying DNS updates to Route 53..."
    aws route53 change-resource-record-sets --hosted-zone-id "$ZONE_ID" --change-batch file://"$JSON_FILE"
    echo "🎉 DNS changes submitted successfully!"
    echo "Note: It can take up to 24-48 hours for DNS changes to fully propagate worldwide."
else
    echo "⚠️ DNS update aborted. No changes were made."
fi
