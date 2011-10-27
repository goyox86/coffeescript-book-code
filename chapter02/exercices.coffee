# 1) Q:The following function will remove all elements from the given array and return the result of the splice, which in this case
# will be a copy of the original array. (We’ll learn more about that particular function in Slicing and Splicing, on page 42.)
clearArray = (arr) -> arr.splice 0, arr.length

# A: Yes, and the answer is because the way CoffeeScript handles the ommited parentheses in function calls the above code is the same 
# as writing clearArray = (arr) -> arr.splice(0, arr.length) and the behavior of the JavaScript Array.prototype.slice which as described
# in it's documentation:

# "The splice() method adds and/or removes elements to/from an array, and returns the removed element(s)."
# Syntax:
  # array.splice(index,howmany,element1,.....,elementX)
  # Parameter	Description
  # - index	Required. An integer that specifies at what position to add/remove elements
  # - howmany	Required. The number of elements to be removed. If set to 0, no elements will be removed
  # - element1, ..., elementX	Optional. The new element(s) to be added to the array

# According to the 'clearArray()' implementation we are removing all the elements simply because we start a index 0 and we pass as second 
# argument to the 'splice()' function the length of the array.

# Q: How would I make clearArray return the cleared array instead? How would I make it return nothing at all? (While this is a trivial 
# example, marking functions as returning nothing often allows the CoffeeScript compiler to generate more efficient output, especially 
# when loops are involved.)

#  How would I make clearArray return the cleared array instead?
clearArray = (arr) -> 
  arr.splice 0, arr.length 
  return arr

#  How would I make it return nothing at all?
clearArray = (arr) -> 
  arr.splice 0, arr.length
  return

# or simply
clearArray = (arr) -> return


# 2) Q: Write a function called run that takes a function as its first argument and passes all additional arguments to the called function. 
# That is, run func, a, b should be equivalent to func(a, b). Hint: This shouldn’t take more than one line.
# A: Accomplished using Function.prototype.apply(f,args)
run = (f, args...) -> f.apply(this,args)

# 3) Q: Implicit parentheses always go to the end of the expression but not necessarily to the end of the line. Find a case where implicit parentheses 
# fall short of the end of the line.

# A: The postfix operators (if/unless and for/while/until) are the only major exceptions to the rule that implicit parentheses go to the end of the line. 
# For example, all of the following lines are equivalent:

return abortMission warning if warning? 
return abortMission(warning) if warning?
if warning? then return abortMission warning 
if warning? then return abortMission(warning)

# Adding explicit parentheses that go to the end of the line would change the meaning considerably:

return abortMission(warning if warning?)

# 4) Q: When you use explicit parentheses in a function call, CoffeeScript doesn’t allow any whitespace after the function name. For instance, f (a, b) is a 
# syntax error. Can you think of a reason why this rule is in place? (Hint: What does f (g) h mean?)

# A: CoffeeScript doesn’t allow space between a function and its explicit parentheses because this would allow parentheses around an expression to radically 
# change its meaning. Here are some examples:

fgh

# This expression really means the following:
f(g(h))

# Compare that meaning with this expression:
f (g) h

# Here the parentheses really mean this:
f(g)(h)

# CoffeeScript’s rule is that if there’s whitespace after any identifier (and something other than a postfix operator after the whitespace), then that identifier 
# is a function with implicit parentheses.

# 5) Q: What is the context of the function call foo.bar.baz()? What about @hoo()? @hoo.rah()?

# A: baz() runs in foo.bar context. @hoo() runs in this/@ and rah() runs in @hoo.

# 6) x refers to a variable that obeys scoping rules, while @x refers to a variable that obeys context rules. The two will never be equivalent—they may reference 
# the same object, but writing x = y would not affect @x and vice versa.) But what.x and @x can be equivalent. If they are, then what is what?

# To find the answer, add a very short line to this code that will generate the output “quantum entanglement”:
xInContext = -> 
 console.log @x
what = { x: 'quantum entanglement' }

# A: 
xInContext = -> 
  console.log @x
what = { x: 'quantum entanglement' }
xInContext.apply(what)

# or

xInContext = -> 
  console.log @x
what = { x: 'quantum entanglement' }
xInContext.call(what)
 
# A: what.x and @x are, of course, equivalent if and only if what is this. Again, it’s perfectly possible for what.x and @x to refer to the same object, 
# but what.x = y will not overwrite @x unless what is this.

# 7) Q: Will this code work?

x = true            
showAnswer = (x = x) ->
  console.log if x then 'It works!' else 'Nope.' 
  showAnswer()

# Explain why or why not.

# A: The code fails because of the x = x, which is a no-op. Here’s the problem. Recall that the default argument syntax a = b is equivalent to placing a ?= b 
# at the top of the function body; there’s no way to bring the x from the outer scope into the function. The solution is to either use showAnswer x or to ditch the shadowing.

