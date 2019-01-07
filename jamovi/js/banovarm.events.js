
var rma_cell = require('./rmacell');

const events = {
    update: function(ui) {
        this._factorCells = null;

        this.initializeValue(ui.modelTerms, [{ components: ["RM Factor 1"], isNuisance: false }]);
        this.setCustomVariable("RM Factor 1", "none", []);

        updateFactorCells(ui, this);
        updateModelTerms(ui, this);
        filterModelTerms(ui, this);
    },

    onChange_rm: function(ui) {
        updateFactorCells(ui, this);
        updateModelTerms(ui, this);
    },

    onChange_rmCells: function(ui) {
        filterCells(ui, this);
    },

    onChange_bs: function(ui) {
        updateModelTerms(ui, this);
    },

    onChange_covs: function(ui) {
        updateModelTerms(ui, this);
    },

    onChange_modelTerms: function(ui) {
        filterModelTerms(ui, this);
    },

    onChange_postHocSupplier: function(ui) {
        let values = this.itemsToValues(ui.postHocSupplier.value());
        this.checkValue(ui.postHoc, true, values, FormatDef.term);
    }
};

let updateModelLabels = function(list, blockName) {
    list.applyToItems(0, (item, index) => {
        item.controls[0].setPropertyValue("label", blockName + " " + (index + 1) );
    });
};

var updateFactorCells = function(ui, context) {
    var value = ui.rm.value();
    if (value === null)
        return;

    var data = []
    var indices = []
    for (var i = 0; i < value.length; i++) {
        indices[i] = 0;
    }

    var end = false;
    var pos = 0;
    while (end === false) {
        var cell = []
        for (var k = 0; k < indices.length; k++) {
            cell.push(value[k].levels[indices[k]])
        }
        data.push(cell);
        pos += 1;
        var zeroCount = 0;

        var r = indices.length - 1;
        if (r < 0)
            end = true;
        while (r >= 0) {
            indices[r] = (indices[r] + 1) % value[r].levels.length;
            if (indices[r] === 0)
                r -= 1;
            else
                break;

            if (r === -1)
                end = true;
        }
    }

    context._factorCells = data;
    filterCells(ui, context);
};

var updateModelTerms = function(ui, context) {
    var variableList = context.cloneArray(ui.bs.value(), []);
    var randomList = context.cloneArray(ui.covs.value(), []);
    let factorList = context.cloneArray(ui.rm.value(), []);

    let customVariables = [];
    for(let i = 0; i < factorList.length; i++) {
        customVariables.push( { name: factorList[i].label, measureType: 'none', dataType: 'none', levels: [] } );
        factorList[i] = factorList[i].label;
    }
    context.setCustomVariables(customVariables);
    var combinedList = factorList.concat(variableList).concat(randomList);
    var varList = factorList.concat(variableList);

    ui.plotsSupplier.setValue(context.valuesToItems(varList, FormatDef.variable));
    ui.postHocSupplier.setValue(context.valuesToItems(varList, FormatDef.variable));
    ui.modelSupplier.setValue(context.valuesToItems(combinedList, FormatDef.variable));
    console.log(combinedList)

    var diff = context.findChanges("variableList", varList, true, FormatDef.variable);
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
    //var bsTerms = context.cloneArray(ui.bsTerms.value(), []);
   // var rmTerms = context.cloneArray(ui.rmTerms.value(), []);
   // var combinedTermsList = rmTerms; //.concat(bsTerms);

    /*for (let i = 0; i < rmTerms.length; i++) {
        for (let j = 0; j < bsTerms.length; j++)
            combinedTermsList.push(rmTerms[i].concat(bsTerms[j]))
    }*/

    //ui.postHocSupplier.setValue(context.valuesToItems(combinedTermsList, FormatDef.term));
};

var filterModelTerms = function(ui, context) {
    let termsList = context.cloneArray(ui.modelTerms.value(), []);
    var diff = context.findChanges("modelTerms", termsList, true, FormatDef.term, 'components');

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

    updatePostHocSupplier(ui, context);
};

var containsCovariate = function(value, covariates) {
    for (var i = 0; i < covariates.length; i++) {
        if (FormatDef.term.contains(value, covariates[i]))
            return true;
    }

    return false;
};

var updateContrasts = function(ui, variableList, context) {
    var currentList = context.cloneArray(ui.contrasts.value(), []);

    var list3 = [];
    for (let i = 0; i < variableList.length; i++) {
        let found = null;
        for (let j = 0; j < currentList.length; j++) {
            if (currentList[j].var === variableList[i]) {
                found = currentList[j];
                break;
            }
        }
        if (found === null)
            list3.push({ var: variableList[i], type: "none" });
        else
            list3.push(found);
    }

    ui.contrasts.setValue(list3);
};

var filterCells = function(ui, context) {
    if (context._factorCells === null)
        return;

    var cells = context.cloneArray(ui.rmCells.value(), []);

    var factorCells = context.clone(context._factorCells);

    var changed = false;
    for (var j = 0; j < factorCells.length; j++) {
        if (j < cells.length && cells[j] !== null) {
            if (rma_cell.isEqual(cells[j].cell, factorCells[j]) === false) {
                cells[j].cell = factorCells[j];
                changed = true;
            }
        }
        else {
            cells[j] = { measure: null, cell: factorCells[j] };
            changed = true;
        }
    }

    if (cells.length > factorCells.length) {
        cells.splice(factorCells.length, cells.length - factorCells.length);
        changed = true;
    }

    if (changed) {
        ui.rmCells.setValue(cells);
        ui.rmCells.setPropertyValue("maxItemCount", cells.length);
    }
};


module.exports = events;
