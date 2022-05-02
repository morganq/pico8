import sys

verts = []
faces = []
with open(sys.argv[1]) as f:
    for line in f.readlines():
        parts = line.split(" ")
        if parts[0] == "v":
            verts.append((float(parts[1]), float(parts[2]), float(parts[3])))

        if parts[0] == "f":
            faceverts = []
            for p in parts[1:]:
                if p.strip():
                    faceverts.append(int(p.split("/")[0]))
            if len(faceverts) == 3:
                faces.append(faceverts)
            elif len(faceverts) == 4:
                faces.append(faceverts[0:3])
                faces.append([faceverts[0], faceverts[2], faceverts[3]])
            elif len(faceverts) == 6:
                faces.append(faceverts[0:3])
                faces.append([faceverts[0], faceverts[2], faceverts[3]])
                faces.append([faceverts[0], faceverts[3], faceverts[4]])
                faces.append([faceverts[0], faceverts[4], faceverts[5]])
            else:
                print(len(faceverts))
                raise NotImplementedError()

print("/".join([",".join(["%.2f" % c for c in pt]) for pt in verts]))
print("/".join([",".join(["%d" % c for c in pt]) for pt in faces]))
