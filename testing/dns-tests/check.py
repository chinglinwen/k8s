#!/usr/bin/python
import imp
try:
    imp.find_module('numpy')
    found = True
except ImportError:
    found = False
if not found:
  sys.exit(1)
