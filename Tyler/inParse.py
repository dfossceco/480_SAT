import sys
import re

# Global used for building the names of gate consistency outputs
outCount = 0


# Invert all inputs in a list
def invert(inList):
    invertList = [""] * len(inList)
    for a in range(0, len(inList)):
        if inList[a][0] == "~":
            invertList[a] = inList[a][1:]
        else:
            invertList[a] = "~" + inList[a]
    return invertList


def checkBalance(exp):
    openParen = ["("]
    closeParen = [")"]

    stack = []
    for i in exp:
        if i in openParen:
            stack.append(i)
        elif i in closeParen:
            pos = closeParen.index(i)
            if (len(stack) > 0) and (openParen[pos] == stack[len(stack) - 1]):
                stack.pop()
            else:
                return "Unbalanced"
    if len(stack) > 0:
        return "Unbalanced"


# Function to build gate consistency functions for OR gates
def orGateConsistency(inList):
    # Output is global outCount
    global outCount
    P1Str, P2Str = "", "("

    # Invert input for product section of equation
    invertList = invert(inList)

    # Create strings for product and sum section of equation
    for a in range(0, len(inList)):
        if a == len(inList) - 1:  # Last one
            P1Str += "(" + invertList[a] + " + ^" + str(outCount) + ")"
            P2Str += inList[a] + " + ~^" + str(outCount) + ")"
        else:
            P1Str += "(" + invertList[a] + " + ^" + str(outCount) + ") * "
            P2Str += inList[a] + " + "

    # Increment outCount for out variables, and AND product and sum sections of the equations together
    outCount += 1
    output = P1Str + " * " + P2Str
    return ["^" + str(outCount - 1), output]


# Function to build gate consistency functions for AND gates
def andGateConsistency(inList):
    # Output is global outCount
    global outCount
    P1Str, P2Str = "", "("

    # Invert input for product section of equation
    invertList = invert(inList)

    # Create strings for proudct and sum section of equation
    for a in range(0, len(inList)):
        if a == len(inList) - 1:  # Last one
            P1Str += "(" + inList[a] + " + ~^" + str(outCount) + ")"
            P2Str += invertList[a] + " + ^" + str(outCount) + ")"
        else:
            P1Str += "(" + inList[a] + " + ~^" + str(outCount) + ") * "
            P2Str += invertList[a] + " + "

    # Increment outCount for out variables, and AND product and sum sections of the equations together
    outCount += 1
    output = P1Str + " * " + P2Str
    return ["^" + str(outCount - 1), output]


# Count occurrences of "(" in a string. Used for extracting nested parentheses sections
def countLeftParenthesis(str):
    count = 0
    for a in range(0, len(str)):
        if str[a] == "(":
            count += 1
    return count


# Check for potential use of the distributive property
def distributiveCheck(uIn):
    iList = []
    if "~(" in uIn:
        # find all occurrences of "~("
        for a in range(0, len(uIn) - 1):
            if uIn[a] + uIn[a + 1] == "~(":
                iList.append(a)

        # extract sections which require distribution
        sub = [""] * len(iList)
        for a in range(0, len(iList)):
            index = iList[a]
            rCount = 0
            while True:
                sub[a] += uIn[index]
                if uIn[index] == ")":
                    rCount += 1
                    if rCount == countLeftParenthesis(sub[a]):
                        break
                index += 1

        # Need to test for nested distribution cases
        new = sub[:]
        if len(iList) > 1:
            # Get indices of
            indices = []
            for a in range(len(sub) - 1, 0, -1):
                if sub[a] in sub[a - 1]:
                    indices.append(a)

            for a in range(0, len(indices)):
                new[indices[a] - 1] = new[indices[a] - 1].replace(sub[indices[a]], distributiveCheck(new[indices[a]]))

        # distribution for variables
        newSub = new[:]
        for a in range(0, len(newSub)):
            newSub[a] = newSub[a][2:][:-1]
            ev = extractVariables(newSub[a], 0)
            inv = invert(ev)
            for b in range(0, len(ev)):
                newSub[a] = newSub[a].replace(ev[b], inv[b])

        # distribution for operators
        for a in range(0, len(newSub)):
            for b in range(0, len(newSub[a])):
                if newSub[a][b] == "+":
                    newSub[a] = newSub[a][:b] + "*" + newSub[a][b + 1:]
                    b += 1
                if newSub[a][b] == "*":
                    newSub[a] = newSub[a][:b] + "+" + newSub[a][b + 1:]

        # Need to replace in original expression
        for a in range(0, len(sub)):
            uIn = uIn.replace(sub[a], newSub[a])
    return uIn


# Extracts expression side of an equation. Index 1 = Expression, Index 0 = Output variable
def extractExpression(equation):
    sides = re.split("[=]", equation)
    if "." or "+" or "~" in sides[0]:
        return [sides[1].strip(), sides[0].strip()]
    elif "." or "+" or "~" in sides[1]:
        return [sides[0].strip(), sides[1].strip()]
    else:
        print("Neither side of equation contains an operator. Exiting!")
        sys.exit()


# Extracts all variables from an expression
def extractVariables(expression, code):
    if code == 0:  # want to extract the variables from an expression
        varSet = sorted(set(re.findall(r'[~0-9a-z!]+', expression)))
    else:  # just want the literals
        varSet = sorted(set(re.findall(r'[0-9a-z!]+', expression)))
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
    return ["Ands: " + str(cAND), "Ors: " + str(cOR)]


# Checks user input function for potential issues
def checkFunction(inStr):
    # Ensure there is only a single = in the equation
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

    # Check that ^ is not in the input as it is used for output indicator later
    if "^" in inStr:
        print("Input cannot contain \'^\'")
        sys.exit()

    # Check that the function has balanced parenthesis
    if checkBalance(extractExpression(uIn)[1]) == "Unbalanced":
        print("Unbalanced parentheses in function. Fix and try again")
        sys.exit()


# Test length of command line args for server
def testArgLength():
    if len(sys.argv) != 2:
        print("Must use 1 command line argument for an equation, Exiting!")
        sys.exit()


# Main Method
if __name__ == '__main__':
    # Take user input from command line and check proper length
    testArgLength()
    uIn = str(sys.argv[1])
    # uIn = "~ab + cd * ~ef + ~gh = xyz"
    print("Input was: " + uIn)

    # Perform checks on the function, remove spaces, extract output and expression side of the equation,
    # and check for distribution
    checkFunction(uIn)
    uIn = uIn.replace(" ", "")
    outVar, ee = extractExpression(uIn)[0], extractExpression(uIn)[1]
    uIn = distributiveCheck(ee)

    if "(" in uIn:
        print("Gonna have to deal with in \"low to high\" structure")
    else:
        # Always split on or first and get and gate consistency functions on the list items if necessary
        orSplit = uIn.split('+')
        agcExp = []
        for a in range(0, len(orSplit)):
            if "*" in orSplit[a]:
                ev = extractVariables(orSplit[a], 0)
                agc = andGateConsistency(ev)
                agcExp.append(str(agc[1]))
                orSplit[a] = agc[0]

        # Build full expression which ands both and and or consistency functions together
        fullExp = ""
        ogc = orGateConsistency(orSplit)
        for a in range(0, len(agcExp)):
            fullExp += agcExp[a] + " * "
        fullExp += ogc[1]

        # Extract literals to be written to file. Ensure they are formatted so Devon's script can read
        ev = extractVariables(uIn, 1)
        literals = "\n"
        for a in range(0, len(ev)):
            if a != len(ev) - 1:
                literals += ev[a] + ", "
            else:
                literals += ev[a]

        # Open and write to file for Devon's script to read
        file = open("Tyler/fxn.txt", "w")
        outFunction = str(outVar) + " = " + fullExp
        file.write(outFunction)
        file.write(literals)
        file.close()

    # To-Do
    # Need to parse the expression and format so we can use the gate functions to create a POS
    # Want to parse low to high level and if not then ands first (precedence to whats in the parentheses)
