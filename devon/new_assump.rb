# Look for terms in the function that only contain one literal
# If such a term is found, make a new assumption that will make
# that term true.
# TODO: Need to think about what happens if such a term does not exist
  def new_assump (assump, fxn)
    fxn.each do |term|
      if (term.length == 1)
        assump[term] = 1
      elsif (term.length == 2)
        term = term.delete('~')
        assump[term] = 0
      end # if elsif
    end # each do 
    
    return assump
  end # def