
bcontTablesClass <- JAnalysis(
    "bcontTablesClass",
    inherit = bcontTablesBase,
    private = list(
        func=function() {
            ContingencyTablesBayesian
        },
        optionsMap=c(
            rows='rows',
            cols='columns',
            counts='counts',
            layers='layers',
            sampling='samplingModel',
            `sampling:poisson`='poisson',
            `sampling:joint`='jointMultinomial',
            `sampling:rowsFixed`='independentMultinomialRowsFixed',
            `sampling:colsFixed`='independentMultinomialColumnsFixed',
            `sampling:hyper`='hypergeometric',
            hypothesis='hypothesis',
            `hypothesis:different`='groupsNotEqual',
            `hypothesis:oneGreater`='groupOneGreater',
            `hypothesis:twoGreater`='groupTwoGreater',
            bfType='bayesFactorType',
            oddsRatio='oddsRatio',
            oddsRatioCIWidth='oddsRatioCredibleIntervalInterval',
            plotOddsRatio='plotPosteriorOddsRatio',
            plotOddsRatioAddInfo='plotPosteriorOddsRatioAdditionalInfo',
            priorWidth='priorConcentration'),
        .constructImage=function(meta) {
            name <- gsub(' ', '_', meta$name)
            image <- jmvcore::Image$new(
                options=self$options,
                name=name,
                title=paste(name, '(image)'),
                renderFun='.render',
                clearWith=c(
                    'rows',
                    'cols',
                    'counts',
                    'layers',
                    'sampling',
                    'hypothesis',
                    'priorWidth',
                    'plotOddsRatioAddInfo'))
        }
    ),
    active=list(
        joptions=function() {
            options <- super$joptions
            options$effectSize <- FALSE
            options$countsExpected <- FALSE
            options$percentagesRow <- FALSE
            options$percentagesColumn <- FALSE
            options$percentagesTotal <- FALSE
            options$rowOrder <- 'descending'
            options$columnOrder <- 'descending'

            options$oddsRatioCredibleIntervalInterval <- options$oddsRatioCredibleIntervalInterval / 100

            if (length(options$layers) > 0)
                options$layers <- list(list(name='Layer 1', variables=options$layers))

            options
        }
    )

)
