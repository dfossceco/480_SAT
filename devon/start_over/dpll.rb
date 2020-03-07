  def dpll(fxn)

    # Check if fxn is consistent (all 1's)
    if (fxn.all?('1'))
      return true
    end # if

    # Check if there is an empty clause
    if (fxn.include?('0'))
      return false
    end

    # Unit propagation
    unit_clauses = []
    fxn.each do |term|
      if ( (term.length == 1 && !term.eql?('1') && !term.eql?('0')) || 
            term.length == 2
          )
        unit_clauses.append(term) 
      end
    end # each do
    fxn = unit_prop(fxn, unit_clauses)
    dpll(fxn)

  end # def
