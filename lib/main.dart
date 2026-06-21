import 'dart:async' as async;
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const StartupOfficeApp());
}

class StartupOfficeApp extends StatelessWidget {
  const StartupOfficeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Office Idle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff1f8f72),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xfff5efe1),
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'monospace',
          bodyColor: const Color(0xff1f2328),
          displayColor: const Color(0xff1f2328),
        ),
      ),
      home: const StartupOfficeHome(),
    );
  }
}

class StartupOfficeHome extends StatefulWidget {
  const StartupOfficeHome({super.key});

  @override
  State<StartupOfficeHome> createState() => _StartupOfficeHomeState();
}

class _StartupOfficeHomeState extends State<StartupOfficeHome> {
  late final GameController controller;
  late final StartupOfficeFlameGame flameGame;
  var selectedTab = OfficeTab.upgrades;

  @override
  void initState() {
    super.initState();
    controller = GameController();
    flameGame = StartupOfficeFlameGame(controller);
    controller.loadAndStart();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 860;
                final office = _OfficeStage(
                  controller: controller,
                  game: flameGame,
                );
                final side = _ControlPanel(
                  controller: controller,
                  selectedTab: selectedTab,
                  onTabChanged: (tab) => setState(() => selectedTab = tab),
                );

                if (wide) {
                  return Row(
                    children: [
                      Expanded(flex: 6, child: office),
                      SizedBox(width: 390, child: side),
                    ],
                  );
                }

                return Column(
                  children: [
                    Expanded(flex: 5, child: office),
                    Expanded(flex: 6, child: side),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

enum OfficeTab {
  upgrades('Upgrade'),
  team('Team'),
  ops('Ops'),
  product('Product'),
  funding('Funding'),
  events('Events'),
  advisors('Advisors'),
  challenges('Challenges'),
  expansion('Expansion'),
  prestige('Prestige'),
  quests('Quests'),
  shop('Shop'),
  settings('Settings');

  const OfficeTab(this.label);
  final String label;
}

enum CompanyFocus {
  balanced('Balanced'),
  product('Product-led'),
  growth('Growth-led'),
  finance('Finance-led');

  const CompanyFocus(this.label);
  final String label;
}

enum StartupEventType {
  viralMoment(
    'Viral Moment',
    'A founder clip is spreading. Cash spikes for a short run.',
    Icons.rocket,
  ),
  investorCall(
    'Investor Call',
    'A warm intro turns into serious interest and board-side buzz.',
    Icons.call,
  ),
  recruitingRush(
    'Talent Surge',
    'A great hiring window opens. Product speed jumps and hiring gets cheaper.',
    Icons.groups,
  );

  const StartupEventType(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum AdvisorId {
  productSage(
    'Product Sage',
    'Adds shipping rhythm and cleaner roadmap output.',
    Icons.lightbulb,
  ),
  growthHacker(
    'Growth Hacker',
    'Turns traction into faster compounding loops.',
    Icons.trending_up,
  ),
  financeChief(
    'Finance Chief',
    'Makes every funding move more efficient.',
    Icons.account_balance_wallet,
  ),
  operatorCoach(
    'Operator Coach',
    'Improves process, contracts, and expansion throughput.',
    Icons.support_agent,
  );

  const AdvisorId(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum ChallengeId {
  bootstrappedRun('Bootstrapped Run', 'Reach Launch without raising funding.'),
  leanTeamRun(
    'Lean Team Run',
    'Reach 300K valuation with 8 team members or fewer.',
  ),
  hypergrowthRun(
    'Hypergrowth Run',
    'Push traction to 80 while keeping reputation above 120.',
  ),
  remoteOnlyRun(
    'Remote Only Run',
    'Reach Growth while keeping office expansion at Lv.3 or below.',
  );

  const ChallengeId(this.label, this.description);
  final String label;
  final String description;
}

enum FounderSpecialization {
  builder(
    'Builder',
    'Starts runs with faster shipping and a small product head start.',
    Icons.architecture,
  ),
  operator(
    'Operator',
    'Boosts credits, offline leverage, and operational stability.',
    Icons.settings_suggest,
  ),
  rainmaker(
    'Rainmaker',
    'Starts runs with more cash and easier fundraising pressure.',
    Icons.auto_graph,
  );

  const FounderSpecialization(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum FounderOrigin {
  builderLab(
    'Builder Lab',
    'Start with stronger product momentum and a cleaner shipping ramp.',
    Icons.construction,
  ),
  operatorGuild(
    'Operator Guild',
    'Open with extra credits, morale, and a more stable org shell.',
    Icons.precision_manufacturing,
  ),
  growthStudio(
    'Growth Studio',
    'Begin with traction, trust pressure, and a faster distribution curve.',
    Icons.auto_graph,
  ),
  financeDesk(
    'Finance Desk',
    'Start with more cash and a cheaper road to the next round.',
    Icons.account_balance_wallet,
  );

  const FounderOrigin(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum MarketPulseType {
  bullRun(
    'Bull Run',
    'Public market enthusiasm boosts valuation and funding optics.',
    Icons.trending_up,
  ),
  correction(
    'Correction',
    'Markets punish hype and force a more disciplined company shape.',
    Icons.trending_down,
  ),
  activistPressure(
    'Activist Pressure',
    'Public shareholders demand efficiency and visible control.',
    Icons.campaign,
  );

  const MarketPulseType(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum ParentDirectiveType {
  crossSell(
    'Cross-sell Push',
    'The parent company wants revenue synergies and aggressive distribution.',
    Icons.add_business,
  ),
  earnOutLock(
    'Earn-out Lock',
    'Compensation is tied to milestones, pushing short-term execution pressure.',
    Icons.lock_clock,
  ),
  integrationAudit(
    'Integration Audit',
    'Process, finance, and quality controls get much tighter.',
    Icons.fact_check,
  );

  const ParentDirectiveType(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum VentureMoveType {
  scoutNetwork(
    'Scout Network',
    'Use founder reputation to surface better advisor and playbook leads.',
    Icons.travel_explore,
  ),
  studioSpinout(
    'Studio Spinout',
    'Turn portfolio companies into launch capital and product momentum.',
    Icons.apartment,
  ),
  syndicateAccess(
    'Syndicate Access',
    'Convert network strength into stronger funding optics and expansion insight.',
    Icons.hub,
  );

  const VentureMoveType(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum SeasonEventType {
  builderSummit(
    'Builder Summit',
    'Shipping and product systems surge for this season.',
    Icons.rocket_launch,
  ),
  growthGames(
    'Growth Games',
    'Traction loops and events run hotter this season.',
    Icons.local_fire_department,
  ),
  capitalWeek(
    'Capital Week',
    'Funding optics and portfolio leverage intensify this season.',
    Icons.attach_money,
  );

  const SeasonEventType(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum ProductStrategy {
  craft(
    'Craft Excellence',
    'Better shipping, stronger product rewards, slower hype.',
    Icons.handyman,
  ),
  growthLoops(
    'Growth Loops',
    'More traction and stronger viral outcomes.',
    Icons.all_inclusive,
  ),
  enterprise(
    'Enterprise Stack',
    'Better valuation and capital efficiency.',
    Icons.apartment,
  );

  const ProductStrategy(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum CapitalPolicy {
  blitzscaling(
    'Blitzscaling',
    'Raise bigger rounds and push harder on awareness.',
    Icons.rocket,
  ),
  efficientGrowth(
    'Efficient Growth',
    'Lower funding pressure and better steady-state output.',
    Icons.savings,
  ),
  talentFirst(
    'Talent First',
    'Turn capital into team speed and credits.',
    Icons.groups,
  );

  const CapitalPolicy(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum ContractType {
  startupPilot(
    'Startup Pilot',
    'A fast pilot with an early adopter team. Great for building trust and basic revenue.',
    Icons.rocket_launch,
    1,
    0,
    0,
    35,
    40,
    35,
    0,
    450,
    24,
  ),
  talentBrandSprint(
    'Talent Brand Sprint',
    'Run a recruiting and culture campaign to improve morale, trust, and hiring momentum.',
    Icons.campaign,
    2,
    0,
    0,
    45,
    38,
    32,
    12,
    320,
    42,
  ),
  smbRollout(
    'SMB Rollout',
    'Launch a repeatable small-business rollout that pays back in cash and reputation.',
    Icons.storefront,
    2,
    1,
    0,
    55,
    50,
    42,
    16,
    760,
    45,
  ),
  channelPartnership(
    'Channel Partnership',
    'Trade margin for reach. Better traction, better valuation, and a chance at growth playbooks.',
    Icons.handshake,
    4,
    1,
    1,
    65,
    52,
    48,
    22,
    1200,
    52,
  ),
  enterpriseRollout(
    'Enterprise Rollout',
    'A heavier implementation with larger upside if your product and process are stable.',
    Icons.apartment,
    4,
    2,
    1,
    78,
    58,
    60,
    28,
    2200,
    72,
  ),
  governmentTender(
    'Government Tender',
    'Slow, bureaucratic, but massive. Requires a mature company and strong trust.',
    Icons.account_balance,
    5,
    3,
    2,
    92,
    64,
    72,
    38,
    3800,
    95,
  );

  const ContractType(
    this.label,
    this.description,
    this.icon,
    this.requiredProductStage,
    this.requiredFundingStage,
    this.requiredExpansionLevel,
    this.durationSeconds,
    this.requiredTrust,
    this.requiredMorale,
    this.baseInsightCost,
    this.baseCashReward,
    this.baseCreditReward,
  );

  final String label;
  final String description;
  final IconData icon;
  final int requiredProductStage;
  final int requiredFundingStage;
  final int requiredExpansionLevel;
  final int durationSeconds;
  final double requiredTrust;
  final double requiredMorale;
  final double baseInsightCost;
  final double baseCashReward;
  final double baseCreditReward;
}

enum PlaybookId {
  growthScript(
    'Growth Script',
    'Turns channel wins into stronger traction and event payouts.',
    Icons.auto_graph,
  ),
  peopleOpsManual(
    'People Ops Manual',
    'Raises morale floor and makes recruiting bursts less chaotic.',
    Icons.groups,
  ),
  enterpriseDeck(
    'Enterprise Deck',
    'Improves contract cash and valuation on bigger deals.',
    Icons.picture_as_pdf,
  );

  const PlaybookId(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum VentureThesis {
  productStudio(
    'Product Studio',
    'Adds stronger shipping, trust retention, and product-matrix upside.',
    Icons.dashboard_customize,
  ),
  distributionMachine(
    'Distribution Machine',
    'Adds hotter event loops, riskier contracts, and bigger traction spikes.',
    Icons.campaign,
  ),
  capitalEngine(
    'Capital Engine',
    'Adds safer recovery, stronger funding optics, and better late-run exits.',
    Icons.account_balance,
  );

  const VentureThesis(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum FounderTrophyId {
  flowState(
    'Flow State',
    'Trigger founder flow for the first time.',
    Icons.bolt,
  ),
  dealCloser(
    'Deal Closer',
    'Reach a 3x deal chain in one run.',
    Icons.handshake,
  ),
  bellRinger(
    'Bell Ringer',
    'Reach IPO and prove the company can go public.',
    Icons.notifications_active,
  ),
  comebackKid(
    'Comeback Kid',
    'Return after a long break and cash in the re-entry surge.',
    Icons.refresh,
  ),
  playbookCollector(
    'Playbook Collector',
    'Unlock every playbook in the shelf.',
    Icons.collections_bookmark,
  );

  const FounderTrophyId(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum CrisisResponseType {
  prRepair(
    'PR Repair',
    'Spend cash to restore trust and calm the public story.',
    Icons.campaign,
  ),
  rescueFinancing(
    'Rescue Financing',
    'Trade valuation quality for liquidity and lower crisis pressure.',
    Icons.health_and_safety,
  ),
  teamReset(
    'Team Reset',
    'Stabilize morale and process, but slow momentum for a moment.',
    Icons.favorite,
  );

  const CrisisResponseType(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum PortfolioTrack {
  talentBench(
    'Talent Bench',
    'Permanent team slot growth and stronger morale at the start of every company.',
    Icons.groups_2,
  ),
  brandNetwork(
    'Brand Network',
    'Permanent trust, better event recovery, and a stronger contract floor.',
    Icons.public,
  ),
  ventureFund(
    'Venture Fund',
    'Bigger starting cash and stronger valuation from serious exits.',
    Icons.account_balance_wallet,
  );

  const PortfolioTrack(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum FeatureBetType {
  onboarding(
    'Onboarding Revamp',
    'Invest product time into activation and retention. Better trust and contract readiness.',
    Icons.login,
  ),
  collaborationSuite(
    'Collaboration Suite',
    'Ship a bigger product layer that increases product and valuation output.',
    Icons.hub,
  ),
  aiCopilot(
    'AI Copilot',
    'Trade team focus for a burst of traction and enterprise appeal.',
    Icons.smart_toy,
  );

  const FeatureBetType(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum BoardDemandType {
  burnCut(
    'Cut Burn',
    'The board wants efficiency. Lower spend pressure, but morale can slip.',
    Icons.savings,
  ),
  growthPush(
    'Push Growth',
    'Chase headlines and user growth. Better traction, weaker trust if it backfires.',
    Icons.trending_up,
  ),
  qualityReset(
    'Quality Reset',
    'Slow down and improve the product surface. Better trust and product rewards.',
    Icons.fact_check,
  );

  const BoardDemandType(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum TeamLeadFocus {
  engineering(
    'Engineering Lead',
    'Pushes shipping and platform throughput.',
    Icons.memory,
  ),
  growth(
    'Growth Lead',
    'Turns campaigns into stronger traction and event gains.',
    Icons.campaign,
  ),
  operations(
    'Operations Lead',
    'Stabilizes morale, credits, and contract delivery.',
    Icons.settings_suggest,
  );

  const TeamLeadFocus(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum ProjectType {
  launchWarRoom(
    'Launch War Room',
    'Pull a cross-functional pod together for a permanent launch process upgrade.',
    Icons.rocket_launch,
  ),
  supportCommand(
    'Support Command',
    'Turn product, support, and ops into a better trust and morale floor.',
    Icons.support_agent,
  ),
  revOpsEngine(
    'RevOps Engine',
    'Connect GTM and finance into stronger contract and valuation output.',
    Icons.query_stats,
  );

  const ProjectType(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

enum CultureIncidentType {
  burnoutWave(
    'Burnout Wave',
    'The team is stretched thin. Choose between speed and recovery.',
    Icons.local_fire_department,
  ),
  processDebt(
    'Process Debt',
    'Too many handoffs are starting to hurt delivery quality.',
    Icons.alt_route,
  ),
  cultureDrift(
    'Culture Drift',
    'New hires are moving faster than the culture can absorb.',
    Icons.diversity_1,
  );

  const CultureIncidentType(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

class GameController extends ChangeNotifier {
  static const _saveKey = 'startup_office_save_v1';
  static const schemaVersion = 7;
  static const resetForIntegration = bool.fromEnvironment(
    'E2E_RESET_ON_LAUNCH',
  );

  final List<String> eventLog = <String>[];
  final Map<Role, int> _roleCounts = <Role, int>{
    for (final role in Role.values) role: 0,
  };
  final Map<StartupSystem, int> _systemLevels = <StartupSystem, int>{
    for (final system in StartupSystem.values) system: 0,
  };
  final Set<AdvisorId> unlockedAdvisors = <AdvisorId>{};
  final Set<ChallengeId> completedChallenges = <ChallengeId>{};
  final Set<PlaybookId> unlockedPlaybooks = <PlaybookId>{};
  final Set<FounderTrophyId> unlockedTrophies = <FounderTrophyId>{};
  final Set<String> claimedLiveOpsMissions = <String>{};
  async.Timer? _timer;
  SharedPreferences? _prefs;
  DateTime _lastSave = DateTime.now();
  int _eventRotationIndex = 0;

  double cash = 0;
  double credits = 0;
  double valuation = 0;
  double reputation = 0;
  double productProgress = 0;
  double funding = 0;
  double traction = 0;
  double marketInsight = 0;
  double customerTrust = 55;
  double teamMorale = 55;
  int prestigePoints = 0;
  int lifetimePrestiges = 0;
  int legacyTokens = 0;
  int founderReputation = 0;
  int portfolioCompanies = 0;
  int portfolioPoints = 0;
  int ventureDealFlow = 0;
  int ventureStudioLevel = 0;
  int syndicateNetworkLevel = 0;
  int tapLevel = 1;
  int officeLevel = 1;
  int productStageIndex = 0;
  int fundingStageIndex = 0;
  int manualTaps = 0;
  int rewardedAdsWatched = 0;
  int focusTokens = 0;
  int permanentTeamSlotBonus = 0;
  int permanentOfflineMinutes = 120;
  int eventRewardLevel = 0;
  int productLegacyLevel = 0;
  int growthLegacyLevel = 0;
  int financeLegacyLevel = 0;
  int talentBenchLevel = 0;
  int brandNetworkLevel = 0;
  int ventureFundLevel = 0;
  int challengeTokens = 0;
  int marketExpansionLevel = 0;
  int contractWins = 0;
  int featureBetTokens = 0;
  int boardInfluence = 0;
  int crisisLevel = 0;
  int projectCompletions = 0;
  int cultureStability = 0;
  int onboardingLabLevel = 0;
  int platformSuiteLevel = 0;
  int aiCopilotLevel = 0;
  int launchWarRoomLevel = 0;
  int supportCommandLevel = 0;
  int revOpsEngineLevel = 0;
  int builderLegacyLevel = 0;
  int operatorLegacyLevel = 0;
  int rainmakerLegacyLevel = 0;
  int productStrategyRefreshes = 0;
  int capitalPolicyRefreshes = 0;
  int founderOriginTokens = 0;
  int seasonTokens = 0;
  int ventureThesisRefreshes = 0;
  bool starterPackOwned = false;
  bool noAdsOwned = false;
  bool offlineSummaryPending = false;
  double lastOfflineCash = 0;
  double lastOfflineCredits = 0;
  double lastOfflineProduct = 0;
  double lastOfflineTraction = 0;
  int lastOfflineSeconds = 0;
  List<String> offlineBriefLines = <String>[];
  double founderMomentum = 0;
  double founderFlowSeconds = 0;
  double comebackBurstSeconds = 0;
  int contractChain = 0;
  double contractChainSeconds = 0;
  double eventCooldownSeconds = 35;
  double supportBacklogSeconds = 0;
  double deliveryConfidenceSeconds = 0;
  double recruitingPipelineSeconds = 0;
  double viralBoostSeconds = 0;
  double investorBuzzSeconds = 0;
  double recruitingRushSeconds = 0;
  double boardPressureSeconds = 0;
  double qualityResetSeconds = 0;
  double marketPulseSeconds = 0;
  double parentDirectiveSeconds = 0;
  double seasonSeconds = 0;
  double activeProjectSeconds = 0;
  ContractType? activeContract;
  double activeContractSeconds = 0;
  ContractType? readyContract;
  String lastContractSummary = '';
  FeatureBetType? activeFeatureBet;
  BoardDemandType? activeBoardDemand;
  MarketPulseType? activeMarketPulse;
  ParentDirectiveType? activeParentDirective;
  SeasonEventType? activeSeason;
  TeamLeadFocus? activeLead;
  ProjectType? activeProject;
  ProjectType? readyProject;
  CultureIncidentType? activeCultureIncident;
  VentureThesis? activeVentureThesis;
  CompanyFocus companyFocus = CompanyFocus.balanced;
  StartupEventType? activeEvent;
  AdvisorId? equippedAdvisor;
  ChallengeId? activeChallenge;
  FounderSpecialization? activeSpecialization;
  FounderOrigin activeFounderOrigin = FounderOrigin.builderLab;
  ProductStrategy? activeProductStrategy;
  CapitalPolicy? activeCapitalPolicy;
  bool productStrategyChoicePending = false;
  bool capitalPolicyChoicePending = false;
  double peakValuationRecord = 0;
  int fastestIpoSecondsRecord = 0;
  bool cleanBootstrappedRecord = false;
  int runSeconds = 0;

  bool get loaded => _prefs != null;
  int get developers =>
      roleCount(Role.juniorDeveloper) + roleCount(Role.seniorEngineer);
  int get designers => roleCount(Role.uxDesigner);
  int get marketers =>
      roleCount(Role.growthMarketer) + roleCount(Role.communityManager);
  int get sales => roleCount(Role.salesRep) + roleCount(Role.accountExecutive);
  double get trustFloor =>
      35 +
      brandNetworkLevel * 6 +
      (unlockedPlaybooks.contains(PlaybookId.peopleOpsManual) ? 6 : 0) -
      (unlockedPlaybooks.contains(PlaybookId.growthScript) ? 4 : 0);
  double get moraleFloor =>
      35 +
      talentBenchLevel * 6 +
      (unlockedPlaybooks.contains(PlaybookId.peopleOpsManual) ? 8 : 0) -
      (unlockedPlaybooks.contains(PlaybookId.growthScript) ? 2 : 0);
  double get trustMultiplier =>
      (0.75 + customerTrust / 120 + brandNetworkLevel * 0.02).clamp(0.8, 1.9);
  double get moraleMultiplier =>
      (0.75 + teamMorale / 120 + talentBenchLevel * 0.02).clamp(0.8, 1.9);
  double get featureBetProductMultiplier =>
      1 + onboardingLabLevel * 0.05 + platformSuiteLevel * 0.09;
  double get featureBetTrustMultiplier =>
      1 + onboardingLabLevel * 0.06 + qualityResetSeconds / 600;
  double get featureBetTractionMultiplier =>
      1 + aiCopilotLevel * 0.1 + boardPressureSeconds / 700;
  double get boardEfficiencyMultiplier => switch (activeBoardDemand) {
    BoardDemandType.burnCut => 1.12,
    _ => 1.0,
  };
  double get boardGrowthMultiplier => switch (activeBoardDemand) {
    BoardDemandType.growthPush => 1.18,
    _ => 1.0,
  };
  double get boardQualityMultiplier => switch (activeBoardDemand) {
    BoardDemandType.qualityReset => 1.14,
    _ => 1.0,
  };
  double get marketPulseCashMultiplier => switch (activeMarketPulse) {
    MarketPulseType.bullRun => 1.08,
    MarketPulseType.correction => 0.93,
    _ => 1.0,
  };
  double get marketPulseValuationMultiplier => switch (activeMarketPulse) {
    MarketPulseType.bullRun => 1.3,
    MarketPulseType.correction => 0.85,
    MarketPulseType.activistPressure => 0.95,
    _ => 1.0,
  };
  double get marketPulseTrustMultiplier => switch (activeMarketPulse) {
    MarketPulseType.activistPressure => 0.94,
    _ => 1.0,
  };
  double get parentCashMultiplier => switch (activeParentDirective) {
    ParentDirectiveType.crossSell => 1.18,
    ParentDirectiveType.earnOutLock => 1.12,
    _ => 1.0,
  };
  double get parentProductMultiplier => switch (activeParentDirective) {
    ParentDirectiveType.earnOutLock => 1.15,
    ParentDirectiveType.integrationAudit => 1.08,
    _ => 1.0,
  };
  double get parentCreditMultiplier => switch (activeParentDirective) {
    ParentDirectiveType.integrationAudit => 1.18,
    _ => 1.0,
  };
  double get parentTractionMultiplier => switch (activeParentDirective) {
    ParentDirectiveType.crossSell => 1.14,
    _ => 1.0,
  };
  double get seasonCashMultiplier => switch (activeSeason) {
    SeasonEventType.capitalWeek => 1.12,
    _ => 1.0,
  };
  double get seasonProductMultiplier => switch (activeSeason) {
    SeasonEventType.builderSummit => 1.2,
    _ => 1.0,
  };
  double get seasonTractionMultiplier => switch (activeSeason) {
    SeasonEventType.growthGames => 1.22,
    _ => 1.0,
  };
  double get seasonFundingMultiplier => switch (activeSeason) {
    SeasonEventType.capitalWeek => 0.88,
    _ => 1.0,
  };
  double get fundingMultiplier => ventureThesisFundingMultiplier;
  double get leadProductMultiplier => switch (activeLead) {
    TeamLeadFocus.engineering => 1.15,
    _ => 1.0,
  };
  double get leadTractionMultiplier => switch (activeLead) {
    TeamLeadFocus.growth => 1.18,
    _ => 1.0,
  };
  double get leadOpsMultiplier => switch (activeLead) {
    TeamLeadFocus.operations => 1.16,
    _ => 1.0,
  };
  double get projectCashMultiplier =>
      1 + launchWarRoomLevel * 0.04 + revOpsEngineLevel * 0.07;
  double get projectTrustMultiplier => 1 + supportCommandLevel * 0.08;
  double get projectValuationMultiplier =>
      1 + launchWarRoomLevel * 0.05 + revOpsEngineLevel * 0.08;
  double get prestigeMultiplier =>
      1 + prestigePoints * 0.08 + financeLegacyLevel * 0.04;
  bool get founderSpecializationsUnlocked => lifetimePrestiges >= 1;
  bool get ventureThesisUnlocked =>
      lifetimePrestiges >= 2 || portfolioCompanies >= 1;
  bool get productMatrixUnlocked => portfolioCompanies >= 2;
  bool get holdingPlatformUnlocked => portfolioCompanies >= 3;
  bool get crisisRecoveryUnlocked => fundingStageIndex >= 2 || crisisLevel >= 2;
  double get trophyCollectionMultiplier =>
      unlockedTrophies.length >= 3 ? 1.08 : 1.0;
  int get activeSpecializationLevel => switch (activeSpecialization) {
    FounderSpecialization.builder => builderLegacyLevel,
    FounderSpecialization.operator => operatorLegacyLevel,
    FounderSpecialization.rainmaker => rainmakerLegacyLevel,
    null => 0,
  };
  double get ventureThesisCashMultiplier => switch (activeVentureThesis) {
    VentureThesis.productStudio => 0.98,
    VentureThesis.distributionMachine => 1.05,
    VentureThesis.capitalEngine => 1.12,
    null => 1.0,
  };
  double get ventureThesisProductMultiplier => switch (activeVentureThesis) {
    VentureThesis.productStudio => 1.16,
    VentureThesis.distributionMachine => 0.98,
    VentureThesis.capitalEngine => 1.04,
    null => 1.0,
  };
  double get ventureThesisTractionMultiplier => switch (activeVentureThesis) {
    VentureThesis.productStudio => 1.05,
    VentureThesis.distributionMachine => 1.18,
    VentureThesis.capitalEngine => 0.98,
    null => 1.0,
  };
  double get ventureThesisFundingMultiplier => switch (activeVentureThesis) {
    VentureThesis.productStudio => 1.02,
    VentureThesis.distributionMachine => 1.04,
    VentureThesis.capitalEngine => 0.88,
    null => 1.0,
  };
  double get ventureThesisRecoveryMultiplier => switch (activeVentureThesis) {
    VentureThesis.productStudio => 1.08,
    VentureThesis.distributionMachine => 0.96,
    VentureThesis.capitalEngine => 1.22,
    null => 1.0,
  };
  double get productMatrixMultiplier => productMatrixUnlocked ? 1.12 : 1.0;
  double get holdingPlatformMultiplier => holdingPlatformUnlocked ? 1.18 : 1.0;
  double get specializationCashMultiplier => switch (activeSpecialization) {
    FounderSpecialization.rainmaker => 1 + rainmakerLegacyLevel * 0.12,
    FounderSpecialization.operator => 1 + operatorLegacyLevel * 0.05,
    _ => 1.0,
  };
  double get specializationProductMultiplier => switch (activeSpecialization) {
    FounderSpecialization.builder => 1 + builderLegacyLevel * 0.14,
    _ => 1.0,
  };
  double get specializationCreditMultiplier => switch (activeSpecialization) {
    FounderSpecialization.operator => 1 + operatorLegacyLevel * 0.16,
    _ => 1.0,
  };
  double get specializationFundingMultiplier => switch (activeSpecialization) {
    FounderSpecialization.rainmaker => math.max(
      0.62,
      1 - rainmakerLegacyLevel * 0.08,
    ),
    _ => 1.0,
  };
  double get specializationEventMultiplier => switch (activeSpecialization) {
    FounderSpecialization.rainmaker => 1 + rainmakerLegacyLevel * 0.08,
    FounderSpecialization.builder => 1 + builderLegacyLevel * 0.04,
    _ => 1.0,
  };
  int get specializationOfflineMinutes =>
      activeSpecialization == FounderSpecialization.operator
      ? operatorLegacyLevel * 30
      : 0;
  double get startingCashBonus =>
      switch (activeSpecialization) {
        FounderSpecialization.rainmaker =>
          220.0 * rainmakerLegacyLevel + ventureFundLevel * 180.0,
        _ => ventureFundLevel * 180.0,
      } +
      switch (activeFounderOrigin) {
        FounderOrigin.financeDesk => 320,
        _ => 0,
      };
  double get startingCreditsBonus =>
      switch (activeSpecialization) {
        FounderSpecialization.operator => 28.0 * operatorLegacyLevel,
        _ => 0.0,
      } +
      switch (activeFounderOrigin) {
        FounderOrigin.operatorGuild => 85,
        _ => 0,
      };
  double get startingProductBonus =>
      switch (activeSpecialization) {
        FounderSpecialization.builder => 18.0 * builderLegacyLevel,
        _ => 0.0,
      } +
      switch (activeFounderOrigin) {
        FounderOrigin.builderLab => 30,
        _ => 0,
      };
  double get startingTrustBonus =>
      8.0 * brandNetworkLevel +
      switch (activeFounderOrigin) {
        FounderOrigin.growthStudio => 6,
        _ => 0,
      };
  double get startingMoraleBonus =>
      8.0 * talentBenchLevel +
      switch (activeFounderOrigin) {
        FounderOrigin.operatorGuild => 8,
        _ => 0,
      };
  double get founderOriginCashMultiplier => switch (activeFounderOrigin) {
    FounderOrigin.financeDesk => 1.08,
    _ => 1.0,
  };
  double get founderOriginProductMultiplier => switch (activeFounderOrigin) {
    FounderOrigin.builderLab => 1.16,
    _ => 1.0,
  };
  double get founderOriginTractionMultiplier => switch (activeFounderOrigin) {
    FounderOrigin.growthStudio => 1.18,
    _ => 1.0,
  };
  double get founderOriginCreditMultiplier => switch (activeFounderOrigin) {
    FounderOrigin.operatorGuild => 1.14,
    _ => 1.0,
  };
  double get founderOriginFundingMultiplier => switch (activeFounderOrigin) {
    FounderOrigin.financeDesk => 0.9,
    _ => 1.0,
  };
  double get productStrategyCashMultiplier => switch (activeProductStrategy) {
    ProductStrategy.enterprise => 1.08,
    _ => 1.0,
  };
  double get productStrategyProductMultiplier =>
      switch (activeProductStrategy) {
        ProductStrategy.craft => 1.18,
        _ => 1.0,
      };
  double get productStrategyTractionMultiplier =>
      switch (activeProductStrategy) {
        ProductStrategy.growthLoops => 1.22,
        _ => 1.0,
      };
  double get productStrategyValuationMultiplier =>
      switch (activeProductStrategy) {
        ProductStrategy.enterprise => 1.14,
        _ => 1.0,
      };
  double get productStageRewardMultiplier => switch (activeProductStrategy) {
    ProductStrategy.craft => 1.2,
    ProductStrategy.growthLoops => 1.08,
    ProductStrategy.enterprise => 1.12,
    null => 1.0,
  };
  double get capitalPolicyCashMultiplier => switch (activeCapitalPolicy) {
    CapitalPolicy.blitzscaling => 1.12,
    CapitalPolicy.efficientGrowth => 1.04,
    _ => 1.0,
  };
  double get capitalPolicyCreditMultiplier => switch (activeCapitalPolicy) {
    CapitalPolicy.talentFirst => 1.18,
    _ => 1.0,
  };
  double get capitalPolicyFundingMultiplier => switch (activeCapitalPolicy) {
    CapitalPolicy.efficientGrowth => 0.84,
    CapitalPolicy.blitzscaling => 1.08,
    _ => 1.0,
  };
  double get capitalPolicyReputationMultiplier => switch (activeCapitalPolicy) {
    CapitalPolicy.blitzscaling => 1.12,
    CapitalPolicy.talentFirst => 1.04,
    _ => 1.0,
  };
  double get capitalRoundRewardMultiplier => switch (activeCapitalPolicy) {
    CapitalPolicy.blitzscaling => 1.22,
    CapitalPolicy.efficientGrowth => 1.08,
    CapitalPolicy.talentFirst => 1.10,
    null => 1.0,
  };
  double get productLegacyMultiplier => 1 + productLegacyLevel * 0.09;
  double get growthLegacyMultiplier => 1 + growthLegacyLevel * 0.09;
  double get financeLegacyMultiplier => 1 + financeLegacyLevel * 0.09;
  double get ventureFundMultiplier => 1 + ventureFundLevel * 0.08;
  double get ventureNetworkCashMultiplier =>
      1 + ventureStudioLevel * 0.06 + syndicateNetworkLevel * 0.04;
  double get ventureNetworkProductMultiplier => 1 + ventureStudioLevel * 0.08;
  double get ventureNetworkInsightMultiplier =>
      1 + syndicateNetworkLevel * 0.12 + ventureDealFlow * 0.05;
  double get challengeProductMultiplier =>
      completedChallenges.contains(ChallengeId.bootstrappedRun) ? 1.16 : 1.0;
  double get challengeTractionMultiplier =>
      completedChallenges.contains(ChallengeId.hypergrowthRun) ? 1.18 : 1.0;
  bool get advisorsUnlocked => fundingStageIndex >= 1 || productStageIndex >= 2;
  bool get challengesUnlocked => lifetimePrestiges >= 1 || valuation >= 250000;
  bool get contractsUnlocked =>
      productStageIndex >= 1 || fundingStageIndex >= 1;
  bool get expansionUnlocked =>
      fundingStageIndex >= 2 || productStageIndex >= 4;
  bool get featureBetsUnlocked => productStageIndex >= 5;
  bool get boardDemandsUnlocked => fundingStageIndex >= 2;
  bool get teamLeadsUnlocked => teamSize >= 6;
  bool get crossProjectsUnlocked => teamSize >= 10;
  bool get cultureIncidentsUnlocked => teamSize >= 20;
  double get advisorCashMultiplier => switch (equippedAdvisor) {
    AdvisorId.growthHacker => 1.10,
    AdvisorId.financeChief => 1.08,
    _ => 1.0,
  };
  double get advisorProductMultiplier => switch (equippedAdvisor) {
    AdvisorId.productSage => 1.18,
    _ => 1.0,
  };
  double get advisorFundingMultiplier => switch (equippedAdvisor) {
    AdvisorId.financeChief => 0.85,
    _ => 1.0,
  };
  double get advisorTractionMultiplier => switch (equippedAdvisor) {
    AdvisorId.growthHacker => 1.22,
    AdvisorId.operatorCoach => 1.08,
    _ => 1.0,
  };
  double get advisorInsightMultiplier => switch (equippedAdvisor) {
    AdvisorId.operatorCoach => 1.25,
    AdvisorId.productSage => 1.08,
    _ => 1.0,
  };
  bool get advisorCollectionSetUnlocked => unlockedAdvisors.length >= 3;
  double get advisorCollectionMultiplier =>
      advisorCollectionSetUnlocked ? 1.12 : 1.0;
  bool get challengeBlocksFunding =>
      activeChallenge == ChallengeId.bootstrappedRun;
  bool get challengeBlocksOfficeUpgrade =>
      activeChallenge == ChallengeId.remoteOnlyRun && officeLevel >= 3;
  int get challengeTeamCap =>
      activeChallenge == ChallengeId.leanTeamRun ? 8 : 999;
  double get challengeReputationFloor =>
      activeChallenge == ChallengeId.hypergrowthRun ? 120 : 0;
  double get focusCashMultiplier => switch (companyFocus) {
    CompanyFocus.balanced => 1,
    CompanyFocus.product => 0.96,
    CompanyFocus.growth => 1.14,
    CompanyFocus.finance => 1.08,
  };
  double get focusProductMultiplier => switch (companyFocus) {
    CompanyFocus.balanced => 1,
    CompanyFocus.product => 1.26,
    CompanyFocus.growth => 0.95,
    CompanyFocus.finance => 0.92,
  };
  double get focusReputationMultiplier => switch (companyFocus) {
    CompanyFocus.balanced => 1,
    CompanyFocus.product => 1.08,
    CompanyFocus.growth => 1.22,
    CompanyFocus.finance => 0.96,
  };
  double get focusValuationMultiplier => switch (companyFocus) {
    CompanyFocus.balanced => 1,
    CompanyFocus.product => 1.07,
    CompanyFocus.growth => 1.05,
    CompanyFocus.finance => 1.22,
  };
  double get focusTractionMultiplier => switch (companyFocus) {
    CompanyFocus.balanced => 1,
    CompanyFocus.product => 1.10,
    CompanyFocus.growth => 1.30,
    CompanyFocus.finance => 0.95,
  };
  double get fundingCostMultiplier => switch (companyFocus) {
    CompanyFocus.balanced => 1,
    CompanyFocus.product => 1.08,
    CompanyFocus.growth => 1.02,
    CompanyFocus.finance => 0.82,
  };
  double get eventRewardMultiplier =>
      (1 + eventRewardLevel * 0.12 + growthLegacyLevel * 0.05) *
      specializationEventMultiplier;
  bool get momentumUnlocked => productStageIndex >= 1 || teamSize >= 3;
  double get founderFlowMultiplier => founderFlowSeconds > 0 ? 1.35 : 1.0;
  double get comebackBurstMultiplier => comebackBurstSeconds > 0 ? 1.22 : 1.0;
  double get activeLoopMultiplier =>
      founderFlowMultiplier * comebackBurstMultiplier;
  double get contractChainMultiplier =>
      1 + contractChain * 0.07 + (contractChainSeconds > 0 ? 0.08 : 0.0);
  double get contractDurationMultiplier => math.max(
    0.65,
    1 - contractChain * 0.05 - (founderFlowSeconds > 0 ? 0.05 : 0.0),
  );
  double get contractRewardMultiplier =>
      (1 + marketExpansionLevel * 0.14) *
      contractChainMultiplier *
      trustMultiplier *
      (unlockedPlaybooks.contains(PlaybookId.enterpriseDeck) ? 1.16 : 1.0) *
      (unlockedPlaybooks.contains(PlaybookId.growthScript) ? 1.08 : 1.0);
  double get contractValuationMultiplier =>
      1 +
      marketExpansionLevel * 0.12 +
      (unlockedPlaybooks.contains(PlaybookId.enterpriseDeck) ? 0.18 : 0.0);
  double get playbookEventMultiplier =>
      (unlockedPlaybooks.contains(PlaybookId.growthScript) ? 1.12 : 1.0) *
      (unlockedPlaybooks.contains(PlaybookId.peopleOpsManual) ? 0.96 : 1.0) *
      (unlockedPlaybooks.contains(PlaybookId.enterpriseDeck) ? 0.98 : 1.0);
  double get moraleHireDiscountMultiplier =>
      unlockedPlaybooks.contains(PlaybookId.peopleOpsManual) ? 0.94 : 1.0;
  double get playbookProductMultiplier =>
      unlockedPlaybooks.contains(PlaybookId.enterpriseDeck) ? 0.92 : 1.0;
  double get playbookTractionMultiplier =>
      unlockedPlaybooks.contains(PlaybookId.growthScript) ? 1.12 : 1.0;
  double get eventContractSuccessModifier =>
      (deliveryConfidenceSeconds > 0 ? 0.08 : 0.0) +
      (recruitingPipelineSeconds > 0 ? 0.05 : 0.0) -
      (supportBacklogSeconds > 0 ? 0.12 : 0.0);
  double get systemCashMultiplier => 1 + _systemBonus((s) => s.cashBoost);
  double get systemProductMultiplier => 1 + _systemBonus((s) => s.productBoost);
  double get systemReputationMultiplier =>
      1 + _systemBonus((s) => s.reputationBoost);
  double get systemCreditMultiplier => 1 + _systemBonus((s) => s.creditBoost);
  double get systemValuationMultiplier =>
      1 + _systemBonus((s) => s.valuationBoost);
  bool get sprintUnlocked => teamSize >= 3;
  bool get leadUnlocked => teamSize >= 6;
  bool get crossFunctionalPodUnlocked => teamSize >= 10;
  bool get cultureEngineUnlocked => teamSize >= 20;
  bool get strategyUnlocked => productStageIndex >= 2;
  bool get feedbackLoopUnlocked => productStageIndex >= 1;
  bool get tractionUnlocked => productStageIndex >= 4;
  bool get investorEventsUnlocked => fundingStageIndex >= 1;
  bool get globalExpansionUnlocked => fundingStageIndex >= 4;
  bool get eventsUnlocked => productStageIndex >= 1 || fundingStageIndex >= 1;
  bool get remoteOfficeUnlocked => officeLevel >= 12;
  bool get executiveSuiteUnlocked => officeLevel >= 8;
  bool get meetingRoomUnlocked => officeLevel >= 5;
  bool get globalMapUnlocked => marketExpansionLevel >= 1;
  bool get ipoUnlocked => fundingStageIndex >= 6;
  bool get engineeringDesignSynergyUnlocked =>
      _departmentCount(Department.engineering) >= 5 && designers >= 2;
  bool get goToMarketSynergyUnlocked =>
      (_departmentCount(Department.growth) +
          _departmentCount(Department.sales)) >=
      5;
  bool get opsCommandSynergyUnlocked =>
      (_departmentCount(Department.operations) +
          _departmentCount(Department.data) +
          _departmentCount(Department.finance)) >=
      5;
  int get officeMilestoneCapacityBonus =>
      (officeLevel >= 2 ? 1 : 0) +
      (officeLevel >= 5 ? 2 : 0) +
      (officeLevel >= 8 ? 3 : 0);
  int get temporaryTeamCapacityBonus => recruitingRushSeconds > 0 ? 2 : 0;
  double get cashBurstMultiplier => viralBoostSeconds > 0 ? 1.8 : 1.0;
  double get productBurstMultiplier => recruitingRushSeconds > 0 ? 1.6 : 1.0;
  double get reputationBurstMultiplier => investorBuzzSeconds > 0 ? 1.5 : 1.0;
  double get hireDiscountMultiplier => recruitingRushSeconds > 0 ? 0.82 : 1.0;
  double get eventCooldownMultiplier => cultureEngineUnlocked ? 0.8 : 1.0;
  double get leadershipMultiplier =>
      (sprintUnlocked ? 1.10 : 1.0) *
      (leadUnlocked ? 1.12 : 1.0) *
      (crossFunctionalPodUnlocked && hasCrossFunctionalPod ? 1.25 : 1.0);
  double get departmentCashMultiplier => goToMarketSynergyUnlocked ? 1.12 : 1.0;
  double get departmentProductMultiplier =>
      engineeringDesignSynergyUnlocked ? 1.18 : 1.0;
  double get departmentCreditMultiplier =>
      opsCommandSynergyUnlocked ? 1.16 : 1.0;
  double get departmentTractionMultiplier =>
      goToMarketSynergyUnlocked ? 1.18 : 1.0;
  double get departmentValuationMultiplier =>
      engineeringDesignSynergyUnlocked && opsCommandSynergyUnlocked ? 1.1 : 1.0;
  double get marketFitMultiplier =>
      tractionUnlocked ? 1 + math.log(traction + 1) / 6 : 1;
  bool get hasCrossFunctionalPod =>
      _departmentCount(Department.engineering) >= 2 &&
      (_departmentCount(Department.product) +
              _departmentCount(Department.design)) >=
          2 &&
      (_departmentCount(Department.growth) +
              _departmentCount(Department.sales)) >=
          2;
  double get tapIncome =>
      tapLevel *
      1.0 *
      prestigeMultiplier *
      ventureFundMultiplier *
      founderOriginCashMultiplier *
      specializationCashMultiplier *
      systemCashMultiplier;
  double get founderAutomationPerSecond {
    if (!sprintUnlocked) return 0;
    final base =
        tapIncome *
        (leadUnlocked ? 0.85 : 0.35) *
        (crossFunctionalPodUnlocked ? 1.2 : 1.0);
    return base;
  }

  double get autoIncomePerSecond {
    final teamOutput = Role.values.fold<double>(
      0,
      (sum, role) => sum + roleCount(role) * role.cashOutput,
    );
    final officeBoost = 1 + (officeLevel - 1) * 0.12;
    final productBoost = 1 + productStageIndex * 0.18;
    final fundingBoost = 1 + fundingStageIndex * 0.22;
    return teamOutput *
        officeBoost *
        productBoost *
        fundingBoost *
        (1 + marketExpansionLevel * 0.12) *
        leadershipMultiplier *
        advisorCollectionMultiplier *
        advisorCashMultiplier *
        departmentCashMultiplier *
        projectCashMultiplier *
        productStrategyCashMultiplier *
        capitalPolicyCashMultiplier *
        founderOriginCashMultiplier *
        marketPulseCashMultiplier *
        parentCashMultiplier *
        specializationCashMultiplier *
        ventureThesisCashMultiplier *
        trophyCollectionMultiplier *
        activeLoopMultiplier *
        cashBurstMultiplier *
        focusCashMultiplier *
        marketFitMultiplier *
        trustMultiplier *
        prestigeMultiplier *
        ventureFundMultiplier *
        ventureNetworkCashMultiplier *
        holdingPlatformMultiplier *
        seasonCashMultiplier *
        systemCashMultiplier;
  }

  double get progressPerSecond =>
      Role.values.fold<double>(
        0,
        (sum, role) => sum + roleCount(role) * role.productOutput,
      ) *
      leadershipMultiplier *
      focusProductMultiplier *
      productLegacyMultiplier *
      departmentProductMultiplier *
      productStrategyProductMultiplier *
      founderOriginProductMultiplier *
      parentProductMultiplier *
      specializationProductMultiplier *
      ventureThesisProductMultiplier *
      trophyCollectionMultiplier *
      activeLoopMultiplier *
      challengeProductMultiplier *
      advisorCollectionMultiplier *
      advisorProductMultiplier *
      moraleMultiplier *
      ventureNetworkProductMultiplier *
      productMatrixMultiplier *
      seasonProductMultiplier *
      featureBetProductMultiplier *
      leadProductMultiplier *
      boardQualityMultiplier *
      productBurstMultiplier *
      playbookProductMultiplier *
      systemProductMultiplier;
  double get reputationPerSecond =>
      Role.values.fold<double>(
        0,
        (sum, role) => sum + roleCount(role) * role.reputationOutput,
      ) *
      focusReputationMultiplier *
      growthLegacyMultiplier *
      advisorCollectionMultiplier *
      capitalPolicyReputationMultiplier *
      trustMultiplier *
      featureBetTrustMultiplier *
      projectTrustMultiplier *
      reputationBurstMultiplier *
      ventureThesisRecoveryMultiplier *
      activeLoopMultiplier *
      systemReputationMultiplier;
  double get creditsPerSecond =>
      Role.values.fold<double>(
        0,
        (sum, role) => sum + roleCount(role) * role.creditsOutput,
      ) *
      leadershipMultiplier *
      departmentCreditMultiplier *
      capitalPolicyCreditMultiplier *
      founderOriginCreditMultiplier *
      parentCreditMultiplier *
      specializationCreditMultiplier *
      leadOpsMultiplier *
      moraleMultiplier *
      systemCreditMultiplier;
  double get tractionPerSecond {
    if (!tractionUnlocked) return 0;
    final growthBase =
        marketers * 0.24 +
        sales * 0.32 +
        roleCount(Role.productManager) * 0.18 +
        roleCount(Role.customerSuccess) * 0.15;
    final expansionBoost = globalExpansionUnlocked ? 1.35 : 1.0;
    return growthBase *
        focusTractionMultiplier *
        departmentTractionMultiplier *
        productStrategyTractionMultiplier *
        founderOriginTractionMultiplier *
        parentTractionMultiplier *
        growthLegacyMultiplier *
        seasonTractionMultiplier *
        challengeTractionMultiplier *
        advisorTractionMultiplier *
        (1 + marketExpansionLevel * 0.1) *
        expansionBoost *
        trustMultiplier *
        featureBetTractionMultiplier *
        leadTractionMultiplier *
        boardGrowthMultiplier *
        reputationBurstMultiplier *
        ventureThesisTractionMultiplier *
        productMatrixMultiplier *
        activeLoopMultiplier *
        playbookTractionMultiplier;
  }

  double get marketInsightPerSecond {
    if (!expansionUnlocked) return 0;
    final insightBase =
        traction * 0.012 +
        reputationPerSecond * 0.5 +
        roleCount(Role.dataAnalyst) * 0.35 +
        roleCount(Role.financeOps) * 0.25;
    return insightBase *
        advisorInsightMultiplier *
        ventureNetworkInsightMultiplier;
  }

  String get nextOfficeUnlockHint => switch (officeLevel) {
    < 2 => 'Office Lv.2: better seating unlocks extra team capacity.',
    < 5 => 'Office Lv.5: meeting room visual unlock and stronger pod synergy.',
    < 8 => 'Office Lv.8: executive suite visual unlock and long-term leverage.',
    < 12 =>
      'Office Lv.12: remote office wing opens as a late-game visual layer.',
    _ =>
      'Office core is fully built. Push product, expansion, and prestige next.',
  };

  String get nextTeamUnlockHint => switch (teamSize) {
    < 3 => '3 hires: sprint rhythm kicks in for a smoother early run.',
    < 6 =>
      '6 hires: team leads unlock and turn departments into real run-defining choices.',
    < 10 =>
      '10 hires: cross-functional projects unlock permanent company traits.',
    < 20 =>
      '20 hires: culture incidents begin creating tradeoffs between speed and stability.',
    _ =>
      'Team milestones are online. Now optimize department mix and challenges.',
  };

  String get nextProductUnlockHint => switch (productStageIndex) {
    < 1 =>
      'Prototype unlocks event cadence, contracts, and faster mid-loop bursts.',
    < 2 => 'MVP unlocks company focus choices.',
    < 4 => 'Launch unlocks traction as a second growth resource.',
    < 5 => 'Growth upgrades the go-to-market compounding loop.',
    < 6 =>
      'Scale unlocks feature bets that permanently reshape product strategy.',
    _ => 'Top-end product layers are open. Chase prestige and expansion loops.',
  };

  String get nextFundingUnlockHint => switch (fundingStageIndex) {
    < 1 => 'Pre-seed unlocks investor-call style event pressure.',
    < 2 =>
      'Seed gives more strategy flexibility and stronger expansion timing.',
    < 4 => 'Series A/B introduce board pressure and growth tradeoffs.',
    < 6 => 'IPO unlocks the top-end prestige fantasy and visual bell moment.',
    _ =>
      'Capital layers are topped out. Focus on challenge clears and prestige.',
  };

  int get teamSize =>
      _roleCounts.values.fold<int>(0, (sum, count) => sum + count);
  int get teamCapacity =>
      3 +
      officeLevel * 2 +
      talentBenchLevel +
      officeMilestoneCapacityBonus +
      permanentTeamSlotBonus +
      temporaryTeamCapacityBonus;
  List<ContractType> get availableContracts => ContractType.values
      .where((contract) => isContractUnlocked(contract))
      .toList(growable: false);
  int contractDurationSeconds(ContractType contract) => math.max(
    20,
    (contract.durationSeconds * contractDurationMultiplier).round(),
  );
  int get systemLevelTotal =>
      _systemLevels.values.fold<int>(0, (sum, level) => sum + level);
  bool get hasTeamCapacity => teamSize < teamCapacity;
  bool get challengeAllowsHire => teamSize < challengeTeamCap;
  String get productStage =>
      productStages[math.min(productStageIndex, productStages.length - 1)];
  String get fundingStage =>
      fundingStages[math.min(fundingStageIndex, fundingStages.length - 1)];
  double get nextProductProgress => (productStageIndex + 1) * 100;
  double get nextExpansionInsight =>
      50 * math.pow(1.9, marketExpansionLevel).toDouble();
  double get prestigeTarget =>
      1000000 * math.pow(2.5, lifetimePrestiges).toDouble();
  bool get canPrestige => valuation >= prestigeTarget;
  bool get canAdvanceProduct =>
      productProgress >= nextProductProgress &&
      productStageIndex < productStages.length - 1;
  bool get canRaiseFunding =>
      !challengeBlocksFunding &&
      valuation >= fundingCost &&
      fundingStageIndex < fundingStages.length - 1;
  String get primaryEventChoiceLabel => switch (activeEvent) {
    StartupEventType.viralMoment => 'Ride the wave',
    StartupEventType.investorCall => 'Take the meeting',
    StartupEventType.recruitingRush => 'Open hiring sprint',
    null => 'Resolve event',
  };
  String get secondaryEventChoiceLabel => switch (activeEvent) {
    StartupEventType.viralMoment => 'Polish onboarding',
    StartupEventType.investorCall => 'Push for press',
    StartupEventType.recruitingRush => 'Train the pipeline',
    null => 'Alt choice',
  };
  double get fundingCost =>
      5000 *
      math.pow(5, fundingStageIndex).toDouble() *
      fundingCostMultiplier *
      founderOriginFundingMultiplier *
      seasonFundingMultiplier *
      fundingMultiplier *
      advisorFundingMultiplier *
      capitalPolicyFundingMultiplier *
      specializationFundingMultiplier;

  static const productStages = <String>[
    'Idea',
    'Prototype',
    'MVP',
    'Beta',
    'Launch',
    'Growth',
    'Scale',
    'Unicorn Platform',
  ];

  static const fundingStages = <String>[
    'Bootstrapped',
    'Pre-seed',
    'Seed',
    'Series A',
    'Series B',
    'Series C',
    'IPO',
    'Acquired',
  ];

  final List<QuestDefinition> quests = const <QuestDefinition>[
    QuestDefinition(
      'first_tap',
      'Founder starts shipping',
      'Tap once',
      QuestKind.taps,
      1,
      15,
    ),
    QuestDefinition(
      'first_hire',
      'First hire',
      'Recruit any teammate',
      QuestKind.teamSize,
      1,
      45,
    ),
    QuestDefinition(
      'engineering_pod',
      'Engineering pod',
      'Reach 3 engineering hires',
      QuestKind.engineeringTeam,
      3,
      160,
    ),
    QuestDefinition(
      'go_to_market',
      'Go-to-market pod',
      'Reach 3 growth/sales hires',
      QuestKind.goToMarketTeam,
      3,
      240,
    ),
    QuestDefinition(
      'ops_credit',
      'Operational muscle',
      'Earn 100 credits',
      QuestKind.credits,
      100,
      350,
    ),
    QuestDefinition(
      'systems_three',
      'Startup operating system',
      'Buy 3 system levels',
      QuestKind.startupSystems,
      3,
      500,
    ),
    QuestDefinition(
      'mvp',
      'Ship the MVP',
      'Reach MVP product stage',
      QuestKind.productStage,
      2,
      650,
    ),
    QuestDefinition(
      'seed',
      'Raise Seed money',
      'Reach Seed funding stage',
      QuestKind.fundingStage,
      2,
      1200,
    ),
    QuestDefinition(
      'team_twelve',
      'Real company',
      'Reach 12 employees',
      QuestKind.teamSize,
      12,
      2500,
    ),
    QuestDefinition(
      'million',
      'Million-dollar startup',
      'Reach 1M valuation',
      QuestKind.valuation,
      1000000,
      6000,
    ),
  ];

  final List<AchievementDefinition> achievements =
      const <AchievementDefinition>[
        AchievementDefinition(
          'tap_100',
          'Founder Mode',
          'Tap 100 times',
          QuestKind.taps,
          100,
        ),
        AchievementDefinition(
          'first_10k',
          'Revenue Signal',
          'Reach 10K cash',
          QuestKind.cash,
          10000,
        ),
        AchievementDefinition(
          'credits_1k',
          'Process Builder',
          'Earn 1K credits',
          QuestKind.credits,
          1000,
        ),
        AchievementDefinition(
          'team_10',
          'Team of Ten',
          'Reach 10 employees',
          QuestKind.teamSize,
          10,
        ),
        AchievementDefinition(
          'team_25',
          'Scaling Org',
          'Reach 25 employees',
          QuestKind.teamSize,
          25,
        ),
        AchievementDefinition(
          'eng_8',
          'Engineering Engine',
          'Reach 8 engineering hires',
          QuestKind.engineeringTeam,
          8,
        ),
        AchievementDefinition(
          'gtm_8',
          'Distribution Machine',
          'Reach 8 growth/sales hires',
          QuestKind.goToMarketTeam,
          8,
        ),
        AchievementDefinition(
          'ops_8',
          'Operator Brain',
          'Reach 8 ops/data/finance hires',
          QuestKind.opsTeam,
          8,
        ),
        AchievementDefinition(
          'systems_8',
          'SOP Library',
          'Buy 8 system levels',
          QuestKind.startupSystems,
          8,
        ),
        AchievementDefinition(
          'launch',
          'Public Launch',
          'Reach Launch product stage',
          QuestKind.productStage,
          4,
        ),
        AchievementDefinition(
          'series_b',
          'Institutional Scale',
          'Reach Series B',
          QuestKind.fundingStage,
          4,
        ),
        AchievementDefinition(
          'ipo',
          'Ring The Bell',
          'Reach IPO',
          QuestKind.fundingStage,
          6,
        ),
        AchievementDefinition(
          'prestige_1',
          'Serial Founder',
          'Prestige once',
          QuestKind.prestiges,
          1,
        ),
      ];

  final List<LiveOpsMissionDefinition> dailyMissions =
      const <LiveOpsMissionDefinition>[
        LiveOpsMissionDefinition(
          'daily_shipping',
          LiveOpsCadence.daily,
          'Daily shipping pulse',
          'Reach MVP stage in this company.',
          QuestKind.productStage,
          2,
          cashReward: 900,
          creditsReward: 90,
          featureBetReward: 1,
        ),
        LiveOpsMissionDefinition(
          'daily_hiring',
          LiveOpsCadence.daily,
          'Daily hiring pulse',
          'Grow the team to 8 people.',
          QuestKind.teamSize,
          8,
          cashReward: 700,
          creditsReward: 120,
          moraleReward: 6,
        ),
        LiveOpsMissionDefinition(
          'daily_revenue',
          LiveOpsCadence.daily,
          'Daily revenue pulse',
          'Reach 60K valuation.',
          QuestKind.valuation,
          60000,
          cashReward: 1200,
          creditsReward: 70,
          trustReward: 4,
        ),
      ];

  final List<LiveOpsMissionDefinition> weeklyMissions =
      const <LiveOpsMissionDefinition>[
        LiveOpsMissionDefinition(
          'weekly_launch',
          LiveOpsCadence.weekly,
          'Weekly launch mandate',
          'Reach Launch stage and prove the product has legs.',
          QuestKind.productStage,
          4,
          cashReward: 4500,
          creditsReward: 260,
          founderReputationReward: 1,
          contractReward: 1,
        ),
        LiveOpsMissionDefinition(
          'weekly_growth',
          LiveOpsCadence.weekly,
          'Weekly growth mandate',
          'Grow the team to 12 people in one run.',
          QuestKind.teamSize,
          12,
          cashReward: 3800,
          creditsReward: 220,
          boardInfluenceReward: 1,
          featureBetReward: 1,
        ),
        LiveOpsMissionDefinition(
          'weekly_operator',
          LiveOpsCadence.weekly,
          'Weekly operator mandate',
          'Earn 800 credits and prove the company can run on process.',
          QuestKind.credits,
          800,
          cashReward: 3200,
          creditsReward: 300,
          permanentOfflineMinutesReward: 30,
          contractReward: 1,
        ),
      ];

  final Set<String> completedQuests = <String>{};
  final Set<String> completedAchievements = <String>{};

  Future<void> loadAndStart() async {
    _prefs = await SharedPreferences.getInstance();
    if (resetForIntegration) {
      await _prefs!.remove(_saveKey);
      await _prefs!.remove('last_seen_ms');
    }
    final raw = _prefs!.getString(_saveKey);
    if (raw != null) {
      _loadFromJson(jsonDecode(raw) as Map<String, dynamic>);
    } else if (resetForIntegration) {
      _seedIntegrationState();
    }
    _applyOfflineEarnings();
    _log('Opened the office. Build something tiny, then make it huge.');
    _timer = async.Timer.periodic(const Duration(seconds: 1), (_) => tick(1));
    notifyListeners();
  }

  void tick(double seconds) {
    runSeconds += seconds.floor();
    final earned = autoIncomePerSecond * seconds;
    cash += earned;
    cash += founderAutomationPerSecond * seconds;
    if (sprintUnlocked) {
      productProgress += founderAutomationPerSecond * 0.18 * seconds;
      credits += founderAutomationPerSecond * 0.04 * seconds;
    }
    credits += creditsPerSecond * seconds;
    productProgress += progressPerSecond * seconds;
    reputation += reputationPerSecond * seconds;
    traction += tractionPerSecond * seconds;
    _tickTimedSystems(seconds);
    _refreshValuation();
    _checkGoals();
    if (DateTime.now().difference(_lastSave).inSeconds >= 5) {
      save();
    }
    notifyListeners();
  }

  void founderTap() {
    manualTaps += 1;
    cash += tapIncome;
    credits += 0.04 + systemLevel(StartupSystem.founderDashboard) * 0.02;
    productProgress += 0.2 + designers * 0.03;
    reputation += 0.03;
    if (tractionUnlocked) {
      traction += 0.06 * focusTractionMultiplier;
    }
    _addMomentum(4);
    _refreshValuation();
    _checkGoals();
    notifyListeners();
  }

  void buyTapUpgrade() => _buy('Founder Focus', tapUpgradeCost, () {
    tapLevel += 1;
    _addMomentum(10);
    _log('Founder focus upgraded to level $tapLevel.');
  });

  void buyOfficeUpgrade() {
    if (challengeBlocksOfficeUpgrade) {
      _log('Remote Only challenge caps office expansion at Lv.3.');
      notifyListeners();
      return;
    }
    _buy('Office Expansion', officeUpgradeCost, () {
      officeLevel += 1;
      _addMomentum(12);
      _log('Office expanded. Capacity is now $teamCapacity.');
      if (officeLevel == 2 || officeLevel == 5 || officeLevel == 8) {
        _log(officeMilestoneHeadline);
      }
    });
  }

  void hire(Role role) {
    if (!isRoleUnlocked(role)) {
      _log('${role.label} unlocks at ${role.unlockText}.');
      notifyListeners();
      return;
    }
    if (!hasTeamCapacity) {
      _log('Office is full. Expand before hiring more people.');
      notifyListeners();
      return;
    }
    if (!challengeAllowsHire) {
      _log('Current challenge caps the team at $challengeTeamCap people.');
      notifyListeners();
      return;
    }
    final cost = hireCost(role);
    _buy('Hire ${role.label}', cost, () {
      _roleCounts[role] = roleCount(role) + 1;
      _addMomentum(8);
      _log('Hired a ${role.label}. Team size: $teamSize/$teamCapacity.');
    });
  }

  void buySystem(StartupSystem system) {
    if (!isSystemUnlocked(system)) {
      _log('${system.label} unlocks at ${system.unlockText}.');
      notifyListeners();
      return;
    }
    final cost = systemCost(system);
    if (credits < cost) {
      _log('${system.label} needs ${formatNumber(cost)} credits.');
      notifyListeners();
      return;
    }
    credits -= cost;
    _systemLevels[system] = systemLevel(system) + 1;
    _addMomentum(6);
    _log('${system.label} upgraded to level ${systemLevel(system)}.');
    _refreshValuation();
    _checkGoals();
    save();
    notifyListeners();
  }

  void advanceProduct() {
    if (productStrategyChoicePending) {
      _log('Choose a product strategy card before shipping further.');
      notifyListeners();
      return;
    }
    if (!canAdvanceProduct) {
      _log('Product needs more progress before the next milestone.');
      notifyListeners();
      return;
    }
    productStageIndex += 1;
    cash += 75 * productStageIndex * productStageRewardMultiplier;
    credits += 18 * productStageIndex * productStageRewardMultiplier;
    reputation += 20 * productStageIndex * productStageRewardMultiplier;
    customerTrust += 4 + productStageIndex * 2;
    teamMorale += 2 + productStageIndex.toDouble();
    if (feedbackLoopUnlocked) {
      reputation += 10 * eventRewardMultiplier * playbookEventMultiplier;
    }
    if (strategyUnlocked) {
      focusTokens += 1;
    }
    if (productStageIndex >= 5) {
      featureBetTokens += 1;
    }
    if (tractionUnlocked) {
      traction += 12 * focusTractionMultiplier;
    }
    if (productStageIndex == 4) {
      _log('Launch unlocked traction. Growth roles now create market pull.');
      customerTrust += 10;
    }
    if (productStageIndex == 2 || productStageIndex == 5) {
      productStrategyChoicePending = true;
      productStrategyRefreshes += 1;
      _log(
        'New product strategy card unlocked. Pick a direction before the next ship.',
      );
    }
    if (productStageIndex == 5) {
      _log(
        'Growth unlocked feature bets. Product choices can now permanently reshape runs.',
      );
    }
    _addMomentum(24);
    _log(
      'Product reached $productStage. ${productMilestoneHeadline(productStageIndex)}',
    );
    _refreshValuation();
    _checkGoals();
    notifyListeners();
  }

  void raiseFunding() {
    if (capitalPolicyChoicePending) {
      _log('Choose a capital policy before raising the next round.');
      notifyListeners();
      return;
    }
    if (challengeBlocksFunding) {
      _log('Bootstrapped Run blocks fundraising until the challenge is done.');
      notifyListeners();
      return;
    }
    if (!canRaiseFunding) {
      _log('Valuation is not high enough for the next round.');
      notifyListeners();
      return;
    }
    fundingStageIndex += 1;
    final roundCash = fundingCost * 0.35 * capitalRoundRewardMultiplier;
    funding += roundCash;
    cash += roundCash;
    credits += 80 * fundingStageIndex * capitalRoundRewardMultiplier;
    reputation += 50 * fundingStageIndex * capitalRoundRewardMultiplier;
    customerTrust += activeCapitalPolicy == CapitalPolicy.efficientGrowth
        ? 6
        : activeCapitalPolicy == CapitalPolicy.blitzscaling
        ? -4
        : 2;
    teamMorale += activeCapitalPolicy == CapitalPolicy.talentFirst
        ? 8
        : activeCapitalPolicy == CapitalPolicy.blitzscaling
        ? -6
        : 1;
    focusTokens += fundingStageIndex >= 2 ? 1 : 0;
    if (fundingStageIndex >= 2) {
      crisisLevel += 1;
    }
    if (investorEventsUnlocked) {
      eventCooldownSeconds = math.min(eventCooldownSeconds, 18);
    }
    if (fundingStageIndex == 2 || fundingStageIndex == 4) {
      capitalPolicyChoicePending = true;
      capitalPolicyRefreshes += 1;
      _log(
        'Board policy decision unlocked. Pick a capital style before the next round.',
      );
    }
    if (fundingStageIndex == 2) {
      _log(
        'Seed introduced board pressure. New directives can now reshape the company.',
      );
    }
    if (fundingStageIndex == 6) {
      activeMarketPulse ??= MarketPulseType.bullRun;
      marketPulseSeconds = 120;
      _log(
        'IPO unlocked market volatility. Public sentiment now reshapes valuation.',
      );
    }
    if (fundingStageIndex == 7) {
      activeParentDirective ??= ParentDirectiveType.crossSell;
      parentDirectiveSeconds = 120;
      _log(
        'Acquisition unlocked parent-company directives and earn-out pressure.',
      );
    }
    _addMomentum(22);
    _log(
      'Raised $fundingStage. Cash injection: ${formatNumber(roundCash)}. ${fundingMilestoneHeadline(fundingStageIndex)}',
    );
    _refreshValuation();
    _checkGoals();
    notifyListeners();
  }

  void setCompanyFocus(CompanyFocus focus) {
    if (!strategyUnlocked) {
      _log('Reach MVP to unlock company focus.');
      notifyListeners();
      return;
    }
    if (focus == companyFocus) {
      _log('${focus.label} is already active.');
      notifyListeners();
      return;
    }
    if (companyFocus != CompanyFocus.balanced && focusTokens <= 0) {
      _log('Earn another strategy token from product or funding milestones.');
      notifyListeners();
      return;
    }
    if (companyFocus != CompanyFocus.balanced) {
      focusTokens -= 1;
    }
    companyFocus = focus;
    _log('Company focus shifted to ${focus.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void chooseProductStrategy(ProductStrategy strategy) {
    if (activeProductStrategy != null &&
        activeProductStrategy != strategy &&
        !productStrategyChoicePending) {
      if (productStrategyRefreshes <= 0) {
        _log(
          'No product strategy refreshes left. Earn one from milestones or achievements.',
        );
        notifyListeners();
        return;
      }
      productStrategyRefreshes -= 1;
    }
    activeProductStrategy = strategy;
    productStrategyChoicePending = false;
    _log('Product strategy chosen: ${strategy.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void chooseCapitalPolicy(CapitalPolicy policy) {
    if (activeCapitalPolicy != null &&
        activeCapitalPolicy != policy &&
        !capitalPolicyChoicePending) {
      if (capitalPolicyRefreshes <= 0) {
        _log(
          'No capital policy refreshes left. Earn one from milestones or achievements.',
        );
        notifyListeners();
        return;
      }
      capitalPolicyRefreshes -= 1;
    }
    activeCapitalPolicy = policy;
    capitalPolicyChoicePending = false;
    _log('Capital policy chosen: ${policy.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void chooseFeatureBet(FeatureBetType bet) {
    if (!featureBetsUnlocked) {
      _log('Reach Growth to unlock feature bets.');
      notifyListeners();
      return;
    }
    if (featureBetTokens <= 0) {
      _log('Ship more product milestones to earn feature bet tokens.');
      notifyListeners();
      return;
    }
    featureBetTokens -= 1;
    activeFeatureBet = bet;
    switch (bet) {
      case FeatureBetType.onboarding:
        onboardingLabLevel += 1;
        customerTrust += 10;
        break;
      case FeatureBetType.collaborationSuite:
        platformSuiteLevel += 1;
        valuation += math.max(500, autoIncomePerSecond * 180);
        break;
      case FeatureBetType.aiCopilot:
        aiCopilotLevel += 1;
        traction += 12;
        teamMorale -= 4;
        break;
    }
    _log('Feature bet shipped: ${bet.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void resolveBoardDemand(BoardDemandType demand) {
    if (!boardDemandsUnlocked) {
      _log('Board demands begin at Seed.');
      notifyListeners();
      return;
    }
    activeBoardDemand = demand;
    boardInfluence += 1;
    switch (demand) {
      case BoardDemandType.burnCut:
        cash += math.max(180, autoIncomePerSecond * 40);
        teamMorale -= 8;
        boardPressureSeconds = 70;
        break;
      case BoardDemandType.growthPush:
        traction += 14;
        customerTrust -= 8;
        boardPressureSeconds = 85;
        break;
      case BoardDemandType.qualityReset:
        customerTrust += 12;
        productProgress += math.max(18, progressPerSecond * 25);
        qualityResetSeconds = 95;
        break;
    }
    crisisLevel = math.max(0, crisisLevel - 1);
    _log('Board directive accepted: ${demand.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void resolveMarketPulse(MarketPulseType pulse) {
    if (!ipoUnlocked) {
      _log('Market volatility begins after IPO.');
      notifyListeners();
      return;
    }
    activeMarketPulse = pulse;
    switch (pulse) {
      case MarketPulseType.bullRun:
        valuation += math.max(1800, autoIncomePerSecond * 180);
        reputation += 20;
        break;
      case MarketPulseType.correction:
        customerTrust += 8;
        cash += math.max(600, autoIncomePerSecond * 55);
        break;
      case MarketPulseType.activistPressure:
        credits += math.max(100, creditsPerSecond * 70);
        teamMorale -= 6;
        boardInfluence += 1;
        break;
    }
    marketPulseSeconds = 110;
    _log('Market pulse accepted: ${pulse.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void resolveParentDirective(ParentDirectiveType directive) {
    if (fundingStageIndex < 7) {
      _log('Parent directives begin after acquisition.');
      notifyListeners();
      return;
    }
    activeParentDirective = directive;
    switch (directive) {
      case ParentDirectiveType.crossSell:
        traction += 14;
        cash += math.max(800, autoIncomePerSecond * 60);
        customerTrust -= 4;
        break;
      case ParentDirectiveType.earnOutLock:
        productProgress += math.max(26, progressPerSecond * 30);
        founderReputation += 1;
        teamMorale -= 8;
        break;
      case ParentDirectiveType.integrationAudit:
        credits += math.max(140, creditsPerSecond * 80);
        customerTrust += 10;
        break;
    }
    parentDirectiveSeconds = 125;
    _log('Parent directive accepted: ${directive.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void resolveEvent(String choice) {
    final event = activeEvent;
    if (event == null) {
      _log('No active startup event right now.');
      notifyListeners();
      return;
    }
    switch (event) {
      case StartupEventType.viralMoment:
        if (choice == secondaryEventChoiceLabel) {
          final progressBonus =
              math.max(18.0, progressPerSecond * 30) *
              eventRewardMultiplier *
              playbookEventMultiplier;
          productProgress += progressBonus;
          traction += tractionUnlocked
              ? 14 * productStrategyTractionMultiplier
              : 0;
          reputation += 12 * eventRewardMultiplier;
          customerTrust += 10;
          teamMorale += 4;
          deliveryConfidenceSeconds = 90;
          supportBacklogSeconds = math.max(0, supportBacklogSeconds - 30);
          _log(
            'Viral Moment converted into onboarding gains: +${formatNumber(progressBonus)} product progress and better retention.',
          );
        } else {
          final bonusCash =
              math.max(120.0, autoIncomePerSecond * 45) *
              eventRewardMultiplier *
              playbookEventMultiplier;
          cash += bonusCash;
          reputation += 18 * eventRewardMultiplier;
          traction += tractionUnlocked ? 8 * focusTractionMultiplier : 0;
          viralBoostSeconds = 75;
          supportBacklogSeconds = 95;
          customerTrust -= 12;
          teamMorale -= 6;
          _log(
            'Viral Moment activated: +${formatNumber(bonusCash)} cash and a short revenue burst.',
          );
        }
        break;
      case StartupEventType.investorCall:
        if (choice == secondaryEventChoiceLabel) {
          final valuationBoost =
              math.max(500.0, valuation * 0.08) *
              eventRewardMultiplier *
              playbookEventMultiplier;
          valuation += valuationBoost;
          reputation += 30 * eventRewardMultiplier;
          focusTokens += 1;
          customerTrust += 6;
          teamMorale -= 3;
          deliveryConfidenceSeconds = 50;
          _log(
            'Investor Call turned into a press cycle: +${formatNumber(valuationBoost)} valuation and stronger market buzz.',
          );
        } else {
          final bonusCash =
              math.max(180.0, fundingCost * 0.06) *
              eventRewardMultiplier *
              playbookEventMultiplier;
          cash += bonusCash;
          valuation += bonusCash * 2.8;
          reputation += 25 * eventRewardMultiplier;
          investorBuzzSeconds = 70;
          supportBacklogSeconds = math.max(supportBacklogSeconds, 40);
          focusTokens += 1;
          customerTrust -= 8;
          teamMorale += 2;
          _log(
            'Investor Call landed: +${formatNumber(bonusCash)} cash, board buzz, and +1 strategy token.',
          );
        }
        break;
      case StartupEventType.recruitingRush:
        if (choice == secondaryEventChoiceLabel) {
          final bonusCredits =
              math.max(24.0, creditsPerSecond * 70 + 18) *
              eventRewardMultiplier *
              playbookEventMultiplier;
          credits += bonusCredits;
          productProgress += 12 * eventRewardMultiplier;
          permanentTeamSlotBonus += 1;
          recruitingPipelineSeconds = 110;
          teamMorale += 12;
          customerTrust += 4;
          _log(
            'Talent Surge invested in pipeline training: +${formatNumber(bonusCredits)} credits, +1 team slot, and faster onboarding.',
          );
        } else {
          final bonusCredits =
              math.max(30.0, creditsPerSecond * 90 + 20) *
              eventRewardMultiplier *
              playbookEventMultiplier;
          credits += bonusCredits;
          recruitingRushSeconds = 80;
          recruitingPipelineSeconds = 50;
          teamMorale -= unlockedPlaybooks.contains(PlaybookId.peopleOpsManual)
              ? 2
              : 8;
          _log(
            'Talent Surge opened: +${formatNumber(bonusCredits)} credits and cheaper hiring for a while.',
          );
        }
        break;
    }
    activeEvent = null;
    eventCooldownSeconds = 55 * eventCooldownMultiplier;
    _addMomentum(18);
    _refreshValuation();
    _checkGoals();
    save();
    notifyListeners();
  }

  void activateEvent() {
    resolveEvent(primaryEventChoiceLabel);
  }

  void buyLegacyUpgrade(CompanyFocus focus) {
    if (legacyTokens <= 0) {
      _log('Prestige to earn legacy tokens.');
      notifyListeners();
      return;
    }
    legacyTokens -= 1;
    switch (focus) {
      case CompanyFocus.balanced:
        legacyTokens += 1;
        _log('Balanced mode has no legacy upgrade path.');
        break;
      case CompanyFocus.product:
        productLegacyLevel += 1;
        _log('Legacy upgraded: Product Playbook Lv.$productLegacyLevel.');
        break;
      case CompanyFocus.growth:
        growthLegacyLevel += 1;
        _log('Legacy upgraded: Growth Engine Lv.$growthLegacyLevel.');
        break;
      case CompanyFocus.finance:
        financeLegacyLevel += 1;
        _log('Legacy upgraded: Capital Discipline Lv.$financeLegacyLevel.');
        break;
    }
    _refreshValuation();
    save();
    notifyListeners();
  }

  void buyPortfolioUpgrade(PortfolioTrack track) {
    if (portfolioPoints <= 0) {
      _log('Close stronger companies to earn portfolio points.');
      notifyListeners();
      return;
    }
    portfolioPoints -= 1;
    switch (track) {
      case PortfolioTrack.talentBench:
        talentBenchLevel += 1;
        break;
      case PortfolioTrack.brandNetwork:
        brandNetworkLevel += 1;
        break;
      case PortfolioTrack.ventureFund:
        ventureFundLevel += 1;
        break;
    }
    _log('Portfolio upgraded: ${track.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void setVentureThesis(VentureThesis thesis) {
    if (!ventureThesisUnlocked) {
      _log('Reach a second prestige to unlock venture theses.');
      notifyListeners();
      return;
    }
    if (activeVentureThesis == thesis) {
      _log('${thesis.label} is already active.');
      notifyListeners();
      return;
    }
    if (activeVentureThesis != null && ventureThesisRefreshes <= 0) {
      _log('Earn another venture thesis refresh from bigger exits.');
      notifyListeners();
      return;
    }
    if (activeVentureThesis != null) {
      ventureThesisRefreshes -= 1;
    }
    activeVentureThesis = thesis;
    _log('Venture thesis switched to ${thesis.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void respondToCrisis(CrisisResponseType response) {
    if (!crisisRecoveryUnlocked) {
      _log('Crisis recovery unlocks after Seed or when pressure rises.');
      notifyListeners();
      return;
    }
    switch (response) {
      case CrisisResponseType.prRepair:
        if (cash < 600) {
          _log('PR Repair needs 600 cash.');
          notifyListeners();
          return;
        }
        cash -= 600;
        customerTrust += 14;
        reputation += 8;
        crisisLevel = math.max(0, crisisLevel - 2);
        supportBacklogSeconds = math.max(0, supportBacklogSeconds - 30);
        break;
      case CrisisResponseType.rescueFinancing:
        valuation *= 0.98;
        cash += math.max(900, fundingCost * 0.18);
        funding += 300;
        crisisLevel = math.max(0, crisisLevel - 1);
        teamMorale += 4;
        break;
      case CrisisResponseType.teamReset:
        teamMorale += 14;
        customerTrust += 6;
        qualityResetSeconds = math.max(qualityResetSeconds, 70);
        crisisLevel = math.max(0, crisisLevel - 1);
        founderMomentum = math.max(0, founderMomentum - 25);
        break;
    }
    _log('Crisis response used: ${response.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void setFounderSpecialization(FounderSpecialization specialization) {
    if (!founderSpecializationsUnlocked) {
      _log('Prestige once to unlock founder specializations.');
      notifyListeners();
      return;
    }
    activeSpecialization = specialization;
    _log('Founder specialization switched to ${specialization.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void setFounderOrigin(FounderOrigin origin) {
    if (!founderSpecializationsUnlocked) {
      _log('Prestige once to unlock founder origins.');
      notifyListeners();
      return;
    }
    if (origin == activeFounderOrigin) {
      _log('${origin.label} is already your founder origin.');
      notifyListeners();
      return;
    }
    if (founderOriginTokens <= 0) {
      _log(
        'Prestige or clear bigger milestones to earn another founder origin token.',
      );
      notifyListeners();
      return;
    }
    founderOriginTokens -= 1;
    activeFounderOrigin = origin;
    _log('Founder origin switched to ${origin.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void executeVentureMove(VentureMoveType move) {
    if (ventureFundLevel <= 0) {
      _log(
        'Upgrade Venture Fund in portfolio meta before operating the network.',
      );
      notifyListeners();
      return;
    }
    switch (move) {
      case VentureMoveType.scoutNetwork:
        if (founderReputation <= 0) {
          _log('Scout Network needs founder reputation.');
          notifyListeners();
          return;
        }
        founderReputation -= 1;
        ventureDealFlow += 1;
        if (!unlockedAdvisors.contains(AdvisorId.growthHacker)) {
          unlockedAdvisors.add(AdvisorId.growthHacker);
        } else {
          unlockedPlaybooks.add(PlaybookId.growthScript);
        }
        _log('Scout Network surfaced a stronger founder lead.');
        break;
      case VentureMoveType.studioSpinout:
        if (portfolioCompanies <= 0) {
          _log('Studio Spinout needs at least one portfolio company.');
          notifyListeners();
          return;
        }
        portfolioCompanies -= 1;
        ventureStudioLevel += 1;
        cash += 1200 + ventureStudioLevel * 400;
        productProgress += 18 + ventureStudioLevel * 6;
        _log(
          'Studio Spinout converted portfolio experience into launch capital.',
        );
        break;
      case VentureMoveType.syndicateAccess:
        if (portfolioPoints <= 0) {
          _log('Syndicate Access needs portfolio points.');
          notifyListeners();
          return;
        }
        portfolioPoints -= 1;
        syndicateNetworkLevel += 1;
        marketInsight += 90 + syndicateNetworkLevel * 20;
        boardInfluence += 1;
        _log('Syndicate Access widened your network and market visibility.');
        break;
    }
    _refreshValuation();
    save();
    notifyListeners();
  }

  void activateSeason(SeasonEventType season) {
    if (seasonTokens <= 0) {
      _log('Earn another season token from prestige or live ops.');
      notifyListeners();
      return;
    }
    seasonTokens -= 1;
    activeSeason = season;
    seasonSeconds = 180;
    _log('Season activated: ${season.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void upgradeFounderSpecialization(FounderSpecialization specialization) {
    if (!founderSpecializationsUnlocked) {
      _log('Prestige once to unlock founder specializations.');
      notifyListeners();
      return;
    }
    if (founderReputation <= 0) {
      _log('Prestige or clear challenges to earn founder reputation.');
      notifyListeners();
      return;
    }
    founderReputation -= 1;
    switch (specialization) {
      case FounderSpecialization.builder:
        builderLegacyLevel += 1;
        break;
      case FounderSpecialization.operator:
        operatorLegacyLevel += 1;
        break;
      case FounderSpecialization.rainmaker:
        rainmakerLegacyLevel += 1;
        break;
    }
    activeSpecialization ??= specialization;
    _log(
      'Founder specialization upgraded: ${specialization.label} Lv.${switch (specialization) {
        FounderSpecialization.builder => builderLegacyLevel,
        FounderSpecialization.operator => operatorLegacyLevel,
        FounderSpecialization.rainmaker => rainmakerLegacyLevel,
      }}.',
    );
    _refreshValuation();
    save();
    notifyListeners();
  }

  void equipAdvisor(AdvisorId advisor) {
    if (!unlockedAdvisors.contains(advisor)) {
      _log('${advisor.label} is not unlocked yet.');
      notifyListeners();
      return;
    }
    if (equippedAdvisor == advisor) {
      equippedAdvisor = null;
      _log('${advisor.label} moved back to the bench.');
    } else {
      equippedAdvisor = advisor;
      _log('${advisor.label} is now advising this run.');
    }
    _refreshValuation();
    save();
    notifyListeners();
  }

  void setTeamLead(TeamLeadFocus focus) {
    if (!teamLeadsUnlocked) {
      _log('Reach 6 team members to unlock team leads.');
      notifyListeners();
      return;
    }
    activeLead = activeLead == focus ? null : focus;
    _log(
      activeLead == null
          ? '${focus.label} moved off the assignment board.'
          : '${focus.label} is driving this run.',
    );
    _refreshValuation();
    save();
    notifyListeners();
  }

  void startProject(ProjectType project) {
    if (!crossProjectsUnlocked) {
      _log('Reach 10 team members to unlock cross-functional projects.');
      notifyListeners();
      return;
    }
    if (activeProject != null || readyProject != null) {
      _log('Finish the current project before starting another.');
      notifyListeners();
      return;
    }
    activeProject = project;
    activeProjectSeconds = switch (project) {
      ProjectType.launchWarRoom => 55,
      ProjectType.supportCommand => 50,
      ProjectType.revOpsEngine => 65,
    }.toDouble();
    teamMorale -= 3;
    _log('Cross-functional project started: ${project.label}.');
    save();
    notifyListeners();
  }

  void claimProject() {
    final project = readyProject;
    if (project == null) {
      _log('No completed project is ready.');
      notifyListeners();
      return;
    }
    switch (project) {
      case ProjectType.launchWarRoom:
        launchWarRoomLevel += 1;
        reputation += 10;
        break;
      case ProjectType.supportCommand:
        supportCommandLevel += 1;
        customerTrust += 10;
        teamMorale += 8;
        break;
      case ProjectType.revOpsEngine:
        revOpsEngineLevel += 1;
        valuation += math.max(600, autoIncomePerSecond * 120);
        break;
    }
    projectCompletions += 1;
    readyProject = null;
    _log('Project completed: ${project.label}.');
    _refreshValuation();
    save();
    notifyListeners();
  }

  void resolveCultureIncident(bool stabilize) {
    final incident = activeCultureIncident;
    if (incident == null) {
      _log('No culture incident is active right now.');
      notifyListeners();
      return;
    }
    if (stabilize) {
      customerTrust += 8;
      teamMorale += 12;
      cultureStability += 1;
      cash -= math.min(cash * 0.08, 1200);
      _log('Culture incident stabilized: ${incident.label}.');
    } else {
      cash += math.max(220, autoIncomePerSecond * 30);
      traction += 8;
      teamMorale -= 12;
      cultureStability = math.max(0, cultureStability - 1);
      _log('Culture incident pushed for speed: ${incident.label}.');
    }
    activeCultureIncident = null;
    _refreshValuation();
    save();
    notifyListeners();
  }

  void startChallenge(ChallengeId challenge) {
    if (!challengesUnlocked) {
      _log('Challenges unlock after the first prestige or 250K valuation.');
      notifyListeners();
      return;
    }
    if (completedChallenges.contains(challenge)) {
      _log('${challenge.label} is already completed.');
      notifyListeners();
      return;
    }
    if (activeChallenge == challenge) {
      _log('${challenge.label} is already active.');
      notifyListeners();
      return;
    }
    activeChallenge = challenge;
    _resetRunProgress();
    _log('Challenge started: ${challenge.label}. ${challenge.description}');
    save();
    notifyListeners();
  }

  void abandonChallenge() {
    if (activeChallenge == null) {
      _log('No active challenge to abandon.');
      notifyListeners();
      return;
    }
    final challenge = activeChallenge!;
    activeChallenge = null;
    _resetRunProgress();
    _log('Challenge abandoned: ${challenge.label}.');
    save();
    notifyListeners();
  }

  void claimLiveOpsMission(LiveOpsMissionDefinition mission) {
    if (!canClaimLiveOpsMission(mission)) {
      _log('${mission.title} is not ready to claim yet.');
      notifyListeners();
      return;
    }
    claimedLiveOpsMissions.add(liveOpsCycleId(mission));
    cash += mission.cashReward;
    credits += mission.creditsReward;
    featureBetTokens += mission.featureBetReward;
    contractWins += mission.contractReward;
    founderReputation += mission.founderReputationReward;
    boardInfluence += mission.boardInfluenceReward;
    permanentOfflineMinutes += mission.permanentOfflineMinutesReward;
    customerTrust += mission.trustReward;
    teamMorale += mission.moraleReward;
    _addMomentum(16);
    _log(
      '${mission.cadence.label} mission claimed: ${mission.title} (${liveOpsRewardText(mission)}).',
    );
    _refreshValuation();
    save();
    notifyListeners();
  }

  void investInExpansion() {
    if (!expansionUnlocked) {
      _log('Expansion unlocks at Seed or Launch.');
      notifyListeners();
      return;
    }
    if (marketInsight < nextExpansionInsight) {
      _log('Expansion needs ${formatNumber(nextExpansionInsight)} insight.');
      notifyListeners();
      return;
    }
    marketInsight -= nextExpansionInsight;
    marketExpansionLevel += 1;
    traction += 6 + marketExpansionLevel * 2;
    reputation += 14 + marketExpansionLevel * 4;
    _addMomentum(20);
    _log(
      'Opened market expansion Lv.$marketExpansionLevel. Contracts now hit harder.',
    );
    _refreshValuation();
    _checkGoals();
    save();
    notifyListeners();
  }

  void signExpansionContract() {
    if (!expansionUnlocked) {
      _log('Expansion unlocks at Seed or Launch.');
      notifyListeners();
      return;
    }
    if (marketExpansionLevel <= 0) {
      _log('Open the first expansion market before selling contracts.');
      notifyListeners();
      return;
    }
    final insightCost = 20 + contractWins * 12.0;
    if (marketInsight < insightCost) {
      _log('Next contract needs ${formatNumber(insightCost)} insight.');
      notifyListeners();
      return;
    }
    marketInsight -= insightCost;
    contractWins += 1;
    final contractCash =
        (650 + marketExpansionLevel * 280 + contractWins * 110) *
        advisorCashMultiplier;
    cash += contractCash;
    credits += 45 + marketExpansionLevel * 12;
    valuation += contractCash * (2.0 + marketExpansionLevel * 0.12);
    _log(
      'Expansion contract #$contractWins signed for ${formatNumber(contractCash)} cash.',
    );
    _refreshValuation();
    _checkGoals();
    save();
    notifyListeners();
  }

  void startContract(ContractType contract) {
    if (!isContractUnlocked(contract)) {
      _log('${contract.label} is not unlocked yet.');
      notifyListeners();
      return;
    }
    if (activeContract != null) {
      _log('Finish the active contract before starting another.');
      notifyListeners();
      return;
    }
    if (readyContract != null) {
      _log('Claim the completed contract reward first.');
      notifyListeners();
      return;
    }
    if (customerTrust < contract.requiredTrust) {
      _log(
        '${contract.label} needs ${contract.requiredTrust.toStringAsFixed(0)} trust.',
      );
      notifyListeners();
      return;
    }
    if (teamMorale < contract.requiredMorale) {
      _log(
        '${contract.label} needs ${contract.requiredMorale.toStringAsFixed(0)} morale.',
      );
      notifyListeners();
      return;
    }
    final insightCost = contractInsightCost(contract);
    if (marketInsight < insightCost) {
      _log('${contract.label} needs ${formatNumber(insightCost)} insight.');
      notifyListeners();
      return;
    }
    marketInsight -= insightCost;
    activeContract = contract;
    activeContractSeconds = contractDurationSeconds(contract).toDouble();
    customerTrust -= contract == ContractType.channelPartnership ? 3 : 0;
    teamMorale -= contract == ContractType.enterpriseRollout ? 4 : 1;
    _addMomentum(10);
    _log(
      'Contract started: ${contract.label}. Delivery ETA ${contractDurationSeconds(contract)}s. Success chance ${(contractSuccessChance(contract) * 100).round()}%.',
    );
    save();
    notifyListeners();
  }

  void claimReadyContract() {
    final contract = readyContract;
    if (contract == null) {
      _log('No completed contract is ready to claim.');
      notifyListeners();
      return;
    }
    final contractCash =
        contract.baseCashReward *
        contractRewardMultiplier *
        switch (contract) {
          ContractType.enterpriseRollout || ContractType.governmentTender
              when unlockedPlaybooks.contains(PlaybookId.enterpriseDeck) =>
            1.12,
          ContractType.startupPilot || ContractType.channelPartnership
              when unlockedPlaybooks.contains(PlaybookId.growthScript) =>
            1.08,
          _ => 1.0,
        };
    final contractCredits =
        contract.baseCreditReward *
        (1 + marketExpansionLevel * 0.08) *
        moraleMultiplier;
    cash += contractCash;
    credits += contractCredits;
    valuation += contractCash * contractValuationMultiplier;
    reputation += 8 + marketExpansionLevel * 3;
    traction += productStageIndex >= 4 ? 4 + marketExpansionLevel * 2 : 0;
    contractWins += 1;
    contractChain = math.min(5, contractChain + 1);
    contractChainSeconds = 150;
    customerTrust += switch (contract) {
      ContractType.startupPilot => 8,
      ContractType.talentBrandSprint => 10,
      ContractType.smbRollout => 6,
      ContractType.channelPartnership => 4,
      ContractType.enterpriseRollout => 7,
      ContractType.governmentTender => 12,
    };
    teamMorale += switch (contract) {
      ContractType.startupPilot => 4,
      ContractType.talentBrandSprint => 12,
      ContractType.smbRollout => 3,
      ContractType.channelPartnership => 2,
      ContractType.enterpriseRollout => -2,
      ContractType.governmentTender => -3,
    };
    _unlockPlaybookFromContract(contract);
    final rareDropText = _awardRareContractDrop(contract);
    lastContractSummary =
        '${contract.label}: +${formatNumber(contractCash)} cash, +${formatNumber(contractCredits)} credits.';
    if (rareDropText.isNotEmpty) {
      lastContractSummary = '$lastContractSummary $rareDropText';
    }
    if (contractChain >= 3 && contractChain % 3 == 0) {
      featureBetTokens += 1;
      lastContractSummary =
          '$lastContractSummary Chain reward: +1 feature bet token.';
    }
    readyContract = null;
    _addMomentum(20);
    _log('Contract closed: $lastContractSummary');
    _refreshValuation();
    _checkGoals();
    save();
    notifyListeners();
  }

  void watchRewardedAd() {
    rewardedAdsWatched += 1;
    final reward = math
        .max(250.0, autoIncomePerSecond * 180 + tapIncome * 25)
        .toDouble();
    final creditReward = math.max(10.0, creditsPerSecond * 120 + 15).toDouble();
    cash += reward;
    credits += creditReward;
    _refreshValuation();
    _log(
      'Rewarded boost: +${formatNumber(reward)} cash, +${formatNumber(creditReward)} credits.',
    );
    _checkGoals();
    notifyListeners();
  }

  void buyStarterPack() {
    if (starterPackOwned) {
      _log('Starter pack already owned.');
    } else {
      starterPackOwned = true;
      cash += 2500;
      credits += 180;
      reputation += 150;
      _refreshValuation();
      _checkGoals();
      _log('Starter pack placeholder granted cash, credits, and reputation.');
    }
    notifyListeners();
  }

  void buyNoAds() {
    noAdsOwned = true;
    _log('No Ads placeholder toggled. Real store product ID comes later.');
    notifyListeners();
  }

  void prestige() {
    if (!canPrestige) {
      _log('Reach ${formatNumber(prestigeTarget)} valuation to prestige.');
      notifyListeners();
      return;
    }
    final gained = math.max(1, math.sqrt(valuation / 1000000).floor());
    final portfolioGained = _portfolioPointsForExit();
    _updateRunRecords();
    prestigePoints += gained;
    lifetimePrestiges += 1;
    legacyTokens += gained;
    founderReputation += gained;
    founderOriginTokens += 1;
    seasonTokens += 1;
    ventureThesisRefreshes += lifetimePrestiges >= 1 ? 1 : 0;
    portfolioCompanies += 1;
    portfolioPoints += portfolioGained;
    activeSpecialization ??= FounderSpecialization.builder;
    if (lifetimePrestiges >= 2) {
      activeVentureThesis ??= VentureThesis.productStudio;
    }
    _resetRunProgress(eventCooldown: 25);
    _log(
      'Prestige complete. Gained $gained Prestige Points, $gained Legacy Tokens, $gained Founder Reputation, +1 Founder Origin Token, and $portfolioGained Portfolio Points.',
    );
    _checkGoals();
    save();
    notifyListeners();
  }

  void resetSave() {
    _resetRunProgress();
    prestigePoints = 0;
    lifetimePrestiges = 0;
    legacyTokens = 0;
    founderReputation = 0;
    founderOriginTokens = 0;
    seasonTokens = 0;
    portfolioCompanies = 0;
    portfolioPoints = 0;
    ventureDealFlow = 0;
    ventureStudioLevel = 0;
    syndicateNetworkLevel = 0;
    rewardedAdsWatched = 0;
    permanentTeamSlotBonus = 0;
    permanentOfflineMinutes = 120;
    eventRewardLevel = 0;
    productLegacyLevel = 0;
    growthLegacyLevel = 0;
    financeLegacyLevel = 0;
    talentBenchLevel = 0;
    brandNetworkLevel = 0;
    ventureFundLevel = 0;
    marketInsight = 0;
    challengeTokens = 0;
    marketExpansionLevel = 0;
    contractWins = 0;
    builderLegacyLevel = 0;
    operatorLegacyLevel = 0;
    rainmakerLegacyLevel = 0;
    productStrategyRefreshes = 0;
    capitalPolicyRefreshes = 0;
    ventureThesisRefreshes = 0;
    unlockedAdvisors.clear();
    unlockedPlaybooks.clear();
    unlockedTrophies.clear();
    completedChallenges.clear();
    claimedLiveOpsMissions.clear();
    equippedAdvisor = null;
    activeChallenge = null;
    activeSpecialization = null;
    activeFounderOrigin = FounderOrigin.builderLab;
    activeProductStrategy = null;
    activeCapitalPolicy = null;
    activeVentureThesis = null;
    activeSeason = null;
    productStrategyChoicePending = false;
    capitalPolicyChoicePending = false;
    peakValuationRecord = 0;
    fastestIpoSecondsRecord = 0;
    cleanBootstrappedRecord = false;
    runSeconds = 0;
    _eventRotationIndex = 0;
    starterPackOwned = false;
    noAdsOwned = false;
    completedAchievements.clear();
    eventLog.clear();
    _log('Fresh save started.');
    save();
    notifyListeners();
  }

  double get tapUpgradeCost => 15 * math.pow(1.55, tapLevel - 1).toDouble();
  double get officeUpgradeCost =>
      120 * math.pow(1.8, officeLevel - 1).toDouble();

  int roleCount(Role role) => _roleCounts[role] ?? 0;
  int systemLevel(StartupSystem system) => _systemLevels[system] ?? 0;

  bool isRoleUnlocked(Role role) {
    return officeLevel >= role.requiredOfficeLevel &&
        productStageIndex >= role.requiredProductStage;
  }

  bool isSystemUnlocked(StartupSystem system) {
    return officeLevel >= system.requiredOfficeLevel &&
        productStageIndex >= system.requiredProductStage;
  }

  bool isContractUnlocked(ContractType contract) {
    return contractsUnlocked &&
        productStageIndex >= contract.requiredProductStage &&
        fundingStageIndex >= contract.requiredFundingStage &&
        marketExpansionLevel >= contract.requiredExpansionLevel;
  }

  double hireCost(Role role) =>
      role.baseCost *
      math.pow(role.costGrowth, roleCount(role)).toDouble() *
      hireDiscountMultiplier *
      moraleHireDiscountMultiplier;
  double systemCost(StartupSystem system) =>
      system.baseCreditCost *
      math.pow(system.costGrowth, systemLevel(system)).toDouble();
  double contractInsightCost(ContractType contract) =>
      contract.baseInsightCost + contractWins * 5.0;
  double contractSuccessChance(ContractType contract) {
    final chance =
        0.50 +
        productStageIndex * 0.035 +
        fundingStageIndex * 0.025 +
        marketExpansionLevel * 0.03 +
        (customerTrust - 50) / 180 +
        (teamMorale - 50) / 220 +
        onboardingLabLevel * 0.025 +
        supportCommandLevel * 0.03 +
        (activeLead == TeamLeadFocus.operations ? 0.05 : 0.0) +
        (equippedAdvisor == AdvisorId.operatorCoach ? 0.06 : 0.0) +
        (unlockedPlaybooks.contains(PlaybookId.peopleOpsManual) ? 0.05 : 0.0) +
        (unlockedPlaybooks.contains(PlaybookId.enterpriseDeck) &&
                (contract == ContractType.enterpriseRollout ||
                    contract == ContractType.governmentTender)
            ? 0.08
            : 0.0) +
        (unlockedPlaybooks.contains(PlaybookId.growthScript) &&
                (contract == ContractType.startupPilot ||
                    contract == ContractType.channelPartnership)
            ? 0.05
            : 0.0) +
        eventContractSuccessModifier;
    return chance.clamp(0.18, 0.97);
  }

  String contractRiskLabel(ContractType contract) {
    final chance = contractSuccessChance(contract);
    if (chance >= 0.85) return 'Low risk';
    if (chance >= 0.68) return 'Medium risk';
    return 'High risk';
  }

  String contractFailurePreview(ContractType contract) => switch (contract) {
    ContractType.startupPilot =>
      'Failure: -6 trust, -4 morale, small reputation hit.',
    ContractType.talentBrandSprint =>
      'Failure: -8 morale, weaker hiring pipeline, -4 trust.',
    ContractType.smbRollout => 'Failure: -8 trust, -6 morale, +1 crisis.',
    ContractType.channelPartnership =>
      'Failure: -10 trust, -8 morale, event backlash.',
    ContractType.enterpriseRollout =>
      'Failure: -12 trust, -10 morale, +1 crisis and board pressure.',
    ContractType.governmentTender =>
      'Failure: -14 trust, -12 morale, +2 crisis and heavy board pressure.',
  };

  List<String> get activeConsequenceLabels {
    final labels = <String>[];
    if (founderFlowSeconds > 0) {
      labels.add('Founder flow ${founderFlowSeconds.ceil()}s');
    }
    if (comebackBurstSeconds > 0) {
      labels.add('Return surge ${comebackBurstSeconds.ceil()}s');
    }
    if (contractChain > 0) {
      labels.add('Deal chain x$contractChain');
    }
    if (supportBacklogSeconds > 0) {
      labels.add('Support backlog ${supportBacklogSeconds.ceil()}s');
    }
    if (deliveryConfidenceSeconds > 0) {
      labels.add('Delivery confidence ${deliveryConfidenceSeconds.ceil()}s');
    }
    if (recruitingPipelineSeconds > 0) {
      labels.add('Hiring pipeline ${recruitingPipelineSeconds.ceil()}s');
    }
    if (viralBoostSeconds > 0)
      labels.add('Revenue burst ${viralBoostSeconds.ceil()}s');
    if (investorBuzzSeconds > 0)
      labels.add('Board buzz ${investorBuzzSeconds.ceil()}s');
    if (recruitingRushSeconds > 0)
      labels.add('Hiring rush ${recruitingRushSeconds.ceil()}s');
    return labels;
  }

  String get officeMilestoneHeadline => switch (officeLevel) {
    2 =>
      'Office milestone: team capacity grows faster from structured seating.',
    5 => 'Office milestone: meeting rooms unlock stronger pod synergy.',
    8 => 'Office milestone: executive suite adds long-term operating leverage.',
    _ => 'Office expanded.',
  };

  String productMilestoneHeadline(int index) => switch (index) {
    1 => 'Customer feedback loops start sharpening the roadmap.',
    2 => 'Company focus cards are now available.',
    4 => 'Launch unlocked traction as a second growth resource.',
    5 => 'Growth stage strengthens go-to-market compounding.',
    6 => 'Scale stage rewards platform-style operations.',
    _ => 'The company gets a little more real.',
  };

  String fundingMilestoneHeadline(int index) => switch (index) {
    1 => 'Investor calls can now appear as burst events.',
    2 => 'Seed capital grants extra strategy flexibility.',
    4 => 'Global expansion boosts traction generation.',
    6 => 'IPO-grade visibility amplifies company valuation.',
    _ => 'Capital opens another layer of decisions.',
  };

  String questRewardText(QuestDefinition quest) => switch (quest.id) {
    'first_tap' => '+15 cash',
    'first_hire' => '+45 cash, +1 event level, and 1 policy refresh',
    'engineering_pod' => '+160 cash and faster events',
    'go_to_market' => '+240 cash and +5 traction',
    'ops_credit' => '+350 cash and +30m offline cap',
    'systems_three' => '+500 cash and +1 team slot',
    'mvp' => '+650 cash, +1 focus token, and 1 strategy refresh',
    'seed' => '+1200 cash, +1 focus token, and 1 policy refresh',
    'team_twelve' => '+2500 cash, +2 team slots, and ops synergy push',
    'million' => '+6000 cash, +1 event level, and founder reputation',
    _ => '+${formatNumber(quest.cashReward)} cash',
  };

  String achievementRewardText(
    AchievementDefinition achievement,
  ) => switch (achievement.id) {
    'tap_100' => '+1 Prestige Point and +1 event level',
    'credits_1k' => '+1 Prestige Point, +45m offline cap, and 1 policy refresh',
    'team_10' => '+1 Prestige Point, +1 team slot, and team synergy',
    'launch' => '+1 Prestige Point, +1 focus token, and 1 strategy refresh',
    'ipo' => '+1 Prestige Point, +1 Legacy Token, and +1 founder reputation',
    _ => '+1 Prestige Point',
  };

  LiveOpsMissionDefinition get currentDailyMission {
    final dayIndex =
        DateTime.now().toUtc().millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
    return dailyMissions[dayIndex % dailyMissions.length];
  }

  LiveOpsMissionDefinition get currentWeeklyMission {
    final weekIndex =
        DateTime.now().toUtc().millisecondsSinceEpoch ~/
        const Duration(days: 7).inMilliseconds;
    return weeklyMissions[weekIndex % weeklyMissions.length];
  }

  String liveOpsRewardText(LiveOpsMissionDefinition mission) {
    final rewards = <String>[];
    if (mission.cashReward > 0) {
      rewards.add('${formatNumber(mission.cashReward)} cash');
    }
    if (mission.creditsReward > 0) {
      rewards.add('${formatNumber(mission.creditsReward)} credits');
    }
    if (mission.featureBetReward > 0) {
      rewards.add('+${mission.featureBetReward} feature bet');
    }
    if (mission.contractReward > 0) {
      rewards.add('+${mission.contractReward} contract win');
    }
    if (mission.founderReputationReward > 0) {
      rewards.add('+${mission.founderReputationReward} founder reputation');
    }
    if (mission.boardInfluenceReward > 0) {
      rewards.add('+${mission.boardInfluenceReward} board influence');
    }
    if (mission.permanentOfflineMinutesReward > 0) {
      rewards.add('+${mission.permanentOfflineMinutesReward}m offline cap');
    }
    if (mission.trustReward > 0) {
      rewards.add('+${mission.trustReward} trust');
    }
    if (mission.moraleReward > 0) {
      rewards.add('+${mission.moraleReward} morale');
    }
    return rewards.join(', ');
  }

  String liveOpsCycleId(LiveOpsMissionDefinition mission) {
    final now = DateTime.now().toUtc();
    final dayIndex = now.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    final weekIndex =
        now.millisecondsSinceEpoch ~/ const Duration(days: 7).inMilliseconds;
    final cycle = mission.cadence == LiveOpsCadence.daily
        ? dayIndex
        : weekIndex;
    return '${mission.id}::$cycle';
  }

  bool isLiveOpsClaimed(LiveOpsMissionDefinition mission) =>
      claimedLiveOpsMissions.contains(liveOpsCycleId(mission));

  bool canClaimLiveOpsMission(LiveOpsMissionDefinition mission) =>
      !isLiveOpsClaimed(mission) && progressFor(mission.kind) >= mission.target;

  double progressFor(QuestKind kind) {
    return switch (kind) {
      QuestKind.taps => manualTaps.toDouble(),
      QuestKind.developers => developers.toDouble(),
      QuestKind.engineeringTeam => _departmentCount(
        Department.engineering,
      ).toDouble(),
      QuestKind.goToMarketTeam =>
        (_departmentCount(Department.growth) +
                _departmentCount(Department.sales))
            .toDouble(),
      QuestKind.opsTeam =>
        (_departmentCount(Department.operations) +
                _departmentCount(Department.data) +
                _departmentCount(Department.finance))
            .toDouble(),
      QuestKind.teamSize => teamSize.toDouble(),
      QuestKind.productStage => productStageIndex.toDouble(),
      QuestKind.fundingStage => fundingStageIndex.toDouble(),
      QuestKind.valuation => valuation,
      QuestKind.cash => cash,
      QuestKind.credits => credits,
      QuestKind.startupSystems => systemLevelTotal.toDouble(),
      QuestKind.prestiges => lifetimePrestiges.toDouble(),
    };
  }

  void _buy(String label, double cost, VoidCallback apply) {
    if (cash < cost) {
      _log('$label needs ${formatNumber(cost)} cash.');
      notifyListeners();
      return;
    }
    cash -= cost;
    apply();
    _refreshValuation();
    _checkGoals();
    save();
    notifyListeners();
  }

  void _refreshValuation() {
    final revenuePower = math.max(
      1,
      autoIncomePerSecond * 900 +
          cash * 0.25 +
          funding +
          credits * 4 +
          traction * 24,
    );
    final productMultiple =
        (1 + productStageIndex * 0.75) * productLegacyMultiplier;
    final marketMultiple =
        1 +
        fundingStageIndex * 0.55 +
        reputation / 1000 +
        marketExpansionLevel * 0.4;
    valuation = math.max(
      valuation,
      revenuePower *
          productMultiple *
          marketMultiple *
          departmentValuationMultiplier *
          focusValuationMultiplier *
          trustMultiplier *
          marketPulseTrustMultiplier *
          financeLegacyMultiplier *
          ventureFundMultiplier *
          holdingPlatformMultiplier *
          marketPulseValuationMultiplier *
          systemValuationMultiplier,
    );
  }

  void _checkGoals() {
    _unlockMetaSystems();
    _checkChallengeCompletion();
    _checkCollectionMilestones();
    for (final quest in quests) {
      if (!completedQuests.contains(quest.id) &&
          progressFor(quest.kind) >= quest.target) {
        completedQuests.add(quest.id);
        _applyQuestReward(quest);
      }
    }
    for (final achievement in achievements) {
      if (!completedAchievements.contains(achievement.id) &&
          progressFor(achievement.kind) >= achievement.target) {
        completedAchievements.add(achievement.id);
        _applyAchievementReward(achievement);
      }
    }
  }

  void _updateRunRecords() {
    if (valuation > peakValuationRecord) {
      peakValuationRecord = valuation;
    }
    if (fundingStageIndex >= 6 &&
        (fastestIpoSecondsRecord == 0 ||
            runSeconds < fastestIpoSecondsRecord)) {
      fastestIpoSecondsRecord = runSeconds;
    }
    if (productStageIndex >= 4 && fundingStageIndex == 0) {
      cleanBootstrappedRecord = true;
    }
  }

  void _applyOfflineEarnings() {
    final lastSeenMs = _prefs?.getInt('last_seen_ms');
    if (lastSeenMs == null) return;
    final elapsed = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(lastSeenMs),
    );
    final seconds = elapsed.inSeconds.clamp(0, permanentOfflineMinutes * 60);
    if (seconds < 10) return;
    final earned = autoIncomePerSecond * seconds;
    final creditGain = creditsPerSecond * seconds * 0.6;
    final productGain = progressPerSecond * seconds * 0.35;
    final tractionGain = tractionPerSecond * seconds * 0.45;
    cash += earned;
    credits += creditGain;
    productProgress += productGain;
    traction += tractionGain;
    lastOfflineCash = earned;
    lastOfflineCredits = creditGain;
    lastOfflineProduct = productGain;
    lastOfflineTraction = tractionGain;
    lastOfflineSeconds = seconds;
    offlineBriefLines = _buildOfflineBriefLines(seconds);
    offlineSummaryPending = true;
    _refreshValuation();
  }

  void dismissOfflineSummary() {
    if (lastOfflineSeconds >= 600) {
      comebackBurstSeconds = math.max(comebackBurstSeconds, 90);
      founderMomentum = math.max(founderMomentum, 35);
      _unlockTrophy(FounderTrophyId.comebackKid);
      _log('Re-entry surge active for 90s. Ride the return spike.');
    }
    offlineSummaryPending = false;
    offlineBriefLines = <String>[];
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = _prefs;
    if (prefs == null) return;
    _lastSave = DateTime.now();
    await prefs.setInt('last_seen_ms', DateTime.now().millisecondsSinceEpoch);
    await prefs.setString(_saveKey, jsonEncode(_toJson()));
  }

  Map<String, dynamic> _toJson() {
    return <String, dynamic>{
      'schemaVersion': schemaVersion,
      'cash': cash,
      'credits': credits,
      'valuation': valuation,
      'reputation': reputation,
      'productProgress': productProgress,
      'funding': funding,
      'traction': traction,
      'marketInsight': marketInsight,
      'customerTrust': customerTrust,
      'teamMorale': teamMorale,
      'prestigePoints': prestigePoints,
      'lifetimePrestiges': lifetimePrestiges,
      'legacyTokens': legacyTokens,
      'founderReputation': founderReputation,
      'founderOriginTokens': founderOriginTokens,
      'seasonTokens': seasonTokens,
      'ventureThesisRefreshes': ventureThesisRefreshes,
      'portfolioCompanies': portfolioCompanies,
      'portfolioPoints': portfolioPoints,
      'ventureDealFlow': ventureDealFlow,
      'ventureStudioLevel': ventureStudioLevel,
      'syndicateNetworkLevel': syndicateNetworkLevel,
      'tapLevel': tapLevel,
      'officeLevel': officeLevel,
      'roles': {for (final role in Role.values) role.name: roleCount(role)},
      'systems': {
        for (final system in StartupSystem.values)
          system.name: systemLevel(system),
      },
      'productStageIndex': productStageIndex,
      'fundingStageIndex': fundingStageIndex,
      'manualTaps': manualTaps,
      'rewardedAdsWatched': rewardedAdsWatched,
      'focusTokens': focusTokens,
      'permanentTeamSlotBonus': permanentTeamSlotBonus,
      'permanentOfflineMinutes': permanentOfflineMinutes,
      'eventRewardLevel': eventRewardLevel,
      'productLegacyLevel': productLegacyLevel,
      'growthLegacyLevel': growthLegacyLevel,
      'financeLegacyLevel': financeLegacyLevel,
      'talentBenchLevel': talentBenchLevel,
      'brandNetworkLevel': brandNetworkLevel,
      'ventureFundLevel': ventureFundLevel,
      'challengeTokens': challengeTokens,
      'marketExpansionLevel': marketExpansionLevel,
      'contractWins': contractWins,
      'builderLegacyLevel': builderLegacyLevel,
      'operatorLegacyLevel': operatorLegacyLevel,
      'rainmakerLegacyLevel': rainmakerLegacyLevel,
      'founderMomentum': founderMomentum,
      'founderFlowSeconds': founderFlowSeconds,
      'comebackBurstSeconds': comebackBurstSeconds,
      'contractChain': contractChain,
      'contractChainSeconds': contractChainSeconds,
      'eventCooldownSeconds': eventCooldownSeconds,
      'supportBacklogSeconds': supportBacklogSeconds,
      'deliveryConfidenceSeconds': deliveryConfidenceSeconds,
      'recruitingPipelineSeconds': recruitingPipelineSeconds,
      'viralBoostSeconds': viralBoostSeconds,
      'investorBuzzSeconds': investorBuzzSeconds,
      'recruitingRushSeconds': recruitingRushSeconds,
      'marketPulseSeconds': marketPulseSeconds,
      'parentDirectiveSeconds': parentDirectiveSeconds,
      'seasonSeconds': seasonSeconds,
      'activeContract': activeContract?.name,
      'activeContractSeconds': activeContractSeconds,
      'readyContract': readyContract?.name,
      'lastContractSummary': lastContractSummary,
      'companyFocus': companyFocus.name,
      'activeFounderOrigin': activeFounderOrigin.name,
      'activeEvent': activeEvent?.name,
      'activeProductStrategy': activeProductStrategy?.name,
      'activeCapitalPolicy': activeCapitalPolicy?.name,
      'activeVentureThesis': activeVentureThesis?.name,
      'activeMarketPulse': activeMarketPulse?.name,
      'activeParentDirective': activeParentDirective?.name,
      'activeSeason': activeSeason?.name,
      'productStrategyChoicePending': productStrategyChoicePending,
      'capitalPolicyChoicePending': capitalPolicyChoicePending,
      'productStrategyRefreshes': productStrategyRefreshes,
      'capitalPolicyRefreshes': capitalPolicyRefreshes,
      'eventRotationIndex': _eventRotationIndex,
      'starterPackOwned': starterPackOwned,
      'noAdsOwned': noAdsOwned,
      'unlockedPlaybooks': unlockedPlaybooks
          .map((playbook) => playbook.name)
          .toList(),
      'unlockedAdvisors': unlockedAdvisors
          .map((advisor) => advisor.name)
          .toList(),
      'unlockedTrophies': unlockedTrophies
          .map<String>((trophy) => trophy.name)
          .toList(),
      'completedChallenges': completedChallenges
          .map((challenge) => challenge.name)
          .toList(),
      'claimedLiveOpsMissions': claimedLiveOpsMissions.toList(),
      'equippedAdvisor': equippedAdvisor?.name,
      'activeChallenge': activeChallenge?.name,
      'activeSpecialization': activeSpecialization?.name,
      'peakValuationRecord': peakValuationRecord,
      'fastestIpoSecondsRecord': fastestIpoSecondsRecord,
      'cleanBootstrappedRecord': cleanBootstrappedRecord,
      'runSeconds': runSeconds,
      'completedQuests': completedQuests.toList(),
      'completedAchievements': completedAchievements.toList(),
    };
  }

  void _loadFromJson(Map<String, dynamic> json) {
    double number(String key) => (json[key] as num?)?.toDouble() ?? 0;
    int integer(String key, [int fallback = 0]) =>
        (json[key] as num?)?.toInt() ?? fallback;
    cash = number('cash');
    credits = number('credits');
    valuation = number('valuation');
    reputation = number('reputation');
    productProgress = number('productProgress');
    funding = number('funding');
    traction = number('traction');
    marketInsight = number('marketInsight');
    customerTrust = number('customerTrust');
    if (customerTrust == 0) customerTrust = 55;
    teamMorale = number('teamMorale');
    if (teamMorale == 0) teamMorale = 55;
    prestigePoints = integer('prestigePoints');
    lifetimePrestiges = integer('lifetimePrestiges');
    legacyTokens = integer('legacyTokens');
    founderReputation = integer('founderReputation');
    founderOriginTokens = integer('founderOriginTokens');
    seasonTokens = integer('seasonTokens');
    ventureThesisRefreshes = integer('ventureThesisRefreshes');
    portfolioCompanies = integer('portfolioCompanies');
    portfolioPoints = integer('portfolioPoints');
    ventureDealFlow = integer('ventureDealFlow');
    ventureStudioLevel = integer('ventureStudioLevel');
    syndicateNetworkLevel = integer('syndicateNetworkLevel');
    tapLevel = integer('tapLevel', 1);
    officeLevel = integer('officeLevel', 1);
    _loadRoleCounts(json);
    _loadSystemLevels(json);
    productStageIndex = integer('productStageIndex');
    fundingStageIndex = integer('fundingStageIndex');
    manualTaps = integer('manualTaps');
    rewardedAdsWatched = integer('rewardedAdsWatched');
    focusTokens = integer('focusTokens');
    permanentTeamSlotBonus = integer('permanentTeamSlotBonus');
    permanentOfflineMinutes = integer('permanentOfflineMinutes', 120);
    eventRewardLevel = integer('eventRewardLevel');
    productLegacyLevel = integer('productLegacyLevel');
    growthLegacyLevel = integer('growthLegacyLevel');
    financeLegacyLevel = integer('financeLegacyLevel');
    talentBenchLevel = integer('talentBenchLevel');
    brandNetworkLevel = integer('brandNetworkLevel');
    ventureFundLevel = integer('ventureFundLevel');
    challengeTokens = integer('challengeTokens');
    marketExpansionLevel = integer('marketExpansionLevel');
    contractWins = integer('contractWins');
    builderLegacyLevel = integer('builderLegacyLevel');
    operatorLegacyLevel = integer('operatorLegacyLevel');
    rainmakerLegacyLevel = integer('rainmakerLegacyLevel');
    founderMomentum = number('founderMomentum');
    founderFlowSeconds = number('founderFlowSeconds');
    comebackBurstSeconds = number('comebackBurstSeconds');
    contractChain = integer('contractChain');
    contractChainSeconds = number('contractChainSeconds');
    eventCooldownSeconds =
        (json['eventCooldownSeconds'] as num?)?.toDouble() ?? 35;
    supportBacklogSeconds =
        (json['supportBacklogSeconds'] as num?)?.toDouble() ?? 0;
    deliveryConfidenceSeconds =
        (json['deliveryConfidenceSeconds'] as num?)?.toDouble() ?? 0;
    recruitingPipelineSeconds =
        (json['recruitingPipelineSeconds'] as num?)?.toDouble() ?? 0;
    viralBoostSeconds = (json['viralBoostSeconds'] as num?)?.toDouble() ?? 0;
    investorBuzzSeconds =
        (json['investorBuzzSeconds'] as num?)?.toDouble() ?? 0;
    recruitingRushSeconds =
        (json['recruitingRushSeconds'] as num?)?.toDouble() ?? 0;
    marketPulseSeconds = (json['marketPulseSeconds'] as num?)?.toDouble() ?? 0;
    parentDirectiveSeconds =
        (json['parentDirectiveSeconds'] as num?)?.toDouble() ?? 0;
    seasonSeconds = (json['seasonSeconds'] as num?)?.toDouble() ?? 0;
    final activeContractName = json['activeContract'] as String?;
    activeContract = activeContractName == null
        ? null
        : ContractType.values.firstWhere(
            (contract) => contract.name == activeContractName,
            orElse: () => ContractType.startupPilot,
          );
    activeContractSeconds =
        (json['activeContractSeconds'] as num?)?.toDouble() ?? 0;
    final readyContractName = json['readyContract'] as String?;
    readyContract = readyContractName == null
        ? null
        : ContractType.values.firstWhere(
            (contract) => contract.name == readyContractName,
            orElse: () => ContractType.startupPilot,
          );
    lastContractSummary = json['lastContractSummary'] as String? ?? '';
    final savedFocus = json['companyFocus'] as String?;
    companyFocus = CompanyFocus.values.firstWhere(
      (focus) => focus.name == savedFocus,
      orElse: () => CompanyFocus.balanced,
    );
    final activeFounderOriginName = json['activeFounderOrigin'] as String?;
    activeFounderOrigin = FounderOrigin.values.firstWhere(
      (origin) => origin.name == activeFounderOriginName,
      orElse: () => FounderOrigin.builderLab,
    );
    final activeEventName = json['activeEvent'] as String?;
    activeEvent = activeEventName == null
        ? null
        : StartupEventType.values.firstWhere(
            (event) => event.name == activeEventName,
            orElse: () => StartupEventType.viralMoment,
          );
    final activeProductStrategyName = json['activeProductStrategy'] as String?;
    activeProductStrategy = activeProductStrategyName == null
        ? null
        : ProductStrategy.values.firstWhere(
            (strategy) => strategy.name == activeProductStrategyName,
            orElse: () => ProductStrategy.craft,
          );
    final activeCapitalPolicyName = json['activeCapitalPolicy'] as String?;
    activeCapitalPolicy = activeCapitalPolicyName == null
        ? null
        : CapitalPolicy.values.firstWhere(
            (policy) => policy.name == activeCapitalPolicyName,
            orElse: () => CapitalPolicy.efficientGrowth,
          );
    final activeVentureThesisName = json['activeVentureThesis'] as String?;
    activeVentureThesis = activeVentureThesisName == null
        ? null
        : VentureThesis.values.firstWhere(
            (thesis) => thesis.name == activeVentureThesisName,
            orElse: () => VentureThesis.productStudio,
          );
    final activeMarketPulseName = json['activeMarketPulse'] as String?;
    activeMarketPulse = activeMarketPulseName == null
        ? null
        : MarketPulseType.values.firstWhere(
            (pulse) => pulse.name == activeMarketPulseName,
            orElse: () => MarketPulseType.bullRun,
          );
    final activeParentDirectiveName = json['activeParentDirective'] as String?;
    activeParentDirective = activeParentDirectiveName == null
        ? null
        : ParentDirectiveType.values.firstWhere(
            (directive) => directive.name == activeParentDirectiveName,
            orElse: () => ParentDirectiveType.crossSell,
          );
    final activeSeasonName = json['activeSeason'] as String?;
    activeSeason = activeSeasonName == null
        ? null
        : SeasonEventType.values.firstWhere(
            (season) => season.name == activeSeasonName,
            orElse: () => SeasonEventType.builderSummit,
          );
    productStrategyChoicePending = json['productStrategyChoicePending'] == true;
    capitalPolicyChoicePending = json['capitalPolicyChoicePending'] == true;
    productStrategyRefreshes = integer('productStrategyRefreshes');
    capitalPolicyRefreshes = integer('capitalPolicyRefreshes');
    _eventRotationIndex = integer('eventRotationIndex');
    starterPackOwned = json['starterPackOwned'] == true;
    noAdsOwned = json['noAdsOwned'] == true;
    unlockedPlaybooks
      ..clear()
      ..addAll(
        (json['unlockedPlaybooks'] as List<dynamic>? ?? const <dynamic>[]).map(
          (value) => PlaybookId.values.firstWhere(
            (playbook) => playbook.name == value,
            orElse: () => PlaybookId.growthScript,
          ),
        ),
      );
    unlockedAdvisors
      ..clear()
      ..addAll(
        (json['unlockedAdvisors'] as List<dynamic>? ?? const <dynamic>[]).map(
          (value) => AdvisorId.values.firstWhere(
            (advisor) => advisor.name == value,
            orElse: () => AdvisorId.productSage,
          ),
        ),
      );
    unlockedTrophies
      ..clear()
      ..addAll(
        (json['unlockedTrophies'] as List<dynamic>? ?? const <dynamic>[]).map(
          (value) => FounderTrophyId.values.firstWhere(
            (trophy) => trophy.name == value,
            orElse: () => FounderTrophyId.flowState,
          ),
        ),
      );
    completedChallenges
      ..clear()
      ..addAll(
        (json['completedChallenges'] as List<dynamic>? ?? const <dynamic>[])
            .map(
              (value) => ChallengeId.values.firstWhere(
                (challenge) => challenge.name == value,
                orElse: () => ChallengeId.bootstrappedRun,
              ),
            ),
      );
    claimedLiveOpsMissions
      ..clear()
      ..addAll(
        (json['claimedLiveOpsMissions'] as List<dynamic>? ?? const <dynamic>[])
            .cast<String>(),
      );
    final equippedAdvisorName = json['equippedAdvisor'] as String?;
    equippedAdvisor = equippedAdvisorName == null
        ? null
        : AdvisorId.values.firstWhere(
            (advisor) => advisor.name == equippedAdvisorName,
            orElse: () => AdvisorId.productSage,
          );
    final activeChallengeName = json['activeChallenge'] as String?;
    activeChallenge = activeChallengeName == null
        ? null
        : ChallengeId.values.firstWhere(
            (challenge) => challenge.name == activeChallengeName,
            orElse: () => ChallengeId.bootstrappedRun,
          );
    final activeSpecializationName = json['activeSpecialization'] as String?;
    activeSpecialization = activeSpecializationName == null
        ? null
        : FounderSpecialization.values.firstWhere(
            (specialization) => specialization.name == activeSpecializationName,
            orElse: () => FounderSpecialization.builder,
          );
    peakValuationRecord = number('peakValuationRecord');
    fastestIpoSecondsRecord = integer('fastestIpoSecondsRecord');
    cleanBootstrappedRecord = json['cleanBootstrappedRecord'] == true;
    runSeconds = integer('runSeconds');
    completedQuests
      ..clear()
      ..addAll(
        (json['completedQuests'] as List<dynamic>? ?? const <dynamic>[])
            .cast<String>(),
      );
    completedAchievements
      ..clear()
      ..addAll(
        (json['completedAchievements'] as List<dynamic>? ?? const <dynamic>[])
            .cast<String>(),
      );
  }

  void _loadRoleCounts(Map<String, dynamic> json) {
    _roleCounts
      ..clear()
      ..addEntries(Role.values.map((role) => MapEntry(role, 0)));
    final roles = json['roles'];
    if (roles is Map) {
      for (final role in Role.values) {
        _roleCounts[role] = (roles[role.name] as num?)?.toInt() ?? 0;
      }
      return;
    }
    _roleCounts[Role.juniorDeveloper] =
        (json['developers'] as num?)?.toInt() ?? 0;
    _roleCounts[Role.uxDesigner] = (json['designers'] as num?)?.toInt() ?? 0;
    _roleCounts[Role.growthMarketer] =
        (json['marketers'] as num?)?.toInt() ?? 0;
    _roleCounts[Role.salesRep] = (json['sales'] as num?)?.toInt() ?? 0;
  }

  void _loadSystemLevels(Map<String, dynamic> json) {
    _systemLevels
      ..clear()
      ..addEntries(StartupSystem.values.map((system) => MapEntry(system, 0)));
    final systems = json['systems'];
    if (systems is Map) {
      for (final system in StartupSystem.values) {
        _systemLevels[system] = (systems[system.name] as num?)?.toInt() ?? 0;
      }
    }
  }

  void _seedIntegrationState() {
    cash = 28000;
    credits = 4200;
    valuation = 420000;
    reputation = 620;
    productProgress = 520;
    funding = 3200;
    traction = 48;
    marketInsight = 420;
    tapLevel = 4;
    officeLevel = 5;
    _roleCounts[Role.juniorDeveloper] = 1;
    _roleCounts[Role.uxDesigner] = 1;
    _roleCounts[Role.growthMarketer] = 1;
    _roleCounts[Role.productManager] = 1;
    _roleCounts[Role.accountExecutive] = 1;
    _roleCounts[Role.dataAnalyst] = 1;
    _systemLevels[StartupSystem.founderDashboard] = 1;
    _systemLevels[StartupSystem.recruitingPipeline] = 1;
    _systemLevels[StartupSystem.analyticsStack] = 1;
    unlockedAdvisors.add(AdvisorId.productSage);
    unlockedAdvisors.add(AdvisorId.financeChief);
    lifetimePrestiges = 1;
    founderReputation = 2;
    builderLegacyLevel = 1;
    activeSpecialization = FounderSpecialization.builder;
    activeProductStrategy = ProductStrategy.craft;
    activeCapitalPolicy = CapitalPolicy.efficientGrowth;
    productStageIndex = 4;
    fundingStageIndex = 2;
    marketExpansionLevel = 1;
    contractWins = 1;
    featureBetTokens = 1;
    boardInfluence = 1;
    crisisLevel = 2;
    activeBoardDemand = BoardDemandType.growthPush;
    activeEvent = StartupEventType.viralMoment;
    customerTrust = 82;
    teamMorale = 78;
    portfolioCompanies = 1;
    portfolioPoints = 2;
    brandNetworkLevel = 1;
    unlockedPlaybooks.add(PlaybookId.growthScript);
    eventCooldownSeconds = 0;
  }

  void _clearRunMaps() {
    for (final role in Role.values) {
      _roleCounts[role] = 0;
    }
    for (final system in StartupSystem.values) {
      _systemLevels[system] = 0;
    }
  }

  int _departmentCount(Department department) => Role.values
      .where((role) => role.department == department)
      .fold<int>(0, (sum, role) => sum + roleCount(role));

  void _tickTimedSystems(double seconds) {
    founderMomentum = math.max(
      0,
      founderMomentum - seconds * (founderFlowSeconds > 0 ? 0.4 : 1.6),
    );
    founderFlowSeconds = math.max(0, founderFlowSeconds - seconds);
    comebackBurstSeconds = math.max(0, comebackBurstSeconds - seconds);
    contractChainSeconds = math.max(0, contractChainSeconds - seconds);
    supportBacklogSeconds = math.max(0, supportBacklogSeconds - seconds);
    deliveryConfidenceSeconds = math.max(
      0,
      deliveryConfidenceSeconds - seconds,
    );
    recruitingPipelineSeconds = math.max(
      0,
      recruitingPipelineSeconds - seconds,
    );
    viralBoostSeconds = math.max(0, viralBoostSeconds - seconds);
    investorBuzzSeconds = math.max(0, investorBuzzSeconds - seconds);
    recruitingRushSeconds = math.max(0, recruitingRushSeconds - seconds);
    boardPressureSeconds = math.max(0, boardPressureSeconds - seconds);
    qualityResetSeconds = math.max(0, qualityResetSeconds - seconds);
    marketPulseSeconds = math.max(0, marketPulseSeconds - seconds);
    parentDirectiveSeconds = math.max(0, parentDirectiveSeconds - seconds);
    seasonSeconds = math.max(0, seasonSeconds - seconds);
    if (marketPulseSeconds <= 0 && ipoUnlocked && activeMarketPulse != null) {
      activeMarketPulse = null;
    }
    if (parentDirectiveSeconds <= 0 &&
        fundingStageIndex >= 7 &&
        activeParentDirective != null) {
      activeParentDirective = null;
    }
    if (seasonSeconds <= 0 && activeSeason != null) {
      activeSeason = null;
    }
    if (activeProject != null) {
      activeProjectSeconds = math.max(0, activeProjectSeconds - seconds);
      if (activeProjectSeconds <= 0) {
        readyProject = activeProject;
        activeProject = null;
        _log('Project ready to claim: ${readyProject!.label}.');
      }
    }
    marketInsight += marketInsightPerSecond * seconds;
    if (activeContract != null) {
      activeContractSeconds = math.max(0, activeContractSeconds - seconds);
      if (activeContractSeconds <= 0) {
        final contract = activeContract!;
        activeContract = null;
        if (_contractSucceeded(contract)) {
          readyContract = contract;
          _log(
            'Contract ready to close: ${readyContract!.label}. Claim the payout.',
          );
        } else {
          _applyContractFailure(contract);
        }
      }
    }
    if (activeChallenge == ChallengeId.hypergrowthRun &&
        reputation < challengeReputationFloor) {
      reputation = challengeReputationFloor;
    }
    if (boardDemandsUnlocked && crisisLevel >= 2 && activeBoardDemand == null) {
      activeBoardDemand = BoardDemandType
          .values[_eventRotationIndex % BoardDemandType.values.length];
      _log(
        'Board pressure is building: ${activeBoardDemand!.label}. Resolve it from Funding.',
      );
    }
    if (cultureIncidentsUnlocked &&
        activeCultureIncident == null &&
        teamMorale < 72) {
      activeCultureIncident = CultureIncidentType
          .values[_eventRotationIndex % CultureIncidentType.values.length];
      _log(
        'Culture incident active: ${activeCultureIncident!.label}. Resolve it from Team.',
      );
    }
    _normalizeRunSignals();
    if (!eventsUnlocked || activeEvent != null) return;
    eventCooldownSeconds -= seconds;
    if (eventCooldownSeconds <= 0) {
      _spawnNextEvent();
    }
  }

  void _spawnNextEvent() {
    final options = <StartupEventType>[
      StartupEventType.viralMoment,
      StartupEventType.recruitingRush,
      if (investorEventsUnlocked) StartupEventType.investorCall,
    ];
    activeEvent = options[_eventRotationIndex % options.length];
    _eventRotationIndex += 1;
    eventCooldownSeconds = 0;
    _log('New startup event: ${activeEvent!.label}.');
  }

  void _normalizeRunSignals() {
    customerTrust = customerTrust.clamp(trustFloor, 150);
    teamMorale = teamMorale.clamp(moraleFloor, 150);
    crisisLevel = crisisLevel.clamp(0, 6);
  }

  void _unlockPlaybookFromContract(ContractType contract) {
    switch (contract) {
      case ContractType.startupPilot:
      case ContractType.channelPartnership:
        unlockedPlaybooks.add(PlaybookId.growthScript);
        break;
      case ContractType.talentBrandSprint:
        unlockedPlaybooks.add(PlaybookId.peopleOpsManual);
        break;
      case ContractType.enterpriseRollout:
      case ContractType.governmentTender:
        unlockedPlaybooks.add(PlaybookId.enterpriseDeck);
        break;
      case ContractType.smbRollout:
        if (customerTrust >= 90) {
          unlockedPlaybooks.add(PlaybookId.growthScript);
        }
        break;
    }
  }

  bool _contractSucceeded(ContractType contract) {
    final roll =
        (contractWins * 13 +
            teamSize * 3 +
            _eventRotationIndex * 7 +
            productStageIndex * 11 +
            fundingStageIndex * 5 +
            marketExpansionLevel * 17) %
        100;
    return roll < (contractSuccessChance(contract) * 100).round();
  }

  void _applyContractFailure(ContractType contract) {
    final trustLoss = switch (contract) {
      ContractType.startupPilot => 6.0,
      ContractType.talentBrandSprint => 4.0,
      ContractType.smbRollout => 8.0,
      ContractType.channelPartnership => 10.0,
      ContractType.enterpriseRollout => 12.0,
      ContractType.governmentTender => 14.0,
    };
    final moraleLoss = switch (contract) {
      ContractType.startupPilot => 4.0,
      ContractType.talentBrandSprint => 8.0,
      ContractType.smbRollout => 6.0,
      ContractType.channelPartnership => 8.0,
      ContractType.enterpriseRollout => 10.0,
      ContractType.governmentTender => 12.0,
    };
    final repLoss = switch (contract) {
      ContractType.startupPilot => 3.0,
      ContractType.talentBrandSprint => 2.0,
      ContractType.smbRollout => 5.0,
      ContractType.channelPartnership => 6.0,
      ContractType.enterpriseRollout => 8.0,
      ContractType.governmentTender => 10.0,
    };
    customerTrust -= trustLoss;
    teamMorale -= moraleLoss;
    reputation = math.max(0, reputation - repLoss);
    crisisLevel += switch (contract) {
      ContractType.enterpriseRollout => 1,
      ContractType.governmentTender => 2,
      ContractType.channelPartnership => 1,
      _ => 0,
    };
    if (contract == ContractType.enterpriseRollout ||
        contract == ContractType.governmentTender) {
      activeBoardDemand ??= BoardDemandType.burnCut;
      boardPressureSeconds = math.max(boardPressureSeconds, 90);
    }
    if (contract == ContractType.channelPartnership ||
        contract == ContractType.enterpriseRollout) {
      supportBacklogSeconds = math.max(supportBacklogSeconds, 80);
    }
    contractChain = 0;
    contractChainSeconds = 0;
    lastContractSummary =
        '${contract.label} slipped: -${trustLoss.toStringAsFixed(0)} trust, -${moraleLoss.toStringAsFixed(0)} morale.';
    _log('Contract failed: $lastContractSummary');
    _normalizeRunSignals();
    _refreshValuation();
    _checkGoals();
    save();
  }

  String _awardRareContractDrop(ContractType contract) {
    final signals =
        customerTrust +
        teamMorale +
        productStageIndex * 8 +
        marketExpansionLevel * 12;
    final milestoneRoll =
        (signals.floor() + contractWins * 9 + _eventRotationIndex) % 4;
    if (contract == ContractType.governmentTender && milestoneRoll <= 1) {
      founderReputation += 1;
      boardInfluence += 1;
      return 'Rare reward: +1 founder reputation and +1 board influence.';
    }
    if ((contract == ContractType.enterpriseRollout ||
            contract == ContractType.channelPartnership) &&
        milestoneRoll == 0 &&
        !unlockedAdvisors.contains(AdvisorId.operatorCoach)) {
      unlockedAdvisors.add(AdvisorId.operatorCoach);
      return 'Rare reward: Operator Coach unlocked.';
    }
    if (contract == ContractType.talentBrandSprint && milestoneRoll <= 1) {
      permanentTeamSlotBonus += 1;
      return 'Rare reward: +1 permanent team slot.';
    }
    if (contract == ContractType.startupPilot && milestoneRoll == 0) {
      featureBetTokens += 1;
      return 'Rare reward: +1 feature bet token.';
    }
    return '';
  }

  int _portfolioPointsForExit() {
    var points = 1;
    if (valuation >= prestigeTarget * 2) points += 1;
    if (productStageIndex >= 5) points += 1;
    if (fundingStageIndex >= 4) points += 1;
    if (contractWins >= 3) points += 1;
    if (unlockedPlaybooks.length >= 2) points += 1;
    return points;
  }

  void _applyQuestReward(QuestDefinition quest) {
    cash += quest.cashReward;
    credits += quest.cashReward * 0.08;
    switch (quest.id) {
      case 'first_hire':
        eventRewardLevel += 1;
        capitalPolicyRefreshes += 1;
        break;
      case 'engineering_pod':
        eventCooldownSeconds = math.min(eventCooldownSeconds, 12);
        break;
      case 'go_to_market':
        traction += 5;
        break;
      case 'ops_credit':
        permanentOfflineMinutes += 30;
        break;
      case 'systems_three':
        permanentTeamSlotBonus += 1;
        break;
      case 'mvp':
        focusTokens += 1;
        productStrategyRefreshes += 1;
        break;
      case 'seed':
        focusTokens += 1;
        capitalPolicyRefreshes += 1;
        break;
      case 'team_twelve':
        permanentTeamSlotBonus += 2;
        credits += 120;
        break;
      case 'million':
        eventRewardLevel += 1;
        founderReputation += 1;
        break;
      default:
        break;
    }
    _log('Quest complete: ${quest.title} (${questRewardText(quest)}).');
  }

  void _applyAchievementReward(AchievementDefinition achievement) {
    prestigePoints += 1;
    credits += 50;
    switch (achievement.id) {
      case 'tap_100':
        eventRewardLevel += 1;
        break;
      case 'credits_1k':
        permanentOfflineMinutes += 45;
        capitalPolicyRefreshes += 1;
        break;
      case 'team_10':
        permanentTeamSlotBonus += 1;
        cash += 250;
        break;
      case 'launch':
        focusTokens += 1;
        productStrategyRefreshes += 1;
        break;
      case 'ipo':
        legacyTokens += 1;
        founderReputation += 1;
        break;
      default:
        break;
    }
    _log(
      'Achievement unlocked: ${achievement.title} (${achievementRewardText(achievement)}).',
    );
  }

  void _unlockMetaSystems() {
    if (!advisorsUnlocked) return;
    if (productStageIndex >= 2) {
      unlockedAdvisors.add(AdvisorId.productSage);
    }
    if (traction >= 40 ||
        completedChallenges.contains(ChallengeId.hypergrowthRun)) {
      unlockedAdvisors.add(AdvisorId.growthHacker);
    }
    if (fundingStageIndex >= 2 ||
        completedChallenges.contains(ChallengeId.bootstrappedRun)) {
      unlockedAdvisors.add(AdvisorId.financeChief);
    }
    if (marketExpansionLevel >= 1 ||
        completedChallenges.contains(ChallengeId.remoteOnlyRun)) {
      unlockedAdvisors.add(AdvisorId.operatorCoach);
    }
  }

  void _checkCollectionMilestones() {
    if (founderFlowSeconds > 0) {
      _unlockTrophy(FounderTrophyId.flowState);
    }
    if (contractChain >= 3) {
      _unlockTrophy(FounderTrophyId.dealCloser);
    }
    if (fundingStageIndex >= 6) {
      _unlockTrophy(FounderTrophyId.bellRinger);
    }
    if (unlockedPlaybooks.length == PlaybookId.values.length) {
      _unlockTrophy(FounderTrophyId.playbookCollector);
    }
  }

  void _checkChallengeCompletion() {
    final challenge = activeChallenge;
    if (challenge == null || completedChallenges.contains(challenge)) return;
    final complete = switch (challenge) {
      ChallengeId.bootstrappedRun =>
        productStageIndex >= 4 && fundingStageIndex == 0,
      ChallengeId.leanTeamRun => valuation >= 300000 && teamSize <= 8,
      ChallengeId.hypergrowthRun =>
        traction >= 80 && reputation >= challengeReputationFloor,
      ChallengeId.remoteOnlyRun => productStageIndex >= 5 && officeLevel <= 3,
    };
    if (!complete) return;
    completedChallenges.add(challenge);
    challengeTokens += 1;
    legacyTokens += 1;
    founderReputation += 1;
    switch (challenge) {
      case ChallengeId.bootstrappedRun:
        unlockedAdvisors.add(AdvisorId.financeChief);
        break;
      case ChallengeId.leanTeamRun:
        permanentTeamSlotBonus += 1;
        break;
      case ChallengeId.hypergrowthRun:
        unlockedAdvisors.add(AdvisorId.growthHacker);
        break;
      case ChallengeId.remoteOnlyRun:
        unlockedAdvisors.add(AdvisorId.operatorCoach);
        permanentOfflineMinutes += 30;
        break;
    }
    activeChallenge = null;
    _log(
      'Challenge complete: ${challenge.label}. +1 challenge token, +1 legacy token, +1 founder reputation.',
    );
  }

  void _resetRunProgress({double eventCooldown = 35}) {
    cash = startingCashBonus;
    credits = startingCreditsBonus;
    valuation = 0;
    reputation = 0;
    productProgress = startingProductBonus;
    funding = 0;
    traction = 0;
    marketInsight = 0;
    customerTrust = 55 + startingTrustBonus;
    teamMorale = 55 + startingMoraleBonus;
    tapLevel = 1;
    officeLevel = 1;
    _clearRunMaps();
    productStageIndex = 0;
    fundingStageIndex = 0;
    manualTaps = 0;
    focusTokens = 0;
    marketExpansionLevel = 0;
    contractWins = 0;
    activeContract = null;
    activeContractSeconds = 0;
    readyContract = null;
    lastContractSummary = '';
    founderMomentum = 0;
    founderFlowSeconds = 0;
    comebackBurstSeconds = 0;
    contractChain = 0;
    contractChainSeconds = 0;
    eventCooldownSeconds = eventCooldown;
    supportBacklogSeconds = 0;
    deliveryConfidenceSeconds = 0;
    recruitingPipelineSeconds = 0;
    viralBoostSeconds = 0;
    investorBuzzSeconds = 0;
    recruitingRushSeconds = 0;
    boardPressureSeconds = 0;
    qualityResetSeconds = 0;
    marketPulseSeconds = 0;
    parentDirectiveSeconds = 0;
    activeEvent = null;
    activeBoardDemand = null;
    activeMarketPulse = null;
    activeParentDirective = null;
    activeSeason = null;
    companyFocus = CompanyFocus.balanced;
    equippedAdvisor = null;
    productStrategyChoicePending = false;
    capitalPolicyChoicePending = false;
    runSeconds = 0;
    permanentOfflineMinutes = math.max(
      permanentOfflineMinutes,
      120 + specializationOfflineMinutes,
    );
    completedQuests.clear();
  }

  double _systemBonus(double Function(StartupSystem system) pick) =>
      StartupSystem.values.fold<double>(
        0,
        (sum, system) => sum + systemLevel(system) * pick(system),
      );

  void _log(String message) {
    eventLog.insert(0, message);
    if (eventLog.length > 7) eventLog.removeLast();
  }

  void _addMomentum(double amount) {
    if (!momentumUnlocked || amount <= 0) return;
    final before = founderMomentum;
    founderMomentum = (founderMomentum + amount).clamp(0, 100);
    if (before < 100 && founderMomentum >= 100) {
      founderMomentum = 35;
      founderFlowSeconds = math.max(founderFlowSeconds, 30 + contractChain * 4);
      if (productStageIndex >= 2) {
        focusTokens += 1;
      }
      _unlockTrophy(FounderTrophyId.flowState);
      _log(
        'Founder flow triggered: 30s burst to cash, product, traction, and contracts.',
      );
    }
  }

  void _unlockTrophy(FounderTrophyId trophy) {
    if (unlockedTrophies.contains(trophy)) return;
    unlockedTrophies.add(trophy);
    _log('Founder trophy unlocked: ${trophy.label}.');
  }

  List<String> _buildOfflineBriefLines(int seconds) {
    final minutes = seconds ~/ 60;
    final lines = <String>[
      'Finance desk closed ${formatNumber(lastOfflineCash)} cash while you were away.',
    ];
    if (lastOfflineCredits >= 10) {
      lines.add(
        'Ops banked ${formatNumber(lastOfflineCredits)} credits from background systems.',
      );
    }
    if (lastOfflineProduct >= 8) {
      lines.add(
        'The team shipped ${formatNumber(lastOfflineProduct)} product progress without you.',
      );
    }
    if (lastOfflineTraction >= 6) {
      lines.add(
        'Word of mouth kept moving: +${formatNumber(lastOfflineTraction)} traction.',
      );
    }
    if (lastOfflineSeconds >= 600) {
      lines.add('A return surge is ready. Reopening now triggers a 90s boost.');
    }
    if (readyContract != null) {
      lines.add('A contract is waiting on your desk for sign-off.');
    } else if (activeContract != null) {
      lines.add('A live contract kept moving while the office was quiet.');
    } else if (minutes >= 180) {
      lines.add(
        'A longer absence built up pressure for your next big decision.',
      );
    } else if (activeBoardDemand != null) {
      lines.add(
        'The board still expects a call on ${activeBoardDemand!.label.toLowerCase()}.',
      );
    } else if (activeEvent != null) {
      lines.add(
        'A fresh event is waiting for your call when you reopen the office.',
      );
    }
    return lines.take(4).toList();
  }

  @override
  void dispose() {
    save();
    _timer?.cancel();
    super.dispose();
  }
}

enum Department {
  engineering,
  product,
  design,
  growth,
  sales,
  operations,
  data,
  finance,
  executive,
}

enum Role {
  intern(
    'Intern',
    Department.operations,
    18,
    1.15,
    0.18,
    0.08,
    0.02,
    0.04,
    1,
    0,
    Icons.school,
  ),
  juniorDeveloper(
    'Junior Developer',
    Department.engineering,
    35,
    1.18,
    0.55,
    0.20,
    0.01,
    0.02,
    1,
    0,
    Icons.code,
  ),
  uxDesigner(
    'UX Designer',
    Department.design,
    48,
    1.20,
    0.32,
    0.34,
    0.03,
    0.02,
    1,
    0,
    Icons.brush,
  ),
  growthMarketer(
    'Growth Marketer',
    Department.growth,
    70,
    1.22,
    0.45,
    0.05,
    0.11,
    0.03,
    1,
    0,
    Icons.campaign,
  ),
  communityManager(
    'Community Manager',
    Department.growth,
    82,
    1.23,
    0.30,
    0.04,
    0.18,
    0.08,
    1,
    1,
    Icons.diversity_3,
  ),
  salesRep(
    'Sales Rep',
    Department.sales,
    90,
    1.24,
    0.72,
    0.02,
    0.07,
    0.02,
    1,
    0,
    Icons.handshake,
  ),
  productManager(
    'Product Manager',
    Department.product,
    140,
    1.25,
    0.30,
    0.52,
    0.08,
    0.08,
    2,
    1,
    Icons.account_tree,
  ),
  qaAnalyst(
    'QA Analyst',
    Department.product,
    170,
    1.24,
    0.24,
    0.42,
    0.04,
    0.11,
    2,
    1,
    Icons.fact_check,
  ),
  recruiter(
    'Recruiter',
    Department.operations,
    220,
    1.26,
    0.20,
    0.04,
    0.05,
    0.20,
    2,
    1,
    Icons.person_add,
  ),
  devOpsEngineer(
    'DevOps Engineer',
    Department.engineering,
    280,
    1.27,
    0.80,
    0.16,
    0.02,
    0.16,
    3,
    2,
    Icons.cloud_sync,
  ),
  dataAnalyst(
    'Data Analyst',
    Department.data,
    360,
    1.29,
    0.38,
    0.18,
    0.10,
    0.28,
    3,
    2,
    Icons.query_stats,
  ),
  customerSuccess(
    'Customer Success',
    Department.operations,
    460,
    1.30,
    0.40,
    0.04,
    0.20,
    0.12,
    3,
    3,
    Icons.support_agent,
  ),
  accountExecutive(
    'Account Executive',
    Department.sales,
    620,
    1.31,
    1.20,
    0.02,
    0.16,
    0.06,
    4,
    3,
    Icons.business_center,
  ),
  financeOps(
    'Finance Ops',
    Department.finance,
    820,
    1.32,
    0.58,
    0.03,
    0.08,
    0.34,
    4,
    4,
    Icons.request_quote,
  ),
  seniorEngineer(
    'Senior Engineer',
    Department.engineering,
    1100,
    1.33,
    1.45,
    0.45,
    0.03,
    0.12,
    5,
    4,
    Icons.memory,
  ),
  chiefOfStaff(
    'Chief of Staff',
    Department.executive,
    1600,
    1.35,
    0.80,
    0.30,
    0.22,
    0.45,
    5,
    5,
    Icons.groups_3,
  );

  const Role(
    this.label,
    this.department,
    this.baseCost,
    this.costGrowth,
    this.cashOutput,
    this.productOutput,
    this.reputationOutput,
    this.creditsOutput,
    this.requiredOfficeLevel,
    this.requiredProductStage,
    this.icon,
  );

  final String label;
  final Department department;
  final double baseCost;
  final double costGrowth;
  final double cashOutput;
  final double productOutput;
  final double reputationOutput;
  final double creditsOutput;
  final int requiredOfficeLevel;
  final int requiredProductStage;
  final IconData icon;

  String get unlockText =>
      'Office Lv.$requiredOfficeLevel and ${GameController.productStages[requiredProductStage]}';
}

enum StartupSystem {
  founderDashboard(
    'Founder Dashboard',
    35,
    1.35,
    0.02,
    0.01,
    0.01,
    0.08,
    0.01,
    1,
    0,
    Icons.dashboard,
  ),
  recruitingPipeline(
    'Recruiting Pipeline',
    55,
    1.38,
    0.01,
    0.00,
    0.02,
    0.12,
    0.01,
    1,
    0,
    Icons.filter_alt,
  ),
  agileRituals(
    'Agile Rituals',
    75,
    1.40,
    0.00,
    0.08,
    0.01,
    0.04,
    0.01,
    1,
    1,
    Icons.sync,
  ),
  designSystem(
    'Design System',
    120,
    1.42,
    0.01,
    0.12,
    0.02,
    0.03,
    0.02,
    2,
    1,
    Icons.palette,
  ),
  analyticsStack(
    'Analytics Stack',
    150,
    1.43,
    0.03,
    0.03,
    0.08,
    0.10,
    0.03,
    2,
    2,
    Icons.analytics,
  ),
  salesPlaybook(
    'Sales Playbook',
    210,
    1.45,
    0.10,
    0.00,
    0.08,
    0.02,
    0.04,
    2,
    2,
    Icons.menu_book,
  ),
  customerFeedbackLoop(
    'Customer Feedback Loop',
    260,
    1.46,
    0.03,
    0.10,
    0.10,
    0.05,
    0.04,
    3,
    3,
    Icons.forum,
  ),
  cloudScaling(
    'Cloud Scaling',
    340,
    1.48,
    0.12,
    0.04,
    0.01,
    0.08,
    0.05,
    3,
    3,
    Icons.cloud_queue,
  ),
  investorRelations(
    'Investor Relations',
    450,
    1.50,
    0.04,
    0.00,
    0.12,
    0.08,
    0.08,
    4,
    4,
    Icons.account_balance,
  ),
  securityReview(
    'Security Review',
    620,
    1.52,
    0.03,
    0.05,
    0.06,
    0.10,
    0.07,
    4,
    4,
    Icons.security,
  ),
  automationLab(
    'Automation Lab',
    820,
    1.55,
    0.11,
    0.09,
    0.03,
    0.18,
    0.08,
    5,
    5,
    Icons.precision_manufacturing,
  ),
  boardOperatingSystem(
    'Board Operating System',
    1200,
    1.58,
    0.07,
    0.07,
    0.14,
    0.14,
    0.12,
    5,
    5,
    Icons.corporate_fare,
  );

  const StartupSystem(
    this.label,
    this.baseCreditCost,
    this.costGrowth,
    this.cashBoost,
    this.productBoost,
    this.reputationBoost,
    this.creditBoost,
    this.valuationBoost,
    this.requiredOfficeLevel,
    this.requiredProductStage,
    this.icon,
  );

  final String label;
  final double baseCreditCost;
  final double costGrowth;
  final double cashBoost;
  final double productBoost;
  final double reputationBoost;
  final double creditBoost;
  final double valuationBoost;
  final int requiredOfficeLevel;
  final int requiredProductStage;
  final IconData icon;

  String get unlockText =>
      'Office Lv.$requiredOfficeLevel and ${GameController.productStages[requiredProductStage]}';
}

enum QuestKind {
  taps,
  developers,
  engineeringTeam,
  goToMarketTeam,
  opsTeam,
  teamSize,
  productStage,
  fundingStage,
  valuation,
  cash,
  credits,
  startupSystems,
  prestiges,
}

enum LiveOpsCadence {
  daily('Daily'),
  weekly('Weekly');

  const LiveOpsCadence(this.label);
  final String label;
}

class LiveOpsMissionDefinition {
  const LiveOpsMissionDefinition(
    this.id,
    this.cadence,
    this.title,
    this.description,
    this.kind,
    this.target, {
    this.cashReward = 0,
    this.creditsReward = 0,
    this.featureBetReward = 0,
    this.contractReward = 0,
    this.founderReputationReward = 0,
    this.boardInfluenceReward = 0,
    this.permanentOfflineMinutesReward = 0,
    this.trustReward = 0,
    this.moraleReward = 0,
  });

  final String id;
  final LiveOpsCadence cadence;
  final String title;
  final String description;
  final QuestKind kind;
  final double target;
  final double cashReward;
  final double creditsReward;
  final int featureBetReward;
  final int contractReward;
  final int founderReputationReward;
  final int boardInfluenceReward;
  final int permanentOfflineMinutesReward;
  final double trustReward;
  final double moraleReward;
}

class QuestDefinition {
  const QuestDefinition(
    this.id,
    this.title,
    this.description,
    this.kind,
    this.target,
    this.cashReward,
  );
  final String id;
  final String title;
  final String description;
  final QuestKind kind;
  final double target;
  final double cashReward;
}

class AchievementDefinition {
  const AchievementDefinition(
    this.id,
    this.title,
    this.description,
    this.kind,
    this.target,
  );
  final String id;
  final String title;
  final String description;
  final QuestKind kind;
  final double target;
}

class StartupOfficeFlameGame extends FlameGame {
  StartupOfficeFlameGame(this.controller);
  final GameController controller;

  @override
  Color backgroundColor() => const Color(0xffd7ecdf);

  @override
  Future<void> onLoad() async {
    add(OfficeSceneComponent(controller));
  }
}

class OfficeSceneComponent extends PositionComponent
    with HasGameReference<StartupOfficeFlameGame> {
  OfficeSceneComponent(this.controller);
  final GameController controller;
  ui.Image? officeArt;
  double pulse = 0;

  @override
  Future<void> onLoad() async {
    officeArt = await game.images.load('startup_office_pixel_stage.png');
  }

  @override
  void update(double dt) {
    pulse += dt;
  }

  @override
  void render(Canvas canvas) {
    final s = game.size;
    final paint = Paint()..style = PaintingStyle.fill;
    final art = officeArt;
    if (art == null) {
      _renderFallbackOffice(canvas, s, paint);
    } else {
      _renderGeneratedOfficeArt(canvas, s, art, paint);
    }
    _drawOfficeEvolutionOverlays(canvas, s);
    _drawValuationBanner(canvas, Rect.fromLTWH(s.x * 0.08, 12, s.x * 0.84, 38));
    _drawProgressPips(canvas, s);
  }

  void _renderGeneratedOfficeArt(
    Canvas canvas,
    Vector2 s,
    ui.Image art,
    Paint paint,
  ) {
    final source = Rect.fromLTWH(0, 0, art.width.toDouble(), art.height * 0.76);
    final dest = Rect.fromLTWH(0, 0, s.x, s.y);
    canvas.drawImageRect(art, source, dest, paint);

    final shade = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x00000000), Color(0x660f332b)],
      ).createShader(Rect.fromLTWH(0, s.y * 0.5, s.x, s.y * 0.5));
    canvas.drawRect(Rect.fromLTWH(0, s.y * 0.5, s.x, s.y * 0.5), shade);
  }

  void _renderFallbackOffice(Canvas canvas, Vector2 s, Paint paint) {
    paint.color = const Color(0xffc6e6d3);
    canvas.drawRect(Rect.fromLTWH(0, 0, s.x, s.y), paint);
    paint.color = const Color(0xff9bc6aa);
    canvas.drawRect(Rect.fromLTWH(0, s.y * 0.72, s.x, s.y * 0.28), paint);

    final deskCount = math.max(1, controller.teamCapacity);
    final cols = math.min(5, deskCount);
    final deskW = s.x / (cols + 1);
    for (var i = 0; i < deskCount; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final x = deskW * (col + 0.6);
      final y = s.y * 0.44 + row * 38;
      _drawDesk(
        canvas,
        Offset(x, y),
        occupied: i < controller.teamSize,
        index: i,
      );
    }

    _drawWhiteboard(
      canvas,
      Offset(s.x * 0.08, s.y * 0.12),
      s.x * 0.34,
      s.y * 0.2,
    );
    _drawServerRack(canvas, Offset(s.x * 0.74, s.y * 0.16), s.y * 0.24);
  }

  void _drawOfficeEvolutionOverlays(Canvas canvas, Vector2 s) {
    if (controller.meetingRoomUnlocked) {
      _drawMeetingRoom(canvas, Offset(s.x * 0.05, s.y * 0.26), s.x * 0.22, 56);
    }
    if (controller.executiveSuiteUnlocked) {
      _drawExecutiveSuite(
        canvas,
        Rect.fromLTWH(s.x * 0.72, s.y * 0.08, s.x * 0.19, s.y * 0.18),
      );
    }
    if (controller.globalMapUnlocked) {
      _drawGlobalMap(
        canvas,
        Rect.fromLTWH(s.x * 0.34, s.y * 0.1, s.x * 0.24, 54),
      );
    }
    if (controller.remoteOfficeUnlocked) {
      _drawRemoteWing(
        canvas,
        Rect.fromLTWH(s.x * 0.61, s.y * 0.31, s.x * 0.28, 64),
      );
    }
    if (controller.ipoUnlocked) {
      _drawIpoBell(canvas, Offset(s.x * 0.48, s.y * 0.22));
    }
    if (controller.productStageIndex >= 5) {
      _drawBrandWall(
        canvas,
        Rect.fromLTWH(s.x * 0.32, s.y * 0.26, s.x * 0.22, 46),
      );
    }
    if (controller.crossProjectsUnlocked) {
      _drawProjectStudio(
        canvas,
        Rect.fromLTWH(s.x * 0.08, s.y * 0.58, s.x * 0.23, 60),
      );
    }
    if (controller.contractsUnlocked) {
      _drawContractWall(
        canvas,
        Rect.fromLTWH(s.x * 0.68, s.y * 0.56, s.x * 0.21, 62),
      );
    }
    if (controller.boardDemandsUnlocked) {
      _drawBoardRoom(
        canvas,
        Rect.fromLTWH(s.x * 0.58, s.y * 0.18, s.x * 0.16, 54),
      );
    }
    if (controller.activeCultureIncident != null ||
        controller.crisisLevel > 0) {
      _drawPressureBeacon(
        canvas,
        Offset(s.x * 0.9, s.y * 0.14),
        controller.activeCultureIncident != null,
      );
    }
    if (controller.portfolioCompanies > 0) {
      _drawPortfolioCase(
        canvas,
        Rect.fromLTWH(s.x * 0.36, s.y * 0.58, s.x * 0.18, 58),
      );
    }
  }

  void _drawDesk(
    Canvas canvas,
    Offset origin, {
    required bool occupied,
    required int index,
  }) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xff6c8a7a);
    canvas.drawRect(Rect.fromLTWH(origin.dx, origin.dy + 20, 48, 16), paint);
    paint.color = const Color(0xff426657);
    canvas.drawRect(Rect.fromLTWH(origin.dx + 4, origin.dy + 36, 7, 18), paint);
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + 37, origin.dy + 36, 7, 18),
      paint,
    );
    paint.color = const Color(0xff2c4150);
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + 13, origin.dy + 7, 22, 14),
      paint,
    );
    paint.color = const Color(0xff8fd4f7);
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + 16, origin.dy + 10, 16, 8),
      paint,
    );
    if (!occupied) return;
    final bob = math.sin(pulse * 3 + index) * 2;
    paint.color = _personColor(index);
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + 17, origin.dy - 8 + bob, 15, 18),
      paint,
    );
    paint.color = const Color(0xffffc991);
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + 18, origin.dy - 20 + bob, 13, 12),
      paint,
    );
    paint.color = const Color(0xff333333);
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + 18, origin.dy - 22 + bob, 13, 4),
      paint,
    );
  }

  void _drawWhiteboard(Canvas canvas, Offset origin, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xfff8fbf6);
    canvas.drawRect(Rect.fromLTWH(origin.dx, origin.dy, w, h), paint);
    paint.color = const Color(0xff40594e);
    canvas.drawRect(Rect.fromLTWH(origin.dx, origin.dy, w, 4), paint);
    canvas.drawRect(Rect.fromLTWH(origin.dx, origin.dy + h - 4, w, 4), paint);
    paint.color = const Color(0xff1f8f72);
    final progress =
        (controller.productProgress / controller.nextProductProgress)
            .clamp(0, 1)
            .toDouble();
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + 12, origin.dy + h - 22, (w - 24) * progress, 8),
      paint,
    );
    paint.color = const Color(0xffe1564f);
    canvas.drawCircle(
      Offset(origin.dx + w * 0.68, origin.dy + h * 0.4),
      10 + controller.productStageIndex * 1.5,
      paint,
    );
  }

  void _drawServerRack(Canvas canvas, Offset origin, double h) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xff32455c);
    canvas.drawRect(Rect.fromLTWH(origin.dx, origin.dy, 58, h), paint);
    for (var i = 0; i < 5; i++) {
      paint.color = i <= controller.fundingStageIndex
          ? const Color(0xff7dd36f)
          : const Color(0xff6f7d8c);
      canvas.drawRect(
        Rect.fromLTWH(origin.dx + 8, origin.dy + 10 + i * 20, 42, 8),
        paint,
      );
    }
  }

  void _drawMeetingRoom(Canvas canvas, Offset origin, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x88ffffff);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, origin.dy, w, h),
        const Radius.circular(6),
      ),
      paint,
    );
    paint.color = const Color(0xff3b5d52);
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + 18, origin.dy + 24, w - 36, 8),
      paint,
    );
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(origin.dx + 28 + i * 24, origin.dy + 18),
        5,
        paint,
      );
    }
    if (controller.activeLead != null) {
      paint.color = const Color(0xfff4d35e);
      canvas.drawCircle(Offset(origin.dx + w - 18, origin.dy + 14), 6, paint);
    }
  }

  void _drawExecutiveSuite(Canvas canvas, Rect rect) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x77dff6ff);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
    paint.color = const Color(0xff28443d);
    canvas.drawRect(
      Rect.fromLTWH(rect.left + 12, rect.top + 14, rect.width - 24, 6),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(rect.left + 18, rect.top + 36, rect.width - 36, 16),
      paint,
    );
    if (controller.activeBoardDemand != null) {
      paint.color = const Color(0xffe1564f);
      canvas.drawCircle(
        Offset(rect.right - 16, rect.top + 16),
        7 + math.sin(pulse * 4).abs() * 2,
        paint,
      );
    }
  }

  void _drawGlobalMap(Canvas canvas, Rect rect) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xff1d2e44);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(5)),
      paint,
    );
    paint.color = const Color(0xff56d18f);
    canvas.drawCircle(
      Offset(rect.left + rect.width * 0.22, rect.top + rect.height * 0.45),
      5,
      paint,
    );
    canvas.drawCircle(
      Offset(rect.left + rect.width * 0.48, rect.top + rect.height * 0.34),
      4,
      paint,
    );
    canvas.drawCircle(
      Offset(rect.left + rect.width * 0.72, rect.top + rect.height * 0.56),
      6,
      paint,
    );
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(rect.left + rect.width * 0.22, rect.top + rect.height * 0.45),
      Offset(rect.left + rect.width * 0.48, rect.top + rect.height * 0.34),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left + rect.width * 0.48, rect.top + rect.height * 0.34),
      Offset(rect.left + rect.width * 0.72, rect.top + rect.height * 0.56),
      paint,
    );
    if (controller.marketExpansionLevel > 1) {
      canvas.drawLine(
        Offset(rect.left + rect.width * 0.22, rect.top + rect.height * 0.45),
        Offset(rect.left + rect.width * 0.72, rect.top + rect.height * 0.56),
        paint,
      );
    }
  }

  void _drawRemoteWing(Canvas canvas, Rect rect) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x66ffffff);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      paint,
    );
    paint.color = const Color(0xff3f8fd2);
    for (var i = 0; i < 3; i++) {
      final top = rect.top + 10 + i * 16;
      canvas.drawRect(Rect.fromLTWH(rect.left + 12, top, 18, 10), paint);
      canvas.drawRect(
        Rect.fromLTWH(rect.left + 36, top, rect.width - 48, 10),
        paint,
      );
    }
    if (controller.contractWins > 0) {
      paint.color = const Color(0xff56d18f);
      canvas.drawRect(
        Rect.fromLTWH(rect.left + 12, rect.bottom - 14, rect.width - 24, 6),
        paint,
      );
    }
  }

  void _drawIpoBell(Canvas canvas, Offset origin) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xfff4d35e);
    canvas.drawOval(
      Rect.fromCenter(center: origin, width: 28, height: 22),
      paint,
    );
    paint.color = const Color(0xff8d6a00);
    canvas.drawRect(Rect.fromLTWH(origin.dx - 2, origin.dy - 20, 4, 10), paint);
    canvas.drawRect(
      Rect.fromLTWH(origin.dx - 12, origin.dy + 10, 24, 4),
      paint,
    );
  }

  void _drawBrandWall(Canvas canvas, Rect rect) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xfffff3d6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      paint,
    );
    paint.color = const Color(0xff1f8f72);
    canvas.drawRect(
      Rect.fromLTWH(rect.left + 12, rect.top + 10, rect.width - 24, 8),
      paint,
    );
    paint.color = const Color(0xff24352d);
    canvas.drawRect(
      Rect.fromLTWH(rect.left + 18, rect.top + 24, rect.width * 0.36, 6),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(rect.left + 18, rect.top + 34, rect.width * 0.22, 6),
      paint,
    );
  }

  void _drawProjectStudio(Canvas canvas, Rect rect) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x8afffffb);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
    paint.color = const Color(0xff40594e);
    canvas.drawRect(
      Rect.fromLTWH(rect.left + 12, rect.top + 18, rect.width - 24, 8),
      paint,
    );
    paint.color = controller.activeProject != null
        ? const Color(0xfff4d35e)
        : const Color(0xff56d18f);
    canvas.drawRect(
      Rect.fromLTWH(rect.left + 14, rect.bottom - 16, rect.width - 28, 6),
      paint,
    );
  }

  void _drawContractWall(Canvas canvas, Rect rect) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x80fff8e8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
    for (var i = 0; i < 3; i++) {
      paint.color = i < controller.contractWins + 1
          ? const Color(0xfff4d35e)
          : const Color(0xffdad2bf);
      canvas.drawRect(
        Rect.fromLTWH(
          rect.left + 14,
          rect.top + 12 + i * 14,
          rect.width - 28,
          10,
        ),
        paint,
      );
    }
    if (controller.readyContract != null) {
      paint.color = const Color(0xff56d18f);
      canvas.drawCircle(Offset(rect.right - 16, rect.top + 16), 6, paint);
    }
  }

  void _drawBoardRoom(Canvas canvas, Rect rect) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x88dff6ff);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
    paint.color = const Color(0xff32455c);
    canvas.drawRect(
      Rect.fromLTWH(rect.left + 10, rect.top + 20, rect.width - 20, 10),
      paint,
    );
    for (var i = 0; i < 3; i++) {
      paint.color = i < controller.boardInfluence + 1
          ? const Color(0xffe1564f)
          : const Color(0xff94a3b8);
      canvas.drawCircle(
        Offset(rect.left + 18 + i * 22, rect.top + 14),
        4,
        paint,
      );
    }
  }

  void _drawPressureBeacon(Canvas canvas, Offset origin, bool culture) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = culture ? const Color(0xfff4d35e) : const Color(0xffe1564f);
    canvas.drawCircle(origin, 10 + math.sin(pulse * 5).abs() * 4, paint);
    paint.color = const Color(0xffffffff);
    canvas.drawCircle(origin, 4, paint);
  }

  void _drawPortfolioCase(Canvas canvas, Rect rect) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x88fff7d6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
    paint.color = const Color(0xff8d6a00);
    canvas.drawRect(
      Rect.fromLTWH(rect.left + 10, rect.top + 12, rect.width - 20, 26),
      paint,
    );
    paint.color = const Color(0xfff4d35e);
    for (var i = 0; i < math.min(4, controller.portfolioCompanies); i++) {
      canvas.drawCircle(
        Offset(rect.left + 18 + i * 18, rect.bottom - 14),
        4,
        paint,
      );
    }
  }

  void _drawProgressPips(Canvas canvas, Vector2 s) {
    final paint = Paint()..style = PaintingStyle.fill;
    final pipCount = math.min(12, math.max(1, controller.teamSize));
    final startX = s.x * 0.08;
    final y = s.y * 0.82 + math.sin(pulse * 2) * 1.5;
    for (var i = 0; i < pipCount; i++) {
      paint.color = i < controller.developers
          ? const Color(0xff59d483)
          : i < controller.developers + controller.designers
          ? const Color(0xff67b8ff)
          : i <
                controller.developers +
                    controller.designers +
                    controller.marketers
          ? const Color(0xffffc857)
          : const Color(0xffff7a61);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(startX + i * 14, y, 9, 9),
          const Radius.circular(2),
        ),
        paint,
      );
    }

    final productRatio =
        (controller.productProgress / controller.nextProductProgress)
            .clamp(0, 1)
            .toDouble();
    final bar = Rect.fromLTWH(s.x * 0.08, s.y * 0.88, s.x * 0.84, 7);
    paint.color = const Color(0x7730443a);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bar, const Radius.circular(3)),
      paint,
    );
    paint.color = const Color(0xff56d18f);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bar.left, bar.top, bar.width * productRatio, bar.height),
        const Radius.circular(3),
      ),
      paint,
    );
  }

  void _drawValuationBanner(Canvas canvas, Rect rect) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xff25372f).withValues(alpha: 0.86);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      paint,
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text:
            'Valuation ${formatNumber(controller.valuation)} | ${controller.productStage}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: rect.width - 16);
    textPainter.paint(canvas, Offset(rect.left + 8, rect.top + 8));
  }

  Color _personColor(int index) {
    const colors = [
      Color(0xfff26d5b),
      Color(0xff3f8fd2),
      Color(0xfff0b64f),
      Color(0xff7a67c7),
    ];
    return colors[index % colors.length];
  }
}

class _OfficeStage extends StatelessWidget {
  const _OfficeStage({required this.controller, required this.game});
  final GameController controller;
  final StartupOfficeFlameGame game;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: GameWidget(game: game)),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatsBar(controller: controller),
              const SizedBox(height: 10),
              FilledButton.icon(
                key: const Key('founder_tap_button'),
                onPressed: controller.founderTap,
                icon: const Icon(Icons.touch_app),
                label: Text(
                  'Founder Tap +${formatNumber(controller.tapIncome)}',
                ),
              ),
            ],
          ),
        ),
        if (controller.offlineSummaryPending)
          Positioned.fill(
            child: _OverlayNotice(
              title: 'Offline briefing',
              body:
                  '+${formatNumber(controller.lastOfflineCash)} cash from ${controller.lastOfflineSeconds ~/ 60} min away',
              details: controller.offlineBriefLines,
              action: 'Collect',
              onPressed: controller.dismissOfflineSummary,
            ),
          ),
        if (!controller.offlineSummaryPending && controller.activeEvent != null)
          Positioned(
            top: 56,
            right: 16,
            child: FilledButton.icon(
              key: const Key('activate_event_button'),
              onPressed: controller.activateEvent,
              icon: Icon(controller.activeEvent!.icon, size: 18),
              label: Text(controller.activeEvent!.label),
            ),
          ),
      ],
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xfffffbf0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff24352d), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _Metric(label: 'Cash', value: formatNumber(controller.cash)),
            _Metric(label: 'Credits', value: formatNumber(controller.credits)),
            _Metric(
              label: 'Valuation',
              value: formatNumber(controller.valuation),
            ),
            _Metric(
              label: 'Auto',
              value: '${formatNumber(controller.autoIncomePerSecond)}/s',
            ),
            _Metric(
              label: 'Autotap',
              value: '${formatNumber(controller.founderAutomationPerSecond)}/s',
            ),
            _Metric(
              label: 'Traction',
              value: formatNumber(controller.traction),
            ),
            _Metric(
              label: 'Trust',
              value: controller.customerTrust.toStringAsFixed(0),
            ),
            _Metric(
              label: 'Morale',
              value: controller.teamMorale.toStringAsFixed(0),
            ),
            _Metric(
              label: 'Insight',
              value: formatNumber(controller.marketInsight),
            ),
            _Metric(
              label: 'Flow',
              value: controller.momentumUnlocked
                  ? '${controller.founderMomentum.toStringAsFixed(0)}%'
                  : 'Locked',
            ),
            _Metric(
              label: 'Chain',
              value: controller.contractChain > 0
                  ? 'x${controller.contractChain}'
                  : '-',
            ),
            _Metric(
              label: 'Team',
              value: '${controller.teamSize}/${controller.teamCapacity}',
            ),
            _Metric(label: 'Focus', value: controller.companyFocus.label),
            _Metric(label: 'Prestige', value: '${controller.prestigePoints}'),
            _Metric(label: 'Portfolio', value: '${controller.portfolioPoints}'),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({
    required this.controller,
    required this.selectedTab,
    required this.onTabChanged,
  });
  final GameController controller;
  final OfficeTab selectedTab;
  final ValueChanged<OfficeTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xfffffbf0)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Startup Office',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                ),
                _StageChip(controller.fundingStage),
              ],
            ),
          ),
          SizedBox(
            height: 46,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final tab = OfficeTab.values[index];
                return ChoiceChip(
                  key: Key('tab_${tab.name}'),
                  label: Text(tab.label),
                  selected: selectedTab == tab,
                  onSelected: (_) => onTabChanged(tab),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemCount: OfficeTab.values.length,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              children: [
                _buildSelected(context),
                const SizedBox(height: 4),
                _RoadmapPanel(controller: controller),
                const SizedBox(height: 12),
                _EventLog(controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelected(BuildContext context) {
    return switch (selectedTab) {
      OfficeTab.upgrades => _UpgradePanel(controller: controller),
      OfficeTab.team => _TeamPanel(controller: controller),
      OfficeTab.ops => _OpsPanel(controller: controller),
      OfficeTab.product => _ProductPanel(controller: controller),
      OfficeTab.funding => _FundingPanel(controller: controller),
      OfficeTab.events => _EventsPanel(controller: controller),
      OfficeTab.advisors => _AdvisorsPanel(controller: controller),
      OfficeTab.challenges => _ChallengesPanel(controller: controller),
      OfficeTab.expansion => _ExpansionPanel(controller: controller),
      OfficeTab.prestige => _PrestigePanel(controller: controller),
      OfficeTab.quests => _QuestPanel(controller: controller),
      OfficeTab.shop => _ShopPanel(controller: controller),
      OfficeTab.settings => _SettingsPanel(controller: controller),
    };
  }
}

class _UpgradePanel extends StatelessWidget {
  const _UpgradePanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionTile(
          icon: Icons.touch_app,
          title: 'Founder Focus Lv.${controller.tapLevel}',
          subtitle: 'Increase manual tap income.',
          cost: controller.tapUpgradeCost,
          canAfford: controller.cash >= controller.tapUpgradeCost,
          buttonKey: const Key('founder_focus_upgrade_button'),
          onPressed: controller.buyTapUpgrade,
        ),
        _ActionTile(
          icon: Icons.domain_add,
          title: 'Office Expansion Lv.${controller.officeLevel}',
          subtitle:
              'Increase team capacity to ${controller.teamCapacity + 2}. Milestones at Lv 2, 5, and 8 unlock bigger office perks.',
          cost: controller.officeUpgradeCost,
          canAfford:
              controller.cash >= controller.officeUpgradeCost &&
              !controller.challengeBlocksOfficeUpgrade,
          buttonKey: const Key('office_expansion_button'),
          onPressed: controller.buyOfficeUpgrade,
        ),
        _TileShell(
          child: Text(
            controller.officeMilestoneHeadline,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _TeamPanel extends StatelessWidget {
  const _TeamPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (controller.teamLeadsUnlocked)
          _InfoPanel(
            icon: Icons.manage_accounts,
            title: 'Team Leads',
            children: [
              Text('Active lead: ${controller.activeLead?.label ?? 'None'}'),
              const SizedBox(height: 8),
              for (final lead in TeamLeadFocus.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(lead.icon, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          lead.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      OutlinedButton(
                        key: Key('team_lead_${lead.name}_button'),
                        onPressed: () => controller.setTeamLead(lead),
                        child: Text(
                          controller.activeLead == lead ? 'Active' : 'Assign',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        if (controller.crossProjectsUnlocked)
          _InfoPanel(
            icon: Icons.hub,
            title: 'Cross-functional Projects',
            children: [
              Text(
                controller.activeProject == null
                    ? 'No active project.'
                    : 'Active: ${controller.activeProject!.label} | ${controller.activeProjectSeconds.ceil()}s left',
              ),
              if (controller.readyProject != null) ...[
                const SizedBox(height: 8),
                FilledButton(
                  key: const Key('claim_project_button'),
                  onPressed: controller.claimProject,
                  child: Text('Claim ${controller.readyProject!.label}'),
                ),
              ],
              const SizedBox(height: 8),
              for (final project in ProjectType.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(project.icon, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          project.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      FilledButton(
                        key: Key('project_${project.name}_button'),
                        onPressed:
                            controller.activeProject == null &&
                                controller.readyProject == null
                            ? () => controller.startProject(project)
                            : null,
                        child: const Text('Start'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        if (controller.activeCultureIncident != null)
          _InfoPanel(
            icon: controller.activeCultureIncident!.icon,
            title: controller.activeCultureIncident!.label,
            children: [
              Text(controller.activeCultureIncident!.description),
              const SizedBox(height: 8),
              Text(
                'Trust ${controller.customerTrust.toStringAsFixed(0)} | Morale ${controller.teamMorale.toStringAsFixed(0)} | Stability ${controller.cultureStability}',
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      key: const Key('culture_stabilize_button'),
                      onPressed: () => controller.resolveCultureIncident(true),
                      child: const Text('Stabilize'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('culture_push_button'),
                      onPressed: () => controller.resolveCultureIncident(false),
                      child: const Text('Push speed'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        for (final role in Role.values)
          _ActionTile(
            icon: role.icon,
            title: 'Hire ${role.label}',
            subtitle: _roleSubtitle(role),
            cost: controller.hireCost(role),
            canAfford:
                controller.cash >= controller.hireCost(role) &&
                controller.hasTeamCapacity &&
                controller.challengeAllowsHire &&
                controller.isRoleUnlocked(role),
            buttonKey: Key('hire_${role.name}_button'),
            onPressed: () => controller.hire(role),
          ),
      ],
    );
  }

  String _roleSubtitle(Role role) {
    final count = controller.roleCount(role);
    if (!controller.isRoleUnlocked(role)) {
      return 'Locked: ${role.unlockText}.';
    }
    if (!controller.challengeAllowsHire) {
      return 'Challenge cap reached. This run is limited to ${controller.challengeTeamCap} total hires.';
    }
    return 'Owned $count | +${formatNumber(role.cashOutput)}/s cash, +${formatNumber(role.productOutput)}/s product, +${formatNumber(role.creditsOutput)}/s credits. Build bonuses grow at 3, 6, 10, and 20 total hires, with sprint automation turning on at 3.';
  }
}

class _OpsPanel extends StatelessWidget {
  const _OpsPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoPanel(
          icon: Icons.token,
          title: 'Credits: ${formatNumber(controller.credits)}',
          children: [
            Text(
              'Credits fund startup operating systems. Earn them from ops/data hires, quests, achievements, ads, and product milestones.',
            ),
          ],
        ),
        for (final system in StartupSystem.values)
          _CreditActionTile(
            icon: system.icon,
            title: '${system.label} Lv.${controller.systemLevel(system)}',
            subtitle: _systemSubtitle(system),
            cost: controller.systemCost(system),
            canAfford:
                controller.credits >= controller.systemCost(system) &&
                controller.isSystemUnlocked(system),
            onPressed: () => controller.buySystem(system),
          ),
      ],
    );
  }

  String _systemSubtitle(StartupSystem system) {
    if (!controller.isSystemUnlocked(system)) {
      return 'Locked: ${system.unlockText}.';
    }
    return 'Boosts cash/product/reputation/credits/valuation by startup-process multipliers.';
  }
}

class _ProductPanel extends StatelessWidget {
  const _ProductPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final ratio = (controller.productProgress / controller.nextProductProgress)
        .clamp(0, 1)
        .toDouble();
    return _InfoPanel(
      icon: Icons.rocket_launch,
      title: 'Product: ${controller.productStage}',
      children: [
        LinearProgressIndicator(value: ratio, minHeight: 12),
        const SizedBox(height: 8),
        Text(
          '${formatNumber(controller.productProgress)} / ${formatNumber(controller.nextProductProgress)} progress',
        ),
        if (controller.tractionUnlocked) ...[
          const SizedBox(height: 8),
          Text(
            'Traction ${formatNumber(controller.traction)} | +${formatNumber(controller.tractionPerSecond)}/s',
          ),
        ],
        const SizedBox(height: 12),
        Text(
          'Focus: ${controller.companyFocus.label} | Tokens: ${controller.focusTokens}',
        ),
        const SizedBox(height: 8),
        Text(
          'Strategy: ${controller.activeProductStrategy?.label ?? 'Pending'}',
        ),
        const SizedBox(height: 8),
        Text(
          'Venture thesis: ${controller.activeVentureThesis?.label ?? 'Locked'}',
        ),
        const SizedBox(height: 8),
        Text('Refreshes: ${controller.productStrategyRefreshes}'),
        const SizedBox(height: 8),
        Text(
          'Feature bets: ${controller.featureBetTokens} | Active lab: ${controller.activeFeatureBet?.label ?? 'None'}',
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final focus in CompanyFocus.values)
              OutlinedButton(
                key: Key('focus_${focus.name}_button'),
                onPressed: focus == CompanyFocus.balanced
                    ? null
                    : () => controller.setCompanyFocus(focus),
                child: Text(focus.label),
              ),
          ],
        ),
        if (controller.productStrategyChoicePending) ...[
          const SizedBox(height: 12),
          const Text(
            'Choose a product strategy card',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          for (final strategy in ProductStrategy.values)
            _TileShell(
              child: Row(
                children: [
                  Icon(strategy.icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strategy.label,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          strategy.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    key: Key('product_strategy_${strategy.name}_button'),
                    onPressed: () => controller.chooseProductStrategy(strategy),
                    child: const Text('Choose'),
                  ),
                ],
              ),
            ),
        ],
        if (controller.featureBetsUnlocked) ...[
          const SizedBox(height: 12),
          const Text(
            'Feature bets',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          for (final bet in FeatureBetType.values)
            _TileShell(
              child: Row(
                children: [
                  Icon(bet.icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bet.label,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          bet.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    key: Key('feature_bet_${bet.name}_button'),
                    onPressed: controller.featureBetTokens > 0
                        ? () => controller.chooseFeatureBet(bet)
                        : null,
                    child: const Text('Ship'),
                  ),
                ],
              ),
            ),
        ],
        const SizedBox(height: 12),
        FilledButton.icon(
          key: const Key('ship_product_button'),
          onPressed: controller.canAdvanceProduct
              ? controller.advanceProduct
              : null,
          icon: const Icon(Icons.upgrade),
          label: const Text('Ship next milestone'),
        ),
      ],
    );
  }
}

class _FundingPanel extends StatelessWidget {
  const _FundingPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      icon: Icons.trending_up,
      title: 'Funding: ${controller.fundingStage}',
      children: [
        Text(
          'Next round needs valuation ${formatNumber(controller.fundingCost)}.',
        ),
        const SizedBox(height: 8),
        Text(
          'Current focus changes fundraising shape. Finance-led lowers round cost; growth-led accelerates traction; product-led speeds shipping.',
        ),
        const SizedBox(height: 8),
        Text('Policy: ${controller.activeCapitalPolicy?.label ?? 'Pending'}'),
        const SizedBox(height: 8),
        Text(
          'Recovery doctrine: ${controller.activeVentureThesis?.label ?? 'Standard Ops'}',
        ),
        const SizedBox(height: 8),
        Text('Refreshes: ${controller.capitalPolicyRefreshes}'),
        const SizedBox(height: 8),
        Text(
          'Board influence ${controller.boardInfluence} | Crisis ${controller.crisisLevel} | Active directive: ${controller.activeBoardDemand?.label ?? 'None'}',
        ),
        if (controller.ipoUnlocked) ...[
          const SizedBox(height: 8),
          Text(
            'Market pulse: ${controller.activeMarketPulse?.label ?? 'None'} | ${controller.marketPulseSeconds.ceil()}s',
          ),
        ],
        if (controller.fundingStageIndex >= 7) ...[
          const SizedBox(height: 8),
          Text(
            'Parent directive: ${controller.activeParentDirective?.label ?? 'None'} | ${controller.parentDirectiveSeconds.ceil()}s',
          ),
        ],
        if (controller.capitalPolicyChoicePending) ...[
          const SizedBox(height: 12),
          const Text(
            'Choose a capital policy',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          for (final policy in CapitalPolicy.values)
            _TileShell(
              child: Row(
                children: [
                  Icon(policy.icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy.label,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          policy.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    key: Key('capital_policy_${policy.name}_button'),
                    onPressed: () => controller.chooseCapitalPolicy(policy),
                    child: const Text('Choose'),
                  ),
                ],
              ),
            ),
        ],
        if (controller.activeBoardDemand != null) ...[
          const SizedBox(height: 12),
          const Text(
            'Board directive',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          for (final demand in BoardDemandType.values)
            _TileShell(
              child: Row(
                children: [
                  Icon(demand.icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demand.label,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          demand.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    key: Key('board_demand_${demand.name}_button'),
                    onPressed: () => controller.resolveBoardDemand(demand),
                    child: const Text('Accept'),
                  ),
                ],
              ),
            ),
        ],
        if (controller.ipoUnlocked) ...[
          const SizedBox(height: 12),
          const Text(
            'Public-market volatility',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          for (final pulse in MarketPulseType.values)
            _TileShell(
              child: Row(
                children: [
                  Icon(pulse.icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pulse.label,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          pulse.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    key: Key('market_pulse_${pulse.name}_button'),
                    onPressed: () => controller.resolveMarketPulse(pulse),
                    child: const Text('Lean in'),
                  ),
                ],
              ),
            ),
        ],
        if (controller.fundingStageIndex >= 7) ...[
          const SizedBox(height: 12),
          const Text(
            'Parent-company directives',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          for (final directive in ParentDirectiveType.values)
            _TileShell(
              child: Row(
                children: [
                  Icon(directive.icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          directive.label,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          directive.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    key: Key('parent_directive_${directive.name}_button'),
                    onPressed: () =>
                        controller.resolveParentDirective(directive),
                    child: const Text('Accept'),
                  ),
                ],
              ),
            ),
        ],
        if (controller.crisisRecoveryUnlocked) ...[
          const SizedBox(height: 12),
          const Text(
            'Crisis recovery',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          for (final response in CrisisResponseType.values)
            _TileShell(
              child: Row(
                children: [
                  Icon(response.icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          response.label,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          response.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    key: Key('crisis_response_${response.name}_button'),
                    onPressed: () => controller.respondToCrisis(response),
                    child: const Text('Use'),
                  ),
                ],
              ),
            ),
        ],
        const SizedBox(height: 12),
        FilledButton.icon(
          key: const Key('raise_funding_button'),
          onPressed: controller.canRaiseFunding
              ? controller.raiseFunding
              : null,
          icon: const Icon(Icons.attach_money),
          label: const Text('Raise funding'),
        ),
      ],
    );
  }
}

class _EventsPanel extends StatelessWidget {
  const _EventsPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final event = controller.activeEvent;
    return _InfoPanel(
      icon: Icons.bolt,
      title: 'Burst Events',
      children: [
        Text(
          event == null
              ? 'Next event in ${controller.eventCooldownSeconds.ceil()}s.'
              : '${event.label}: ${event.description}',
        ),
        const SizedBox(height: 8),
        Text(
          'Event reward level ${controller.eventRewardLevel} | Multiplier x${controller.eventRewardMultiplier.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 8),
        Text(
          'Momentum ${controller.founderMomentum.toStringAsFixed(0)}% | Founder flow ${controller.founderFlowSeconds.ceil()}s | Return surge ${controller.comebackBurstSeconds.ceil()}s',
        ),
        const SizedBox(height: 8),
        Text(
          'Trust ${controller.customerTrust.toStringAsFixed(0)} | Morale ${controller.teamMorale.toStringAsFixed(0)}',
        ),
        if (controller.activeConsequenceLabels.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Active consequences: ${controller.activeConsequenceLabels.join(' • ')}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
        const SizedBox(height: 6),
        const Text(
          'Revenue-heavy choices usually cash out harder right now, but they can lower trust or morale and make later contracts worse.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          key: const Key('events_claim_button'),
          onPressed: event == null ? null : controller.activateEvent,
          icon: Icon(event?.icon ?? Icons.hourglass_bottom),
          label: Text(
            event == null ? 'Waiting for event' : 'Activate ${event.label}',
          ),
        ),
        if (event != null) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const Key('events_alt_button'),
            onPressed: () =>
                controller.resolveEvent(controller.secondaryEventChoiceLabel),
            icon: const Icon(Icons.alt_route),
            label: Text(controller.secondaryEventChoiceLabel),
          ),
        ],
      ],
    );
  }
}

class _AdvisorsPanel extends StatelessWidget {
  const _AdvisorsPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoPanel(
          icon: Icons.support_agent,
          title: 'Advisor Loadout',
          children: [
            Text(
              controller.advisorsUnlocked
                  ? 'Unlocked ${controller.unlockedAdvisors.length}/${AdvisorId.values.length} advisors. Equip one to shape this run.'
                  : 'Advisors unlock after Product Beta or Pre-seed.',
            ),
            const SizedBox(height: 8),
            Text('Equipped: ${controller.equippedAdvisor?.label ?? 'None'}'),
            const SizedBox(height: 8),
            Text(
              controller.advisorCollectionSetUnlocked
                  ? 'Collection set active: 3 advisors unlocked for a permanent x${controller.advisorCollectionMultiplier.toStringAsFixed(2)} office bonus.'
                  : 'Collection set bonus: unlock 3 advisors for a permanent office-wide multiplier.',
            ),
          ],
        ),
        for (final advisor in AdvisorId.values)
          _TileShell(
            child: Row(
              children: [
                Icon(advisor.icon, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        advisor.label,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        advisor.description,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  key: Key('advisor_${advisor.name}_button'),
                  onPressed: controller.unlockedAdvisors.contains(advisor)
                      ? () => controller.equipAdvisor(advisor)
                      : null,
                  child: Text(
                    controller.equippedAdvisor == advisor ? 'Unequip' : 'Equip',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _RoadmapPanel extends StatelessWidget {
  const _RoadmapPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      icon: Icons.alt_route,
      title: 'Next Unlocks',
      children: [
        Text(controller.nextOfficeUnlockHint),
        const SizedBox(height: 6),
        Text(controller.nextTeamUnlockHint),
        const SizedBox(height: 6),
        Text(controller.nextProductUnlockHint),
        const SizedBox(height: 6),
        Text(controller.nextFundingUnlockHint),
        const SizedBox(height: 10),
        const Text(
          'Active milestone synergies',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          controller.engineeringDesignSynergyUnlocked
              ? 'Engineering + Design pod active: stronger shipping and valuation.'
              : 'Need 5 engineering + 2 design for the product synergy milestone.',
        ),
        const SizedBox(height: 6),
        Text(
          controller.goToMarketSynergyUnlocked
              ? 'Go-to-market machine active: stronger cash and traction loops.'
              : 'Need 5 growth/sales hires for the GTM synergy milestone.',
        ),
        const SizedBox(height: 6),
        Text(
          controller.opsCommandSynergyUnlocked
              ? 'Ops command active: stronger credits and process leverage.'
              : 'Need 5 ops/data/finance hires for the operations milestone.',
        ),
        const SizedBox(height: 10),
        const Text(
          'Retention hooks now online',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          controller.momentumUnlocked
              ? 'Founder momentum is live. Push taps, hires, ships, and contracts into a 100% bar to trigger a 30s founder flow burst.'
              : 'Prototype or 3 hires unlock founder momentum bursts.',
        ),
        const SizedBox(height: 6),
        Text(
          controller.contractsUnlocked
              ? 'Deal chain active: consecutive contract closes shorten future delivery time and raise payouts.'
              : 'Prototype unlocks contracts, then streaking deals becomes a core mid-game loop.',
        ),
        const SizedBox(height: 6),
        Text(
          'Long offline sessions now convert into a short re-entry surge so coming back immediately feels rewarding.',
        ),
        const SizedBox(height: 6),
        Text(
          controller.productMatrixUnlocked
              ? 'Product matrix unlocked: portfolio experience now boosts shipping and traction across multiple product lines.'
              : 'Two portfolio companies reveal the product-matrix layer.',
        ),
        const SizedBox(height: 6),
        Text(
          controller.holdingPlatformUnlocked
              ? 'Holding platform unlocked: the company now compounds like a broader operating platform.'
              : 'Three portfolio companies reveal the holding-platform layer.',
        ),
      ],
    );
  }
}

class _ChallengesPanel extends StatelessWidget {
  const _ChallengesPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoPanel(
          icon: Icons.flag,
          title: 'Challenge Runs',
          children: [
            Text(
              controller.challengesUnlocked
                  ? 'Challenge tokens: ${controller.challengeTokens} | Completed ${controller.completedChallenges.length}/${ChallengeId.values.length}'
                  : 'Challenges unlock after your first prestige or 250K valuation.',
            ),
            const SizedBox(height: 8),
            Text('Active: ${controller.activeChallenge?.label ?? 'None'}'),
            if (controller.activeChallenge != null) ...[
              const SizedBox(height: 8),
              OutlinedButton(
                key: const Key('challenge_abandon_button'),
                onPressed: controller.abandonChallenge,
                child: const Text('Abandon challenge'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        for (final mission in <LiveOpsMissionDefinition>[
          controller.currentDailyMission,
          controller.currentWeeklyMission,
        ])
          _TileShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      mission.cadence == LiveOpsCadence.daily
                          ? Icons.today
                          : Icons.date_range,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${mission.cadence.label} Mission: ${mission.title}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    if (controller.isLiveOpsClaimed(mission))
                      const Icon(Icons.check_circle, size: 18),
                  ],
                ),
                const SizedBox(height: 6),
                Text(mission.description, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  'Progress ${formatNumber(controller.progressFor(mission.kind))}/${formatNumber(mission.target)}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reward: ${controller.liveOpsRewardText(mission)}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  key: Key('live_ops_${mission.id}_button'),
                  onPressed: controller.canClaimLiveOpsMission(mission)
                      ? () => controller.claimLiveOpsMission(mission)
                      : null,
                  child: Text(
                    controller.isLiveOpsClaimed(mission)
                        ? 'Claimed'
                        : controller.canClaimLiveOpsMission(mission)
                        ? 'Claim reward'
                        : 'In progress',
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        for (final challenge in ChallengeId.values)
          _TileShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        challenge.label,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    if (controller.completedChallenges.contains(challenge))
                      const Icon(Icons.check_circle, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  challenge.description,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  key: Key('challenge_${challenge.name}_button'),
                  onPressed:
                      controller.challengesUnlocked &&
                          !controller.completedChallenges.contains(challenge)
                      ? () => controller.startChallenge(challenge)
                      : null,
                  child: Text(
                    controller.completedChallenges.contains(challenge)
                        ? 'Completed'
                        : controller.activeChallenge == challenge
                        ? 'Active'
                        : 'Start fresh run',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ExpansionPanel extends StatelessWidget {
  const _ExpansionPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final contractCost = 20 + controller.contractWins * 12.0;
    return Column(
      children: [
        _InfoPanel(
          icon: Icons.public,
          title: 'Contracts & Markets',
          children: [
            Text(
              controller.contractsUnlocked
                  ? 'Insight ${formatNumber(controller.marketInsight)} | +${formatNumber(controller.marketInsightPerSecond)}/s'
                  : 'Contracts unlock at Prototype or Pre-seed. Markets unlock at Launch or Seed.',
            ),
            const SizedBox(height: 8),
            Text(
              'Expansion Lv.${controller.marketExpansionLevel} | Contracts won ${controller.contractWins}',
            ),
            const SizedBox(height: 8),
            Text(
              'Trust ${controller.customerTrust.toStringAsFixed(0)} | Morale ${controller.teamMorale.toStringAsFixed(0)} | Playbooks ${controller.unlockedPlaybooks.length}/${PlaybookId.values.length}',
            ),
            const SizedBox(height: 8),
            Text(
              'Deal chain x${controller.contractChain} | Reward x${controller.contractChainMultiplier.toStringAsFixed(2)} | Delivery x${controller.contractDurationMultiplier.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              'Contracts now roll against trust, morale, playbooks, and event consequences. Safer runs close deals more reliably.',
              style: const TextStyle(fontSize: 12),
            ),
            if (controller.activeContract != null) ...[
              const SizedBox(height: 8),
              Text(
                'Active contract: ${controller.activeContract!.label} | ${controller.activeContractSeconds.ceil()}s left | ${(controller.contractSuccessChance(controller.activeContract!) * 100).round()}% success | Chain x${controller.contractChain}',
              ),
            ],
            if (controller.readyContract != null) ...[
              const SizedBox(height: 8),
              FilledButton.icon(
                key: const Key('claim_ready_contract_button'),
                onPressed: controller.claimReadyContract,
                icon: const Icon(Icons.inventory_2),
                label: Text('Claim ${controller.readyContract!.label}'),
              ),
            ],
            if (controller.lastContractSummary.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                controller.lastContractSummary,
                style: const TextStyle(fontSize: 12),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Next market needs ${formatNumber(controller.nextExpansionInsight)} insight. Expansion boosts income, traction, and contract payouts.',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              key: const Key('expansion_upgrade_button'),
              onPressed: controller.expansionUnlocked
                  ? controller.investInExpansion
                  : null,
              icon: const Icon(Icons.travel_explore),
              label: const Text('Open next market'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              key: const Key('expansion_contract_button'),
              onPressed:
                  controller.expansionUnlocked &&
                      controller.marketExpansionLevel > 0
                  ? controller.signExpansionContract
                  : null,
              icon: const Icon(Icons.description),
              label: Text('Legacy market deal (${formatNumber(contractCost)})'),
            ),
          ],
        ),
        if (controller.availableContracts.isNotEmpty)
          ...controller.availableContracts.map(
            (contract) => _TileShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(contract.icon, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          contract.label,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text('${controller.contractDurationSeconds(contract)}s'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    contract.description,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Needs Trust ${contract.requiredTrust.toStringAsFixed(0)} / Morale ${contract.requiredMorale.toStringAsFixed(0)} / Insight ${formatNumber(controller.contractInsightCost(contract))}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${controller.contractRiskLabel(contract)} • ${(controller.contractSuccessChance(contract) * 100).round()}% success • ${controller.contractFailurePreview(contract)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    key: Key('contract_${contract.name}_button'),
                    onPressed:
                        controller.activeContract == null &&
                            controller.readyContract == null
                        ? () => controller.startContract(contract)
                        : null,
                    child: const Text('Start contract'),
                  ),
                ],
              ),
            ),
          ),
        if (controller.unlockedPlaybooks.isNotEmpty)
          _InfoPanel(
            icon: Icons.menu_book,
            title: 'Playbook Shelf',
            children: [
              for (final playbook in controller.unlockedPlaybooks)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(playbook.icon, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${playbook.label}: ${playbook.description}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              const Text(
                'Growth Script trades a little trust floor for hotter loops. People Ops lowers burst upside but stabilizes hiring and delivery. Enterprise Deck makes big deals richer but slows pure product throughput.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
      ],
    );
  }
}

class _PrestigePanel extends StatelessWidget {
  const _PrestigePanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      icon: Icons.auto_awesome,
      title: 'Prestige / Rebirth',
      children: [
        Text(
          'Permanent multiplier: x${controller.prestigeMultiplier.toStringAsFixed(2)}',
        ),
        Text('Legacy tokens: ${controller.legacyTokens}'),
        Text('Founder reputation: ${controller.founderReputation}'),
        Text('Founder origin tokens: ${controller.founderOriginTokens}'),
        Text(
          'Portfolio companies: ${controller.portfolioCompanies} | Portfolio points: ${controller.portfolioPoints}',
        ),
        Text(
          'Product Lv.${controller.productLegacyLevel} | Growth Lv.${controller.growthLegacyLevel} | Finance Lv.${controller.financeLegacyLevel}',
        ),
        Text(
          'Talent Bench Lv.${controller.talentBenchLevel} | Brand Network Lv.${controller.brandNetworkLevel} | Venture Fund Lv.${controller.ventureFundLevel}',
        ),
        Text(
          'Deal Flow ${controller.ventureDealFlow} | Studio Lv.${controller.ventureStudioLevel} | Syndicate Lv.${controller.syndicateNetworkLevel}',
        ),
        Text('Season tokens: ${controller.seasonTokens}'),
        Text(
          'Founder trophies: ${controller.unlockedTrophies.length}/${FounderTrophyId.values.length}',
        ),
        const SizedBox(height: 8),
        Text(
          controller.founderSpecializationsUnlocked
              ? 'Founder specialization: ${controller.activeSpecialization?.label ?? 'None'}'
              : 'Prestige once to unlock founder specializations.',
        ),
        Text('Founder origin: ${controller.activeFounderOrigin.label}'),
        Text(
          controller.ventureThesisUnlocked
              ? 'Venture thesis: ${controller.activeVentureThesis?.label ?? 'Choose one'}'
              : 'Second prestige unlocks venture theses and a stronger meta layer.',
        ),
        Text(
          'Season: ${controller.activeSeason?.label ?? 'None'} | ${controller.seasonSeconds.ceil()}s',
        ),
        Text('Target valuation: ${formatNumber(controller.prestigeTarget)}'),
        if (controller.productMatrixUnlocked)
          Text(
            'Reveal: Product matrix online. Multi-product leverage is now active.',
          ),
        if (controller.holdingPlatformUnlocked)
          Text(
            'Reveal: Holding platform online. The company now compounds across portfolio structure.',
          ),
        if (controller.ventureThesisUnlocked) ...[
          const SizedBox(height: 12),
          const Text(
            'Venture thesis',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          for (final thesis in VentureThesis.values)
            _TileShell(
              child: Row(
                children: [
                  Icon(thesis.icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thesis.label,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          thesis.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    key: Key('venture_thesis_${thesis.name}_button'),
                    onPressed: () => controller.setVentureThesis(thesis),
                    child: Text(
                      controller.activeVentureThesis == thesis
                          ? 'Active'
                          : 'Equip',
                    ),
                  ),
                ],
              ),
            ),
        ],
        if (controller.founderSpecializationsUnlocked) ...[
          const SizedBox(height: 12),
          for (final specialization in FounderSpecialization.values)
            _TileShell(
              child: Row(
                children: [
                  Icon(specialization.icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${specialization.label} Lv.${switch (specialization) {
                            FounderSpecialization.builder => controller.builderLegacyLevel,
                            FounderSpecialization.operator => controller.operatorLegacyLevel,
                            FounderSpecialization.rainmaker => controller.rainmakerLegacyLevel,
                          }}',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          specialization.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      OutlinedButton(
                        key: Key(
                          'specialization_${specialization.name}_button',
                        ),
                        onPressed: () =>
                            controller.setFounderSpecialization(specialization),
                        child: Text(
                          controller.activeSpecialization == specialization
                              ? 'Active'
                              : 'Equip',
                        ),
                      ),
                      const SizedBox(height: 6),
                      FilledButton(
                        key: Key(
                          'specialization_upgrade_${specialization.name}_button',
                        ),
                        onPressed: controller.founderReputation > 0
                            ? () => controller.upgradeFounderSpecialization(
                                specialization,
                              )
                            : null,
                        child: const Text('+1'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
        const SizedBox(height: 12),
        const Text(
          'Founder origin',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        for (final origin in FounderOrigin.values)
          _TileShell(
            child: Row(
              children: [
                Icon(origin.icon, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        origin.label,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        origin.description,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  key: Key('origin_${origin.name}_button'),
                  onPressed: controller.activeFounderOrigin == origin
                      ? null
                      : () => controller.setFounderOrigin(origin),
                  child: Text(
                    controller.activeFounderOrigin == origin
                        ? 'Active'
                        : 'Equip',
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        const Text(
          'Founder trophies',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        for (final trophy in FounderTrophyId.values)
          _TileShell(
            child: Row(
              children: [
                Icon(trophy.icon, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trophy.label,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        trophy.description,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(
                  controller.unlockedTrophies.contains(trophy)
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              key: const Key('legacy_product_button'),
              onPressed: () =>
                  controller.buyLegacyUpgrade(CompanyFocus.product),
              child: const Text('Upgrade Product Legacy'),
            ),
            OutlinedButton(
              key: const Key('legacy_growth_button'),
              onPressed: () => controller.buyLegacyUpgrade(CompanyFocus.growth),
              child: const Text('Upgrade Growth Legacy'),
            ),
            OutlinedButton(
              key: const Key('legacy_finance_button'),
              onPressed: () =>
                  controller.buyLegacyUpgrade(CompanyFocus.finance),
              child: const Text('Upgrade Finance Legacy'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Portfolio meta',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        for (final track in PortfolioTrack.values)
          _TileShell(
            child: Row(
              children: [
                Icon(track.icon, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.label,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        track.description,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  key: Key('portfolio_${track.name}_button'),
                  onPressed: controller.portfolioPoints > 0
                      ? () => controller.buyPortfolioUpgrade(track)
                      : null,
                  child: const Text('+1'),
                ),
              ],
            ),
          ),
        if (controller.ventureFundLevel > 0) ...[
          const SizedBox(height: 12),
          const Text(
            'Venture network',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          for (final move in VentureMoveType.values)
            _TileShell(
              child: Row(
                children: [
                  Icon(move.icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          move.label,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          move.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    key: Key('venture_move_${move.name}_button'),
                    onPressed: () => controller.executeVentureMove(move),
                    child: const Text('Run'),
                  ),
                ],
              ),
            ),
        ],
        const SizedBox(height: 12),
        const Text(
          'Season event',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        for (final season in SeasonEventType.values)
          _TileShell(
            child: Row(
              children: [
                Icon(season.icon, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        season.label,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        season.description,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  key: Key('season_${season.name}_button'),
                  onPressed: () => controller.activateSeason(season),
                  child: const Text('Activate'),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        const Text(
          'Founder records',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text('Peak valuation: ${formatNumber(controller.peakValuationRecord)}'),
        Text(
          'Fastest IPO: ${controller.fastestIpoSecondsRecord == 0 ? 'None yet' : '${controller.fastestIpoSecondsRecord}s'}',
        ),
        Text(
          'Clean bootstrapped run: ${controller.cleanBootstrappedRecord ? 'Unlocked' : 'Not yet'}',
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          key: const Key('prestige_button'),
          onPressed: controller.canPrestige ? controller.prestige : null,
          icon: const Icon(Icons.restart_alt),
          label: const Text('Sell company and restart'),
        ),
      ],
    );
  }
}

class _QuestPanel extends StatelessWidget {
  const _QuestPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final quest in controller.quests)
          _GoalTile(
            title: quest.title,
            description: quest.description,
            progress: controller.progressFor(quest.kind),
            target: quest.target,
            complete: controller.completedQuests.contains(quest.id),
            reward: controller.questRewardText(quest),
          ),
        const SizedBox(height: 8),
        const Divider(),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Achievements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ),
        for (final achievement in controller.achievements)
          _GoalTile(
            title: achievement.title,
            description: achievement.description,
            progress: controller.progressFor(achievement.kind),
            target: achievement.target,
            complete: controller.completedAchievements.contains(achievement.id),
            reward: controller.achievementRewardText(achievement),
          ),
      ],
    );
  }
}

class _ShopPanel extends StatelessWidget {
  const _ShopPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SimpleTile(
          icon: Icons.play_circle,
          title: 'Rewarded Ad Boost',
          subtitle: 'Placeholder: grants 3 minutes of local income.',
          button: 'Watch',
          buttonKey: const Key('rewarded_ad_button'),
          onPressed: controller.watchRewardedAd,
        ),
        _SimpleTile(
          icon: Icons.inventory_2,
          title: 'Starter Pack',
          subtitle: controller.starterPackOwned
              ? 'Owned'
              : 'Placeholder IAP reward.',
          button: controller.starterPackOwned ? 'Owned' : 'Buy',
          buttonKey: const Key('starter_pack_button'),
          onPressed: controller.starterPackOwned
              ? null
              : controller.buyStarterPack,
        ),
        _SimpleTile(
          icon: Icons.block,
          title: 'Remove Ads',
          subtitle: controller.noAdsOwned
              ? 'Owned'
              : 'Placeholder store product.',
          button: controller.noAdsOwned ? 'Owned' : 'Buy',
          buttonKey: const Key('remove_ads_button'),
          onPressed: controller.noAdsOwned ? null : controller.buyNoAds,
        ),
      ],
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      icon: Icons.settings,
      title: 'Settings',
      children: [
        Text('Save schema v${GameController.schemaVersion}'),
        Text('Manual taps: ${controller.manualTaps}'),
        Text('Ads watched: ${controller.rewardedAdsWatched}'),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: controller.save,
          icon: const Icon(Icons.save),
          label: const Text('Save now'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: controller.resetSave,
          icon: const Icon(Icons.delete_outline),
          label: const Text('Reset local save'),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cost,
    required this.canAfford,
    this.buttonKey,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final double cost;
  final bool canAfford;
  final Key? buttonKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _TileShell(
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          FilledButton(
            key: buttonKey,
            onPressed: canAfford ? onPressed : null,
            child: Text(formatNumber(cost)),
          ),
        ],
      ),
    );
  }
}

class _CreditActionTile extends StatelessWidget {
  const _CreditActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cost,
    required this.canAfford,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final double cost;
  final bool canAfford;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _TileShell(
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: canAfford ? onPressed : null,
            icon: const Icon(Icons.token, size: 16),
            label: Text(formatNumber(cost)),
          ),
        ],
      ),
    );
  }
}

class _SimpleTile extends StatelessWidget {
  const _SimpleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.button,
    required this.buttonKey,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String button;
  final Key buttonKey;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _TileShell(
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          FilledButton(
            key: buttonKey,
            onPressed: onPressed,
            child: Text(button),
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.title,
    required this.description,
    required this.progress,
    required this.target,
    required this.complete,
    required this.reward,
  });
  final String title;
  final String description;
  final double progress;
  final double target;
  final bool complete;
  final String reward;

  @override
  Widget build(BuildContext context) {
    final ratio = target <= 0
        ? 1.0
        : (progress / target).clamp(0, 1).toDouble();
    return _TileShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                complete ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                reward,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: ratio, minHeight: 8),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.children,
  });
  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _TileShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _TileShell extends StatelessWidget {
  const _TileShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff273d33), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StageChip extends StatelessWidget {
  const _StageChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xff1f8f72),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EventLog extends StatelessWidget {
  const _EventLog({required this.controller});
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      icon: Icons.receipt_long,
      title: 'Office Log',
      children: controller.eventLog.isEmpty
          ? const [Text('No events yet.')]
          : [
              for (final event in controller.eventLog)
                Text('• $event', style: const TextStyle(fontSize: 12)),
            ],
    );
  }
}

class _OverlayNotice extends StatelessWidget {
  const _OverlayNotice({
    required this.title,
    required this.body,
    this.details = const <String>[],
    required this.action,
    required this.onPressed,
  });
  final String title;
  final String body;
  final List<String> details;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.45),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xfffffbf0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center),
              if (details.isNotEmpty) ...[
                const SizedBox(height: 12),
                for (final detail in details)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $detail', textAlign: TextAlign.center),
                  ),
              ],
              const SizedBox(height: 12),
              FilledButton(onPressed: onPressed, child: Text(action)),
            ],
          ),
        ),
      ),
    );
  }
}

String formatNumber(double value) {
  final abs = value.abs();
  if (abs >= 1000000000) return '${(value / 1000000000).toStringAsFixed(2)}B';
  if (abs >= 1000000) return '${(value / 1000000).toStringAsFixed(2)}M';
  if (abs >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  if (abs >= 100) return value.toStringAsFixed(0);
  if (abs >= 10) return value.toStringAsFixed(1);
  if (abs == 0) return '0';
  return value.toStringAsFixed(1);
}
