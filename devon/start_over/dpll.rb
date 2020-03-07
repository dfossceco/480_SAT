# Recursive DPLL algorithm 
  def dpll(fxn)
    # Check if fxn is consistent (all 1's)
    if (fxn.all?('1'))
      return "SAT"
    end # if

    # Check if there is an empty clause
    if (fxn.include?('0'))
      return "unSAT"
    end

    # Unit propagation & simplification
    fxn = simplify(fxn, unit_prop(fxn))

    # Pure literal assignment & simplification
    fxn = simplify(fxn, pure_lit(fxn))
    dpll(fxn)
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
    assignments = {}
    unit_clauses.each do |unit_clause|
      if (unit_clause.length == 2)
        assignments[unit_clause.delete('~')] = '0'
      else 
        assignments[unit_clause] = '1'
      end # if else
    end # each do
    return assignments
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
  assignments = {}
    pure_literals.each do |pure_literal|
      if (pure_literal.length == 2)
        assignments[pure_literal.delete('~')] = '0'
      else 
        assignments[pure_literal] = '1'
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
    return fxn
  end # def
