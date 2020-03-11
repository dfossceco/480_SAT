#!/usr/bin/env ruby

# ***********************************************************************
# THIS SCRIPT WILL ONLY WORK IF THE FUNCTIONS ARE IN CANONICAL CNF
# CONTAINING NO INTERMEDIATE LITERALS. THE LITERALS IN THE FUNCTION MUST 
# ONLY BE INPUTS OF THE FUNCTION. TERMS MUST INCLUDE EVERY LITERAL
# ***********************************************************************

# This script will perform the multi function XOR
# and feed that result to the dpll algorithm
# to determine whether or not two functions are equivalent

# Take in 2 CNF functions, convert to a integer representation,
# (i.e. a PI representation of the maxterms), find the complement
# of each fxn, then perform the following on the maxterms
# F = F1+~F2.~F1+F2 to get the XOR of the two functions
# Give this result to the dpll algorithm
# (In minterms f = f1.~f2 + ~f1.f2)

class Multi_Fxn
# Instance variables for the class
  def initialize (verbose)
    @verbose = verbose
  end # def

# TO NUMBERS
# Convert the fxn into a integer representation
# INPUT: [x+y+z, ~x+~y+~z]
# Intermediate: 000, 111
# OUTPUT: 0, 7
  def to_num(fxn)
    if (@verbose)
      puts("#{fxn}")
    end
    fxn.length.times do |index|
      term = fxn[index].split('+')
      term.length.times do |index|
        if (term[index].include?('~'))
          term[index] = '1'
        else
          term[index] = '0'
        end # if else
      end # each do 
      fxn[index] = term.join('').to_i(2)
    end # times do
    if (@verbose)
      puts("MAXTERMS: #{fxn}")
    end
    return fxn
  end # def

# FXN NOT
# Find the not of the function in terms of maxterms
# INPUT: [0, 1, 2]
# OUTPUT: [3, 4, 5, 6, 7]
  def not(num_inputs, fxn)
    not_fxn = (0..((2 ** num_inputs) - 1)).to_a
    fxn.each do |term|
      not_fxn.delete(term)
    end # each do
    if (@verbose)
      puts("#{not_fxn}")
    end
    return not_fxn
  end # def

  def or(fxn_a, fxn_b)
    new_fxn = fxn_a.concat(fxn_b).sort.uniq
    if (@verbose)
      puts("#{new_fxn}")
    end # if
    return new_fxn
  end # def 

  def and(fxn_a, fxn_b)
    new_fxn = fxn_a & fxn_b
    if (@verbose)
      puts("#{new_fxn}")
    end # if
    return new_fxn
  end # def

end # class

multi = Multi_Fxn.new(true)

fxn1 = 'x+~y+~z.~x+y+z.~x+y+~z.~x+~y+z.~x+~y+~z'
fxn1 = fxn1.split('.')
int_fxn1 = multi.to_num(fxn1)
not_fxn1 = multi.not(3, int_fxn1)
puts
fxn2 = 'x+~y+z.x+~y+~z.~x+y+z.~x+y+~z.'
fxn2 = fxn2.split('.')
int_fxn2 = multi.to_num(fxn2)
not_fxn2 = multi.not(3, int_fxn2)
puts
term_a = multi.or(int_fxn1, not_fxn2)
term_b = multi.or(not_fxn1, int_fxn2)
puts
xor_fxn = multi.and(term_a, term_b)

