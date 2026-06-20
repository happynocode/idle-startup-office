# Idle Game Shared System Plan

Version: 0.1  
Language: 中文为主 / English terms retained where useful  
Target stack: Flutter + Flame  
Target platforms: Android, iOS  
Project scope: 系列化 Idle Game 母版，首作 Startup Office

---

## 1. Document Purpose

This document is the shared master plan for a series of Idle Game products. It defines the reusable product frame, technical architecture, content system, economy system, and production workflow.

The first game in the series is **Startup Office Idle Game**.

Future titles should reuse the same:

- technical framework
- save system
- achievement system
- quest system
- ads system
- IAP system
- data table structure
- codebase

Only these parts should change per title:

- themed art assets
- UI skins
- content config
- economy tuning
- formula tuning

---

## 2. Product Vision

### 2.1 Series Vision

Build a long-lived Idle Game production system that can support 10, 20, or 30 themed games without rewriting the core game.

The series should behave like a content pipeline, not a one-off project.

### 2.2 First Game Vision

Startup Office is a tycoon + idle management game where the player grows a startup from a tiny MVP team into a unicorn.

Player fantasy:

- build the company from nothing
- hire people and automate work
- ship products
- raise funding
- increase valuation
- reach IPO
- get acquired
- prestige / rebirth

### 2.3 Genre Positioning

- Primary: Idle / Incremental / Tycoon
- Secondary: Light simulation management
- Visual style: pixel art or simplified 2D illustration
- Platform fit: mobile-first

---

## 3. Product Requirements Document

### 3.1 Core User Goals

1. Grow company valuation continuously.
2. Turn MVP into a scalable product.
3. Raise capital through funding stages.
4. Unlock automation through hiring and office expansion.
5. Reach prestige layers and restart with long-term bonuses.

### 3.2 Player Experience Goals

- easy to understand in under 1 minute
- rewarding every 5 to 30 seconds
- clear long-term progression
- satisfying visible growth
- frequent milestone feedback

### 3.3 Game Loop

#### Short Loop

Tap / wait / collect revenue / upgrade team or systems.

#### Mid Loop

Hire staff, expand office, improve product quality, increase company valuation.

#### Long Loop

Raise funding, scale operations, hit IPO, get acquired, prestige, restart stronger.

### 3.4 Primary Systems

- Revenue generation
- Employee hiring
- Office expansion
- Product development
- Funding rounds
- Valuation system
- Prestige / rebirth
- Offline earnings
- Tasks / quests
- Achievements
- Monetization

### 3.5 MVP Scope

The first playable version must include:

- startup office theme
- core idle earning
- manual tap income
- automated income
- employee system
- office upgrade system
- product progression
- funding progression
- valuation growth
- prestige / rebirth
- offline earnings
- tasks
- achievements
- save/load
- settings
- rewarded ad placeholders
- IAP placeholders
- Android/iOS simulator runnable

### 3.6 Non-Goals for MVP

Not required in the first release:

- multiplayer
- live ops backend
- social guilds
- PvP
- open world
- complex 3D scene

---

## 4. Game Design: Startup Office

### 4.1 Thematic Pillars

- Build a startup culture
- Turn chaos into systems
- Grow from bootstrapped chaos to unicorn scale
- Balance speed, quality, hiring, and funding

### 4.2 Main Resources

- Cash
- Product Progress
- Company Valuation
- Reputation
- Talent
- Funding
- Prestige Points

### 4.3 Main Buildings / Areas

- Desk Area
- Dev Team
- Meeting Room
- Sales Team
- Marketing Team
- Server Room
- HR / Recruiting
- Executive Office

### 4.4 Main Roles

- Founder
- Developer
- Designer
- Sales
- Marketer
- Recruiter
- Ops
- Investor

### 4.5 Progression Stages

1. MVP stage
2. Product-market fit stage
3. Growth stage
4. Scaling stage
5. Funding stage
6. IPO stage
7. Acquisition stage
8. Prestige restart

---

## 5. Meta Loop

### 5.1 Core Meta

The game uses a layered progression system:

- immediate income from tapping / automation
- mid-term upgrades for efficiency
- long-term milestones for funding and valuation
- meta prestige for permanent growth

### 5.2 Prestige Design

Prestige resets the current run but grants permanent bonuses.

Suggested prestige currency: **Prestige Points**.

Prestige rewards can boost:

- income multiplier
- hiring efficiency
- offline earnings
- valuation growth
- automation speed

### 5.3 Reset Philosophy

The game should feel like:

- resetting is a power move
- each new run is faster and deeper
- new layers unlock after prestige

---

## 6. Economy Design

### 6.1 Economy Principles

- easy first 10 minutes
- visible exponential growth
- controlled inflation
- prestige soft-resets economic pressure
- each stage should open a new scaling layer

### 6.2 Currency Stack

Recommended currencies:

- `Cash`: primary spend currency
- `Reputation`: unlocks hiring / product / market upgrades
- `Valuation`: progression metric
- `Funding`: unlocks milestones and strategic boosts
- `Prestige Points`: permanent meta currency

### 6.3 Economy Targets

- early progression: upgrade every 10 to 30 seconds
- mid progression: milestone every 2 to 5 minutes
- late progression: major unlock every 10 to 20 minutes
- prestige cycle: 15 to 45 minutes for first version

### 6.4 Upgrade Categories

- Tap income
- Auto income
- Employee output
- Team capacity
- Product quality
- Office capacity
- Funding efficiency
- Offline earnings
- Prestige multiplier

### 6.5 Sample Formula Philosophy

Use simple, readable formulas.

Example formulas:

```text
cost = baseCost * growthRate ^ level
output = baseOutput * (1 + bonusSum) * prestigeMultiplier
valuation = revenuePower * productQuality * marketMultiplier
offlineEarnings = min(cap, earningsPerHour * hoursAway)
```

The exact numbers can be tuned later.

---

## 7. Numeric Design

### 7.1 Design Goals

- early game feels active
- mid game shifts toward automation
- late game becomes management + optimization
- prestige should never feel wasted

### 7.2 Suggested Growth Curve

Use a layered exponential model with soft gates:

- linear-ish tutorial start
- low exponent early upgrades
- stronger exponent in late game
- prestige multiplier keeps long-term pacing stable

### 7.3 Tuning Levers

- base income
- base cost
- cost growth rate
- employee output
- product efficiency
- office unlock thresholds
- funding milestones
- prestige bonus gain

### 7.4 Balancing Rules

- avoid dead zones where no upgrade is affordable
- avoid runaway numbers too early
- keep one obvious next goal visible
- preserve a sense of momentum

### 7.5 First-Pass Startup Office Numbers

These values are intentionally simple. They are starter values for implementation and tuning.

| System | Value | Notes |
| --- | ---: | --- |
| Starting cash | 0 | Player starts from zero |
| Tap income | 1 cash | Founder does manual work |
| Base developer output | 0.5 cash/sec | First automation source |
| Developer base cost | 25 cash | Affordable within first minute |
| Developer cost growth | 1.15x | Smooth early curve |
| Office upgrade base cost | 100 cash | Unlocks capacity |
| Product milestone interval | 100 progress | MVP to launch pacing |
| Offline earning cap | 2 hours | Can expand later |
| First prestige target | 1M valuation | MVP target |

---

## 8. System Design

### 8.1 Game Systems

#### Idle Earning

Automatic income over time.

#### Tap Income

Player tapping gives small early-game acceleration.

#### Employee System

Employees produce output, can be upgraded, and unlock synergies.

#### Office System

Office expansion increases capacity and unlocks new work areas.

#### Product System

Products move through stages:

- idea
- prototype
- MVP
- beta
- launch
- growth
- scale

#### Funding System

Represents startup fundraising progression.

Suggested stages:

- pre-seed
- seed
- series A
- series B
- series C
- IPO
- acquisition

#### Valuation System

The headline success metric.

#### Quest System

Short tasks and long goals to guide play.

#### Achievement System

Permanent unlock goals for progression and retention.

#### Offline Progress

Simulate income while the app is closed.

#### Prestige System

Reset with permanent meta growth.

### 8.2 Content State Model

Each game title should be data-driven with:

- theme config
- buildings
- staff roles
- products
- upgrade tables
- quest tables
- achievement tables
- monetization placement config
- localization strings

---

## 9. Technical Architecture

### 9.1 Stack Choice

Use **Flutter + Flame**.

Reason:

- one codebase for Android and iOS
- beginner-friendly
- good for 2D UI-heavy games
- easier to iterate on mobile-first idle UX
- data-driven content setup is straightforward

### 9.2 Project Structure

Suggested modules:

```text
lib/
  main.dart
  app/
  game/
  ui/
  data/
  economy/
  progression/
  save/
  monetization/
  analytics/
  localization/
assets/
  config/
  images/
  audio/
test/
```

### 9.3 Rendering Approach

Use Flame for the game layer and Flutter for UI overlays, menus, dialogs, and settings.

### 9.4 State Management

Use a simple, stable approach:

- game state model
- repository layer for persistence
- config-driven content loading
- UI bound to reactive state

### 9.5 Save System

Save should include:

- player currencies
- unlocked content
- upgrade levels
- prestige state
- task state
- achievement state
- last active timestamp
- monetization flags
- schema version

### 9.6 Offline Simulation

On app launch:

1. read last exit timestamp
2. calculate elapsed time
3. apply offline earnings
4. clamp by offline cap
5. show summary to player

### 9.7 Content Delivery Strategy

For a series of games, the core code should read theme-specific config files:

- JSON for runtime config
- CSV for design iteration if needed

Recommended default: JSON first, because it is simple to bundle and parse in Flutter.

### 9.8 Cross-Game Reuse Model

The reusable core must support:

- swapping theme config
- swapping art assets
- swapping text localization
- swapping formula tables
- swapping unlock progression

---

## 10. Code Reuse Strategy for 10+ Games

### 10.1 Shared Core Package

Build one shared package that contains:

- economy engine
- progression engine
- save/load
- quest/achievement logic
- ad/IAP integration points
- localization hooks
- formula evaluation helpers

### 10.2 Game-Specific Layer

Each title only provides:

- theme assets
- game-specific config tables
- unique text
- unique formulas if needed
- UI skin

### 10.3 Versioning Rules

Core changes must be backward compatible whenever possible.

When breaking changes are unavoidable:

- bump schema version
- add migration layer
- preserve save compatibility

### 10.4 Content Authoring Rules

All tunable values must live outside code where practical.

Examples:

- upgrade costs
- outputs
- unlock thresholds
- reward amounts
- quest goals

---

## 11. Monetization Design

### 11.1 Monetization Goals

- support long-term live service economics
- keep free-to-play fair
- monetize convenience, acceleration, and optional value

### 11.2 Ad Model

Use rewarded / incentive ads only.

Suggested placements:

- double offline earnings
- instant cash boost
- speed up a build timer
- bonus chest

### 11.3 IAP Model

Use simple mobile-friendly IAP:

- remove ads
- starter pack
- currency pack
- permanent booster pack

### 11.4 Monetization Rules

- never block core gameplay behind payment
- always offer a free path
- reward ads should feel optional and useful
- IAP should accelerate, not replace play

### 11.5 Placeholder Integration

For now, implement interfaces and UI entry points.

Real store keys, ad unit IDs, and release metadata can be inserted later.

---

## 12. UX / UI Plan

### 12.1 Screen List

- Home / Main Office
- Upgrade Panel
- Employee Panel
- Product Panel
- Funding Panel
- Prestige Panel
- Quests Panel
- Achievements Panel
- Shop Panel
- Settings Panel

### 12.2 UI Principles

- mobile-first
- readable at small sizes
- fast access to next action
- minimal friction
- strong milestone feedback

### 12.3 Visual Style

Preferred:

- pixel art
- simplified 2D illustration

UI should remain clean, warm, and slightly playful.

---

## 13. Content Pipeline

### 13.1 Authoring Flow

1. Define theme.
2. Fill config tables.
3. Add art assets.
4. Set formulas and balance values.
5. Run simulator.
6. Tune pacing.

### 13.2 Build Flow

- edit config
- hot reload if possible
- test progression
- verify save/load
- verify offline earnings
- verify prestige reset
- verify monetization entry points

---

## 14. Analytics and Live Ops

### 14.1 Required Events

- tutorial start/complete
- first upgrade
- first hire
- funding raised
- prestige triggered
- ad watched
- IAP purchased
- session start/end

### 14.2 Future Live Ops Hooks

- seasonal quest sets
- limited-time boosts
- event config swap
- economy hotfix support

---

## 15. Localization Plan

Support localization from the beginning.

Minimum:

- Chinese
- English

All user-facing strings should live outside code.

---

## 16. Testing Plan

### 16.1 Functional Testing

Verify:

- app launches
- save/load works
- offline earnings work
- prestige resets correctly
- quest and achievement unlocks work
- ad and IAP placeholders open correctly

### 16.2 Simulator Acceptance Criteria

The game is not finished until:

- Android simulator can run end-to-end
- iOS simulator can run end-to-end
- a full gameplay loop is playable
- at least one prestige cycle is reachable
- no blocking crash exists in the core path

### 16.3 Regression Targets

Each new series title must not break:

- shared save schema
- shared core economy
- shared task/achievement framework
- shared monetization flow

---

## 17. Development Milestones

### Phase 0: Foundation

- create Flutter project
- integrate Flame
- define shared data models
- create save system
- create config loader
- create basic UI shell

### Phase 1: Core Loop

- tap income
- auto income
- upgrade system
- employee system
- office system
- offline earnings

### Phase 2: Meta Systems

- product progression
- funding progression
- valuation model
- tasks
- achievements
- prestige

### Phase 3: Monetization

- rewarded ad hooks
- IAP hooks
- shop UI

### Phase 4: Polish

- pixel/simplified art pass
- UI refinement
- sound hooks
- balancing
- simulator QA

---

## 18. Manual Work Needed Later

The following items can be left for human input later:

- store account credentials
- ad network IDs
- IAP product IDs
- app icons
- screenshots
- final art assets
- final localization copy
- legal text / privacy policy

---

## 19. Open Questions

These should be finalized before production lock:

- exact art direction: pixel art vs simplified illustration
- exact prestige reward formula
- exact funding/IPO/acquisition pacing
- exact first-session tutorial length
- exact monetization pricing

---

## 20. Success Definition

This project is successful when:

- the shared framework can spawn multiple Idle Game titles
- Startup Office can run on Android and iOS simulators
- the full loop is playable end-to-end
- the first prestige cycle works
- the core code can be reused for future series titles with only content swaps

---

## 21. Implemented MVP Scope Update

This section records the current implemented MVP after the first playable build.

### 21.1 Implemented Art Direction

The first playable version now uses generated pixel-art office artwork as the main office stage.

Generated art assets:

- `assets/art_direction/startup_office_art_direction_v1_pixel.png`
- `assets/art_direction/startup_office_art_direction_v2_2d.png`
- `assets/art_direction/startup_office_art_direction_v3_dashboard.png`
- `assets/images/startup_office_pixel_stage.png`

Selected runtime direction:

- V1 Pixel / isometric startup office

### 21.2 Implemented Team Roles

The recruitment system is no longer limited to a few generic roles. It now supports a broader startup org chart with department-specific output.

Implemented roles:

- Intern
- Junior Developer
- UX Designer
- Growth Marketer
- Community Manager
- Sales Rep
- Product Manager
- QA Analyst
- Recruiter
- DevOps Engineer
- Data Analyst
- Customer Success
- Account Executive
- Finance Ops
- Senior Engineer
- Chief of Staff

Each role can affect some combination of:

- cash per second
- product progress per second
- reputation per second
- credits per second

Roles can also have unlock requirements based on:

- office level
- product stage

### 21.3 Implemented Credits System

The MVP now includes `Credits` as a startup operations currency.

Credits can be earned from:

- selected roles
- founder tapping
- product milestones
- funding rounds
- quests
- achievements
- rewarded ad placeholder boosts
- starter pack placeholder

Credits are spent on startup operating systems.

### 21.4 Implemented Startup Operating Systems

The Ops tab contains reusable startup-system upgrades that make the game feel closer to a real startup operating model.

Implemented systems:

- Founder Dashboard
- Recruiting Pipeline
- Agile Rituals
- Design System
- Analytics Stack
- Sales Playbook
- Customer Feedback Loop
- Cloud Scaling
- Investor Relations
- Security Review
- Automation Lab
- Board Operating System

These systems can improve:

- cash output
- product progress
- reputation
- credits generation
- valuation multiplier

### 21.5 Implemented Quest and Achievement Direction

The current quest and achievement design now covers:

- first founder action
- first hire
- engineering team growth
- go-to-market team growth
- operations/data/finance team growth
- credits milestones
- startup systems milestones
- MVP and product launch progress
- Seed, Series B, IPO funding milestones
- first prestige / serial founder progression

### 21.6 Current Verification Evidence

Current local verification artifacts:

- Android QA screenshot: `output/qa/android_complex_team_final.png`
- Android Ops screenshot: `output/qa/android_complex_ops.png`
- iOS QA screenshot: `output/qa/ios_complex_latest.jpg`

Current verification commands used during development:

```text
flutter test
flutter analyze
flutter run -d emulator-5554 --no-resident
xcodebuildmcp build_run_sim
```

