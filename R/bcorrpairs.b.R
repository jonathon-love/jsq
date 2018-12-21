
bcorrPairsClass <- JAnalysis(
    "bcorrPairsClass",
    inherit = bcorrPairsBase,
    private = list(
        func=function() {
            CorrelationBayesianPairs
        },
        optionsMap=c(
            pairs='pairs',
            stat='corcoefficient',
            `stat:pearson`='Pearson',
            `stat:kendall`='Kendall',
            hypothesis='hypothesis',
            `hypothesis:corr`='correlated',
            `hypothesis:pos`='correlatedPositively',
            `hypothesis:neg`='correlatedNegatively',
            bfType='bayesFactorType',
            priorWidth='priorWidth',
            ci='credibleInterval',
            plotScat='plotScatter',
            plotPP = 'plotPriorAndPosterior',
            plotPPAddInfo = 'plotPriorAndPosteriorAdditionalInfo',
            plotRobust = 'plotBayesFactorRobustness',
            plotRobustAddInfo = 'plotBayesFactorRobustnessAdditionalInfo',
            plotSeq = 'plotSequentialAnalysis',
            missing='missingValues',
            `missing:perAnalysis`='excludeAnalysisByAnalysis',
            `missing:listwise`='excludeListwise'
        )
    ),
    active=list(
        joptions=function() {
            options <- super$joptions

            options$ciValue <- 0.95
            options$plotSequentialAnalysisRobustness <- FALSE
            options$plotWidth <- 400
            options$plotHeight <- 300

            options
        }
    )
)
