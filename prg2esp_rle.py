# Zero-only RLE compression for ESP32 C array
import os
import datetime

inputfile = "/home/bart/GitHub/ccgmsterm/build/ccgmsterm.prg"
outfolder = "/home/bart/Dropbox/C64 Chat/WiFi_Modem_CHAT64/C64_Chat_400"
outputfile = outfolder + "/prgfile_m.h"

print("-----------------------------------------------")
print("> input    :", inputfile)
print("> output   :", outputfile)
print("> bin size :", os.path.getsize(inputfile))

with open(inputfile, "rb") as f:
    data = f.read()

compressed = bytearray()
i = 0
while i < len(data):
    if data[i] == 0:
        # count zeros up to 255
        run_length = 1
        while i + run_length < len(data) and data[i + run_length] == 0 and run_length < 255:
            run_length += 1
        compressed.append(0)          # marker for zeros
        compressed.append(run_length) # number of zeros
        i += run_length
    else:
        compressed.append(data[i])
        i += 1

print(f"> compressed size: {len(compressed)} bytes ({len(compressed)/len(data)*100:.1f}%)")

# Build C-style array
strArray = f"// original size: {len(data)} bytes, compressed size: {len(compressed)} bytes\n"
strArray += f"// generated: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M')}\n"
strArray += "static const byte prgfile_m[] PROGMEM = {\n"

c = 0
for byte in compressed:
    strArray += f"0x{byte:02X},"
    c += 1
    if c > 15:
        c = 0
        strArray += "\n"

strArray = strArray.rstrip(',') + "\n};"

with open(outputfile, "w") as f:
    f.writelines(strArray)

print("> done!")
