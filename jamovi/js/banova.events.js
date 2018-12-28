
const events = {
    update: function(ui) {
        calcModelTerms(ui, this);
        filterModelTerms(ui, this);
        updatePostHocSupplier(ui, this);
    },

    onChange_factors: function(ui) {
        calcModelTerms(ui, this);
        updatePostHocSupplier(ui, this);
    },

    onChange_random: function(ui) {
        calcModelTerms(ui, this);
        updatePostHocSupplier(ui, this);
    },

    onChange_modelTerms: function(ui) {
        filterModelTerms(ui, this);
    },

    onChange_plotsSupplier: function(ui) {
        let values = this.itemsToValues(ui.plotsSupplier.value());
        this.checkValue(ui.plotHz, false, values, FormatDef.variable);
        this.checkValue(ui.plotLines, false, values, FormatDef.variable);
        this.checkValue(ui.plotSep, false, values, FormatDef.variable);
    },

    onChange_postHocSupplier: function(ui) {
        let values = this.itemsToValues(ui.postHocSupplier.value());
        this.checkValue(ui.postHoc, true, values, FormatDef.variable);
    }
};


var calcModelTerms = function(ui, context) {
    var variableList = context.cloneArray(ui.factors.value(), []);
    var randomList = context.cloneArray(ui.random.value(), []);

    var combinedList = variableList.concat(randomList);
    ui.plotsSupplier.setValue(context.valuesToItems(combinedList, FormatDef.variable));
    ui.modelSupplier.setValue(context.valuesToItems(combinedList, FormatDef.variable));

    var diff = context.findChanges("variableList", variableList, true, FormatDef.variable);
    var diff3 = context.findChanges("randomList", randomList, true, FormatDef.variable);
    var combinedDiff = context.findChanges("combinedList", combinedList, true, FormatDef.variable);

    var termsList = context.cloneArray(ui.modelTerms.value(), []);
    var termsChanged = false;

    for (var i = 0; i < combinedDiff.removed.length; i++) {
        for (var j = 0; j < termsList.length; j++) {
            if (FormatDef.term.contains(termsList[j].components, combinedDiff.removed[i])) {
                termsList.splice(j, 1);
                termsChanged = true;
                j -= 1;
            }
        }
    }

    for (var a = 0; a < diff.added.length; a++) {
        let item = diff.added[a];
        var listLength = termsList.length;
        for (var j = 0; j < listLength; j++) {
            var newTerm = context.clone(termsList[j].components);
            if (containsCovariate(newTerm, randomList) === false) {
                if (context.listContains(newTerm, item, FormatDef.variable) === false) {
                    newTerm.push(item)
                    if (context.listContains(termsList, newTerm , FormatDef.term, 'components') === false) {
                        termsList.push({ components: newTerm, isNuisance: false });
                        termsChanged = true;
                    }
                }
            }
        }
        if (context.listContains(termsList, [item] , FormatDef.term, 'components') === false) {
            termsList.push({ components: [item], isNuisance: false });
            termsChanged = true;
        }
    }

    for (var a = 0; a < diff3.added.length; a++) {
        let item = diff3.added[a];
        if (context.listContains(termsList, [item] , FormatDef.term, 'components') === false) {
            termsList.push({ components: [item], isNuisance: true });
            termsChanged = true;
        }
    }

    if (termsChanged)
        ui.modelTerms.setValue(termsList);
};

var updatePostHocSupplier = function(ui, context) {
    var variableList = context.cloneArray(ui.factors.value(), []);
    var randomList = context.cloneArray(ui.random.value(), []);

    var list = variableList.concat(randomList);

    ui.postHocSupplier.setValue(context.valuesToItems(list, FormatDef.variable));
};

var filterModelTerms = function(ui, context) {
    var termsList = context.cloneArray(ui.modelTerms.value(), []);
    var diff = context.findChanges("termsList", termsList, true, FormatDef.term, 'components');

    var changed = false;
    if (diff.removed.length > 0) {
        var itemsRemoved = false;
        for (var i = 0; i < diff.removed.length; i++) {
            var item = diff.removed[i];
            for (var j = 0; j < termsList.length; j++) {
                if (FormatDef.term.contains(termsList[j].components, item.components)) {
                    termsList.splice(j, 1);
                    j -= 1;
                    itemsRemoved = true;
                }
            }
        }

        if (itemsRemoved)
            changed = true;
    }

    if (context.sortArraysByLength(termsList, 'components'))
        changed = true;

    if (changed)
        ui.modelTerms.setValue(termsList);
};

var containsCovariate = function(value, covariates) {
    for (var i = 0; i < covariates.length; i++) {
        if (FormatDef.term.contains(value, covariates[i]))
            return true;
    }

    return false;
};


module.exports = events;
