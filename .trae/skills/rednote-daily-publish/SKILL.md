---
name: "rednote-daily-publish"
description: "每日定时发布iPhone和iPad壁纸视频到小红书创作者中心。Invoke when user asks to publish wallpaper to Xiaohongshu/小红书, or mentions 发布到小红书/发布笔记/小红书发布, or specifies a date for wallpaper publishing."
---

# 小红书每日壁纸发布工作流

根据指定日期从项目 CDN 和博客源文件提取素材，通过浏览器自动化上传视频并填写文案，定时发布到小红书创作者中心。

## 触发条件

- 用户要求发布壁纸到小红书
- 用户提到"发布到小红书"、"小红书发布"、"发布笔记"
- 用户指定日期并要求发布壁纸内容到小红书

## 文件匹配规则

给定日期 `YYYY-MM-DD`（如 `2026-09-18`），计算：

```
YMD    = YYYYMMDD    (如 20260918)
YYYYMM = YYYY + MM   (如 202609)
```

| 类型 | 视频路径 | 博客路径 |
|------|----------|----------|
| iPhone | `_cdn/showcase/{YYYYMM}/{YMD}.mp4` | `_iphone-wallpaper/{YYYY}/{MM}/{YYYY-MM-DD}-*.markdown` |
| iPad | `_cdn/showcase_ipad/{YYYYMM}/{YMD}_ipad.mp4` | `_ipad-wallpaper/{YYYY}/{MM}/{YYYY-MM-DD}-*.markdown` |

> 使用 Glob 工具按通配符匹配博客文件，视频文件直接按路径检查是否存在。

## 内容提取规则

1. **标题**: 从博客 frontmatter `description` 字段提取，去掉 `No.YYYYMMDD` 前缀
2. **正文**: 从博客简体中文区块提取（标题含 `动态壁纸` 而非 `動態壁紙`）
3. **🖼️ 关键词行**: iPad 博客中直接存在于 markdown；iPhone 博客中缺失时需根据正文生成 5 个关键词短语，用「｜」分隔
4. **# 话题标签**: 从简体中文区块末尾提取，补充 `#LockLive #实况全能王 #LiveWallpaper #xLiveWallpaper #游戏壁纸`（iPad 额外添加 `#iPad壁纸`）
5. **文案组装**: 标题 + 空行 + 正文段落 + 空行 + 🖼️关键词行 + 空行 + #话题标签

## 发布流程

### 准备工作

1. 创建/确认工作目录：`_local/trea/rednote/`
   - `content/` - 存放每日文案文件
   - `screenshots/` - 存放发布截图
   - `publish-log.md` - 发布日志

2. 检查视频文件和博客源文件是否存在
3. 提取内容并保存为 `iphone-{YMD}.txt` 和 `ipad-{YMD}.txt`

### 浏览器发布步骤（每条笔记独立执行）

1. **导航**: 打开 `https://creator.xiaohongshu.com/publish/publish?from=menu&target=video`
2. **上传视频**:
   - 定位隐藏的 `input[type=file]`
   - 通过 `browser_evaluate` 设置 `style.display="block"`、`tabindex`、`role`、`aria-label` 属性使元素出现在无障碍树中
   - 使用 `browser_upload_file` 上传视频文件（参数名 `filePath`）
3. **填写标题**: 在标题输入框填写提取的标题
4. **填写正文**: 在正文区域填写完整文案（标题 + 正文 + 🖼️关键词行 + #话题标签）
5. **添加小工具（iPhone）**: 搜索"今日壁纸"并添加组件
6. **定时发布**:
   - 滚动到页面底部「更多设置」区域
   - 找到 `.post-time-wrapper` 内的 `.d-switch`，点击启用定时发布
   - 设置时间输入框值为 `YYYY-MM-DD 10:29`（使用原生 value setter + dispatch input/change/blur 事件）
7. **提交发布**:
   - 找到 `xhs-publish-btn` 自定义组件
   - 通过 shadow root 找到文字为"定时发布"的按钮并点击
   - 等待页面跳转到成功页（URL 含 `published=true` 或 `/publish/success`）

### 重复发布 iPad 壁纸

返回发布页面，重复上述步骤 2-7 发布 iPad 壁纸。

## 更新发布日志

在 `_local/trea/rednote/publish-log.md` 顶部追加记录，格式：

```markdown
## YYYY-MM-DD 发布记录

### 手机壁纸（iPhone）

| 项目 | 值 |
|------|-----|
| 日期 | YYYY-MM-DD |
| 文章编号 | No.YMD |
| 主题 | ... |
| 视频文件 | `_cdn/showcase/YYYYMM/YMD.mp4` |
| 博客源文件 | `_iphone-wallpaper/...` |
| 内容文件 | `_local/trea/rednote/content/iphone-YMD.txt` |
| 标题 | ... |
| 定时发布 | YYYY-MM-DD 10:29 |
| 状态 | ✅ 已定时 / ✅ 已发布 / ❌ 失败 |
| 发布时间 | YYYY-MM-DD 10:29 |

### 平板壁纸（iPad）

（同上格式，替换为 iPad 信息）

---
```

## 技术要点

| 要点 | 说明 |
|------|------|
| 文件上传 | `input[type=file]` 默认隐藏，需设置 CSS + 无障碍属性才能被检测到 |
| 定时发布位置 | 页面底部「更多设置」区域内的 `.post-time-wrapper` |
| 定时开关 | `.d-switch` 组件，点击切换状态，检查 `.d-switch-simulator.checked` 确认 |
| 时间输入 | 文本类型 input，需用原生 value setter + 事件触发 |
| 发布按钮 | `xhs-publish-btn` 自定义组件，需访问其 shadow root 找到按钮 |
| emoji 输入 | 直接 `browser_type` 即可，emoji 编码正常 |
| 上传超时 | 大视频上传可能超时，视频通常已上传成功，用 snapshot 确认状态 |
| 当前时间 | 定时发布时间必须晚于当前时间 |

## 输出文件

- `_local/trea/rednote/content/iphone-{YMD}.txt` - iPhone 发布文案
- `_local/trea/rednote/content/ipad-{YMD}.txt` - iPad 发布文案
- `_local/trea/rednote/publish-log.md` - 发布日志（追加）
