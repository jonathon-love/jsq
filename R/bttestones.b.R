
bttestOneSClass <- JAnalysis(
    "bttestOneSClass",
    inherit = bttestOneSBase,
    private = list(
        func=function() {
            TTestBayesianOneSample
        },
        optionsMap=c(
            vars = 'variables',
            testValue = 'testValue',
            hypothesis = 'hypothesis',
            `hypothesis:different` = 'notEqualToTestValue',
            `hypothesis:greater` = 'greaterThanTestValue',
            `hypothesis:less` = 'lessThanTestValue',
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
