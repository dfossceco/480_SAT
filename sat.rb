#!/usr/bin/env ruby 
require './reduce_sat.rb'

# Assuming we are getting an input string in the proper CNF form.
# This code will apply recursive decision and deduction techniques
# to get a minimal SAT or unSAT POS CNF fxn. This way we can apply
# the recursion one time regardless if we get user input or not

# Assuming input is of the form
# (derived from the gate consistency fxns):
# z.a+b+c.d+e+f
# where the first term is the output variable
# This will help us with our first assumption

# If the input has spaces in it, make a single string input
  if (ARGV.length == 0)
    abort('This SAT solver requires an input fxn!')
  elsif (ARGV.length != 1)
    fxn = ''
    i = 0
    ARGV.each do |index|
      fxn.concat(ARGV[i])
      i += 1
    end
  else
    fxn = ARGV[0]
  end # if

# Get the CNF function separated by each respective product term
  fxn = fxn.split('.')
  fxn.each do |term|
    term.gsub(/\s+/, "")
  end # each do

# Check that the first term is a single variable
# TODO: Might need to revisit this (Pending Tylers output)
  if (fxn[0].length != 1)
    abort('The first term should be a single variable!')
  end

# Create a hash of assumptions that we are going to make
  assump = {}

# Make our first assumption which will always be that the 
# output variable is 1
  assump[fxn[0]] = 1

  fxn = reduce_sat(assump, fxn)
  puts fxn


  