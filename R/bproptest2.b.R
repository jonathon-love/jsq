
bpropTest2Class <- JAnalysis(
    "bpropTest2Class",
    inherit = bpropTest2Base,
    private = list(
        func=function() {
            BinomialTestBayesian
        },
        optionsMap=c(
            vars='variables',
            testValue='testValue',
            hypothesis='hypothesis',
            `hypothesis:different`='notEqualToTestValue',
            `hypothesis:greater`='greaterThanTestValue',
            `hypothesis:less`='lessThanTestValue',
            bfType='bayesFactorType',
            plotPP='plotPriorAndPosterior',
            plotPPAddInfo='plotPriorAndPosteriorAdditionalInfo',
            plotSeq='plotSequentialAnalysis',
            priorA='priorA',
            priorB='priorB'
        )
    )
)
