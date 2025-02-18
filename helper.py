import random
import string


def gen_random() -> str:
    return "$" + ''.join(random.choice(string.ascii_letters + string.digits) for _ in range(4))

