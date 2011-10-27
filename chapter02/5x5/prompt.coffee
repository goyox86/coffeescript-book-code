# 'process' come from the Node environment, one of the few parts that doesn’t require a require statement to access.
# 'process' provides methods for getting command-line arguments, managing memory, and, of course, dealing with standard IO.

# Opening the standard input stream
stdin = process.openStdin()
# You can achieve the same in the current stable version of node.js (v0.4.12) with something like this:
#process.stdin.resume()
# Setting the encoding for standard input stream
stdin.setEncoding 'utf8'
# You can achieve the same in the current stable version of node.js (v0.4.12) with something like this:
#process.stdin.setEncoding 'utf8'

# Setting of a 'inputCallback' variable to hold the input callback at module scope in order to have access to it and allowing change
# the callback behaviour
inputCallback = null
# The stdin.on 'data' call tells Node, “Each time a new line of input comes in, pass it to this function.”
stdin.on 'data', (input) -> inputCallback input
# You can achieve the same in the current stable version of node.js with something like this:
#process.stdin.on 'data', (input) -> inputCallback input

# Creating a funtion in charge of asking for the first pair of coordinates. Here we set the 'inputCallback' variable to a anonymous
# function which takes the input and afterwards calls promptForTile2() if validation passes. (reimplementing the input callback,
# 'inputCallback' acts as a proxy)
promptForTile1 = ->
  console.log "Please enter coordinates for the first tile."
  inputCallback = (input) ->
    promptForTile2() if strToCoordinates input

# Creating a funtion in charge of asking for the second pair of coordinates. Here we set the 'inputCallback' variable to a anonymous
# function which takes the input and afterwards prints a 'success' message before passing the control to 'promptForTile1()' if validation
# passes. (reimplementing the input callback again)
promptForTile2 = ->
  console.log "Please enter coordinates for the second tile." 
  inputCallback = (input) ->
    if strToCoordinates input
      console.log "Swapping tiles...done!"
      promptForTile1()
  
# Here we define a pseudo-constant hence for the compiler is just another module level variable, we here by convention use capital letters
# to denote that semantically is a constant (just for better readbility).
GRID_SIZE = 5

# Simple utility function that takes two arguments and uses CoffeeScript’s chained comparisons feature: '0 <= x < GRID_SIZE' which is short-
# hand for '(0 <= x) and (x < GRID_SIZE)' and returns a boolean value as the result of the comparison.
inRange = (x,y) ->
  0 <= x < GRID_SIZE and 0 <= y < GRID_SIZE

# Simple utility function that takes one argument and uses the JavaScript 'Math.round()' funtion to deterine if the argument 'num' is an inte-
# ger not a letter or other character.
isInteger = (num) ->
  num is Math.round(num)

# The validation function used in 'promptForTile1()' and 'promptForTile2()' for validating the input. This function makes use of the previous
# 'inRange()' and 'isInteger()' utility functions as well as the standard JavaScript 'parseFloat()' which  parses a string and returns a
# floating point number. The code is very verbose but here is what it does:
# 1) Takes the input and split it into pieces using ',' as the separator and assings it to the halves local variable (split returns an regular
# Array).
# 2) Afterwards verifies if the length of the 'halves' array is 2 (the user provided a pair coordinates) else prints using 'console.log' a
# message notifying the user with the correct input format.
# 3) If the length of 'halves' is 2 then we convert the two strings into floating point numbers setting the local varibles 'x' and 'y' respec-
# tively.
# 4) We verify if 'x' and 'y' are both integers if not it uses 'console.log' to print a meningfull message.
# 5) Verify that both 'x' and 'y' are within the range of 0 to 4 andd if this is true we return the pair of coordinates (which is coerced to
# true) otherwise we use 'console.log()' to print a meaningful message.
strToCoordinates = (input) ->
  halves = input.split(',')
  if halves.length is 2
    x = parseFloat halves[0]
    y = parseFloat halves[1]
    if !isInteger(x) or !isInteger(y)
      console.log "Each coordinate must be an integer."
    else if not inRange x - 1, y - 1
      console.log "Each coordinate must be between 1 and #{GRID_SIZE}."
    else
      {x, y}
  else
    console.log 'Input must be of the form `x, y`.'

# IMPORTANT: You should have noticed that inside 'promptForTile1()' and 'promptForTile2()' we used 'strToCoordinates()' in conditionals. The
# explanation is simple 'console.log()' always returns 'undefined' which is automatically coerced by CoffeeScript/JavaScript to false. Remember
# that in CoffeeScript (as in JavaScript), all values are implicitly coerced to booleans by the boolean logic operators, && and || (known as 'and'
# and 'or' under CoffeeScript style), as well as 'if'. Most values become true, while a handful—notably null, undefined, 0, and the empty string—become
# false.
    
# We start the party!
console.log "Welcome to 5x5!"
promptForTile1()



