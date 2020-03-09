#!/usr/bin/env ruby
require "./dpll_obj.rb"

# Select between the different modes of the SAT tool
# Partial assignment : Get user input and determine SAT for those values 
# Complete assignment : Automatically find assignments that will SAT fxn
# TODO : Multi-fxn 
# If fxn is unSAT, return all assignments that led to this conclusion
# If fxn is SAT, return all assignments that led to this conclusion

  puts("\nWhat mode would you like to run the SAT solver in?")
  puts("\tType 'complete' for a complete  SAT solution")
  puts("\tType 'partial' for a partial assignment SAT solution")
  puts("\tType 'multi' for a multi-function comparison\n")

  run_type = gets().strip.downcase

  puts("You chose run type #{run_type}\n")

  # Get the fxn from the user, convert to CNF,
  # possibly get partial assignment
  # Then use DPLL to solve the SAT of the fxn
  if (run_type.eql?('complete') || run_type.eql?('partial'))
    # TODO: Let Tyler's script run and have it write to fxn.txt
    # First line will contain the function
    # Second line will contain the list of inputs
    # TODO: Who is going to print the CNF form?
    # system ("./inParse.py")
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

    dpll = DPLL.new(true, {})
    # If in partial mode, get the users partial assignment(s)
    # Simplifiy the function according to their assignments,
    # send that reduced function to the DPLL algorithm
    if (run_type.eql?('partial'))
      puts ('Input your partial assignments for the function in the following form: ')
      puts ("\tinput1=value input2=value (continue for more assignments)")
      user_assign = gets().chomp.split(' ')
      partial_assign = {}
      user_assign.length.times do |index|
        user_assign[index] = user_assign[index].split('=')
        partial_assign[user_assign[index][0]] = user_assign[index][1]
      end # times do
      fxn = dpll.simplify(fxn, partial_assign)
    end #if
    puts(dpll.dpll_rec(fxn))
  end # if

