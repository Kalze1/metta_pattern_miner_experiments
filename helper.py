from hyperon import *
import random
import string


def gen_random() :
    random_string = ''.join(random.choices(string.ascii_uppercase, k=3))
    random_var = V(random_string)
    return random_var



