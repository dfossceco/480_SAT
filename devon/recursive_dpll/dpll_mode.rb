#!/usr/bin/env ruby
require "./dpll.rb"

# Select between the different modes of the SAT tool
# Mode 1: Get user input and determine SAT for those values 
# Mode 2: Automatically find assignments that will SAT fxn
# If fxn is unSAT, return all assignments that led to this conclusion
# If fxn is SAT, return all assignments that led to this conclusion

# Get this shit from the file
fxn = "p+q+r.p+q+~r.p+~q+r.p+~q+~r.~p+q+r.~p+q+~r.~p+~q+r"

fxn = fxn.split('.')
puts(fxn)
puts
status = dpll(fxn)
puts(status)
