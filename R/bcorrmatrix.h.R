
# This file is automatically generated, you probably don't want to edit this

bcorrMatrixOptions <- if (requireNamespace("jmvcore", quietly=TRUE)) R6::R6Class(
    "bcorrMatrixOptions",
    inherit = jmvcore::Options,
    public = list(
        initialize = function(
            vars = NULL,
            pearson = TRUE,
            kendall = FALSE,
            hypothesis = "correlated",
            bfType = "BF10",
            bf = TRUE,
            flag = FALSE,
            ci = FALSE,
            plotMatrix = FALSE,
            plotDens = FALSE,
            plotPost = FALSE,
            priorWidth = 1,
            missing = "excludePairwise", ...) {

            super$initialize(
                package="jsq",
                name="bcorrMatrix",
                requiresData=TRUE,
                ...)

            private$..vars <- jmvcore::OptionVariables$new(
                "vars",
                vars)
            private$..pearson <- jmvcore::OptionBool$new(
                "pearson",
                pearson,
                default=TRUE)
            private$..kendall <- jmvcore::OptionBool$new(
                "kendall",
                kendall,
                default=FALSE)
            private$..hypothesis <- jmvcore::OptionList$new(
                "hypothesis",
                hypothesis,
                options=list(
                    "correlated",
                    "correlatedPositively",
                    "correlatedNegatively"),
                default="correlated")
            private$..bfType <- jmvcore::OptionList$new(
                "bfType",
                bfType,
                options=list(
                    "BF10",
                    "BF01"),
                default="BF10")
            private$..bf <- jmvcore::OptionBool$new(
                "bf",
                bf,
                default=TRUE)
            private$..flag <- jmvcore::OptionBool$new(
                "flag",
                flag,
                default=FALSE)
            private$..ci <- jmvcore::OptionBool$new(
                "ci",
                ci,
                default=FALSE)
            private$..plotMatrix <- jmvcore::OptionBool$new(
                "plotMatrix",
                plotMatrix,
                default=FALSE)
            private$..plotDens <- jmvcore::OptionBool$new(
                "plotDens",
                plotDens,
                default=FALSE)
            private$..plotPost <- jmvcore::OptionBool$new(
                "plotPost",
                plotPost,
                default=FALSE)
            private$..priorWidth <- jmvcore::OptionNumber$new(
                "priorWidth",
                priorWidth,
                min=0,
                max=2,
                default=1)
            private$..missing <- jmvcore::OptionList$new(
                "missing",
                missing,
                options=list(
                    "excludePairwise",
                    "excludeListwise"),
                default="excludePairwise")

            self$.addOption(private$..vars)
            self$.addOption(private$..pearson)
            self$.addOption(private$..kendall)
            self$.addOption(private$..hypothesis)
            self$.addOption(private$..bfType)
            self$.addOption(private$..bf)
            self$.addOption(private$..flag)
            self$.addOption(private$..ci)
            self$.addOption(private$..plotMatrix)
            self$.addOption(private$..plotDens)
            self$.addOption(private$..plotPost)
            self$.addOption(private$..priorWidth)
            self$.addOption(private$..missing)
        }),
    active = list(
        vars = function() private$..vars$value,
        pearson = function() private$..pearson$value,
        kendall = function() private$..kendall$value,
        hypothesis = function() private$..hypothesis$value,
        bfType = function() private$..bfType$value,
        bf = function() private$..bf$value,
        flag = function() private$..flag$value,
        ci = function() private$..ci$value,
        plotMatrix = function() private$..plotMatrix$value,
        plotDens = function() private$..plotDens$value,
        plotPost = function() private$..plotPost$value,
        priorWidth = function() private$..priorWidth$value,
        missing = function() private$..missing$value),
    private = list(
        ..vars = NA,
        ..pearson = NA,
        ..kendall = NA,
        ..hypothesis = NA,
        ..bfType = NA,
        ..bf = NA,
        ..flag = NA,
        ..ci = NA,
        ..plotMatrix = NA,
        ..plotDens = NA,
        ..plotPost = NA,
        ..priorWidth = NA,
        ..missing = NA)
)

bcorrMatrixResults <- if (requireNamespace("jmvcore", quietly=TRUE)) R6::R6Class(
    "bcorrMatrixResults",
    inherit = jmvcore::Group,
    active = list(),
    private = list(),
    public=list(
        initialize=function(options) {
            super$initialize(
                options=options,
                name="",
                title="Bayesian Correlation Matrix",
                clearWith=list(
                    "vars"))}))

bcorrMatrixBase <- if (requireNamespace("jmvcore", quietly=TRUE)) R6::R6Class(
    "bcorrMatrixBase",
    inherit = jmvcore::Analysis,
    public = list(
        initialize = function(options, data=NULL, datasetId="", analysisId="", revision=0) {
            super$initialize(
                package = "jsq",
                name = "bcorrMatrix",
                version = c(1,0,0),
                options = options,
                results = bcorrMatrixResults$new(options=options),
                data = data,
                datasetId = datasetId,
                analysisId = analysisId,
                revision = revision,
                pause = NULL,
                completeWhenFilled = FALSE,
                requiresMissings = FALSE)
        }))

#' Bayesian Correlation Matrix
#'
#' 
#' @param data .
#' @param vars .
#' @param pearson .
#' @param kendall .
#' @param hypothesis .
#' @param bfType .
#' @param bf .
#' @param flag .
#' @param ci .
#' @param plotMatrix .
#' @param plotDens .
#' @param plotPost .
#' @param priorWidth .
#' @param missing .
#' @return A results object containing:
#' \tabular{llllll}{
#' }
#'
#' @export
bcorrMatrix <- function(
    data,
    vars,
    pearson = TRUE,
    kendall = FALSE,
    hypothesis = "correlated",
    bfType = "BF10",
    bf = TRUE,
    flag = FALSE,
    ci = FALSE,
    plotMatrix = FALSE,
    plotDens = FALSE,
    plotPost = FALSE,
    priorWidth = 1,
    missing = "excludePairwise") {

    if ( ! requireNamespace("jmvcore", quietly=TRUE))
        stop("bcorrMatrix requires jmvcore to be installed (restart may be required)")

    if ( ! missing(vars)) vars <- jmvcore::resolveQuo(jmvcore::enquo(vars))
    if (missing(data))
        data <- jmvcore::marshalData(
            parent.frame(),
            `if`( ! missing(vars), vars, NULL))


    options <- bcorrMatrixOptions$new(
        vars = vars,
        pearson = pearson,
        kendall = kendall,
        hypothesis = hypothesis,
        bfType = bfType,
        bf = bf,
        flag = flag,
        ci = ci,
        plotMatrix = plotMatrix,
        plotDens = plotDens,
        plotPost = plotPost,
        priorWidth = priorWidth,
        missing = missing)

    analysis <- bcorrMatrixClass$new(
        options = options,
        data = data)

    analysis$run()

    analysis$results
}

