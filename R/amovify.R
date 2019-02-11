
jenv <- new.env()

JAnalysis <- function(
    name,
    inherit,
    public = list(),
    private = list(),
    active = list()) {

    R6::R6Class(
        name,
        public = public,
        private = private,
        active = active,
        inherit = R6::R6Class(
            'JAnalysis',
            inherit = inherit,
            private=list(
                .imageCount = 0,
                .init = function() {

                    jenv$.requestTempFileNameNative <- function(ext) {
                        if (is.function(private$.resourcesPathSource)) {
                            paths <- private$.resourcesPathSource(paste(private$.imageCount), 'png')
                            private$.imageCount <- private$.imageCount + 1
                            return(list(root=paths$rootPath, relativePath=paths$relPath))
                        } else {
                            path <- tempfile(fileext=paste0('.', ext))
                            root <- dirname(path)
                            rel  <- basename(path)
                            return(list(root=root, relativePath=rel))
                        }
                    }

                    jenv$.imageBackground <- function() {
                        'transparent'
                    }

                    jenv$.ppi <- function() {
                        self$options$ppi * 96 / 72  # wtf?
                    }

                    jenv$setError <- function(message) {
                        self$setError(message)
                    }

                    jenv$callback <- function(results, progress) {
                        if ( ! missing(results))
                            private$.populateResults(results)
                        private$.checkpoint()
                        list(status='ok')
                    }

                    read <- function(
                        columns=c(),
                        columns.as.numeric=c(),
                        columns.as.ordinal=c(),
                        columns.as.factor=c(),
                        all.columns=FALSE,
                        exclude.na.listwise=c(),
                        ...) {

                        data <- self$data
                        for (name in columns.as.numeric)
                            data[[name]] <- jmvcore::toNumeric(data[[name]])
                        for (name in columns.as.ordinal)
                            data[[name]] <- as.ordered(data[[name]])
                        for (name in columns.as.factor)
                            data[[name]] <- as.factor(data[[name]])

                        if (length(exclude.na.listwise) > 0) {
                            retain <- complete.cases(subset(data, select=exclude.na.listwise))
                            data <- data[retain,]
                        }

                        names(data) <- .v(names(data))

                        data
                    }

                    jenv$.readDataSetHeaderNative <- read
                    jenv$.readDatasetToEndNative <- read

                    jenv$retrieveState <- function() {
                        self$results$state
                    }
                },
                .postInit = function() {

                    options <- self$joptions

                    func <- private$func()
                    state <- self$results$state
                    stateKey <- attr(state, 'stateKey')

                    if ('state' %in% names(formals(func)))
                        state <- .getStateFromKey(stateKey, options)

                    output <- func(data=NULL, options=options, perform='init', state=state)
                    results <- output$results

                    private$.constructResults(results)
                    private$.populateResults(results)

                    if (identical(output$status, 'complete'))
                        self$setStatus('complete')
                },
                .run = function() {

                    options <- self$joptions
                    func <- private$func()
                    state <- self$results$state
                    stateKey <- attr(state, 'stateKey')

                    if ('state' %in% names(formals(func)))
                        state <- .getStateFromKey(stateKey, options)

                    output <- func(data=NULL, options=options, perform='run', callback=jenv$callback, state=state)
                    results <- output$results
                    state <- output$state

                    self$results$setState(state)
                    private$.populateResults(results)
                },
                .render = function(image, theme, ggtheme, ...) {

                    recordedPlot <- image$state

                    if ( ! is.null(recordedPlot)) {
                        for (i in seq_along(recordedPlot[[1]])) {
                            symbol <- recordedPlot[[1]][[i]][[2]][[1]]
                            if ('NativeSymbolInfo' %in% class(symbol)) {
                                if (is.null(symbol$package)) {
                                    name <- symbol$dll[['name']]
                                } else {
                                    name <- symbol$package[['name']]
                                }
                                dll <- getLoadedDLLs()[[name]]
                                nativeSymbol <- getNativeSymbolInfo(
                                    name = symbol$name,
                                    PACKAGE = dll,
                                    withRegistrationInfo = TRUE)
                                recordedPlot[[1]][[i]][[2]][[1]] <- nativeSymbol
                            }
                        }
                    }

                    recordedPlot
                },
                .constructResults = function(results) {

                    for (i in seq_along(results$.meta)) {
                        meta <- results$.meta[[i]]
                        jname <- meta$name
                        item <- self$results[[jname]]
                        name <- gsub(' ', '_', jname)
                        if ( ! name %in% self$results$itemNames) {
                            item <- private$.constructElement(meta)
                            if ( ! is.null(item))
                                self$results$add(item)
                        }
                    }

                    self$results$setRefs('jasp')

                    # debug <- jmvcore::Preformatted$new(
                    #     options=self$options,
                    #     name='debug',
                    #     title='debug')
                    # self$results$add(debug)
                    #
                    # elements <- list()
                    # for (meta in results$.meta)
                    #     elements[[length(elements)+1]] <- private$.meta(meta)
                    # debug$setContent(yaml::as.yaml(elements))
                    #
                    # debug <- jmvcore::Preformatted$new(
                    #     options=self$options,
                    #     name='debug2',
                    #     title='debug2')
                    # self$results$add(debug)
                    #
                    # debug$setContent(results$.meta)
                },
                .populateResults = function(results) {
                    for (meta in results$.meta) {
                        jname <- meta$name
                        name <- gsub(' ', '_', jname)
                        element <- self$results$get(name)
                        data <- results[[jname]]
                        private$.populateElement(element, data)
                    }
                },
                .populateElement = function(element, data) {
                    if (is.null(element)) {
                        return()
                    }
                    if (is.null(data)) {
                        element$setVisible(FALSE)
                        return()
                    }

                    element$resetVisible()

                    if (inherits(element, 'Table'))
                        private$.populateTable(element, data)
                    else if (inherits(element, 'Group'))
                        private$.populateGroup(element, data)
                    else if (inherits(element, 'Array'))
                        private$.populateArray(element, data)
                    else if (inherits(element, 'Image'))
                        private$.populateImage(element, data)

                    if ('citation' %in% names(data)) {
                        refs <- private$.getRefNames(data$citation)
                        element$setRefs(refs)
                    }

                    if (is.list(data) && ! is.null(data$error)) {
                        if (is.character(data$error))
                            element$setError(data$error)
                        else if (is.character(data$error$errorMessage))
                            element$setError(data$error$errorMessage)
                        else
                            element$setError('Error')
                    }
                },
                .populateImage = function(image, data) {

                    if (is.null(data$width)) {
                        image$.setPath(NULL)
                        image$setVisible(FALSE)
                        return()
                    }

                    image$setTitle(data$title)

                    width <- data$width
                    height <- data$height
                    if ( ! is.null(width) && ! is.null(height))
                        image$setSize(width, height)

                    # if (identical(data$status, 'waiting'))
                    #    image$setStatus('inited')
                    if (identical(data$status, 'complete'))
                        image$setStatus('complete')
                    else
                        image$setStatus('inited')

                    if ( ! is.null(data$data)) {
                        image$.setPath(data$data)
                    } else {
                        image$.setPath(NULL)
                    }

                    if ( ! is.null(data$obj))
                        image$setState(data$obj)
                },
                .populateArray = function(array, data) {

                    array$setTitle(data$title)

                    for (i in seq_along(data$collection)) {
                        itemData <- data$collection[[i]]
                        item <- `if`(i <= length(array), array[[i]], array$addItem(i))
                        private$.populateElement(item, itemData)
                    }
                },
                .populateGroup = function(group, data) {

                    group$setTitle(data$title)

                    for (child in group$items) {
                        childName <- gsub('_', ' ', child$name)
                        childData <- data[[childName]]
                        private$.populateElement(child, childData)
                    }

                },
                .populateTable = function(table, data) {

                    table$deleteRows()
                    table$setTitle(data$title)

                    for (field in data$schema$fields)
                        private$.populateColumn(table, field)

                    footnotes <- data$footnotes
                    for (fn in footnotes) {
                        if (is.character(fn$symbol)) {
                            if (fn$symbol == '<em>Note.</em>')
                                table$setNote(fn$symbol, paste(fn$text))
                            else
                                table$setNote(fn$symbol, paste(fn$symbol, fn$text))
                        }
                    }

                    rowData <- data$data
                    for (rowNo in seq_along(rowData)) {

                        row <- rowData[[rowNo]]
                        if (inherits(row, 'try-error')) {
                            error <- jmvcore:::extractErrorMessage(row)
                            self$setError(error)
                            break()
                        }

                        fnis <- row$.footnotes
                        row$.footnotes <- NULL

                        # remove non-atomic items
                        row <- lapply(row, function(x) `if`(is.atomic(x), x, ''))

                        table$addRow(rowKey=rowNo, values=row)

                        for (col in names(fnis)) {
                            for (index in fnis[[col]]) {
                                if (is.character(index)) {
                                    table$addSymbol(rowNo=rowNo, col=col, index)
                                } else {
                                    note <- footnotes[[index+1]]$text
                                    table$addFootnote(rowNo=rowNo, col=col, note)
                                }
                            }
                        }

                    }
                },
                .populateColumn = function(table, field) {
                    name <- field$name
                    title <- field$title
                    if (is.null(title))
                        title <- name
                    type <- field$type
                    combineBelow <- `if`(is.null(field$combine), F, field$combine)
                    superTitle <- field$overTitle

                    format <- ''
                    sep <- ''
                    if ( ! is.null(field$format)) {
                        formats <- strsplit(field$format, ';')[[1]]
                        if ('log10' %in% formats) {
                            format <- paste0(format, sep, 'log10')
                            sep <- ','
                        }
                    }

                    table$addColumn(
                        name = name,
                        title = title,
                        type = type,
                        superTitle = superTitle,
                        format = format,
                        combineBelow = combineBelow)
                },
                .constructElement = function(meta) {
                    if (meta$type == 'table')
                        item <- private$.constructTable(meta)
                    else if (meta$type == 'collection')
                        item <- private$.constructCollection(meta)
                    else if (meta$type == 'object')
                        item <- private$.constructObject(meta)
                    else if (meta$type == 'image')
                        item <- private$.constructImage(meta)
                    else
                        item <- NULL
                    item
                },
                .constructCollection = function(meta) {

                    name <- gsub(' ', '_', meta$name)

                    childMeta <- meta$meta
                    if (is.character(childMeta))
                        childMeta <- list(name='item', type=childMeta)

                    template <- private$.constructElement(childMeta)

                    array <- jmvcore::Array$new(
                        options=self$options,
                        name=name,
                        title=paste(name, '(array)'),
                        template=template)

                    array
                },
                .constructImage=function(meta) {
                    name <- gsub(' ', '_', meta$name)
                    image <- jmvcore::Image$new(
                        options=self$options,
                        name=name,
                        title=paste(name, '(image)'),
                        renderFun='.render')
                },
                .constructObject = function(meta) {
                    name <- gsub(' ', '_', meta$name)
                    group <- jmvcore::Group$new(
                        options=self$options,
                        name=name,
                        title=paste(name, '(object)'))

                    for (child in meta$meta) {
                        child <- private$.constructElement(child)
                        group$add(child)
                    }

                    group
                },
                .constructTable = function(meta) {
                    name <- gsub(' ', '_', meta$name)
                    jmvcore::Table$new(
                        options=self$options,
                        name=name,
                        title=paste(name, '(table)'))
                },
                .meta = function(elem) {

                    item <- list(name=elem$name)

                    if (elem$type == 'table') {
                        item$type='Table'
                        item$columns=list()
                    }
                    else if (elem$type == 'object') {
                        item$type = 'Group'
                        items <- list()
                        for (child in elem$meta)
                            items[[length(items)+1]] <- private$.meta(child)
                        item$items <- items
                    }
                    else if (elem$type == 'collection') {
                        item$type = 'Array'
                        child <- elem$meta
                        if (is.character(child))
                            child <- list(name='item', type=child)
                        item$template <- private$.meta(child)
                    }
                    else if (elem$type == 'image') {
                        item$type = 'Image'
                        item$renderFun = '.render'
                    }

                    item
                },
                .getRefNames=function(refs) {
                    refNames <- vapply(refs, function(ref) {
                        for (name in names(.jmvrefs)) {
                            comp <- .jmvrefs[[name]]
                            if (startsWith(ref, comp$authors))
                                return(name)
                        }
                        return('')
                    }, 'a')
                    refNames <- c('jasp', refNames)
                    refNames
                }
            ),
            active = list(
                jdata = function() {
                    data <- super$data
                    names(data) <- .v(names(data))
                    data
                },
                joptions = function() {

                    # substitute option names

                    transformed <- list()
                    options <- self$options
                    for (name in options$names) {
                        option <- options$option(name)
                        value <- option$value
                        if (inherits(option, 'OptionVariable')) {
                            if (is.null(value))
                                value = ''
                        }
                        else if (inherits(option, 'OptionVariables')) {
                            if (is.null(value))
                                value = list()
                        }
                        else if (inherits(option, 'OptionPairs')) {
                            value <- lapply(value, function(pair) {
                                if (is.null(pair[[1]]))
                                    pair[[1]] <- ''
                                if (length(pair) < 2 || is.null(pair[[2]]))
                                    pair[[2]] <- ''
                                c(pair[[1]], pair[[2]])
                            })
                        }
                        transformed[name] <- list(value)
                    }

                    oldNames <- names(transformed)
                    newNames <- private$optionsMap[oldNames]

                    missing <- is.na(newNames)
                    if (any(missing))
                        stop(paste('new names do not exist for', paste(oldNames[missing], collapse=', ')))

                    # substitute list option values

                    subOptionIndices <- grepl(':', names(private$optionsMap))
                    subOptions <- strsplit(names(private$optionsMap)[subOptionIndices], ':', fixed=TRUE)
                    optionNames <- sapply(subOptions, function(x) x[1])
                    optionOldValues <- sapply(subOptions, function(x) x[2])
                    optionNewValues <- unname(private$optionsMap[subOptionIndices])

                    for (i in seq_along(optionNames)) {
                        name <- optionNames[i]
                        value <- optionOldValues[i]
                        if (identical(value, transformed[[name]])) {
                            transformed[[name]] <- optionNewValues[i]
                            next()
                        }
                    }

                    names(transformed) <- newNames

                    transformed
                }
            )
        )
    )
}

.retrieveState <- function() {
    jenv$retrieveState()
}

.newProgressbar <- function(...) {
    jenv$callback
}

.quitAnalysis <- function(message, ...) {
    jenv$setError(message)
}

.fromRCPP <- function(x, ...) {
    jenv[[x]](...)
}
