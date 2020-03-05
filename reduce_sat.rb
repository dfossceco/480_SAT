# For each assumption, iterate through each term in the function
# and check if the term can be reduced. If the term can be reduced, 
# reduce it. If the term reduces to 1, delete the term. If the term
# reduces to 0, the fxn is unSAT!!
def reduce_sat (assump, fxn)
  assump.each do |key, value|
    fxn.length.times do |index|

      term = fxn[index].split('+')
      not_key = '~'.concat(key)

      if (term.include?(not_key))
        if (value == 1)
          if (term.length != 1)
            term.delete(not_key)
          else 
            abort ('FXN IS unSAT') # TODO: print out the assumptions that caused this
          end # if else
        else
          term = 1
        end # if else
      elsif (term.include?(key))
        if (value == 0)
          if (term.length != 1)
            term.delete(key)
          else
            abort('FXN IS unSAT') # TODO: print out the assumptions that caused this
          end # if else
        else
          term = 1 
        end # if else
      end # if elsif

      if (term.kind_of?(Array))
        term = term.join('+')
      end # if

      fxn[index] = term

    end # times do
  end # each do 

  fxn.delete(1) 
  return fxn

end