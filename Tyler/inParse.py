import sys
import re


# Extracts expression side of an equation
def extractExpression(equation):
    sides = re.split("[=]", equation)
    if "." or "+" or "~" in sides[0]:
        return sides[0].strip()
    else:
        return sides[1].strip()


# Extracts all variables from an expression
def extractVariables(expression):
    varSet = sorted(set(re.findall(r'[~0-9a-z]+', expression)))
    return varSet


# Counts number of different input variables
def countVariables(varList):
    count = len(set(varList))
    return count


# Count the number of and / or gates
def countOperators(uIn):
    cAND, cOR = 0, 0
    for a in range(0, len(uIn)):
        if uIn[a] == ".":
            cAND += 1
        if uIn[a] == "+":
            cOR += 1
    return [cAND, cOR]


# Checks user input function for potential issues
def checkFunction(inStr):
    eqCount = 0
    for a in range(0, len(inStr)):
        if inStr[a] == "=":
            eqCount += 1

    if eqCount == 0:
        print("Input must be a function. Please add an equals sign and an output variable")
        sys.exit()
    elif eqCount > 1:
        print("Invalid function. Only one \'=\' allowed")
        sys.exit()


# Main Method
if __name__ == '__main__':

    # Take user input
    print("Input a valid boolean function and include the output variable")
    uIn = input()
    # uIn = "~ab . (ab + cd) = h"
    print("Input was: " + uIn)

    checkFunction(uIn)

    ops = countOperators(uIn)
    e = extractExpression(uIn)
    v = extractVariables(e)
    c = countVariables(v)

    # To-Do
    # Need to parse the expression and format so we can use the gate functions to create a POS
    # Implement gate functions
    # Pass parse functions to get POS output
    # Ensure output is readable for Devon's script
