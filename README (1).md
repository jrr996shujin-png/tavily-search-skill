# tavily-search-skill for OpenClaw

OpenClaw 的 Tavily 搜索 Skill，解决内置 `web_search` 只支持 Brave API 的问题。

## 一键安装

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/tavily-search-skill/main/install.sh | bash
```

安装完成后重启 OpenClaw Gateway：
```bash
openclaw gateway restart
```

## 前提条件

1. 已安装 [OpenClaw](https://openclaw.ai)
2. 拥有 [Tavily API Key](https://tavily.com)（免费注册可用）

## 配置 API Key

打开 `~/.openclaw/openclaw.json`，找到或添加：

```json
{
  "skills": {
    "entries": {
      "web-search": {
        "apiKey": "你的 Tavily API Key"
      }
    }
  }
}
```

## 使用方法

在 OpenClaw 对话中直接说：
> "帮我搜索一下最新的 AI 新闻"

OpenClaw 会自动调用这个 skill 进行搜索。

## 为什么需要这个 Skill？

OpenClaw 内置的 `web_search` 工具依赖 Brave Search API，申请需要信用卡。

Tavily 提供免费套餐，注册即可使用，无需信用卡。这个 skill 让你用 Tavily 替代 Brave 完成网络搜索功能。

## 手动测试

```bash
python3 ~/.openclaw/workspace/skills/tavily-search/scripts/search.py "今天天气"
```

## License

MIT
