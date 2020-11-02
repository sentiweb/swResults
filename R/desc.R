# Description functions

#' Create a file to describe the output
#' Descriptive file are stored in the directory of the file prefixed by '.d_'
#' @param path character file path to describe
#' @param desc description to add
#' @param plot if TRUE use last plot title as description
#' @export
desc_output = function(path, desc=NULL, plot=FALSE) {
  if(isTRUE(plot)) {
    desc = desc_plot()
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

#' Get description from plot title
#' @export
desc_plot = function(plot=NULL) {
  if(is.null(plot) || isTRUE(plot)) {
    plot = ggplot2::last_plot()
  }
  plot$labels$title
}

#' Create a readme file, usable by results server to show description of a directory
#' @export
desc_readme = function(contents, title=NULL, path=NULL) {
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
