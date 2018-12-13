
bancovaClass <- JAnalysis(
    "bancovaClass",
    inherit = bancovaBase,
    private = list(
        func=function() {
            AncovaBayesian
        },
        optionsMap=c(
            dep = 'dependent',
            factors = 'fixedFactors',
            random = 'randomFactors',
            covs = 'covariates',
            bfType = 'bayesFactorType',
            order = 'bayesFactorOrder',
            desc = 'descriptives',
            effects = 'effects',
            effectsType = 'effectsType',
            modelTerms = 'modelTerms',
            postHoc = 'postHocTestsVariables',
            postHocCorr = 'postHocTestsNullControl',
            plotHz = 'plotHorizontalAxis',
            plotLines = 'plotSeparateLines',
            plotSep = 'plotSeparatePlots',
            plotCI = 'plotCredibleInterval',
            ciWidth = 'plotCredibleIntervalInterval',
            rScaleFixed = 'priorFixedEffects',
            rScaleRand = 'priorRandomEffects',
            rScaleCovs = 'priorCovariates',
            sampling = 'sampleMode',
            nSamples = 'fixedSamplesNumber')
    ), active = list(
        joptions = function() {
            options <- super$joptions
            options$plotCredibleIntervalInterval <- options$plotCredibleIntervalInterval / 100
            options$plotWidthDescriptivesPlotLegend <- 450
            options$plotHeightDescriptivesPlotLegend <- 300
            options$plotWidthDescriptivesPlotNoLegend <- 350
            options$plotHeightDescriptivesPlotNoLegend <- 300
            options$posteriorEstimates <- FALSE
            options$posteriorEstimatesMCMCIterations <- 10000
            if (is.null(options$covariates))
                options$covariates <- list()
            if (is.null(options$priorCovariates))
                options$priorCovariates <- 0.354
            options
        }
    )
)
