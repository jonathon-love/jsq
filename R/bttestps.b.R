
bttestPSClass <- JAnalysis(
    "bttestPSClass",
    inherit = bttestPSBase,
    private = list(
        func=function() {
            TTestBayesianPairedSamples
        },
        optionsMap=c(
            pairs = 'pairs',
            hypothesis = 'hypothesis',
            `hypothesis:different` = 'groupsNotEqual',
            `hypothesis:oneGreater` = 'groupOneGreater',
            `hypothesis:twoGreater` = 'groupTwoGreater',
            plotPP = 'plotPriorAndPosterior',
            plotPPAddInfo = 'plotPriorAndPosteriorAdditionalInfo',
            plotRobust = 'plotBayesFactorRobustness',
            plotRobustAddInfo = 'plotBayesFactorRobustnessAdditionalInfo',
            plotSeq = 'plotSequentialAnalysis',
            plotSeqRobust = 'plotSequentialAnalysisRobustness',
            plotDesc = 'descriptivesPlots',
            plotDescCI = 'descriptivesPlotsCredibleInterval',
            bfType = 'bayesFactorType',
            priorWidth = 'priorWidth',
            desc = 'descriptives',
            priorType = 'effectSizeStandardized',
            `priorType:info` = 'informative',
            `priorType:default` = 'default',
            priorWidth = 'priorWidth',
            infoShape = 'informativeStandardizedEffectSize',
            infoCL = 'informativeCauchyLocation',
            infoCS = 'informativeCauchyScale',
            infoTL = 'informativeTLocation',
            infoTS = 'informativeTScale',
            infoTDf = 'informativeTDf',
            infoNL = 'informativeNormalMean',
            infoNS = 'informativeNormalStd',
            plotWidth='plotWidth',
            plotHeight='plotHeight',
            missing='missingValues')
    ),
    active=list(
        joptions=function() {
            options <- super$joptions
            options$descriptivesPlotsCredibleInterval <- options$descriptivesPlotsCredibleInterval / 100
            options
        }
    )
)
