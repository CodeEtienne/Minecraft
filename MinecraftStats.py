#!/usr/bin/python3

__author__ = "Etienne Jannin"
__copyright__ = "Copyright 2020, Etienne Jannin"
__credits__ = ["Etienne Jannin"]
__license__ = "GNU GPL v3"
__version__ = "0.1"
__maintainer__ = "Etienne Jannin"
__email__ = "etienne@lordinateur.net"


import json # Standard library json module to interact with the json file easily
import os # Used to list the json files
import pprint # Mostly for debugging. Allows to print data structures in a human readable format
import requests # Used for HTTP requests


# Sets up Pretty Printer for debugging
pp = pprint.PrettyPrinter(indent=4)


# 1 - Set up the variables we will be working with

# Directory where the minecraft stat files are stored
statDir = '/home/pi/minecraft/world/stats'

# List of the values we want to get from the file.
# For all the values of one category, use ['*']
#keys = {
#        'custom': ['deaths', 'animals_bred'],
#        'mined': ['diamond_ore'],
#        'picked_up': ['diamond'],
#        'killed_by': ['*']
#        }

keys = {
        'custom': ['*'],
        'mined': ['*'],
        'picked_up': ['*'],
        'killed_by': ['*']
        }

# This is the dictionary in which we will sort 
# the data to generate the csv file
stats = {}

# Generates a list of all trhe files contained in a directory
def files(path):
    for file in os.listdir(path):
        if os.path.isfile(os.path.join(path, file)):
            yield file


# 2 - Let's extract the data from our json files

for file in files(statDir):

    # Let's get the player uuid from the file name
    player_uuid = file.split('.')[0]

    # Calling the remote api and getting the response
    response = requests.get("https://playerdb.co/api/player/minecraft/" + player_uuid)
    player = json.loads(response.content)

    # if we don't find the player name, let's keep the uuid
    if player['code'] == 'player.found':
        player_username = player['data']['player']['username']
    else:
        player_username = player_uuid

    # Now reading the json file
    with open(statDir + '/' + file) as json_file:
        
        data = json.load(json_file)
        
        stats[player_username] = {}
        
        # This is where the magic happens
        for key in keys:
            datakey = 'minecraft:' + key
            
            if datakey in data['stats']:
                for subkey in keys[key]:
                    datasubkey = 'minecraft:' + subkey

                    # Accounting for the wild card                    
                    if len(keys[key]) == 1 and keys[key] == ['*']:                        
                        for datasubkey in data['stats'][datakey]:
                            stats[player_username][key + ":" + datasubkey.split(':')[1]] = data['stats'][datakey][datasubkey]
                    
                    # if not a wild card, then simply store the value we're interested in
                    else:                        
                        if datasubkey in data['stats'][datakey]:
                            stats[player_username][key + ":" + subkey] = data['stats'][datakey][datasubkey]

# for debugging purpose, we can check the content of our nested dict
# pp.pprint(stats)


# 3 - Generating the csv file

stat_names = []
players = sorted(stats.keys())

# Gets a list of player names
for player in stats:
    for row in stats[player]:
        stat_names.append(row)

# Gets a list of stat names
stat_names = sorted(list(set(stat_names)))

# onto the csv file

# Here we generate the header
csv = ''

for player in players:
    csv += ', ' + player

csv += '\n'

# And now the main content of the file
for value in stat_names:
    csv += value
    for player in players:
        if value in stats[player]:
            csv += ', ' + str(stats[player][value])
        else:
            csv += ', '
    csv += '\n'

# And we print our result on the standard output
print(csv)

