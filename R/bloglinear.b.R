
blogLinearClass <- JAnalysis(
    "blogLinearClass",
    inherit = blogLinearBase,
    private = list(
        func=function() {
            RegressionLogLinearBayesian
        },
        optionsMap=c(
            factors='factors',
            counts='counts',
            bfType='bayesFactorType',
            priorShape='priorShape',
            priorScale='priorScale',
            maxModels='maxModels',
            postProbCutOff='posteriorProbabilityCutOff',
            modelTerms='modelTerms',
            est='regressionCoefficientsEstimates',
            ci='regressionCoefficientsCredibleIntervals',
            ciWidth='regressionCoefficientsCredibleIntervalsInterval',
            sub='regressionCoefficientsSubmodel',
            subNo='regressionCoefficientsSubmodelNo',
            subEst='regressionCoefficientsSubmodelEstimates',
            subCI='regressionCoefficientsSubmodelCredibleIntervals',
            subCIWidth='regressionCoefficientsSubmodelCredibleIntervalsInterval',
            sampling='sampleMode',
            nSamples='fixedSamplesNumber')
    ),
    active = list(
        joptions = function() {
            options <- super$joptions
            options$regressionCoefficientsCredibleIntervalsInterval <- options$regressionCoefficientsCredibleIntervalsInterval / 100
            options$regressionCoefficientsSubmodelCredibleIntervalsInterval <- options$regressionCoefficientsSubmodelCredibleIntervalsInterval / 100

            options$modelTerms <- lapply(options$modelTerms, function(x) list(components=x))

            options
        }
    )
)
