# ResultContext

#' Create a layered context for description
#' Context is a dynamic list of values, that can be updated by layer
#' A full context is the merge of all values of all layers
#' A layer can be added (push) or removed (pop)
#'
#' @examples
#' context = ResultContext$new()
#' context$set(step="main")
#' context$push() # Create a new layer
#' context$set(level=1)
#' context$resolve()
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
