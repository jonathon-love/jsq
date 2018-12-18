
blinRegClass <- JAnalysis(
    "blinRegClass",
    inherit = blinRegBase,
    private = list(
        func=function() {
            RegressionLinearBayesian
        },
        .init = function() {

            super$.init()

            # RegressionLinearBayesian poops itself with factors
            # so we override the readDatasetToEnd() method to only
            # return numerics

            read <- function(
                columns=c(),
                columns.as.numeric=c(),
                columns.as.ordinal=c(),
                columns.as.factor=c(),
                all.columns=FALSE,
                exclude.na.listwise=c(),
                ...) {

                data <- self$data
                for (name in columns)
                    data[[name]] <- jmvcore::toNumeric(data[[name]])

                names(data) <- .v(names(data))

                data
            }

            jenv$.readDatasetToEndNative <- read
        },
        optionsMap=c(
            dep='dependent',
            covs='covariates',
            wls='wlsWeights',
            bfType='bayesFactorType',
            order='bayesFactorOrder',
            desc='descriptives',
            postSumm='postSummaryTable',
            postSummModel='summaryType',
            omitIntercept='omitIntercept',
            plotSumm='postSummaryPlot',
            ciWidth='posteriorSummaryPlotCredibleIntervalValue',
            limitModels='shownModels',
            limitModelsN='numShownModels',
            modelTerms='modelTerms',
            plotCoefInc='plotInclusionProbabilities',
            plotCoef='plotCoefficientsPosterior',
            plotResVFit='plotResidualsVsFitted',
            plotOdds='plotLogPosteriorOdds',
            modelVSize='plotModelComplexity',
            modelProbs='plotModelProbabilities',
            prior='priorRegressionCoefficients',
            jzsS='rScale',
            hAlpha='alpha',
            modelPrior='modelPrior',
            `modelPrior:beta`='beta.binomial',
            `modelPrior:bern`='Bernoulli',
            `modelPrior:unif`='uniform',
            bernP='bernoulliParam',
            betaA='betaBinomialParamA',
            betaB='betaBinomialParamB',
            sampling='samplingMethod',
            basNModels='numberOfModels',
            mcmcN='iterationsMCMC',
            ciN='nSimForCRI')
    ),
    active = list(
        joptions = function() {
            options <- super$joptions
            options$posteriorSummaryPlotCredibleIntervalValue <- options$posteriorSummaryPlotCredibleIntervalValue / 100
            options
        }
    )
)
