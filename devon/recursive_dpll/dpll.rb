# Global $verbose signal for debugging
$verbose = true

# RECURSIVE DPLL ALGORITHM 
  def dpll(fxn)
    # Check if fxn is empty (all terms reduced)
    # or if there are any empty clauses
    if (fxn.empty?)
      return "SAT"
    elsif (fxn.include?('0'))
      return 'unSAT'
    end # if elsif

    # Make a local copy of the function for this activation record 
    t_fxn = Array.new(fxn)

    # While there exists some unit clause or pure literal,
    # simplify the fxn based on those assignments
    while ( !unit_prop(t_fxn).empty? || 
            !pure_lit(t_fxn).empty? )
      # Unit propagation & simplification
      if ($verbose)
        puts ("UNIT CLAUSE: #{unit_prop(t_fxn)}" )
      end # if 
      t_fxn = simplify(t_fxn, unit_prop(t_fxn))

      # Pure literal assignment & simplification
      if ($verbose)
        puts ("PURE LITERAL: #{pure_lit(t_fxn)}")
      end
      t_fxn = simplify(t_fxn, pure_lit(t_fxn))
    end # while

    if (t_fxn.empty?)
      return "SAT"
    elsif (t_fxn.include?('0'))
      return 'unSAT'
    end # if elsif

    # Pick a literal and create an assignment
    assignment = pick_lit(t_fxn)
    if ($verbose)
      puts ("ASSUMPTION: #{assignment}")
    end

    if (dpll(simplify(t_fxn, assignment)).eql?('SAT'))
      return "SAT"
    else 
      assignment = assignment.transform_values { |val|
                                                 if (val.eql?('0'))
                                                  val = '1'
                                                 else
                                                  val = '0'
                                                 end # if else 
                                                }
      if ($verbose)
        puts ("ASSUMPTION: #{assignment}")
      end
      return dpll(simplify(fxn, assignment))
    end # if else
  end # def

# UNIT PROPAGATION
# Identify any unit clauses in the function
# Make a hash of assignments based on the unit clauses
# and return those assignments
  def unit_prop (fxn)
    unit_clauses = []
    fxn.each do |term|
      if ( (term.length == 1 && !term.eql?('1') && !term.eql?('0')) || 
            term.length == 2
          )
        unit_clauses.append(term) 
      end
    end # each do
    return assign(unit_clauses)
  end # def 

# PURE LITERAL ASSIGNMENT
# Identify any pure literals in the function and return
# a hash of assignments that make those pure literals true
def pure_lit(fxn)
  pure_literals = fxn.join('+').split('+').uniq.sort
  pure_literals.length.times do |index|
    not_literal = '~'.concat(pure_literals[index])
    if ( pure_literals[index].length == 1 && pure_literals.include?(not_literal))
      pure_literals[index] = '0'
      pure_literals[pure_literals.index(not_literal)] = '0'
    end # if 
  end # each do
  pure_literals.delete('0')
  return assign(pure_literals)
end # def

# PICK LITERAL
# Find the term with the fewest literals and return a hash
# containing  an assignment for the first literal in that term
def pick_lit(fxn)
  t_fxn = []
  fxn.length.times do |index|
    t_fxn[index] = fxn[index].split('+').join('').split('~').join('')
  end # times do
  smallest_term_index = 0
  t_fxn.length.times do |index|
    if (t_fxn[index].length < t_fxn[smallest_term_index].length)
      smallest_term_index = index
    end # if
  end # times do 
  pick = []
  smallest_term = fxn[smallest_term_index].split('+')
  pick.append(smallest_term[0])
  return assign(pick)
end # def

# ASSIGNMENTS
# Given an array of literals, create a hash that contains
# the assignments that make those literals true
  def assign(literals)
    assignments = {}
    literals.each do |literal|
      if (literal.length == 2)
        assignments[literal.delete('~')] = '0'
      else 
        assignments[literal] = '1'
      end # if else
    end # each do
    return assignments
  end # def

# SIMPLIFY
# Given the function and hash of assignments,
# simplify the function and return that simplified
# function
  def simplify (fxn, assignments)
    t_fxn = Array.new(fxn)
    assignments.each do |unit, value|
      t_fxn.length.times do |index|
        if (t_fxn[index].include?(unit))
          if (t_fxn[index].length == 1)
            t_fxn[index] = value
          elsif (t_fxn[index].length == 2)
            if (value.eql?('0'))
              t_fxn[index] = '1'
            else
              t_fxn[index] = '0'
            end # if else
          else
            term = t_fxn[index].split('+')
            if ( (term.include?(unit) && value.eql?('1')) ||
                 (term.include?('~'.concat(unit)) && value.eql?('0'))
                )
              t_fxn[index] = '1'
            elsif (term.include?(unit) && value.eql?('0'))
              term.delete_at(term.index(unit))
              t_fxn[index] = term.join('+')
            elsif (term.include?('~'.concat(unit)) && value.eql?('1'))
              term.delete_at(term.index('~'.concat(unit)))
              t_fxn[index] = term.join('+')
            else
              abort ('Something has gone horribly wrong!')
            end # if elsif
          end # if else
        end # if  
      end # times do
    end # each do
    t_fxn.delete('1')
    if ($verbose)
      puts("INPUT: #{fxn}")
      puts("OUTPUT: #{t_fxn}")
      puts
    end 
    return t_fxn
  end # def
