def unit_prop(fxn, unit_clauses)

# Create a hash of assignments based on the unit clauses
  assignments = {}
  unit_clauses.each do |unit_clause|
    if (unit_clause.length == 2)
      assignments[unit_clause.delete('~')] = '0'
    else 
      assignments[unit_clause] = '1'
    end # if else
  end # each do

# Iterate through fxn for each assignment and reduce the fxn
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
