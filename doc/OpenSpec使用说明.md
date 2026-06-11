# OpenSpec 使用说明

## 简介

[OpenSpec](https://github.com/Fission-AI/OpenSpec) 是一个 AI 原生的规格驱动开发框架（Spec-Driven Development）。它在你和 AI 编码助手之间建立一个轻量级的"规格层"，确保在写代码之前先对齐需求和方案。

**核心理念**：先达成共识，再动手写代码。

---

## 安装

```bash
npm install -g @fission-ai/openspec@latest
```

要求 Node.js >= 20.19.0。

---

## 初始化

在项目根目录运行：

```bash
openspec init
```

交互式选择你要使用的 AI 工具（Claude Code、Cursor、Windsurf 等）。也可以非交互式指定：

```bash
openspec init --tools claude,cursor
```

初始化后，项目中会生成以下结构：

```
openspec/
├── specs/          # 规格文档（系统行为的"真相之源"）
├── changes/        # 变更提案（每个变更一个文件夹）
└── config.yaml     # 项目配置

.claude/skills/     # Claude Code 技能文件（自动生成）
```

---

## 核心工作流

### 快速路径（默认 core 配置）

```
/opsx:propose  →  /opsx:apply  →  /opsx:sync  →  /opsx:archive
   提出变更         实现代码         同步规格         归档完成
```

### 逐步路径（扩展工作流）

```
/opsx:new  →  /opsx:continue  →  /opsx:apply  →  /opsx:verify  →  /opsx:archive
  新建变更      逐步生成制品        实现代码          验证实现          归档完成
```

---

## 常用命令速查

### AI 斜杠命令（在 AI 工具聊天框中使用）

| 命令 | 作用 | 使用场景 |
|------|------|----------|
| `/opsx:propose <描述>` | 创建变更并一次性生成所有规划制品 | 快速启动一个新功能 |
| `/opsx:explore <主题>` | 探索性讨论，不创建任何制品 | 需求不明确时先调研 |
| `/opsx:apply` | 按 tasks.md 逐项实现代码 | 规划完成后开始编码 |
| `/opsx:archive` | 归档已完成的变更，合并规格 | 功能开发完成 |
| `/opsx:verify` | 验证实现是否匹配规格 | 归档前检查 |
| `/opsx:onboard` | 交互式教程，走完完整流程 | 首次学习使用 |

### CLI 命令（在终端中使用）

| 命令 | 作用 |
|------|------|
| `openspec init` | 初始化项目 |
| `openspec list` | 列出所有活跃变更 |
| `openspec show <name>` | 查看变更详情 |
| `openspec status` | 查看制品完成进度 |
| `openspec validate` | 校验规格格式 |
| `openspec view` | 交互式仪表盘 |
| `openspec update` | 升级后刷新 AI 指令文件 |
| `openspec config list` | 查看当前配置 |

---

## 变更制品（Artifacts）

每个变更文件夹包含 4 个制品，按依赖顺序生成：

```
openspec/changes/<变更名>/
├── proposal.md    # 为什么做、做什么（意图与范围）
├── specs/         # 增量规格（新增/修改/删除的需求）
├── design.md      # 怎么做（技术方案）
└── tasks.md       # 实现清单（带复选框）
```

**依赖链**：`proposal → specs → design → tasks → 实现`

你可以随时回头修改前面的制品——OpenSpec 鼓励迭代，而非瀑布。

---

## 增量规格（Delta Specs）

增量规格是 OpenSpec 的核心概念，用结构化的方式描述"什么在变"：

```markdown
# Delta for Auth

## ADDED Requirements
### Requirement: Two-Factor Authentication
系统登录时必须要求二次验证。

## MODIFIED Requirements
### Requirement: Session Timeout
会话超时从 60 分钟改为 30 分钟。

## REMOVED Requirements
### Requirement: Remember Me
（已被 2FA 取代）
```

归档时：
- **ADDED** → 追加到主规格
- **MODIFIED** → 替换主规格中对应内容
- **REMOVED** → 从主规格中删除

---

## 实际使用示例

### 场景：为学生宿舍管理系统添加"暗黑模式"

**第 1 步：提出变更**

在 Claude Code 聊天框中输入：
```
/opsx:propose add-dark-mode
```

AI 会自动创建 `openspec/changes/add-dark-mode/` 并生成 proposal.md、specs/、design.md、tasks.md。

**第 2 步：实现代码**

```
/opsx:apply
```

AI 读取 tasks.md，逐项完成编码并勾选。

**第 3 步：归档**

```
/opsx:archive
```

增量规格合并到主规格，变更移入 `openspec/changes/archive/`。

---

## 配置管理

```bash
# 查看所有配置
openspec config list

# 切换工作流配置（core / custom）
openspec config profile

# 设置遥测关闭
export OPENSPEC_TELEMETRY=0
```

---

## 支持的 AI 工具

OpenSpec 支持 25+ 种 AI 编码工具，包括：

Claude Code、Cursor、Windsurf、GitHub Copilot、Gemini、Codex、Cline、Trae、Kimi CLI 等。

完整列表见 [Supported Tools](https://github.com/Fission-AI/OpenSpec/blob/main/docs/supported-tools.md)。

---

## 参考链接

- GitHub: https://github.com/Fission-AI/OpenSpec
- 文档: https://github.com/Fission-AI/OpenSpec/tree/main/docs
- Discord: https://discord.gg/YctCnvvshC
