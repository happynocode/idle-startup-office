import 'package:flutter_test/flutter_test.dart';
import 'package:idle_startup_office/main.dart';

void main() {
  test(
    'a normal strategy can reach the first prestige without mutating state',
    () {
      final controller = GameController();

      for (var step = 0; step < 20000 && !controller.canPrestige; step++) {
        if (!controller.starterPackOwned) {
          controller.buyStarterPack();
        }

        for (var i = 0; i < 20; i++) {
          controller.founderTap();
        }

        while (controller.cash >= controller.tapUpgradeCost) {
          controller.buyTapUpgrade();
        }
        while (controller.cash >= controller.officeUpgradeCost) {
          controller.buyOfficeUpgrade();
        }
        for (final role in Role.values) {
          while (controller.cash >= controller.hireCost(role) &&
              controller.hasTeamCapacity) {
            controller.hire(role);
          }
        }
        if (controller.canAdvanceProduct) {
          controller.advanceProduct();
        }
        if (controller.canRaiseFunding) {
          controller.raiseFunding();
        }

        controller.watchRewardedAd();
        controller.tick(15);
      }

      expect(controller.canPrestige, isTrue);
      final pointsBefore = controller.prestigePoints;
      controller.prestige();
      expect(controller.lifetimePrestiges, 1);
      expect(controller.prestigePoints, greaterThan(pointsBefore));
      expect(controller.teamSize, 0);
    },
  );

  test('has a richer startup simulation surface', () {
    final controller = GameController();

    expect(Role.values.length, greaterThanOrEqualTo(12));
    expect(StartupSystem.values.length, greaterThanOrEqualTo(10));
    expect(controller.achievements.length, greaterThanOrEqualTo(12));

    controller.buyStarterPack();
    expect(controller.credits, greaterThan(0));
    controller.buySystem(StartupSystem.founderDashboard);
    expect(controller.systemLevel(StartupSystem.founderDashboard), 1);
    expect(controller.nextOfficeUnlockHint, contains('Office Lv.2'));

    controller.buyOfficeUpgrade();
    controller.hire(Role.juniorDeveloper);
    controller.hire(Role.uxDesigner);
    controller.hire(Role.growthMarketer);
    expect(controller.sprintUnlocked, isTrue);
    expect(controller.founderAutomationPerSecond, greaterThan(0));
  });

  test(
    'challenge runs award permanent rewards and expansion contracts pay out',
    () {
      final controller = GameController();

      controller.buyStarterPack();
      controller.valuation = 300000;
      expect(controller.challengesUnlocked, isTrue);

      controller.startChallenge(ChallengeId.bootstrappedRun);
      expect(controller.activeChallenge, ChallengeId.bootstrappedRun);
      expect(controller.cash, 0);

      controller.productStageIndex = 4;
      controller.tick(0);
      expect(
        controller.completedChallenges,
        contains(ChallengeId.bootstrappedRun),
      );
      expect(controller.challengeTokens, 1);
      expect(controller.unlockedAdvisors, contains(AdvisorId.financeChief));

      controller.equipAdvisor(AdvisorId.financeChief);
      expect(controller.equippedAdvisor, AdvisorId.financeChief);

      controller.fundingStageIndex = 2;
      controller.productStageIndex = 4;
      controller.marketInsight = controller.nextExpansionInsight + 50;
      controller.investInExpansion();
      expect(controller.marketExpansionLevel, 1);

      controller.marketInsight = 999;
      final cashBefore = controller.cash;
      controller.signExpansionContract();
      expect(controller.contractWins, 1);
      expect(controller.cash, greaterThan(cashBefore));

      controller.unlockedAdvisors.addAll({
        AdvisorId.productSage,
        AdvisorId.growthHacker,
        AdvisorId.financeChief,
      });
      expect(controller.advisorCollectionSetUnlocked, isTrue);
      expect(controller.advisorCollectionMultiplier, greaterThan(1));

      final prestigeController = GameController();
      prestigeController.valuation = prestigeController.prestigeTarget;
      prestigeController.prestige();
      expect(prestigeController.founderSpecializationsUnlocked, isTrue);
      expect(prestigeController.founderReputation, greaterThan(0));

      prestigeController.upgradeFounderSpecialization(
        FounderSpecialization.builder,
      );
      prestigeController.setFounderSpecialization(
        FounderSpecialization.builder,
      );
      expect(prestigeController.builderLegacyLevel, greaterThan(0));
      expect(
        prestigeController.activeSpecialization,
        FounderSpecialization.builder,
      );
      expect(prestigeController.startingProductBonus, greaterThan(0));
    },
  );

  test(
    'product strategy, capital policy, and alternate event choices work',
    () {
      final controller = GameController();

      controller.productStageIndex = 1;
      controller.productProgress = controller.nextProductProgress;
      controller.advanceProduct();
      expect(controller.productStageIndex, 2);
      expect(controller.productStrategyChoicePending, isTrue);

      controller.chooseProductStrategy(ProductStrategy.growthLoops);
      expect(controller.activeProductStrategy, ProductStrategy.growthLoops);
      expect(controller.productStrategyChoicePending, isFalse);
      expect(controller.productStrategyTractionMultiplier, greaterThan(1));

      controller.valuation = controller.fundingCost;
      controller.raiseFunding();
      controller.valuation = controller.fundingCost;
      controller.raiseFunding();
      expect(controller.fundingStageIndex, 2);
      expect(controller.capitalPolicyChoicePending, isTrue);

      controller.chooseCapitalPolicy(CapitalPolicy.efficientGrowth);
      expect(controller.activeCapitalPolicy, CapitalPolicy.efficientGrowth);
      expect(controller.capitalPolicyChoicePending, isFalse);
      expect(controller.capitalPolicyFundingMultiplier, lessThan(1));

      controller.activeEvent = StartupEventType.investorCall;
      final valuationBefore = controller.valuation;
      controller.resolveEvent(controller.secondaryEventChoiceLabel);
      expect(controller.activeEvent, isNull);
      expect(controller.valuation, greaterThan(valuationBefore));
    },
  );

  test('contracts, playbooks, and portfolio meta persist across exits', () {
    final controller = GameController();

    controller.productStageIndex = 4;
    controller.fundingStageIndex = 2;
    controller.marketExpansionLevel = 1;
    controller.marketInsight = 500;
    controller.customerTrust = 110;
    controller.teamMorale = 105;

    controller.startContract(ContractType.enterpriseRollout);
    expect(controller.activeContract, ContractType.enterpriseRollout);
    expect(
      controller.contractSuccessChance(ContractType.enterpriseRollout),
      greaterThan(0.8),
    );

    controller.tick(ContractType.enterpriseRollout.durationSeconds.toDouble());
    expect(controller.readyContract, ContractType.enterpriseRollout);

    final cashBefore = controller.cash;
    controller.claimReadyContract();
    expect(controller.cash, greaterThan(cashBefore));
    expect(controller.contractWins, 1);
    expect(controller.unlockedPlaybooks, contains(PlaybookId.enterpriseDeck));

    controller.valuation = controller.prestigeTarget * 3;
    controller.productStageIndex = 5;
    controller.fundingStageIndex = 4;
    controller.contractWins = 3;
    controller.prestige();

    expect(controller.portfolioCompanies, 1);
    expect(controller.portfolioPoints, greaterThan(0));

    final pointsBefore = controller.portfolioPoints;
    controller.buyPortfolioUpgrade(PortfolioTrack.brandNetwork);
    expect(controller.portfolioPoints, lessThan(pointsBefore));
    expect(controller.brandNetworkLevel, 1);
  });

  test('contract failures create visible downside and event choices alter delivery', () {
    final controller = GameController();

    controller.productStageIndex = 4;
    controller.fundingStageIndex = 2;
    controller.marketExpansionLevel = 1;
    controller.marketInsight = 500;
    controller.customerTrust = 92;
    controller.teamMorale = 90;
    controller.activeEvent = StartupEventType.viralMoment;

    controller.resolveEvent(controller.primaryEventChoiceLabel);
    expect(controller.supportBacklogSeconds, greaterThan(0));

    controller.fundingStageIndex = 1;
    controller.customerTrust = 52;
    controller.teamMorale = 48;
    final failureChance = controller.contractSuccessChance(
      ContractType.channelPartnership,
    );
    expect(failureChance, lessThan(0.68));

    controller.startContract(ContractType.channelPartnership);
    controller.tick(ContractType.channelPartnership.durationSeconds.toDouble());

    expect(controller.readyContract, isNull);
    expect(controller.lastContractSummary, contains('slipped'));
    expect(controller.crisisLevel, greaterThan(0));
  });

  test('feature bets and board demands create mid-game systemic rewards', () {
    final controller = GameController();

    controller.productStageIndex = 5;
    controller.fundingStageIndex = 2;
    controller.featureBetTokens = 2;
    controller.customerTrust = 90;
    controller.teamMorale = 88;
    controller.activeBoardDemand = BoardDemandType.growthPush;
    controller.crisisLevel = 2;

    controller.chooseFeatureBet(FeatureBetType.aiCopilot);
    expect(controller.aiCopilotLevel, 1);
    expect(controller.traction, greaterThan(0));
    expect(controller.featureBetTokens, 1);

    controller.resolveBoardDemand(BoardDemandType.qualityReset);
    expect(controller.activeBoardDemand, BoardDemandType.qualityReset);
    expect(controller.customerTrust, greaterThan(90));
    expect(controller.qualityResetSeconds, greaterThan(0));
    expect(controller.crisisLevel, lessThan(2));
  });

  test(
    'team leads, projects, and culture incidents unlock at team milestones',
    () {
      final controller = GameController();

      controller.cash = 100000;
      controller.officeLevel = 8;
      controller.productStageIndex = 5;

      controller.hire(Role.juniorDeveloper);
      controller.hire(Role.uxDesigner);
      controller.hire(Role.growthMarketer);
      controller.hire(Role.productManager);
      controller.hire(Role.devOpsEngineer);
      controller.hire(Role.dataAnalyst);
      expect(controller.teamLeadsUnlocked, isTrue);

      controller.setTeamLead(TeamLeadFocus.engineering);
      expect(controller.activeLead, TeamLeadFocus.engineering);
      expect(controller.leadProductMultiplier, greaterThan(1));

      controller.hire(Role.accountExecutive);
      controller.hire(Role.financeOps);
      controller.hire(Role.customerSuccess);
      controller.hire(Role.recruiter);
      expect(controller.crossProjectsUnlocked, isTrue);

      controller.startProject(ProjectType.launchWarRoom);
      expect(controller.activeProject, ProjectType.launchWarRoom);
      controller.tick(60);
      expect(controller.readyProject, ProjectType.launchWarRoom);
      controller.claimProject();
      expect(controller.launchWarRoomLevel, 1);

      while (controller.teamSize < 20 && controller.hasTeamCapacity) {
        controller.hire(Role.intern);
      }
      controller.teamMorale = 60;
      controller.tick(1);
      expect(controller.activeCultureIncident, isNotNull);
      controller.resolveCultureIncident(true);
      expect(controller.activeCultureIncident, isNull);
      expect(controller.cultureStability, greaterThan(0));
    },
  );

  test(
    'milestone synergies and reward refreshes unlock through progression',
    () {
      final controller = GameController();

      controller.cash = 50000;
      controller.officeLevel = 5;
      controller.productStageIndex = 4;

      controller.hire(Role.juniorDeveloper);
      controller.hire(Role.juniorDeveloper);
      controller.hire(Role.devOpsEngineer);
      controller.hire(Role.seniorEngineer);
      controller.hire(Role.seniorEngineer);
      controller.hire(Role.uxDesigner);
      controller.hire(Role.uxDesigner);
      expect(controller.engineeringDesignSynergyUnlocked, isTrue);
      expect(controller.departmentProductMultiplier, greaterThan(1));

      controller.completedQuests.clear();
      controller.productStageIndex = 2;
      controller.productProgress = 0;
      controller.tick(0);
      expect(controller.productStrategyRefreshes, greaterThan(0));

      controller.completedAchievements.clear();
      controller.credits = 1000;
      controller.tick(0);
      expect(controller.capitalPolicyRefreshes, greaterThan(0));
    },
  );

  test('daily and weekly live ops missions can be claimed once per cycle', () {
    final controller = GameController();

    void satisfyMission(LiveOpsMissionDefinition mission) {
      switch (mission.kind) {
        case QuestKind.teamSize:
          controller.cash = 100000;
          controller.officeLevel = 8;
          controller.productStageIndex = 5;
          while (controller.teamSize < mission.target &&
              controller.hasTeamCapacity) {
            controller.hire(Role.intern);
          }
          break;
        case QuestKind.productStage:
          controller.productStageIndex = mission.target.toInt();
          break;
        case QuestKind.valuation:
          controller.valuation = mission.target;
          break;
        case QuestKind.credits:
          controller.credits = mission.target;
          break;
        case QuestKind.taps:
          controller.manualTaps = mission.target.toInt();
          break;
        case QuestKind.developers:
          controller.cash = 100000;
          controller.officeLevel = 8;
          controller.productStageIndex = 5;
          while (controller.developers < mission.target &&
              controller.hasTeamCapacity) {
            controller.hire(Role.juniorDeveloper);
          }
          break;
        case QuestKind.engineeringTeam:
          controller.cash = 100000;
          controller.officeLevel = 8;
          controller.productStageIndex = 5;
          while (controller.progressFor(QuestKind.engineeringTeam) <
                  mission.target &&
              controller.hasTeamCapacity) {
            controller.hire(Role.juniorDeveloper);
          }
          break;
        case QuestKind.goToMarketTeam:
          controller.cash = 100000;
          controller.officeLevel = 8;
          controller.productStageIndex = 5;
          while (controller.progressFor(QuestKind.goToMarketTeam) <
                  mission.target &&
              controller.hasTeamCapacity) {
            controller.hire(Role.growthMarketer);
          }
          break;
        case QuestKind.opsTeam:
          controller.cash = 100000;
          controller.officeLevel = 8;
          controller.productStageIndex = 5;
          while (controller.progressFor(QuestKind.opsTeam) < mission.target &&
              controller.hasTeamCapacity) {
            controller.hire(Role.intern);
          }
          break;
        case QuestKind.fundingStage:
          controller.fundingStageIndex = mission.target.toInt();
          break;
        case QuestKind.cash:
          controller.cash = mission.target;
          break;
        case QuestKind.startupSystems:
          controller.credits = 10000;
          controller.officeLevel = 8;
          controller.productStageIndex = 5;
          for (final system in StartupSystem.values) {
            if (controller.progressFor(QuestKind.startupSystems) >=
                mission.target) {
              break;
            }
            if (controller.isSystemUnlocked(system)) {
              controller.buySystem(system);
            }
          }
          break;
        case QuestKind.prestiges:
          controller.lifetimePrestiges = mission.target.toInt();
          break;
      }
    }

    final daily = controller.currentDailyMission;
    satisfyMission(daily);
    expect(controller.canClaimLiveOpsMission(daily), isTrue);
    final dailyCashBefore = controller.cash;
    controller.claimLiveOpsMission(daily);
    expect(controller.cash, greaterThanOrEqualTo(dailyCashBefore));
    expect(controller.isLiveOpsClaimed(daily), isTrue);
    expect(controller.canClaimLiveOpsMission(daily), isFalse);

    final weekly = controller.currentWeeklyMission;
    satisfyMission(weekly);
    expect(controller.canClaimLiveOpsMission(weekly), isTrue);
    final repBefore = controller.founderReputation;
    controller.claimLiveOpsMission(weekly);
    expect(controller.isLiveOpsClaimed(weekly), isTrue);
    expect(controller.founderReputation, greaterThanOrEqualTo(repBefore));
  });

  test('founder origins change run openings and consume origin tokens', () {
    final controller = GameController();

    controller.valuation = controller.prestigeTarget;
    controller.prestige();
    expect(controller.founderOriginTokens, greaterThan(0));

    final tokensBefore = controller.founderOriginTokens;
    controller.setFounderOrigin(FounderOrigin.financeDesk);
    expect(controller.activeFounderOrigin, FounderOrigin.financeDesk);
    expect(controller.founderOriginTokens, tokensBefore - 1);
    controller.valuation = controller.prestigeTarget;
    controller.prestige();
    expect(controller.cash, greaterThan(0));

    controller.founderOriginTokens = 1;
    controller.setFounderOrigin(FounderOrigin.operatorGuild);
    controller.valuation = controller.prestigeTarget;
    controller.prestige();
    expect(controller.startingCreditsBonus, greaterThan(0));
    expect(controller.startingMoraleBonus, greaterThan(0));
    expect(controller.credits, greaterThan(0));
    expect(controller.teamMorale, greaterThan(55));
  });

  test('ipo volatility and acquired directives reshape late-game state', () {
    final controller = GameController();

    controller.fundingStageIndex = 6;
    controller.productStageIndex = 5;
    controller.cash = 50000;
    controller.valuation = 2000000;
    controller.customerTrust = 90;
    controller.teamMorale = 85;
    controller.resolveMarketPulse(MarketPulseType.activistPressure);
    expect(controller.activeMarketPulse, MarketPulseType.activistPressure);
    expect(controller.marketPulseSeconds, greaterThan(0));
    expect(controller.boardInfluence, greaterThan(0));

    controller.fundingStageIndex = 7;
    controller.traction = 40;
    final trustBefore = controller.customerTrust;
    controller.resolveParentDirective(ParentDirectiveType.integrationAudit);
    expect(
      controller.activeParentDirective,
      ParentDirectiveType.integrationAudit,
    );
    expect(controller.parentDirectiveSeconds, greaterThan(0));
    expect(controller.customerTrust, greaterThan(trustBefore));
  });

  test(
    'venture fund moves convert portfolio meta into founder network power',
    () {
      final controller = GameController();

      controller.ventureFundLevel = 1;
      controller.founderReputation = 2;
      controller.portfolioCompanies = 2;
      controller.portfolioPoints = 2;

      controller.executeVentureMove(VentureMoveType.scoutNetwork);
      expect(controller.ventureDealFlow, 1);
      expect(controller.founderReputation, 1);

      final companiesBefore = controller.portfolioCompanies;
      controller.executeVentureMove(VentureMoveType.studioSpinout);
      expect(controller.portfolioCompanies, companiesBefore - 1);
      expect(controller.ventureStudioLevel, 1);
      expect(controller.cash, greaterThan(0));

      final pointsBefore = controller.portfolioPoints;
      controller.executeVentureMove(VentureMoveType.syndicateAccess);
      expect(controller.portfolioPoints, pointsBefore - 1);
      expect(controller.syndicateNetworkLevel, 1);
      expect(controller.marketInsight, greaterThan(0));
    },
  );

  test(
    'season events activate and founder records persist across prestige',
    () {
      final controller = GameController();

      controller.seasonTokens = 1;
      controller.activateSeason(SeasonEventType.capitalWeek);
      expect(controller.activeSeason, SeasonEventType.capitalWeek);
      expect(controller.seasonSeconds, greaterThan(0));

      controller.valuation = 2500000;
      controller.productStageIndex = 4;
      controller.fundingStageIndex = 6;
      controller.runSeconds = 42;
      controller.prestige();

      expect(controller.peakValuationRecord, greaterThan(0));
      expect(controller.fastestIpoSecondsRecord, 42);
      expect(controller.cleanBootstrappedRecord, isFalse);
    },
  );
}
