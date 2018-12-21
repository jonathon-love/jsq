
banovaRMClass <- JAnalysis(
    "banovaRMClass",
    inherit = banovaRMBase,
    private = list(
        func=function() {
            AnovaRepeatedMeasuresBayesian
        },
        optionsMap=c(
            rm = 'repeatedMeasuresFactors',
            rmCells = 'repeatedMeasuresCells',
            bs = 'betweenSubjectFactors',
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
            depLabel = 'labelYAxis',
            plotCI = 'plotCredibleInterval',
            ciWidth = 'plotCredibleIntervalInterval',
            rScaleFixed = 'priorFixedEffects',
            rScaleRand = 'priorRandomEffects',
            rScaleCovs = 'priorCovariates',
            sampling = 'sampleMode',
            nSamples = 'fixedSamplesNumber')
    ),
    active = list(
        joptions = function() {
            options <- super$joptions

            options$posteriorEstimates <- FALSE
            options$plotWidthDescriptivesPlotLegend <- 450
            options$plotHeightDescriptivesPlotLegend <- 300
            options$plotWidthDescriptivesPlotNoLegend <- 350
            options$plotHeightDescriptivesPlotNoLegend <- 300

            options$plotCredibleIntervalInterval <- options$plotCredibleIntervalInterval / 100

            if (is.null(options$plotHorizontalAxis))
                options$plotHorizontalAxis <- ''

            if (is.null(options$plotSeparateLines))
                options$plotSeparateLines <- ''

            if (is.null(options$plotSeparatePlots))
                options$plotSeparatePlots <- ''

            options$repeatedMeasuresFactors <- lapply(
                options$repeatedMeasuresFactors,
                function(x) list(name=x$label, levels=x$levels))

            options$repeatedMeasuresCells <- unlist(lapply(
                options$repeatedMeasuresCells,
                function(x) `if`(is.null(x$measure), '', x$measure)))

            options
        }
    )
)
