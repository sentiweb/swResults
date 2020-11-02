#' Manipulate Output Assets Description And Context
#'
#' swResults provides a set of functions to manipulate description and context of generated files static (csv, results)
#' These description and context are used by an external system to build dynamic UI to present the results. An example is Results Server
#'
#' @importFrom jsonlite write_json
#' @importFrom R6 R6Class
#' @import ggplot2
"_PACKAGE"


get_current_path = function() {
  oo = options("swResults")$swResults
  path = NULL
  if( !is.null(oo) ) {
    p = oo[["path_provider"]]
    if(!is.null()) {
      if(is.function(p)) {
        path = do.call(p)
      } else {
        path = p
      }
    }
  }
  path
}
