#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

REPO_NAME="dt1900.github.io"
TARGET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_DOMAIN="dan-thompson.net"

echo "=================================================="
echo " GitHub Pages Initializer & Deployer (dt1900.github.io)"
echo "=================================================="
echo "Repository Directory: $TARGET_DIR"
echo "GitHub Repo Remote:   git@github.com:dt1900/$REPO_NAME.git"
echo "Custom Domain:        $CUSTOM_DOMAIN"
echo "=================================================="

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Error: 'git' is not installed or not in PATH."
    exit 1
fi

# Check git config
USER_EMAIL=$(git config user.email || true)
if [ -z "$USER_EMAIL" ]; then
    echo "❌ Error: Git is not configured with user.email on your system."
    exit 1
fi
echo "✅ Git is installed and configured (user: $(git config user.name || echo 'None'), email: $USER_EMAIL)"

# Create the CNAME file for custom domain mapping in GitHub Pages if not present
if [ ! -f "$TARGET_DIR/CNAME" ]; then
    echo "Configuring custom domain CNAME file..."
    echo "$CUSTOM_DOMAIN" > "$TARGET_DIR/CNAME"
fi

# Initialize git repository
cd "$TARGET_DIR"
if [ ! -d ".git" ]; then
    echo "Initializing new Git repository..."
    git init -b main
else
    echo "Git repository is already initialized."
fi

# Commit files
git add -A
if git diff-index --quiet HEAD --; then
    echo "No changes to commit."
else
    echo "Staging and committing files..."
    git commit -m "Configure GitHub Pages landing page with CNAME, index.html, and assets"
fi

# Add remote
if ! git remote | grep -q "^origin$"; then
    echo "Adding remote origin..."
    git remote add origin "git@github.com:dt1900/$REPO_NAME.git"
else
    echo "Remote origin already exists. Aligning URL..."
    git remote set-url origin "git@github.com:dt1900/$REPO_NAME.git"
fi

echo "=================================================="
echo "🚀 READY TO DEPLOY"
echo "=================================================="
echo "Before pushing, ensure you have created the empty repository on GitHub:"
echo "👉 Name: $REPO_NAME"
echo "👉 Visibility: Public (recommended for standard GitHub Pages)"
echo "👉 URL: https://github.com/new"
echo "=================================================="

# Check for GITHUB_TOKEN to offer automated repo creation
if [ -n "$GITHUB_TOKEN" ]; then
    read -p "A GITHUB_TOKEN is detected. Would you like to automatically create the repository '$REPO_NAME' via GitHub API? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Creating GitHub repository via API..."
        curl -s -H "Authorization: token $GITHUB_TOKEN" \
             -H "Accept: application/vnd.github.v3+json" \
             https://api.github.com/user/repos \
             -d "{\"name\":\"$REPO_NAME\", \"private\":false, \"has_issues\":false, \"has_projects\":false, \"has_wiki\":false}"
        echo "✅ Repository created!"
    fi
fi

read -p "Would you like to push the landing page to GitHub now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Pushing code to GitHub..."
    if git push -u origin main; then
        echo "🎉 Pushed successfully!"
        echo "=================================================="
        echo "Next Steps to complete setup:"
        echo "1. Go to your GitHub Repository settings -> Pages"
        echo "2. Under 'Build and deployment', set Source to 'Deploy from a branch' and Branch to 'main' (/root)"
        echo "3. Under 'Custom domain', ensure it shows '$CUSTOM_DOMAIN'"
        echo "4. Tick 'Enforce HTTPS' (once DNS propagates and SSL certificate is provisioned by GitHub)"
        echo "=================================================="
    else
        echo "❌ Error: Failed to push to GitHub. Ensure the repository exists and your SSH key is authorized."
    fi
else
    echo "⚠️ Push aborted. You can push manually from $TARGET_DIR using:"
    echo "   git push -u origin main"
fi
