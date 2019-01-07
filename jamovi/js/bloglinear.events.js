
const events = {
    update: function(ui) {
        calcModelTerms(ui, this);
        filterModelTerms(ui, this);
    },

    onChange_factors: function(ui) {
        calcModelTerms(ui, this);
    },

    onChange_modelTerms: function(ui) {
        filterModelTerms(ui, this);
    }
};


var calcModelTerms = function(ui, context) {
    var variableList = context.cloneArray(ui.factors.value(), []);

    ui.modelSupplier.setValue(context.valuesToItems(variableList, FormatDef.variable));

    var varsDiff = context.findChanges("variableList", variableList, true, FormatDef.variable);
    var termsList = context.cloneArray(ui.modelTerms.value(), []);

    var termsChanged = false;
    for (var i = 0; i < varsDiff.removed.length; i++) {
        for (var j = 0; j < termsList.length; j++) {
            if (FormatDef.term.contains(termsList[j], varsDiff.removed[i])) {
                termsList.splice(j, 1);
                termsChanged = true;
                j -= 1;
            }
        }
    }

    termsList = context.getCombinations(varsDiff.added, termsList);
    termsChanged = termsChanged || varsDiff.added.length > 0;

    if (termsChanged)
        ui.modelTerms.setValue(termsList);
};

var filterModelTerms = function(ui, context) {
    var termsList = context.cloneArray(ui.modelTerms.value(), []);

    //Remove common terms
    var termsDiff = context.findChanges("currentList", termsList, true, FormatDef.term);
    var changed = false;
    if (termsDiff.removed.length > 0 && termsList !== null) {
        var itemsRemoved = false;
        for (var i = 0; i < termsDiff.removed.length; i++) {
            var item = termsDiff.removed[i];
            for (var j = 0; j < termsList.length; j++) {
                if (FormatDef.term.contains(termsList[j], item)) {
                    termsList.splice(j, 1);
                    j -= 1;
                    itemsRemoved = true;
                }
            }
        }

        if (itemsRemoved)
            changed = true;
    }
    /////////////////////

    //Sort terms
    if (context.sortArraysByLength(termsList))
        changed = true;
    ////////////

    if (changed)
        ui.modelTerms.setValue(termsList);
};


module.exports = events;
