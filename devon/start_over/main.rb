#!/usr/bin/env ruby
require "./dpll.rb"

# Get this shit from the file
fxn = "h.a+d.b+d.~a+~b+~d.~b+~e.~c+~e.b+c+e.~d+~f.d+f.~d+g.~e+g.d+e+~g.f+~h.g+~h.~f+~g+h"

fxn = fxn.split('.')
status = dpll(fxn)
puts(status)
