import subprocess
import os
import glob
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


if os.path.isdir('./fixtures/'):
    filelist = glob.glob('./fixtures/*.json')
    for file in sorted(filelist):
        print(f"Installing fixure {file}")
        if subprocess.run(
                ['python', 'manage.py', 'loaddata', file]).returncode == 0:
            print(bcolors.OKGREEN+'Success loading fixture!\n'+bcolors.ENDC)
        else:
            print(bcolors.FAIL+'Error loading fixtures from file: ' + file + "\n" +bcolors.ENDC)
else:
    print('No fixtures folder found!')
