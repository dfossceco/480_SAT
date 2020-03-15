#!/usr/bin/env python3
import pyeda
from pyeda.inter import *

x, y, z = map(bddvar, 'xyz')
f = (~x&~y&~z)|(~x&~y&z)|(x&~y&~z)|(x&~y&z)|(x&y&z)

print("\n")
print(list(f.satisfy_all()))
print("\n")
