# Idle Game 调研与改进建议

日期: `2026-06-20`  
项目: `Startup Office Idle`  
代码入口: `/Volumes/ExternalSSD/idle game/lib/main.dart`

## 1. 调研结论

行业里能长期留住玩家的 Idle / Incremental Game，几乎都会同时具备下面几类要素：

1. `Prestige / Reset`
2. `Automation`
3. `Milestone Unlocks`
4. `Build Choice`
5. `Contracts / Missions / Timed Goals`
6. `Offline Progress + Return Reward`
7. `Collection / Artifact / Relic`
8. `Challenges / Restricted Runs`
9. `Burst Events`
10. `多层长期目标`

不是每款游戏都要全有，但只要想让用户“停不下来”，至少要同时满足：

- 短反馈: 10 到 30 秒内有动作可做
- 中反馈: 2 到 5 分钟内出现新按钮、新组合或新奖励
- 长反馈: 15 到 60 分钟内出现一次 reset / prestige / build 抉择
- 回流反馈: 玩家回来时立刻得到“现在登录是值得的”奖励

## 2. 这类游戏为什么容易 Hook 住用户

核心不是“大数字”，而是 `下一步总是很近，但又永远还有下一层`。

最有效的 Hook 通常来自这 5 个结构：

1. `再等 20 秒就买得起`
2. `再撑一会就能 prestige`
3. `下一次事件 / 掉落 / 合同也许更好`
4. `这次 reset 不会白打，因为有永久成长`
5. `我回来领奖后，可以立刻打一波更爽的爆发`

对你的 startup 题材来说，最适合承载这些 Hook 的，不是继续加纯倍率，而是：

- `Founder Momentum`
- `Deal / Contract Chain`
- `Event Consequences`
- `Playbook / Advisor / Strategy Build`
- `Offline Return Burst`

## 3. 我看完你当前版本后的判断

你现在的问题不是“系统太少”，而是“系统对玩家行为改变不够大”。

当前版本已经有：

- 点击与自动产出
- 团队招聘
- 产品阶段
- 融资阶段
- 事件
- 合同
- Playbook / Advisor / Challenge / Prestige / Live Ops

但它现在还不够上瘾，原因主要是：

1. 很多 milestone 还是偏 `+数值`
2. 合同虽然存在，但还没形成“连续成交”的主循环压力
3. 玩家离开后回来，有收益，但“回来这一刻”的刺激不够强
4. 很多系统有 tab，但玩家缺少“现在最该做什么”的明确诱因

## 4. 本次我已经落到代码里的改进

这次我优先实现了 4 个最能直接提升黏性的机制，而且它们会同时作用于 iOS 和 Android，因为这个项目是 Flutter 共享逻辑，不是两套分离代码。

### 4.1 Founder Momentum

我加入了 `Founder Momentum` 条，玩家通过点击、升级、招聘、推进产品、融资、做任务、做合同来持续蓄力。

当 Momentum 拉满时，会触发 `Founder Flow`，给一段短时间强爆发，让玩家有“我再多玩 30 秒”的冲动。

这是为了补足你现在缺的 `短周期爽感`。

### 4.2 Deal Chain

我把合同改成了更像主循环的 `Deal Chain` 结构。

连续成功签单会：

- 提高合同奖励
- 缩短后续合同时长
- 在连击到一定层数后额外给奖励

合同失败会直接断链。

这让玩家不再只是“有合同就做一下”，而会开始围绕连续成交去规划。

### 4.3 Return Surge

我把离线结算改成了更强的回流钩子。

长时间离线后，玩家重新打开游戏，不只是收菜，而是会得到一个短时间 `Return Surge`。

这能强化“回来立刻玩几分钟最划算”的感觉。

### 4.4 UI 明示 Hook

我把这些状态直接写进界面了：

- `Flow`
- `Chain`
- `Founder Flow`
- `Return Surge`
- 合同链倍率和时长缩放

这一步很重要，因为 Idle Game 的乐趣不只是有系统，还要让玩家看得见自己的节奏和下一步目标。

## 5. 还缺什么

如果要继续往“真正上头”的方向走，你这款游戏下一阶段还缺 5 个关键层：

### 5.1 第二层 Prestige

现在 prestige 已经有了，但还缺“重开后像进入新游戏”的第二层变化。

建议把 `IPO / Exit` 之后做成更强的 meta layer，比如：

- 新创业主题
- 新市场规则
- 新 founder archetype
- 新公司模型

### 5.2 更强的 Build 分化

现在 focus / advisor / playbook / founder origin 都有了，但还可以更极端。

建议让不同路线真的变成不同打法，比如：

- Product-led: 更强 ship / trust / retention
- Growth-led: 更强 traction / event burst / risky contracts
- Finance-led: 更强 round timing / valuation / safer reset

### 5.3 收藏型长期目标

优秀 idle game 往往会给玩家一个“不止刷数值，还想收集”的长期目标。

你目前最适合加的是：

- 稀有合同掉落
- 稀有 advisor
- Founder trophies
- 公司史诗事件收藏

### 5.4 Reveal 感

很多优秀作品的乐趣来自 `不断揭示新层`。

你这个题材可以做成：

- 从办公室到全球市场
- 从单产品到产品矩阵
- 从创业公司到控股平台

### 5.5 更强的失败代价与恢复手段

现在失败存在，但恢复选择还可以更戏剧化。

建议以后增加：

- Crisis recovery 项
- PR repair 项
- Burn cut / layoff / rescue financing 抉择

## 6. 整体 Recommendation

如果只讲一句话，我的建议是：

`不要再继续横向加 tab，优先把“短期爆发 + 中期连击 + 回流奖励 + 长期重开”这四层循环打透。`

更具体地说，优先级建议如下：

1. 继续强化 `Founder Momentum / Founder Flow`
2. 把 `Contracts` 做成真正的主循环
3. 给 `Prestige` 再加一层明显的新规则
4. 增加 `Collectible` 长期目标
5. 增加更强的主题揭示与叙事推进

## 7. 本次代码落地点

本次已更新的主要代码位置：

- `/Volumes/ExternalSSD/idle game/lib/main.dart`
- `/Volumes/ExternalSSD/idle game/test/playthrough_test.dart`

本次新增并验证过的内容包括：

- Momentum / Founder Flow
- Deal Chain
- Return Surge
- 相关 UI 展示
- 对应自动化测试

## 8. 参考来源

- [Incremental game - Wikipedia](https://en.wikipedia.org/wiki/Incremental_game)
- [The Math of Idle Games, Part I - Kongregate](https://blog.kongregate.com/the-math-of-idle-games-part-i/)
- [The Math of Idle Games, Part II - Kongregate](https://blog.kongregate.com/the-math-of-idle-games-part-ii/)
- [The Math of Idle Games, Part III - Kongregate](https://blog.kongregate.com/the-math-of-idle-games-part-iii/)
- [Ascension - Cookie Clicker Wiki](https://cookieclicker.wiki.gg/wiki/Ascension)
- [Reality - Antimatter Dimensions Wiki](https://antimatter-dimensions.fandom.com/wiki/Reality)
- [Contracts - Egg, Inc. Wiki](https://egg-inc.fandom.com/wiki/Contracts)
- [Artifacts - Egg, Inc. Wiki](https://egg-inc.fandom.com/wiki/Artifacts)
- [Managers - AdVenture Capitalist Wiki](https://adventure-capitalist.fandom.com/wiki/Managers)
- [Research - Realm Grinder community reference](https://musicfamily.org/realm/Research/)
- [r/incremental_games community list](https://www.reddit.com/r/incremental_games/wiki/list_of_incremental_games/)
- [Lessons of my first incremental game - Game Developer](https://www.gamedeveloper.com/design/lessons-of-my-first-incremental-game)
