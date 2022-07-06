import csv
import sys

if sys.argv[1] == 'build':
    with open("herostats.lua", "w") as wf:
        wf.write("herostats_str = [[\n")
        with open("herostats.csv") as f:
            reader = csv.DictReader(f)
            for row in reader:
                wf.write(",".join(row.values()) + "\n")
        wf.write("]]")

if sys.argv[1] == 'balance':
    with open("herostats.csv") as f:
        reader = csv.DictReader(f)
        for row in reader:
            hp = int(row['max_health'])
            dps = float(row['damage']) * float(row['attack_speed'])
            upm = 30 / float(row['max_mana']) * 60
            print("%s: %dhp %.1fdps %.1fupm" % (row['name'].ljust(15), hp, dps, upm))
