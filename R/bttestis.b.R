
bttestISClass <- JAnalysis(
    "bttestISClass",
    inherit = bttestISBase,
    private = list(
        func=function() {
            TTestBayesianIndependentSamples
        },
        .postInit=function(...) {
            super$.postInit(...)
            if (self$options$priorType == 'info' && self$options$test == 'mann')
                stop('Informative priors are not supported with Mann-Whitney')
        },
        optionsMap=c(
            vars = 'variables',
            group = 'groupingVariable',
            test = 'testStatistic',
            `test:students` = 'Student',
            `test:mann` = 'Wilcoxon',
            mannN = 'wilcoxonSamplesNumber',
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
            missing='missingValues',
            `missing:listwise`='excludeListwise'),
        .sourcifyOption = function(option) {
            if (option$name %in% c('vars', 'group'))
                return('')
            super$.sourcifyOption(option)
        },
        .formula=function() {
            jmvcore:::composeFormula(self$options$vars, self$options$group)
        }
    ),
    active=list(
        joptions=function() {
            options <- super$joptions
            options$wilcoxText <- FALSE
            options$descriptivesPlotsCredibleInterval <- options$descriptivesPlotsCredibleInterval / 100
            options
        }
    )
)
