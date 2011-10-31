# 1) Q: It’s common to use slice to copy an entire array:

# Note: Use the CoffeeScript REPL to test it.
original = ['Mary', 'Poppins']
copy = original[0..]
copy[0] = 'Sh' + copy[0][1..]
copy[1] = 'B' + copy[1][1..]
original.join ' ' # Mary Poppins
copy.join ' ' # Shary Boppins

# Explain how copy = original[0..] differs from copy = original.

# A: For the first case 'copy = original[0..]' the call 'original[0..]' returns a copy of the slice (the group of elements removed)
# contrasting with the second 'copy = original' which makes copy variable reference to the same object held in the 'original' variable.

# Answer from the book:
# When you use slice, the result is a new array containing some or all of the items from the original array; adding, removing, or replacing 
# items in the new array will not affect the original. That’s why you’ll see arr.slice[0..] in a lot in functions—when someone passes you 
# an array and you want to modify it for your own purposes, working with a copy is just common courtesy.

# 2) Q: One subtle difference between CoffeeScript’s for...in loops and the C-style for loops in JavaScript is illustrated by this code. 
# Explain why this code produces the following result:

once = ->
  if once.hasRun
    null
  else
    once.hasRun = true
    [1, 2, 3]

console.log x for x in once()

# Output
# 1
# 2
# 3

# A: Funtions in JS are just objects in the 'once' function we are checking for the hasRun property inside the context of once call if this
# is 'null' for the first call is so we frok to the 'else' section of the 'if' statement in which we set the 'hasRun' property to true and
# we explicitly return an array '[1,2,3]' so why the line 'console.log x for x in once()' works is simply because everything in CoffeeScript
# is an expression amd every expresion has a return value in this case the above array and in this case 'x for x in once()' represents a
# comprenhesion console.log is called like this 'console.log x for x in [1,2,3]'.

# Answer from the book:
# In the following code it’s important to realize that once is only called, well, once():
once = ->
  if once.hasRun
    null
  else
    once.hasRun = true
    [1, 2, 3]

console.log x for x in once()

# That last line is equivalent to this:
onceResult = once()
console.log x for x in onceResult

# In short, CoffeeScript takes care of caching the function result automatically in a for loop. If you want to call a function on each
# loop iteration, you should use while or until.

# 3) Q: What is the output of this code?

for x in [1, 2]
  setTimeout (-> console.log x), 50
  
# Bonus question: Does it matter if the timeout is 0? For illumination, see Scope in Loops, on page 96.

# A: Loops doe not create scopes , only Funtions objects (functions) do that. As a consequece by the time of calling 
# 'setTimeout (-> console.log x), 50' the 
# loop has finished assigining the result to the variable 'x' been gone.

# Answer from the book
# Look at this section:
for x in [1, 2]
  setTimeout (-> console.log x), 50

# This gives the following output:
# 2 2
# What’s going on? The key here is that there’s only one x variable. The timeout is invoked after the loop has finished and x has been set to 2; it doesn’t matter what 
# the value of x was when the function was declared. Changing the timeout to 0 has no effect because setTimeout always adds its target to the “event queue,” which isn’t 
# invoked until after all other code has run. The easiest solution is to use do to capture the value of x in each loop iteration:
for x in [1, 2] 
  do (x) ->
  setTimeout (-> console.log x), 50

# 4) Q: Recall that 'foo' in arr will tell you whether the array arr contains the string 'foo' and whether 'bar' of obj will tell you if obj.bar exists. But how would you
# check whether an arbitrary object contains a given value? Start with this:
  
objContains = (obj, val) ->

# A: My function would look like this:

objContains = (obj, val) ->
  obj[val]?
  
# But it does fail for hashes (regular JSON objects) so let's go to the book.

# Answer from the book

# Here’s a function that checks whether a particular value is attached to
# the given object:
objContains = (obj, match) -> 
  for k, v of obj
    if v is match 
      return true
  false

# Note that 'k' is unused but necessary; the of syntax always goes in the order 'key, value', and we want that value. In practice, you should be writing your code so that 
# this sort of loop is unnecessary. The whole point of the hash structure is that fetching values is fast when you know the corresponding key. If you’re frequently 
# checking whether a value is in a hash or not, you should be using a different data structure.

# Note: After running this solution this only works for one level of deep of the hash. For example under this conditions the above solution works:

objContains = (obj, match) -> 
  for k, v of obj
    if v is match 
      return true
  false
  
a = [1,2,3]
b = foo: "bar"

console.log objContains(a,1)
console.log objContains(a,4)
console.log objContains(b,"bar")
console.log objContains(b,"baz")

# Which gives us the results (correct):
# true
# false
# true
# false

# But chaging the structure of 'b' hash makes the 'objContains()' implementation fails.
a = [1,2,3]
b = foo: 
      bar: "bar"

console.log objContains(a,1)
console.log objContains(a,4)
console.log objContains(b,"bar")
console.log objContains(b,"baz")

# Gives this results: # FAIL!

# true
# false
# false
# false

# 5) Q: Let’s say that we need to run a function at least once and then run it again repeatedly until a condition is met. In C/Java/JavaScript, we 
# can write this:

do {
  user.harangue()
  } while (!user.paidInFull)

# The direct CoffeeScript equivalent would be the following:
user.harangue()
user.harangue() until user.paidInFull

# But this violates the sacred principle of DRY (Don’t Repeat Yourself). Define a doAndRepeatUntil function that takes two functions (equivalent to 
# the loop body and the condition), so that we can instead write it this way:
doAndRepeatUntil user.harangue, -> user.paidInFull

# A: This was my answer: 
doAndRepeatUntil = (fun, condition) ->
  fun.apply(@)
  fun.apply(@) until condition()
  
# Let's go to the book's answer:

# To run a function once and then repeat it until a condition is called, we can write this:
doAndRepeatUntil = (func, condition) ->
  func.call this
  func.call this until condition()
  
# 6) Q: For the project in this chapter, we set MIN_WORD_LENGTH as a constant. However, it makes more sense from a modularity standpoint to derive this 
# from the dictionary we load into the game. How would you do that on one line using Math.min.apply and a list comprehension? (Math.min returns the 
# argument given with the lowest value, such as Math.min 15, 16, 23, 42, 5, 8 is 5.)

# A: At the moment of this writting I could not foind a solution for this exercise.

# Answer from the book:

# To get the length of the shortest string in our wordList array, we can write the following:

Math.min.apply Math, (w.length for w in wordList)

# The comprehension (w.length for w in wordList) generates a list of the length of each word in wordList. Using apply passes it to Math.min as an enormous 
# list of arguments. (The first argument to apply ensures that Math.min runs in the Math context, just as it would if we called Math.min directly.) 
# This isn’t the most efficient approach, but it’s very succinct.