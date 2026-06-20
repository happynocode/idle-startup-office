# Idle Game Research and Recommendation

日期: 2026-06-20  
项目: `Startup Office Idle`  
代码观察: `/Volumes/ExternalSSD/idle game/lib/main.dart`

## 0. 调研范围与假设

- 你的要求里提到“每一步、每一关、每一个要素”，我这里将其落地为:
  - 每款游戏的核心循环
  - 它的主要里程碑奖励
  - 它靠什么把玩家往下一层推进
  - 哪些机制最值得 `Startup Office Idle` 借鉴
- 我没有把 50+ 款游戏做逐分钟 walkthrough，而是做了更适合产品设计落地的 `benchmark breakdown`。
- 本文同时使用了:
  - 代表作品的官方页面、官方/社区 wiki、设计分享
  - Steam / 官方站点的玩法描述
  - 广度样本的交叉对照，确认哪些机制是行业共性，哪些只是个例

## 1. 先说结论

你现在这款游戏的问题，不是“完全没内容”，而是:

1. 你已经有很多系统名字了，但大多数系统给的是 `倍率`，不是 `玩法变化`
2. 你的 milestone 节奏存在，但奖励不够“改变行为”
3. 你的主题是 startup/company growth，这个题材天然适合做事件、分支、危机、融资、组织管理、市场扩张，但现在还没有被真正用成 hook
4. 你的 prestige 已经存在，但更像 `数值重开`，还不够像 `开新层`

一句话总结:

> 现在这版更像“可以运行的 idle 骨架”，还不是“会让人停不下来的 idle 产品”。

## 2. 你当前版本已经有什么

基于 `/Volumes/ExternalSSD/idle game/lib/main.dart` 观察，你已经有这些层:

- `手动点击 + 自动收入`
- `Team / Office / Product / Funding / Events / Advisors / Challenges / Expansion / Prestige / Quests / Achievements`
- 团队人数阈值解锁节奏:
  - `3 hires` 解锁 sprint automation
  - `6 hires` 解锁 lead multiplier
  - `10 hires` 解锁 cross-functional pod
  - `20 hires` 解锁 culture engine
- 产品阶段:
  - `Idea -> Prototype -> MVP -> Beta -> Launch -> Growth -> Scale -> Unicorn Platform`
- 融资阶段:
  - `Bootstrapped -> Pre-seed -> Seed -> Series A -> Series B -> Series C -> IPO -> Acquired`
- 已有 burst / event 雏形:
  - `Viral Moment`
  - `Investor Call`
  - `Recruiting Rush`
- 已有 build choice 雏形:
  - `CompanyFocus`
  - `ProductStrategy`
  - `CapitalPolicy`
- 已有 challenge / advisor / specialization / legacy token 雏形

代码里几个关键观察:

- 团队阈值和功能门槛是存在的，但多数仍是倍率型收益，而非新玩法开启
- `product` 和 `funding` 的 milestone 已经会给 token / choice，但奖励密度仍偏薄
- `prestige()` 会给 `Prestige Points / Legacy Tokens / Founder Reputation`，但重开后主要还是回到同一条成长轨道
- 事件有两选一，方向是对的，但目前仍偏“短 burst 奖励”，缺少长期后果和组合效应

## 3. 现在为什么会觉得单调

核心原因不是数字小，而是循环层次太少。

### 3.1 你现在更偏线性增长

虽然系统很多，但玩家大部分时间的真实行为仍然是:

1. 点一下
2. 雇人
3. 等数字涨
4. 升产品 / 融资
5. 重复

这会导致:

- 决策张力不够
- 里程碑前的期待感不够
- 回流理由不够
- “再玩一下就能解锁新东西”的拉力不够强

### 3.2 你现在的里程碑，多数是“变强”，不是“变新”

优秀 idle game 的 milestone 往往会带来下列至少一种变化:

- 新货币
- 新自动化
- 新副本 / 新挑战
- 新随机事件池
- 新构筑分支
- 新地图 / 新场景 / 新视觉层
- 新重开层
- 新长期任务线

你现在很多 milestone 更像:

- `+cash`
- `+credits`
- `+reputation`
- `+valuation`
- `+multiplier`

这不够 hook。

## 4. 网上调研后，Idle Game 最常见的强要素

我把 50+ 款样本反复出现的设计要素整理成下面这套。

### 4.1 Milestone 最常见的奖励类型

1. `新系统解锁`
- 新货币
- 新页签
- 新区域
- 新角色槽位
- 新 automation
- 新 reset 层

2. `规则改变`
- 自动购买
- 离线收益上限提升
- 批量购买 / 批量生产
- 资源转化规则变化
- 新 synergy

3. `永久成长`
- prestige currency
- meta tree
- 永久 multiplier
- 收藏品
- 账号级加成

4. `不确定性奖励`
- 随机事件
- 金色饼干 / 宝箱 / relic / artifact
- 限时爆发
- 限时合同 / 派遣

5. `玩法目标切换`
- 从点击转为自动化
- 从生产转为 build optimization
- 从跑主线转为冲 challenge
- 从单局推进转为多轮重开优化

### 4.2 最能 Hook 用户的通用节奏

1. `10-30 秒` 级别的短反馈
- 总有一个小东西可以买
- 总有一个条能涨满

2. `2-5 分钟` 级别的中反馈
- 新建筑、新角色、新按钮、新分支

3. `15-60 分钟` 级别的长反馈
- 可重开
- 可开挑战
- 可冲下一层 prestige

4. `离开游戏也有期待`
- 离线收益
- 计时合同
- 定时收菜
- 被动任务完成

5. `回来就领奖`
- 离线结算
- 新成就
- 新事件
- 新合同
- 新随机掉落

### 4.3 真正让人上瘾的不是“数字变大”，而是这四件事同时成立

1. `确定性奖励`
- 再 20 秒我就能买到这个

2. `不确定性奖励`
- 下一次事件 / 合同 / relic 会不会出好东西

3. `永久成长`
- 这次重开不白玩

4. `系统揭示`
- 下一层到底会开什么新机制

## 5. 50+ 款 Idle Game Benchmark

说明:

- 这里优先记录每款游戏最值得参考的 `核心循环 / milestone / hook`
- 不追求每个 UI 小按钮，而追求“它为什么能让人继续玩”
- 深度代表样本和广度样本混合，总计 60 款

| # | 游戏 | 核心循环 | 关键里程碑 / 奖励 | 它的 Hook | 适合你借鉴的点 |
|---|---|---|---|---|---|
| 1 | Cookie Clicker | 点饼干 -> 买建筑 -> 吃爆发事件 -> Ascend | Golden Cookie, Achievements, Milk, Heavenly Chips | 随机爆发 + 成就也能变强 | 让成就和事件进入主成长线 |
| 2 | Clicker Heroes | 杀怪 -> 招英雄 -> 升级 -> Ascend / Transcend | Hero breakpoints, Ancients, Transcendence | 双层 reset 把重开做成长期目标 | 你的 Prestige 需要更深的第二层 |
| 3 | Realm Grinder | 赚钱 -> 选 faction -> Abdication -> Reincarnation | Faction unlocks, researches, challenges | 构筑分支极强，重玩价值高 | 给 startup 路线真正做流派分化 |
| 4 | Antimatter Dimensions | 买维度 -> Infinity -> Eternity -> Reality | Autobuyers, challenge clears, new prestige layers | 每次 prestige 都像新游戏 | 让 IPO / Prestige 打开新规则，而不只是加倍率 |
| 5 | Kittens Game | 多资源链 -> 建筑 -> 科技 -> 重开 | Paragon, Metaphysics, faith systems | 资源链和长期系统化很上头 | 你的 startup 非常适合做组织系统化 |
| 6 | Trimps | 生产 -> 区域推进 -> Portal -> Challenge | Portal, Heirlooms, challenge perks | 限制规则让每轮都不同 | 挑战模式可以是核心 longevity 系统 |
| 7 | Universal Paperclips | 工厂 -> 市场 -> 探索 -> 宇宙探针 | 阶段切换本身就是奖励 | “玩法变新”大于“数字变大” | 让公司从 office 进化到 platform / ecosystem |
| 8 | A Dark Room | 文本资源 -> 村庄 -> 探索 -> 战斗 | 一个个新系统渐进展开 | 揭示感很强 | 早期简单可以，但必须快速 unfold |
| 9 | Candy Box! | 先极简积累 -> 后续逐步开世界 | 菜单和地图逐步展开 | 神秘感驱动继续玩 | 开局可简单，但 5-10 分钟内必须惊喜 |
| 10 | Candy Box 2 | 资源 -> 任务 -> 装备 -> 地图 | 探索 / quest / 装备解锁 | 增量式 reveal 很强 | 你的“市场版图”可做地图揭示 |
| 11 | Progress Quest | 零玩家自动推进 | 观看进度本身就是乐趣 | 看系统自己跑也爽 | 办公室应该更“会演戏” |
| 12 | AdVenture Capitalist | 买产业 -> Manager 自动化 -> Angels | Manager automation, Angel investors | 自动化解锁改变操作需求 | 招 manager / lead 应该真正替玩家操作 |
| 13 | AdVenture Communist | 任务驱动资源链 | Missions, researchers, timed events | 任务不断推着玩家前进 | 你需要更强的任务驱动 |
| 14 | Egg, Inc. | 农场增长 -> Prestige -> Contracts -> Artifacts | Contracts, Soul Eggs, Epic Research | 合同让回流强、meta 强 | “客户合同 / 企业订单”非常适配你的题材 |
| 15 | Cell to Singularity | 主模拟 + 子模拟并行 | Mesozoic Valley, Beyond, Reality Engine | 子系统反哺主线 | 可做“海外市场”或“新产品线”子地图 |
| 16 | Idle Champions | 阵容排布 -> 推关 -> Variant | Formation strategy, patrons, variants | 不是只堆数值，而是堆组合 | 团队站位 / 组织配置可做更深 |
| 17 | Idle Slayer | 跑酷 + idle -> Ascension -> Ultra Ascension | Minions, divinities, UA | 多层重开 + 定时 minion | 可以加入“高管任务 / 部门派遣” |
| 18 | NGU Idle | rebirth -> boss -> wishes -> adventure | 高频 rebirth + 面板海量展开 | 总有新系统出现 | 你的中后期要更密集地开新层 |
| 19 | Mr.Mine | 挖深度 -> 新层 -> relic / super miners | 深度 milestone 持续开新内容 | 每一段深度都有新目标 | 你的产品成熟度 / 公司规模需要深度里程碑表 |
| 20 | Leaf Blower Revolution | 多货币、多宠物、多挑战、多 prestige | Leaves, pets, challenge layers | 内容 churn 非常高 | 你现在货币层太薄 |
| 21 | Swarm Simulator | 繁殖 -> 突变 -> Ascend | Mutagen and mutation trees | 永久成长和 build choice 很紧 | 可做组织文化 / 技术债基因树 |
| 22 | Spaceplan | 点击 -> 自动化 -> 叙事推进 | 叙事和增长同步推进 | 有故事张力 | 你的 startup 题材应更有故事感 |
| 23 | Almost a Hero | 团队推进 -> 失败 -> Mythstones meta | 失败也推进账号成长 | 卡关不会白费 | 失败需要给 meta 奖励 |
| 24 | Zombidle | 点 / 法术 / 破坏 -> 重开 | 主动技能 burst 很关键 | 打断单调节奏 | 加主动技能会明显改善手感 |
| 25 | Crush Crush | 时间资源 -> 多角色并行推进 | 多角色目标并行 | 并行目标比单线目标更黏人 | 可并行推进投资人 / 客户 / 团队关系 |
| 26 | Bit City | 赚钱 -> 升级城市 -> 开新区 | 视觉成长就是奖励 | 看城市变化很爽 | 办公室 / 楼层视觉变化要更明显 |
| 27 | Make It Rain | 点钱 -> 升级 -> prestige | 极强即时反馈 | 一次点击就很爽 | 点击反馈必须更强 |
| 28 | Lego Tower | 建楼层 -> 收居民 -> 完成收集 | 新楼层是清晰 milestone | 目标清晰且可视化 | 办公室扩张很适合做楼层系统 |
| 29 | Rusty's Retirement | 低打扰放置农场 | 挂后台也有生活感 | 轻陪伴感很强 | 你的办公室可以更像“活着的场景” |
| 30 | PokeClicker | 打地区 -> 集图鉴 -> 重刷 | 收藏完成度驱动回流 | 收集党会一直回来 | 你缺收藏型目标 |
| 31 | Shark Game | 多资源文明演化 | 新资源改变最优解 | 资源结构层层变化 | cash/credits/valuation 还不够 |
| 32 | CivClicker | 人口 -> 建筑 -> 资源链 | 发展层递进明确 | 文明感强 | startup 从小团队到组织体系可借鉴 |
| 33 | Space Company | 资源链 -> 发电 -> 太空扩张 | 多资源门槛式推进 | 每次开新资源都很爽 | 你可以做多产品线 / 多区域经营 |
| 34 | Crank | 小系统不断展开 | 每个解锁都改变操作重点 | reveal 强于复杂 UI | 新系统展开速度可以更快 |
| 35 | Clickpocalypse | 自动队伍冒险 | 看队伍自己跑图 | 可观察性高 | 团队执行 sprint / 销售外出可视化 |
| 36 | Clickpocalypse II | 自动 RPG 队伍成长 | 角色成长 + loot 回流 | 自动演出很上头 | 员工可以不仅是数字 |
| 37 | Forge & Fortune | 队伍 -> 战斗 -> 锻造 -> idle | 装备线和角色线并行 | 双循环互相推 | 可加“工具栈 / 软件栈 / 基建”装备线 |
| 38 | Godville | 纯自动 + 文本日志 | 事件日志本身是内容 | 文案产生黏性 | Startup 日志完全可以做成亮点 |
| 39 | Grindcraft | 资源 -> 配方 -> 新配方 | 配方树驱动长期目标 | 下一配方总在勾人 | 可做 SOP / 工具链 / 流程配方树 |
| 40 | Wizard and Minion Idle | 法术树 + minion 层 | 新法术等于新节奏 | build planning 强 | 产品 / 增长 / 融资可拆 skill tree |
| 41 | Campaign Clicker | 主题包装 + 升级链 | 新地区 / 新阶段 | 题材包装增强投入感 | 你的 startup 题材需要更强包装 |
| 42 | Anti-Idle: The Game | 超多模式共存 | 内容密度超高 | 永远有事做 | 但要避免乱，必须让分支回流主循环 |
| 43 | BubbleByte | 轻量快节奏 idle | 低摩擦回报 | 上手非常快 | 你的新手 2-3 分钟还可更紧凑 |
| 44 | Coin Treasures | 收集 + 资源增长 | 奖励来源多元 | 多奖励源更抗疲劳 | 奖励来源不能只靠 cash |
| 45 | A Firelit Room | 氛围叙事型 idle | 情绪和节奏比数值更重要 | 氛围本身增强回流 | 你需要更鲜明的 startup 氛围 |
| 46 | Bacterial Takeover | 题材驱动生成链 | 主题塑造资源意义 | 玩法和题材绑定紧 | 你的系统命名要更像创业世界 |
| 47 | City Inc | 企业 / 城市扩张 | 规模变化很直观 | “公司变大了”可感知 | 可把总部扩张做得更直观 |
| 48 | Castle Digger | 深度推进 -> 系统解锁 | 每下潜一段开新系统 | 里程碑密度高 | 每个产品层级都应开新能力 |
| 49 | Idle Raiders: Second Run | 队伍跑图 -> 二周目优化 | 重开本身是产品主题 | 二周目更爽 | Prestige 可包装成“下一家公司” |
| 50 | Nano Empire | 新尺度 = 新层级 | 阶段变化改变目标 | 规模切换很有效 | 从 feature -> product -> platform -> ecosystem |
| 51 | Arcane Incrementalist | 组合式升级路线 | 构筑乐趣高 | 规划 build 很上头 | 需要更深的路线抉择 |
| 52 | Amino Idle | 多资源转化 | 资源结构变化 > 数字 | 结构性成长更耐玩 | valuation 不该只是结果数值 |
| 53 | Build A Spaceship | 明确终局目标 -> 逐步建成 | 目标导向强 | 玩家总知道下一步 | 每章要有清晰终点 |
| 54 | Cavernous II | 规划 / 自动脚本 | 优化流程本身就是玩法 | 高端玩家会钻研 | 后期可加 COO automation scripts |
| 55 | City of Sacrifice | sacrifice 重开 | 献祭让 reset 合理化 | 失去换更大未来 | 可做“创业失败经验” |
| 56 | House Idle Pro | 空间成长 | 房间变化就是奖励 | 空间可视化强 | 办公区装修价值很高 |
| 57 | Idle Awards 2 | achievement-heavy | 成就直接给主线奖励 | 收成就也有战力 | 你可以更重做 achievements |
| 58 | Idle Evolution | 形态蜕变推进 | 新形态就是新目标 | 变身感强 | startup 的 company stage 可更戏剧化 |
| 59 | Prosperity | 长线资源管理 | 阶段策略切换 | 中后期更耐玩 | 招聘 / 融资 / 系统化要互相制约 |
| 60 | Queslar / minimalist incremental archetype | 简 UI + 深系统 | 系统深度胜过外壳复杂 | 数学与规划驱动 | 你不一定要更花，但必须更深 |

## 6. 从这 60 款游戏里抽出来的高频模式

### 6.1 出现频率最高的 12 个要素

1. `Prestige / Reset`
2. `Milestone unlocks`
3. `Automation`
4. `Multiple currencies`
5. `Challenges / restricted runs`
6. `Random burst events`
7. `Achievements with power`
8. `Collections / relics / artifacts / pets`
9. `Build choice / faction / loadout`
10. `Offline progress`
11. `Narrative reveal`
12. `Visible world growth`

### 6.2 里程碑奖励最常见的模板

- `Level 10/25/50/100` 类阈值:
  - 小倍数
  - 自动化
  - 新资源
  - 新副本
  - 新规则
- `第一次 Prestige`:
  - 永久货币
  - 新技能树
  - 新职业 / 新路线
- `第一次 Challenge clear`:
  - 永久特殊加成
  - 新 build
  - 新事件池
- `Daily / Weekly / Contract`:
  - 稀有 meta currency
  - 收藏品
  - 换皮肤 / 永久词条

## 7. 你的游戏现在最缺什么

这是这次调研后，我认为你最缺的 8 件事。

### 7.1 缺“改变玩法的 milestone”

你当前很多 milestone 只会让数字更大，没有让玩家换一种思考方式。

应该补:

- milestone 解锁 `新资源线`
- milestone 解锁 `新事件池`
- milestone 解锁 `新自动化权限`
- milestone 解锁 `新 challenge`
- milestone 解锁 `新房间 / 新视觉层`

### 7.2 缺“中期收集系统”

目前缺一个 `可长期收集、可 build、可掉落、可组合` 的系统。

最适合你题材的是:

- `Advisor Cards`
- `Investor Contacts`
- `Tool Stack / SaaS Stack`
- `Team Culture Traits`
- `Company Memos / Playbooks`

这些都能做成:

- 稀有度
- 套装效果
- challenge 专属掉落
- event 专属掉落

### 7.3 缺“合同 / 订单 / 派遣”类回流系统

这是你题材最天然、但现在还没做强的一块。

建议加:

- `Client Contracts`
- `Enterprise Deals`
- `Hiring Campaigns`
- `PR Windows`
- `Market Expeditions`

机制上可参考 `Egg, Inc.` 的 contracts、`Idle Slayer` 的 minions、`Mr.Mine` 的深度里程碑回收。

### 7.4 缺“真正的 build 差异”

你现在已经有:

- `CompanyFocus`
- `ProductStrategy`
- `CapitalPolicy`
- `FounderSpecialization`

但是它们还不够像“流派”，更像 `不同倍率`。

建议让不同路线真的改变玩法:

- `Product-led`
  - 更强 ship reward
  - 更快解锁 feature labs
  - 合同更少，但高口碑高留存
- `Growth-led`
  - 更强 traction event
  - 更快市场扩张
  - 更容易遇到 reputation crisis
- `Finance-led`
  - 融资门槛更低
  - 现金更宽裕
  - 研发速度更慢
- `Operations-led`
  - 自动化更早
  - 离线更强
  - 爆发更少，但稳定性高

### 7.5 缺“风险和代价”

现在多数选择的 downside 不够明显，所以选择不够有张力。

优秀 idle 的 build choice 常常都伴随 tradeoff:

- 增长快，但口碑容易掉
- 融资猛，但 burn rate 变高
- 招人快，但 culture 变差
- 多线扩张，但产品质量吃亏

没有代价，选择就不刺激。

### 7.6 缺“事件后果”

你已经有事件系统，但事件更像短期奖励按钮。

应改为:

- 事件有 `即时收益`
- 事件有 `中期状态`
- 事件能改动 `后续事件池`
- 事件能影响 `品牌、团队士气、客户信任`

例如:

- `Viral Moment`
  - 选冲营收: 立刻暴涨，但未来 2 分钟客服压力增加，reputation 更容易波动
  - 选打磨 onboarding: 当下收益较低，但后续合同完成率更高

### 7.7 缺“第二重 Prestige”

现在 prestige 存在，但还不够深。

建议分成两层:

1. `Founder Prestige`
- 保留你现在的 Prestige Points / Legacy Tokens / Founder Reputation

2. `Portfolio Layer`
- 每完成一家公司，进入 portfolio
- portfolio 解锁全局基金、品牌、校友网络、顾问池、特殊剧本
- 这层不是每局都触发，而是更慢的账号级成长

这样能把“serial founder fantasy”真正做出来。

### 7.8 缺“更强的视觉兑现”

Idle game 里，视觉变化本身就是奖励。

你当前很适合加:

- 工位数量 visibly 增长
- 会议室解锁
- CEO room / board room
- 海外办公室支线
- 上市敲钟 / acquisition 动画
- 团队角色在办公室里行动
- dashboard 墙、服务器机架、活动海报、客户 logo 墙

## 8. 怎么 Improve 你现在这个游戏

下面是我建议的分阶段方案，按“投入较小但收益高”优先。

### 8.1 第一阶段: 先把现有骨架变好玩

这是最优先的一层，不需要完全推翻现有代码结构。

#### A. 把 milestone 奖励从“倍率”升级成“新系统”

建议直接重做以下 milestone:

- `3 hires`
  - 不是只开自动化
  - 再加 `Sprint Tasks` 小任务槽
- `6 hires`
  - 解锁 `Team Leads`
  - 可给某部门指派 lead，改变部门成长曲线
- `10 hires`
  - 解锁 `Cross-functional Project`
  - 需要固定组合员工，完成后给永久公司 trait
- `20 hires`
  - 解锁 `Culture / Process Incidents`
  - 玩家必须管理速度与稳定性的权衡

#### B. 强化 product milestone

当前产品阶段很好，但每次奖励偏轻。

建议:

- `Prototype`
  - 解锁事件池和第一个用户反馈系统
- `MVP`
  - 解锁用户分群、留存、投诉
- `Launch`
  - 除 traction 外，新增 `Customer Trust`
- `Growth`
  - 解锁 `Feature Bets`
- `Scale`
  - 解锁 `Platform Strategy`
- `Unicorn Platform`
  - 解锁 `Ecosystem / Acquisition / Multi-product`

#### C. 强化 funding milestone

建议让融资不是“拿钱”，而是“拿约束”。

- `Pre-seed`
  - 开 investor event pool
- `Seed`
  - 开 board requests
- `Series A`
  - 开 KPI pressure
- `Series B`
  - 开海外扩张 / 大客户系统
- `IPO`
  - 开 public-market volatility
- `Acquired`
  - 开 parent-company directives / earn-out system

### 8.2 第二阶段: 加一条真正能 hook 的中期循环

这是最值得投入的一层。

我建议你优先做 `Contracts + Relics` 双系统。

#### A. Contracts 系统

合同可以分为:

- `Startup Pilot`
- `SMB Deal`
- `Enterprise Rollout`
- `Government Tender`
- `Celebrity / Viral Partnership`

每个合同有:

- 时长
- 所需团队配置
- 风险
- 奖励包
- 失败代价

奖励不只给 cash:

- 稀有 advisor
- SaaS stack card
- 永久 reputation cap
- event 权重变化
- 特殊办公室装饰

#### B. Relics / Cards 系统

可命名成更贴题材的:

- `Playbooks`
- `Founder Lore`
- `Network Contacts`
- `Infra Stack`

特征:

- 稀有度
- 套装
- 部门偏向
- run-only 与 account-wide 混合

这样玩家会开始“刷配置”，而不是只刷 cash。

### 8.3 第三阶段: 把 prestige 改成真正的 meta

建议改成:

#### Layer 1: `Exit and Restart`

- 出售公司 / IPO / Acquired
- 获得:
  - `Founder Reputation`
  - `Legacy Tokens`
  - `Investor Trust`

#### Layer 2: `Portfolio`

- portfolio 解锁:
  - 新起手 buff
  - 新顾问池
  - 新公司剧本
  - 新 challenge 赛道
  - 新事件池

#### Layer 3: `Venture Fund`

更后期才开。

- 玩家不再只是做一家公司
- 而是管理基金网络 / 校友生态 / 顾问影响力

这个层级会把题材从“创业公司 clicker”变成“创业帝国 incremental”。

## 9. 怎么让用户更上瘾、更 Hook

这里说的是 retention 设计，不是单纯让数值膨胀。

### 9.1 短期 Hook

每 20-40 秒至少给玩家一个清晰决定:

- 买谁
- 升哪个系统
- 开哪个 sprint
- 接哪个合同
- 赌哪个事件分支

### 9.2 中期 Hook

每 3-5 分钟要出现一个“可感知的新东西”:

- 新房间
- 新事件
- 新卡牌
- 新客户类型
- 新挑战

### 9.3 长期 Hook

每 20-45 分钟让玩家进入“现在 prestige 还是再撑一下”的纠结。

这是 idle game 非常经典的 hook 点。

### 9.4 用“差一点”设计目标

让玩家永远觉得:

- 再攒 1 个合同点数就够
- 再过一个事件就能开新顾问
- 再升一个房间就能冲 challenge

这类 “almost there” 感受比纯大数值更有黏性。

### 9.5 把随机奖励和可控目标混在一起

最健康的 idle hook 不是纯赌博，也不是纯算术。

理想结构是:

- 可控目标:
  - milestone
  - prestige
  - challenge clear
- 随机目标:
  - 稀有事件
  - 稀有合同
  - 稀有顾问 / relic

### 9.6 让玩家离开也有牵挂

可以加:

- 1 小时完成的 enterprise contract
- 3 小时完成的 hiring campaign
- 8 小时完成的 overseas expansion
- 离线期间发生的新闻简报

玩家回来不是只看一串 cash，而是看“公司发生了什么”。

## 10. 对你这个项目的整体 Recommendation

如果让我给这个项目做产品方向建议，我会这样定:

### 10.1 不要继续只加普通升级项

继续加更多 `+10%`、`+15%`、`+cash/s`，边际收益会越来越低。

你更应该加:

- 新循环
- 新资源
- 新后果
- 新可视化
- 新 build 分化

### 10.2 把主题做深，而不是只做“创业皮”

最值钱的不是 generic idle 模板，而是你这个 startup 题材本身。

题材上最值得做深的是:

- 融资压力
- 招聘速度 vs 文化质量
- 产品速度 vs 稳定性
- 病毒传播 vs 留存质量
- 海外扩张 vs 本地口碑
- 大客户合同 vs 团队负荷
- 董事会要求 vs 创始人愿景

这些都比单纯加一个新 tab 更有辨识度。

### 10.3 先做“一条新中期循环”，不要同时摊太大

优先级我建议是:

1. `Contracts`
2. `Card / Relic / Playbook collection`
3. `Stronger prestige layers`
4. `Event consequences`
5. `Office visual growth`

只要这五项做好，产品吸引力会明显上一个台阶。

### 10.4 推荐的版本路线

#### v1.1

- 重做 milestone 奖励
- 加 contracts
- 加更强事件分支

#### v1.2

- 加 advisor / playbook 收藏系统
- 加更强 challenge 奖励
- 加 office 视觉成长

#### v1.3

- 上第二层 prestige
- 上 portfolio meta
- 上多公司 / 多市场层

## 11. 一个可以直接执行的补缺清单

下面这份最适合直接转成开发 backlog。

### 必做

- 让 milestone 奖励更多地解锁新玩法，而不是只加倍率
- 给 `product` 和 `funding` 每个阶段增加一个“系统型奖励”
- 给 `events` 增加长期后果
- 给 `prestige` 增加第二层 meta
- 增加至少一条 `contracts / dispatch / mission` 中期循环

### 强烈建议

- 增加 `collection / relic / playbook / advisor card` 系统
- 增加更明显的办公室视觉升级
- 增加更多 downside-based choices
- 增加离线返回时的“新闻简报 / 结算叙事”

### 可选增强

- 日常 / 周常 challenge
- 限时 event season
- founder origin / company archetype 开局
- 社交炫耀点: valuation peak, fastest IPO, clean bootstrapped run

## 12. 最终判断

你现在这款游戏，已经不是零基础了。

它真正缺的不是“更多按钮”，而是:

- 更强的 milestone 奖励设计
- 更深的中期循环
- 更明显的构筑差异
- 更有后果的事件系统
- 更像“serial founder fantasy”的 prestige

如果只给一个最重要建议:

> 先做 `Contracts + Collection + Consequence-based Events`，这是最容易让你这款 startup idle 从“能玩”变成“想继续玩”的三件套。

## 13. Sources

以下来源主要用于确认行业共性、代表作品机制、以及样本覆盖范围。

### 设计与机制分析

- [GDC Vault: Idle Games - The Mechanics and Monetization of Self-Playing Games](https://www.gdcvault.com/play/1022065/Idle-Games-The-Mechanics-and)
- [Kongregate Developers Blog: The Math of Idle Games, Part I](https://blog.kongregate.com/the-math-of-idle-games-part-i/)
- [Kongregate Developers Blog: The Math of Idle Games, Part II](https://blog.kongregate.com/the-math-of-idle-games-part-ii/)

### 代表作品机制来源

- [Cookie Clicker Wiki](https://cookieclicker.wiki.gg/wiki/Cookie_Clicker_Wiki)
- [Clicker Heroes Wiki](https://clickerheroes.fandom.com/wiki/Clicker_Heroes_Wiki)
- [Realm Grinder Wiki](https://realm-grinder.fandom.com/wiki/Realm_Grinder_Wiki)
- [Antimatter Dimensions Guide / Wiki](https://antimatter-dimensions.fandom.com/wiki/Guide)
- [Kittens Game Wiki](https://kittensgame.fandom.com/wiki/Kittens_Game_Wiki)
- [Trimps Wiki](https://trimps.fandom.com/wiki/Trimps_Wiki)
- [Universal Paperclips](https://www.decisionproblem.com/paperclips/index2.html)
- [A Dark Room](https://adarkroom.doublespeakgames.com/)
- [AdVenture Capitalist Wiki](https://adventure-capitalist.fandom.com/wiki/AdVenture_Capitalist_Wiki)
- [Egg, Inc. Wiki](https://egg-inc.fandom.com/wiki/Egg,_Inc._Wiki)
- [Cell to Singularity](https://www.celltosingularity.com/)
- [Idle Champions official site](https://www.codenameentertainment.com/?page=idle_champions)
- [Idle Slayer Wiki](https://idleslayer.fandom.com/wiki/Idle_Slayer_Wiki)
- [NGU IDLE on Steam](https://store.steampowered.com/app/1147690/NGU_IDLE/)
- [Mr.Mine on Steam](https://store.steampowered.com/app/1397920/MrMine/)
- [Leaf Blower Revolution on Steam](https://store.steampowered.com/app/1468260/Leaf_Blower_Revolution__Idle_Game/)
- [Rusty's Retirement on Steam](https://store.steampowered.com/app/2666510/Rustys_Retirement/)
- [Pokeclicker Wiki](https://wiki.pokeclicker.com/)
- [Crush Crush on Steam](https://store.steampowered.com/app/459820/Crush_Crush/)

### 样本拓展与广度校验

- [Wikipedia: Incremental game](https://en.wikipedia.org/wiki/Incremental_game)
- [Steam Idle Tag](https://store.steampowered.com/tags/en/Idler/)
- [Steam Clicker Tag](https://store.steampowered.com/tags/en/Clicker/)

