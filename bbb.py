from hyperon import V
var_atom = V('x')
print(var_atom) # $x
print(var_atom.get_name()) # x
print(var_atom.get_metatype()) # AtomKind.VARIABLE
print(type(var_atom)) # VariableAtom