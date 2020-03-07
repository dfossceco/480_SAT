# RECURSIVE DPLL ALGORITHM 
  def dpll(fxn)
    # Check if fxn is empty (all terms reduced)
    # or if there are any empty clauses
    if (fxn.empty?)
      return "SAT"
    elsif (fxn.include?('0'))
      return "unSAT"
    end # if elseif

    # Unit propagation & simplification
    fxn = simplify(fxn, unit_prop(fxn))

    # Pure literal assignment & simplification
    fxn = simplify(fxn, pure_lit(fxn))

    if (fxn.empty?)
      return "SAT"
    elsif (fxn.include?('0'))
      return "unSAT"
    end # if elsif

    # Pick a literal and create an assignment
    assignment = pick_lit(fxn)

    if (dpll(simplify(fxn, assignment)).eql?('SAT'))
      return "SAT"
    else 
      assignment = assignment.transform_values { |val|
                                                 if (val.eql?('0'))
                                                  val = '1'
                                                 else
                                                  val = '0'
                                                 end # if else 
                                                }
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
    assignments.each do |unit, value|
      fxn.length.times do |index|
        if (fxn[index].include?(unit))
          if (fxn[index].length == 1)
            fxn[index] = value
          elsif (fxn[index].length == 2)
            if (value.eql?('0'))
              fxn[index] = '1'
            else
              fxn[index] = '0'
            end # if else
          else
            term = fxn[index].split('+')
            if ( (term.include?(unit) && value.eql?('1')) ||
                 (term.include?('~'.concat(unit)) && value.eql?('0'))
                )
              fxn[index] = '1'
            elsif (term.include?(unit) && value.eql?('0'))
              term.delete_at(term.index(unit))
              fxn[index] = term.join('+')
            elsif (term.include?('~'.concat(unit)) && value.eql?('1'))
              term.delete_at(term.index('~'.concat(unit)))
              fxn[index] = term.join('+')
            else
              abort ('Something has gone horribly wrong!')
            end # if elsif
          end # if else
        end # if 
      end # times do
    end # each do
    fxn.delete('1')
    return fxn
  end # def
