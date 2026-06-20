# Idle Game 重新调研报告

日期: `2026-06-20`  
项目: `Startup Office Idle`  
代码参考: `/Volumes/ExternalSSD/idle game/lib/main.dart`

## 1. 这次怎么调研

这份文档是重新调研后从零写的，没有沿用上一版文档内容。

这次我把你的需求拆成 3 个问题:

1. 别人的 Idle Game 在 milestone 到来时，通常给玩家什么奖励
2. 至少 50 款代表性 Idle / Incremental 游戏，分别靠什么机制留住玩家
3. 结合你当前这个 startup 题材，哪些机制最值得引入，哪些现在还缺

说明:

- Idle Game 很多并没有“关卡”这个固定概念，所以我把“每一步、每一关、每一个要素”统一映射成:
  - `早期循环`: 玩家前 30 秒到 5 分钟在做什么
  - `中期推进`: milestone、解锁、自动化、任务、事件、build choice
  - `长期循环`: prestige、meta progression、收藏、挑战、离线回流
- 这次不是做 50 款游戏的逐分钟攻略，而是做产品设计维度的 benchmark。
- 样本池来自:
  - 官方站 / 官方 Steam 页面 / 官方或社区 wiki
  - `r/incremental_games` 社区列表
  - `IncrementalDB` 数据库
  - Wikipedia 对类型的综述
  - Kongregate / GDC / 学术论文对 idle genre 的机制分析

## 2. 先说结论

你现在这款游戏不缺“系统名字”，缺的是 `真正改变玩家行为的中期循环`。

更具体地说，你现在最需要补的是这 5 件事:

1. `Milestone 奖励要从加倍率，改成开新玩法`
2. `Contracts / Dispatch / Missions` 要变成主循环，而不是边角奖励
3. `Events` 要有后果，不能只是一次性 burst
4. `Playbooks / Advisors / Founder Meta` 要从数值卡，变成 build 卡
5. `Prestige` 要更像“开新层”，不是“把同一轮再刷一遍”

一句话总结:

> 现在这版更像“有很多 tab 的 idle 原型”，还不是“会让玩家一直惦记下一次登录”的 idle 产品。

## 3. 你现在这个游戏已经有什么

基于 `/Volumes/ExternalSSD/idle game/lib/main.dart`，你已经有这些骨架:

- `手动点击 + 自动收入`
- `Team / Product / Funding / Events / Advisors / Challenges / Expansion / Prestige / Quests / Shop`
- 产品阶段:
  - `Idea -> Prototype -> MVP -> Beta -> Launch -> Growth -> Scale -> Unicorn Platform`
- 融资阶段:
  - `Bootstrapped -> Pre-seed -> Seed -> Series A -> Series B -> Series C -> IPO -> Acquired`
- 事件:
  - `Viral Moment`
  - `Investor Call`
  - `Talent Surge`
- 合同:
  - `Startup Pilot`
  - `Talent Brand Sprint`
  - `SMB Rollout`
  - `Channel Partnership`
  - `Enterprise Rollout`
  - `Government Tender`
- build 分支:
  - `CompanyFocus`
  - `ProductStrategy`
  - `CapitalPolicy`
  - `FounderSpecialization`
  - `FounderOrigin`
- meta / collection 雏形:
  - `Advisors`
  - `Playbooks`
  - `Challenges`
  - `Achievements`
  - `Founder Reputation`
  - `Portfolio Points`

所以问题不是“没内容”，而是:

- 很多系统目前还是 `倍率型奖励`
- milestone 的 `行为改变力度不够`
- contract、event、advisor、playbook 都有雏形，但还没成为玩家主动围绕它规划的核心循环

## 4. 行业里最常见的 Idle Game 强要素

结合类型综述、设计分析和 50 款 benchmark，高频要素基本集中在下面 10 个:

1. `Prestige / Reset`
2. `Milestone Unlocks`
3. `Automation`
4. `Multiple Currencies`
5. `Short Burst Events`
6. `Challenges / Restricted Runs`
7. `Achievements that also grant power`
8. `Collection / Artifacts / Cards / Pets / Relics`
9. `Build Choice / Faction / Loadout`
10. `Offline Progress + Return Rewards`

这些机制不是每个游戏都会全有，但优秀作品往往至少具备其中 5 到 7 个。

## 5. Milestone 到来时，别人通常给玩家什么

这是这次调研里最重要的一部分。

### 5.1 最常见的 milestone 奖励类型

1. `新系统解锁`
- 新货币
- 新面板
- 新区域
- 新职业 / 阵容槽位
- 新 automation
- 新 reset 层

2. `规则改变`
- 自动购买
- 批量购买
- 离线收益上限提升
- 新资源转化关系
- 旧系统获得新用途

3. `永久成长`
- prestige currency
- meta tree
- 永久被动
- 永久收藏加成
- 下一轮更强开局

4. `不确定性奖励`
- 稀有事件
- 随机掉落
- 限时爆发
- 宝箱 / artifact / relic / contract reward

5. `玩法目标切换`
- 从点击切到自动化
- 从生产切到 build optimization
- 从主线切到 challenge
- 从单轮推进切到多轮 reset 规划

### 5.2 真正常见、而且有效的 milestone 模板

- `第一次自动化`
  - 玩家从“手动点”转入“配置系统”
- `第一次 prestige`
  - 玩家理解“重开不是失败，而是下一层开始”
- `第一次挑战通关`
  - 给 run-defining 的永久奖励
- `第一次稀有掉落 / 收藏成套`
  - 给玩家长期 farm 理由
- `第一次世界切换`
  - 例如地图、宇宙、子系统、第二产品线

### 5.3 结论

优秀 idle game 的 milestone 很少只是:

- `+10%`
- `+cash`
- `+speed`

更常见的是:

- `开新按钮`
- `开新循环`
- `开新资源`
- `开新风险`
- `开新身份`

## 6. 50 款 Idle / Incremental 游戏 benchmark

说明:

- 下面的“关键设计”是设计摘要，不是 full walkthrough。
- 我重点记录每款游戏最值得学的 `核心循环 / milestone / 留存钩子 / 对你项目的启发`。

| # | 游戏 | 关键设计 | milestone / 奖励 | 留存 hook | 对你最有用的点 |
|---|---|---|---|---|---|
| 1 | Cookie Clicker | 点击 + 建筑 + Golden Cookie + Ascension | 建筑阈值、成就、Heavenly Chips | 随机爆发和成就回流 | 事件和成就进入主成长线 |
| 2 | Clicker Heroes | 打怪、招英雄、Ascend、Transcend | hero breakpoints、Ancients | 多层 reset | 你的 prestige 要有第二层 |
| 3 | Realm Grinder | 挣钱、选 faction、abdication、reincarnation | faction、research、challenges | 流派分化极强 | 让 startup 路线真正不同 |
| 4 | Antimatter Dimensions | 维度增长、Infinity、Eternity、Reality | autobuyers、新 prestige 层 | 每次 reset 都像新游戏 | IPO / Exit 要打开新规则 |
| 5 | Kittens Game | 资源链、建筑、科技、重开 | Paragon、Metaphysics | 规划感和长期 meta | 组织系统化、资源链更深 |
| 6 | Trimps | 生产、推图、Portal、Challenge | Portal perks、挑战奖励 | 受限规则带来重玩性 | challenge 应该是长期内容 |
| 7 | Universal Paperclips | 生产、市场、扩张、宇宙化 | 阶段切换就是奖励 | 玩法持续变形 | 公司要从 office 进化为 ecosystem |
| 8 | A Dark Room | 极简积累、村庄、探索、战斗 | 系统逐步揭示 | reveal 本身就是 hook | 开局可简，但必须快速展开 |
| 9 | Candy Box! | 简单积累后逐步开菜单和世界 | 新界面、新地图 | 神秘感驱动 | 早期要更有“惊喜揭示” |
| 10 | Candy Box 2 | 资源、任务、装备、地图 | 地图 / 装备解锁 | 探索式推进 | 市场扩张可以做成地图 |
| 11 | Progress Quest | 全自动推进、观看成长 | 自动职业成长 | 看系统自己跑也爽 | 办公室要更“会演” |
| 12 | AdVenture Capitalist | 投资、manager 自动化、angel reset | managers、angel investors | 自动化改变操作方式 | lead / manager 应真能替玩家做事 |
| 13 | AdVenture Communist | 任务驱动的资源链 | missions、researchers、events | 持续任务压着你前进 | 任务系统要更强 |
| 14 | Egg, Inc. | 农场、prestige、contracts、artifacts | contracts、Soul Eggs、Epic Research | 合同强回流 | startup 题材极适合合同系统 |
| 15 | Cell to Singularity | 主模拟 + 子模拟 | 新分支模拟反哺主线 | 子系统反哺 | 可做海外市场 / 新产品线 |
| 16 | Idle Champions | 阵容、推进、variant、patron | formation、variant、patron | 组合和限制玩法 | 团队配置要比人数更重要 |
| 17 | Idle Slayer | 跑酷 + idle + Ascension | minions、divinities、UA | 多层 reset + 定时派遣 | 高管派遣 / 部门任务很适合 |
| 18 | NGU Idle | rebirth、boss、wishes、adventure | 高频 rebirth、新系统密集展开 | 总有新面板开 | 中后期新东西密度要更高 |
| 19 | Mr.Mine | 挖深度、装备、relic、super miners | 深度 milestone、稀有掉落 | 每一段深度都有新目标 | 每个阶段要有明确深度表 |
| 20 | Leaf Blower Revolution | 多货币、多宠物、多 prestige | 持续开货币和系统 | 内容 churn 非常高 | 你的货币层偏薄 |
| 21 | Swarm Simulator | 繁殖、变异、ascend | mutagen、mutation tree | meta 和 build 紧耦合 | culture / process 可做成基因树 |
| 22 | Spaceplan | 点击、自动化、叙事展开 | 剧情推进 | 叙事增强推进感 | startup 题材应更有故事线 |
| 23 | Almost a Hero | 队伍推进、失败回流、meta 升级 | 失败也给 Mythstones | 卡关不等于白玩 | 失败也要产出 meta |
| 24 | Zombidle | 主动法术 + idle 增长 | 法术和 burst 是节奏打断器 | 主动技能打断单调 | 需要更多主动 burst 技能 |
| 25 | Crush Crush | 多目标并行推进 | 多角色目标奖励 | 并行任务强黏性 | 客户 / 投资人 / 团队关系并行化 |
| 26 | Bit City | 城市扩张可视化 | 新建筑、新区 | 视觉成长就是奖励 | 办公室成长要更明显 |
| 27 | Make It Rain | 强即时点击反馈 | 快速买升级 | 每秒都在涨 | 点击反馈要更爽 |
| 28 | LEGO Tower | 楼层增长、居民和收藏 | 新楼层就是 milestone | 目标清晰可视 | 办公室扩层非常适配 |
| 29 | Rusty's Retirement | 低打扰挂机与陪伴感 | 农田扩展和自动化 | 轻陪伴型回流 | 办公室可做后台陪伴感 |
| 30 | PokéClicker | 地区推进、图鉴收集、重刷 | 地区和图鉴目标 | 收集驱动长期回流 | 你缺收集型长期目标 |
| 31 | Shark Game | 多资源文明演化 | 新资源改变最优策略 | 结构变化大于数值增长 | 资源结构要更立体 |
| 32 | CivClicker | 人口、资源链、文明发展 | 阶段式发展 | 成长层次明确 | startup 到组织体制升级可借鉴 |
| 33 | Space Company | 多资源链、能源、太空扩张 | 新资源、新生产链 | 每开一种资源都很爽 | 多产品线 / 多区域经营 |
| 34 | Crank | 小系统持续展开 | 每个解锁都换重心 | reveal > UI 复杂度 | 早期展开速度要更快 |
| 35 | Clickpocalypse II | 自动队伍跑图 | loot、职业成长 | 观察系统自己跑有乐趣 | 团队执行项目要可视化 |
| 36 | Forge & Fortune | 队伍、战斗、锻造、idle | 装备线和角色线并行 | 双循环互推 | 工具栈 / 基建可成为副循环 |
| 37 | Godville | 全自动 + 文本日志 | 事件日志本身是内容 | 文案产生黏性 | 创业日报志可做成亮点 |
| 38 | GrindCraft | 资源、配方、配方树 | 新配方解锁 | “下一配方”持续勾人 | 流程 / SOP 可做成 tech tree |
| 39 | Wizard and Minion Idle | 法术树、minion、规划 build | 新法术改变节奏 | build 规划驱动 | 产品 / 增长 / 融资做成 skill tree |
| 40 | Anti-Idle: The Game | 模式非常多、内容极密 | 大量 side systems | 总有事可做 | 但要避免散乱，要回流主循环 |
| 41 | Sandcastle Builder | 超长期 meta、深层规则 | 多层资源和目标 | 长线发现感 | 后期系统深度可借鉴 |
| 42 | Cow Clicker | 极简、荒诞、社交 satirical | 签到式推进 | 社交和反讽记忆点 | 主题包装也能形成 hook |
| 43 | Idle Research | 研究树、重开、复杂连锁 | 新研究 = 新节奏 | 规划型玩家黏性高 | 你的 strategy layer 可以更深 |
| 44 | Idle Loops | 时间循环、自动脚本规划 | loop 优化即奖励 | 重复中找最优 | COO / automation scripts 很适合 |
| 45 | Orb of Creation | spellcraft、资源转化、发现 | 新法术开新生产方式 | 发现感强 | 新产品策略要改变规则 |
| 46 | Increlution | 时间分配、轮回、技能成长 | 下一轮保留经验 | 再来一轮更聪明 | prestige 应更像创业经验积累 |
| 47 | Melvor Idle | RuneScape 式技能并行挂机 | 新技能、装备、任务 | 长线养成与收集 | 并行部门线很适合 startup |
| 48 | Synergism | 多层 prestige、synergy build | 每一层都是新优化题 | 系统深度带来执着 | 后期 meta 可以更数学化 |
| 49 | The Gnorp Apologue | 视觉演出 + build 组合 | 每个新单位都改打法 | 观赏性和系统性兼得 | 办公室动画和 build 应同时加强 |
| 50 | Evolve Idle | 文明演化、多阶段路线 | 物种 / 路线差异、挑战 | 重玩价值高 | 不同公司 archetype 应明显区分 |

## 7. 从 50 款游戏里抽出来的高频规律

### 7.1 最容易上瘾的不是“大数字”，而是 4 件事同时成立

1. `短反馈`
- 10 到 30 秒就能做一个决定

2. `中反馈`
- 2 到 5 分钟能看到新按钮、新区域、新任务或新构筑件

3. `长反馈`
- 15 到 60 分钟进入一次“现在 prestige 还是再撑一下”的抉择

4. `离线反馈`
- 退出后还有合同、任务、离线结算、定时派遣、回来领奖

### 7.2 最常见的 hook 结构

- `确定性目标`
  - 再 20 秒我就能买这个
  - 再一局我就能 prestige
- `不确定性目标`
  - 下一次会不会刷到稀有事件 / 稀有掉落
- `永久成长`
  - 这次重开不白打
- `系统揭示`
  - 下一层到底会开什么新机制

### 7.3 让玩家停不下来的常见节奏

- `30 秒内`
  - 让玩家看到数字上涨和第一笔购买
- `3 分钟内`
  - 开第一个“能改变玩法”的系统
- `10 分钟内`
  - 让玩家知道这个游戏不只是点点点
- `20 到 40 分钟内`
  - 给第一次 prestige 或一次大型 milestone
- `离线回来时`
  - 不只是领钱，而是“公司发生了事”

## 8. 你现在这个游戏为什么会让人觉得单调

### 8.1 系统多，但玩家真实动作太单一

玩家大部分时候还是在:

1. 点击
2. 雇人
3. 等资源
4. 升产品或融资
5. 重复

这说明真正的 `决策密度` 还不够高。

### 8.2 里程碑多，但很多只是数值更大

现在最缺的是“到这一步后，玩家开始换一种玩法”的感觉。

例如优秀 idle 常见的 milestone 结果是:

- 新事件池
- 新资源线
- 新自动化权限
- 新限制挑战
- 新地图 / 新房间
- 新 reset 层

而不是单纯:

- `+cash`
- `+credits`
- `+speed`
- `+multiplier`

### 8.3 题材优势还没被充分用起来

你的题材不是 generic fantasy，不是 generic factory，而是 `创业公司成长`。

这意味着天然就适合做:

- 招聘速度 vs 文化质量
- 产品速度 vs 稳定性
- 病毒增长 vs 用户留存
- 融资效率 vs 控制权压力
- 大客户合同 vs 团队负荷
- 海外扩张 vs 本地口碑
- IPO / Acquired 后的新规则

现在这些张力还没有真正变成玩法。

## 9. 重新调研后的改进建议

### 9.1 第一优先级: 强化 milestone，让它开新玩法

建议把你的 milestone 设计成以下类型:

- `Team milestone`
  - 开部门自动化
  - 开 cross-functional project
  - 开团队危机 / 文化事件
- `Product milestone`
  - 开用户留存 / 差评 / feedback loop
  - 开 feature bets
  - 开 multi-product
- `Funding milestone`
  - 开董事会压力
  - 开 KPI 要求
  - 开 public market volatility
  - 开 parent-company directive

### 9.2 第二优先级: 把合同系统做成中期主循环

你已经有 `ContractType`，这是最值得立刻做强的一层。

建议每个合同具备:

- 时长
- 所需部门配置
- 成功率
- 风险
- 失败代价
- 稀有掉落
- 对后续事件池的影响

合同奖励不要只给 cash，应该混合给:

- 稀有 `Advisor`
- 稀有 `Playbook`
- 永久 `Reputation Cap`
- 新客户类型
- 特殊办公室装饰
- 新挑战 token

### 9.3 第三优先级: 让事件有后果

你现在的事件方向是对的，但需要从 `瞬时收益按钮` 升级为 `中期状态修改器`。

建议事件同时影响:

- 当前收益
- 未来 1 到 3 分钟的状态
- 客户信任
- 团队士气
- 后续事件权重
- 合同成功率

例子:

- `Viral Moment`
  - 冲增长:
    - 立刻涨 traction
    - 但未来 2 分钟 churn 和 support pressure 上升
  - 稳接住:
    - 立刻收益较少
    - 但后续合同成功率、用户信任更高

### 9.4 第四优先级: 把 Playbooks / Advisors 变成 build 系统

你现在已经有 `PlaybookId` 和 `AdvisorId`，这非常好，但它们还更像 multiplier。

建议改成:

- `run-defining modifiers`
- 组合生效
- 套装效果
- 互斥选择
- challenge 专属掉落

可发展的方向:

- `Growth Script`
  - 让 viral / partnership 更强
  - 但品牌波动更大
- `Enterprise Deck`
  - 让大客户合同更强
  - 但产品节奏变慢
- `People Ops Manual`
  - 让招聘、士气、离线更稳
  - 但爆发收益较弱

### 9.5 第五优先级: 让 prestige 成为“身份变化”

优秀 idle 的 prestige 不只是效率更高，而是角色身份变化。

你最适合的 prestige 包装应该是:

1. `Exit`
- IPO / Acquired / Shut Down

2. `Founder Legacy`
- 保留 founder reputation、legacy tokens、portfolio points

3. `New Company`
- 下一局不是“同一家公司重来”
- 而是新的 founder origin、新路线、新资源偏好、新挑战

这样才更像 serial founder fantasy。

## 10. 怎么让用户更容易上瘾

这里不讲付费设计，只讲 retention / hook。

### 10.1 短期 hook

每 20 到 40 秒至少给玩家一个决定:

- 雇谁
- 升哪个部门
- 接哪个合同
- 赌哪个事件分支
- 给哪条路线投入 token

### 10.2 中期 hook

每 3 到 5 分钟出现一个“感知明确的新东西”:

- 新房间
- 新客户类型
- 新卡
- 新事件
- 新 challenge

### 10.3 长期 hook

每 20 到 45 分钟制造一次：

`现在 prestige 还是再撑一下`

这是 idle game 最经典、最有效的纠结点之一。

### 10.4 离线回流 hook

回来时不要只弹“你赚了多少”。

应该弹:

- 哪个合同完成了
- 哪个部门出了问题
- 哪个客户升级了
- 哪个顾问给了新机会
- 哪条新闻改变了市场环境

玩家看到的是“公司活着”，不是“数字涨了”。

## 11. 你现在还缺什么

这是基于当前代码骨架，我认为最缺的 8 个要素。

1. `有后果的选择`
- 现在很多选择收益有了，但代价不够明显

2. `更强的中期主循环`
- contract 还没成为必玩核心

3. `更深的收集系统`
- playbooks / advisors 可以再往卡组化发展

4. `更强的主题化风险`
- 董事会、裁员、技术债、品牌危机、增长泡沫

5. `更明确的 build identity`
- Product-led、Growth-led、Finance-led、Ops-led 还不够分化

6. `更好的视觉兑现`
- 办公室空间、楼层、Logo 墙、会议室、董事会、海外分部

7. `更像故事的离线结算`
- 不是单一收益总结，而是公司日报

8. `更深的 prestige 后身份变化`
- 下一轮应该更不同

## 12. 推荐的版本路线

### v1.1

- 重做 team / product / funding milestone 奖励
- 把 contracts 做成中期主循环
- 给 events 增加持续后果

### v1.2

- 扩展 playbooks / advisors 为更完整的 build / collection 系统
- 增加 challenge 专属奖励
- 增加办公室视觉成长

### v1.3

- 做第二层 prestige
- 做 portfolio meta
- 做多公司 / 多市场 / 多产品线

## 13. 最终 recommendation

如果只给一套最实用、最不容易做偏的建议，我推荐你这样改:

1. 先把 `Contracts` 做强
- 这是你题材最自然、也是最容易产生回流的系统

2. 再把 `Events` 做成有后果的系统
- 让玩家对选择有情绪和记忆点

3. 然后把 `Playbooks / Advisors` 做成 build
- 让不同 run 的玩法不同

4. 最后把 `Prestige` 做成 founder journey
- 让玩家玩的不只是同一家公司，而是一连串创业人生

如果只允许你优先做一个组合包，那就做:

> `Contracts + Consequence-based Events + Build-style Playbooks`

这三件事最容易把你现在的游戏从“可以跑”变成“会让人回来继续跑”。

## 14. Sources

以下来源用于这次重新调研。

### 类型与机制综述

- [GDC Vault: Idle Games: The Mechanics and Monetization of Self-Playing Games](https://www.gdcvault.com/play/1022065/Idle-Games-The-Mechanics-and)
- [Kongregate: The Math of Idle Games, Part I](https://blog.kongregate.com/the-math-of-idle-games-part-i/)
- [Kongregate: The Math of Idle Games, Part II](https://blog.kongregate.com/the-math-of-idle-games-part-ii/)
- [Wikipedia: Incremental game](https://en.wikipedia.org/wiki/Incremental_game)

### 社区样本池

- [r/incremental_games Wiki: Ultimate List of Incremental Games](https://www.reddit.com/r/incremental_games/wiki/list_of_incremental_games/)
- [IncrementalDB](https://www.incrementaldb.com/)
- [Steam: Idler Tag](https://store.steampowered.com/tags/en/Idler/)

### 学术 / 研究参考

- [Playing to Wait: A Taxonomy of Idle Games](https://dl.acm.org/doi/10.1145/3173574.3174195)
- [The Pleasure of Playing Less: A Study of Incremental Games Through the Lens of Kittens](https://kilthub.cmu.edu/articles/book/The_Pleasure_of_Playing_Less_A_Study_of_Incremental_Games_Through_the_Lens_of_Kittens/6686957)

### 代表作品官方 / wiki / store 页面

- [Cookie Clicker Wiki](https://cookieclicker.wiki.gg/wiki/Cookie_Clicker_Wiki)
- [Clicker Heroes Wiki](https://clickerheroes.fandom.com/wiki/Clicker_Heroes_Wiki)
- [Realm Grinder Wiki](https://realm-grinder.fandom.com/wiki/Realm_Grinder_Wiki)
- [Antimatter Dimensions Guide](https://antimatter-dimensions.fandom.com/wiki/Guide)
- [Kittens Game Wiki](https://kittensgame.fandom.com/wiki/Kittens_Game_Wiki)
- [Trimps](https://trimps.github.io/)
- [Universal Paperclips](https://www.decisionproblem.com/paperclips/index2.html)
- [A Dark Room](https://adarkroom.doublespeakgames.com/)
- [AdVenture Capitalist Wiki](https://adventure-capitalist.fandom.com/wiki/AdVenture_Capitalist_Wiki)
- [AdVenture Communist Wiki](https://adventurecommunist.fandom.com/wiki/AdVenture_Communist_Wiki)
- [Egg, Inc. Wiki](https://egg-inc.fandom.com/wiki/Egg,_Inc._Wiki)
- [Cell to Singularity](https://www.celltosingularity.com/)
- [Idle Champions](https://store.steampowered.com/app/627690/Idle_Champions_of_the_Forgotten_Realms/)
- [Idle Slayer Wiki](https://idleslayer.fandom.com/wiki/Idle_Slayer_Wiki)
- [NGU IDLE](https://store.steampowered.com/app/1147690/NGU_IDLE/)
- [Mr.Mine](https://store.steampowered.com/app/1397920/MrMine/)
- [Leaf Blower Revolution](https://store.steampowered.com/app/1468260/Leaf_Blower_Revolution__Idle_Game/)
- [Rusty's Retirement](https://store.steampowered.com/app/2666510/Rustys_Retirement/)
- [PokéClicker Wiki](https://wiki.pokeclicker.com/)
