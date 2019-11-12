
const events = {
    update: function(ui) {
        calcModelTerms(ui, this);
        filterModelTerms(ui, this);
    },

    onChange_covs: function(ui) {
        calcModelTerms(ui, this);
    },

    onUpdate_modelSupplier: function(ui) {
        let covariatesList = this.cloneArray(ui.covs.value(), []);
        ui.modelSupplier.setValue(this.valuesToItems(covariatesList, FormatDef.variable));
    },

    onChange_modelTerms: function(ui) {
        filterModelTerms(ui, this);
    }
};


var calcModelTerms = function(ui, context) {
    var covariatesList = context.cloneArray(ui.covs.value(), []);

    ui.modelSupplier.setValue(context.valuesToItems(covariatesList, FormatDef.variable));

    var diff2 = context.findChanges("covariatesList", covariatesList, true, FormatDef.variable);

    var termsList = context.cloneArray(ui.modelTerms.value(), []);
    var termsChanged = false;

    for (var i = 0; i < diff2.removed.length; i++) {
        for (var j = 0; j < termsList.length; j++) {
            if (FormatDef.term.contains(termsList[j].components, diff2.removed[i])) {
                termsList.splice(j, 1);
                termsChanged = true;
                j -= 1;
            }
        }
    }

    for (var a = 0; a < diff2.added.length; a++) {
        let item = diff2.added[a];
        if (context.listContains(termsList, [item] , FormatDef.term, 'components') === false) {
            termsList.push({ components: [item], isNuisance: false });
            termsChanged = true;
        }
    }

    if (termsChanged)
        ui.modelTerms.setValue(termsList);
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


module.exports = events;
