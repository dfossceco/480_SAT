#!/usr/bin/env ruby
require "./dpll_obj.rb"

# Select between the different modes of the SAT tool
# Partial assignment : Get user input and determine SAT for those values 
# Complete assignment : Automatically find assignments that will SAT fxn
# Multi : Determine if two networks are equivalent
# If fxn is unSAT, return all assignments that led to this conclusion
# If fxn is SAT, return all assignments that led to this conclusion

# GET FUNCTION
# Read the function and the list of inputs from the file
 def get_fxn()
  fxn_file = File.open("fxn.txt", "r")
  fxn = ''
  inputs = ''
  i = 0
  fxn_file.each do |line|
    if (i == 0)
      fxn = line.chomp.split('.')
    else
      inputs = line.chomp.split(',')
    end # if else
    i += 1
  end # each do
  fxn_file.close
  # system("rm fxn.txt")
  return fxn, inputs
 end # def

# COMPLETE
# TODO: Let Tyler's script run and have it write to fxn.txt
# First line will contain the function
# Second line will contain the list of inputs
# TODO: Who is going to print the CNF form?
  def complete()
    # user_in = gets().chomp
    # system ("./inParse.py #{user_in}")
    return get_fxn()
  end # def

# PARTIAL
# If in partial mode, get the users partial assignment(s)
# Simplifiy the function according to their assignments,
# send that reduced function to the DPLL algorithm
  def partial (fxn, dpll)
    puts ('Input your partial assignments for the function in the following form: ')
    puts ("\tinput1=value input2=value (continue for more assignments)")
    user_assign = gets().chomp.split(' ')
    partial_assign = {}
    user_assign.length.times do |index|
      user_assign[index] = user_assign[index].split('=')
      partial_assign[user_assign[index][0]] = user_assign[index][1]
    end # times do
    return dpll.simplify(fxn, partial_assign)
  end #def

# MULTI
# Take in 2 functions
# Produce the XOR of those two functions 
# Pass that result to Tyler's script to get CNF
# Return the CNF result
  def multi()
    puts('Input your first function:')
    fxn1 = gets().chomp
    puts('Input your second function:')
    fxn2 = gets().chomp

    fxn1 = '('.concat(fxn1).concat(')')
    fxn2 = '('.concat(fxn2).concat(')')
    not_fxn1 = '~'.concat(fxn1)
    not_fxn2 = '~'.concat(fxn2)

    term_a = '('.concat(fxn1).concat('.').concat(not_fxn2).concat(')')
    term_b = '('.concat(not_fxn1).concat('.').concat(fxn2).concat(')')

    fxn = term_a.concat('+').concat(term_b)
    # system ("./inParse.py #{fxn}")
    return get_fxn()
  end # def

# REDUCE
# The function given in CNF may not be in terms of only the inputs
# It may contain literals that are not actually part of the input set
# that are generated by converting to CNF using GCF
# This method will remove such literals that are not in the input set
  def reduce(inputs, assignments)
    assignments.each do |key, value|
      if (!inputs.include?(key))
        assignments.delete(key)
      end 
    end # each do 
    return assignments
  end # def


# MAIN
# Get the fxn from the user, convert to CNF,
# possibly get partial assignment
# Then use DPLL to solve the SAT of the fxn
  puts("\nWhat mode would you like to run the SAT solver in?")
  puts("\tType 'complete' for a complete  SAT solution")
  puts("\tType 'partial' for a partial assignment SAT solution")
  puts("\tType 'multi' for a multi-function comparison\n")

  run_type = gets().strip.downcase
  puts("You chose run type #{run_type}\n\n")

  fxn = ''
  inputs = ''
  dpll = DPLL.new(true, {})

  if (run_type.eql?('complete') || run_type.eql?('partial'))
    fxn, inputs = complete()
    if (run_type.eql?('partial'))
      fxn = partial(fxn, dpll)
    end # if
  elsif (run_type.eql?('multi'))
    fxn = multi()
  else
    abort ('INPUT MODE WAS NOT RECOGNIZED!')
  end # if else


  status = dpll.dpll_rec(fxn)
  assignments = dpll.get_assignments()
  assignments = reduce(inputs, assignments)
  puts("From the following assignments:\n\t#{assignments}\n\n")
  puts("The solver determined that the function is: #{status}\n\n")
