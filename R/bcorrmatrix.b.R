
bcorrMatrixClass <- JAnalysis(
    "bcorrMatrixClass",
    inherit = bcorrMatrixBase,
    private = list(
        func=function() {
            CorrelationBayesian
        },
        optionsMap=c(
            vars='variables',
            pearson='pearson',
            kendall='kendallsTauB',
            hypothesis='hypothesis',
            bfType='bayesFactorType',
            bf='reportBayesFactors',
            flag='flagSupported',
            ci='credibleInterval',
            plotMatrix='plotCorrelationMatrix',
            plotDens='plotDensitiesForVariables',
            plotPost='plotPosteriors',
            priorWidth='priorWidth',
            missing='missingValues'
        )
    ),
    active=list(
        joptions=function() {
            options <- super$joptions
            options$spearman <- FALSE
            options$ciValue <- 0.95
            options
        }
    )
)
