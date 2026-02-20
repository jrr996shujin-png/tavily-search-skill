#!/bin/bash
# Tavily Search Skill for OpenClaw
# One-line install: curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/tavily-search-skill/main/install.sh | bash

set -e

SKILL_DIR="$HOME/.openclaw/workspace/skills/tavily-search"
SCRIPTS_DIR="$SKILL_DIR/scripts"

echo "📦 Installing tavily-search skill for OpenClaw..."

# Create directories
mkdir -p "$SCRIPTS_DIR"

# Write SKILL.md
cat > "$SKILL_DIR/SKILL.md" << 'EOF'
---
name: tavily-search
description: Web search using Tavily API. Use when the user needs to search the internet for information, news, research, or any online content. Alternative to web_search tool when Brave API is not available.
---

# Tavily Web Search

Use this skill to perform web searches using Tavily API.

## Usage

```bash
python3 ~/.openclaw/workspace/skills/tavily-search/scripts/search.py "your search query"
```

## API Key

The skill reads your Tavily API key from OpenClaw config (`~/.openclaw/openclaw.json`) under `skills.entries.web-search.apiKey`.

## Output Format

Returns JSON with search results including title, URL, and content snippet.
EOF

# Write search.py
cat > "$SCRIPTS_DIR/search.py" << 'EOF'
#!/usr/bin/env python3
"""
Tavily Web Search Script for OpenClaw
Uses Tavily API to perform web searches
"""

import sys
import json
import urllib.request
import urllib.parse
import re

def get_api_key():
    """Extract Tavily API key from OpenClaw config"""
    try:
        with open(f"{__import__('os').path.expanduser('~')}/.openclaw/openclaw.json", 'r') as f:
            config = json.load(f)
            # Try skills.entries.web-search.apiKey first
            api_key = config.get('skills', {}).get('entries', {}).get('web-search', {}).get('apiKey', '')
            if api_key:
                return api_key
            # Fallback: try mcpServers.tavily.url
            tavily_url = config.get('mcpServers', {}).get('tavily', {}).get('url', '')
            match = re.search(r'tavilyApiKey=([^&]+)', tavily_url)
            if match:
                return match.group(1)
    except Exception as e:
        print(f"Error reading config: {e}", file=sys.stderr)
    return None

def search(query, num_results=5):
    """Perform Tavily search"""
    api_key = get_api_key()
    if not api_key:
        return {"error": "Could not find Tavily API key. Please add it to ~/.openclaw/openclaw.json under skills.entries.web-search.apiKey"}
    
    url = "https://api.tavily.com/search"
    headers = {"Content-Type": "application/json"}
    data = {
        "api_key": api_key,
        "query": query,
        "search_depth": "basic",
        "include_answer": False,
        "max_results": num_results
    }
    
    try:
        req = urllib.request.Request(
            url,
            data=json.dumps(data).encode('utf-8'),
            headers=headers,
            method='POST'
        )
        with urllib.request.urlopen(req, timeout=30) as response:
            result = json.loads(response.read().decode('utf-8'))
            return result
    except Exception as e:
        return {"error": f"Search failed: {str(e)}"}

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 search.py <query>", file=sys.stderr)
        sys.exit(1)
    
    query = " ".join(sys.argv[1:])
    results = search(query)
    print(json.dumps(results, indent=2, ensure_ascii=False))
EOF

chmod +x "$SCRIPTS_DIR/search.py"

echo ""
echo "✅ 安装成功！tavily-search skill 已安装到："
echo "   $SKILL_DIR"
echo ""
echo "📋 使用前请确保你的 Tavily API Key 已填入 OpenClaw 配置："
echo "   ~/.openclaw/openclaw.json -> skills.entries.web-search.apiKey"
echo ""
echo "🔍 测试搜索："
echo "   python3 ~/.openclaw/workspace/skills/tavily-search/scripts/search.py \"今天新闻\""
