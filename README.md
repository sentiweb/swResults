# swResults

## Goals & Principles

swResults is a tiny R package providing some functions to describe a set of files and directories.

During data analysis, especially during exploratory phase, we can sometimes produce dynamically an important number of files, to analyse or document data processing phase. 

This package helps to create a documentation for each files and directory, associating with a file some metadata like a title, a description and file a "context" (a set of labels). Those metadata will be stored alongside with the output file (image/pdf/csv, or whatever).

The metadata can be then used by another program to generate a documentation, a document (by selecting a set of files based on their metatada), or a web UI with exploring/filtering features. They are stored in json.

The goals of the functions of this package is only to provide functions to create metadata associated with output files (and manage the storage part) allowing to manage the metadata creation within the same program generating the output. 

## Contexts

Context in this package is a set of labels (key+value) that can be associated with a file (and stored with it).
This package provide a `ResultContext` class handling the context generation.

```R
  context = ResultContext$new() # 
  
  context$set("disease"="influenza") # Add label with value in the current context
  
  context$resolve() # Get the current context
````

When output are generated, some files can "share" the same context : they use the same data source, the same method, they analyse the same variable or one is the graphic and the other csv containing the data of the graph. The "context" basically reflects the data processing by describing it with a set of label.
For example, if the program is producing a graphic about age of influenza cases, the context can be ["variable"="age", "disease"="influenza"].

In many cases, the data processing is done by a set of steps, each step will share the same "context". The step can be a block of program, a step of a loop. And it can be hierarchical, like in a nested loop : the inner loop will share some variables/context with the outer loop. 

The `ResultContext` class handle the current context with a stack of layers. You can add or remove the head of the stack using the `push()` or `pop()` methods on the context object. Each layer contains a set of labels. The current context is determined by merging all layers, the layer on the head has the precendence over the previous.

Labels are only defined in the head of the stack. When you remove a layer, you remove all labels defined in this layer. This is useful when you want to define labels that will only be during for a step of you program.
The push/pop operations can follows the nesting of a loop to create a context reflecting the current state of your program, and associating the output with it.

```R
  context = ResultContext$new() # 
  
  # 
  context$set("disease"="influenza") # Working on influenza
  
  context$push() # Add a layer
  
  context$set("variable"="age") # Working on age variable
  
  # Doing something about influenza & age
  
  context$resolve() # Ok working on influenza & age
  
  context$pop()
  
  context$resolve() # only disease is defined
  

````

## Describing output

To associate the metadata with a file, just call the `result_desc_output()` function

```R
# Associating a title, and passing the context object
result_desc_output("graph_influenza.pdf", desc=list(title="My title"))

# If you just createdd the plot with ggplot you can just

result_desc_output("graph_influenza.pdf", plot=TRUE) # Use the last plot as title

```

You have to call the function each time you create an output, this can overload your script. 
To handle this we usually define an helper function in our script to handle the output and the creation of the metadata

For example for graphics output (with ggplot):

```R 
# Global context
context = ResultContext$new()

# Save graphic and store the current context
g_save = function(..., width, height, units="in", plot=last_plot(), desc=list()) {
  file = paste0(...)
  ctx = context$resolve()
  desc = modifyList(ctx, desc) # merge with file defined meta
  ggsave(file, width=width, height = height, plot=plot, units=units)
  result_desc_output(file, desc=desc)
}

# Doing things...
g_save("my_plot.pdf", width=10, height=11) # Output graph with metadaa

```

