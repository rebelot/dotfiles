#!/usr/bin/env python3
from subprocess import check_output, DEVNULL
from os.path import expanduser

def getpass(acct):
    return check_output(f"gpg -dq {expanduser('~')}/.config/neomutt/accounts/{acct}_pass.gpg".split(), stderr=DEVNULL).strip().decode()
