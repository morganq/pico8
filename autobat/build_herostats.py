import csv

with open("herostats.lua", "w") as wf:
    wf.write("herostats_str = [[\n")
    with open("herostats.csv") as f:
        reader = csv.DictReader(f)
        for row in reader:
            wf.write(",".join(row.values()) + "\n")
    wf.write("]]")
