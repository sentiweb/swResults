# Description functions

#' Create a metadata file to describe the another file
#'
#' Metadata file are stored in the same directory as the file with the file name prefixed with '.d_'
#' Metadata file is a tiny json file that can be used by a server to get more information about the context of a file (purpose, comment, ...)
#' If it's a plot, it can extract the plot title as a descriptive label for the file
#' @param path character file path to describe
#' @param desc description to add
#' @param plot if TRUE use last plot title as description
#' @export
result_desc_output = function(path, desc=NULL, plot=FALSE) {
  if(isTRUE(plot)) {
    desc = result_desc_plot()
  }
  if(!is.null(desc)) {
    dir = dirname(path)
    desc_file = paste0(dir, "/", ".d_", basename(path))

    if(is.list(desc)) {
      jsonlite::write_json(desc, path = desc_file, auto_unbox = TRUE)
    } else {
      write(desc, file=desc_file)
    }
  }
}

#' @export
#' @name result_desc_output
desc_output = result_desc_output

#' Get description from plot title
#' @export
result_desc_plot = function(plot=NULL) {
  if(is.null(plot) || isTRUE(plot)) {
    plot = ggplot2::last_plot()
  }
  plot$labels$title
}

#' Create a readme file, usable by results server to show description of a directory
#' @param contents readme contents
#' @param title title of the readme
#' @param path file path, by default use get_current_path() to get current path from configuration
#' @export
result_desc_readme = function(contents, title=NULL, path=NULL) {
  if(length(contents) > 1) {
    contents = paste("<p>", contents,"</p>")
  }
  html = c(contents)
  if(!is.null(title)) {
    html = c("<div class=\"card-header\">", title,"</div><div class=\"card-body\">", html,"</div></div>")
  }
  if(is.null(path)) {
    path = get_current_path()
  }
  write(paste(html, collapse = "\n"), file=paste0(path, "/.readme"))
}

#' @export
#' @name result_desc_readme
desc_readme = result_desc_readme


#' Create a filters description
#'
#' Filters are used to create filter feature on the UI.
#' Each filter has a name, a label, and a set of values to be used as filter
#' Filters allows to select a set of files using the context labels of each files
#'
#' @param auto use auto filtering feature (create a filter for each context tag)
#' @param filters list() list of filters, each filter is a result_filter object [result_filter()]
#' @importFrom methods is
#' @export
result_desc_filters = function(auto=FALSE, filters, path=NULL) {
  if(is.null(path)) {
    path = get_current_path()
  }

  ff = list()
  for(i in seq_along(filters)) {
    name = names(filters[i])
    filter = filters[[i]]
    is_s3 = is(filter, "result_filter")
    if(is.null(name) || name == "") {
      if(is_s3) {
        name = filter$name
      } else {
        rlang::abort(paste("no name is defined for filter", i))
      }
    }
    ff[[name]] = unclass(filter)
  }

  data = list(
    auto=auto,
    filters=ff
  )

  jsonlite::write_json(data, paste0(path, '/.filters.json'), auto_unbox=TRUE)
}

#' @export
#' @name result_desc_filters
desc_filters = result_desc_filters

#' Create a filter
#' @param name filter name, the filter name is the name of the context label to filter on
#' @param label filter label
#' @param values list of possibles values for the label
#' @export
result_filter = function(name, label, values=NULL, ...) {
  structure(list(
    label=label,
    values=values,
    name=name,
    ...
  ), class="result_filter")
}

