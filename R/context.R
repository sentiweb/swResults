# ResultContext

#' ResultContext Creates a layered set of named values for context description
#' Context is a dynamic list of named values, that can be updated by layer.
#' A full context is the merge of all values of all layers, with the rule, last layer overrides the first one.
#'
#' Context is used to manage the context of a set of files, typically during the generation of them (you know well the context of a file when you create it)
#'
#' For example, during data analysis, a  high number of files can be generated and some can share the same context (same output, same analysis method, same step, ...)
#' The context can be used to manage this shared context, an create a dedicated context for each file or group of file.
#' The layered feature allow to restore a previous context or to work in a recursive way (using push() and pop() to manage recursion level)
#'
#' The resolved context is the set of labels in the current context with all layers merged. You can see the context as the "labels" in K8s,, a label has a name and a value.
#'
#' A layer can be added (push) or removed (pop)
#'
#' @examples
#' context = ResultContext$new()
#' context$set(step="main")
#' context$push() # Create a new layer
#' context$set(level=1)
#' context$resolve() # get the values for all merged layers
#' context$pop() # Get back to first layer
#' context$resolve()
#' @export
ResultContext = R6::R6Class("ResultContext",
  list(

    #' @field contexts layers as list
    contexts = NULL,

    #' @description
    #' Create the instance
    initialize=function() {
      self$empty()
    },

    #' @description
    #' Empty the context
    #' Create an empty context with a base layer
    empty = function()  {
      self$contexts = list(list())
    },

    #' @description
    #' Get the current contexts values
    resolve = function() {
      data = list()
      for(ctx in self$contexts) {
        data = modifyList(data, ctx)
      }
      data
    },

    #' @description
    #' Add a new context layer
    push = function() {
      self$contexts[[length(self$contexts) + 1]] <<- list()
    },

    #' @description
    #' Remove last context layer
    pop = function() {
      if(length(self$contexts) > 1) {
        self$contexts <<- self$contexts[-length(self$contexts)]
      }
    },

    #' @description
    #' Define context values
    #' @param ... list of named value to define in the current layer
    set = function(...) {
      v = list(...)
      self$contexts[[length(self$contexts)]] <<- modifyList(self$contexts[[length(self$contexts)]], v)
    }
  )
)
