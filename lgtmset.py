import sys

query = sys.argv[1]
from plistlib import readPlist, writePlist

info = readPlist('info.plist')
info['variables']['num'] = query
writePlist(info, 'info.plist')
