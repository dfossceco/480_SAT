#!/usr/bin/env ruby
require "./dpll.rb"

# Get this shit from the file
fxn = "p+q+r.p+q+~r.p+~q+r.p+~q+~r.~p+q+r.~p+q+~r.~p+~q+r"

fxn = fxn.split('.')
status = dpll(fxn)
puts(status)
