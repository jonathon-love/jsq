
banovaClass <- R6::R6Class(
    "banovaClass",
    inherit = bancovaClass,
    private = list(
        .init=function() {
            super$.init()
            self$results$setTitle('Bayesian ANOVA')
        }),
    public = list(
        asSource=function() {
            paste0(private$.package, '::', 'banova', '(', private$.asArgs(), ')')
        },
        initialize=function(...) {
            super$initialize(...)
            private$.name <- 'banova'
        }
    )
)
