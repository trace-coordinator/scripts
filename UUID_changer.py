import os
import sys

def read_offset(metadata_path):
    offset, offset_s = 0, 0
    uuid = ""
    with open(metadata_path, "rb") as metadata:
        decoded_line = ""
        next(metadata)
        for line in metadata:
            try:
                decoded_line = line.decode("utf-8")
            except UnicodeDecodeError:
                continue
            if "\tuuid =" in decoded_line:
                #print(decoded_line)
                uuid = str(decoded_line[9:-3])
            if "\toffset_s =" in decoded_line:
                offset_s = int(decoded_line[11:-2])
                #continue
            if "\toffset =" in decoded_line:
                offset = int(decoded_line[9:-2])
                #continue
    return offset, offset_s, uuid
# if the s list has n characters, perms will generate n! lists
def perms(s):        
    if(len(s)==1): return [s]
    result=[]
    for i,v in enumerate(s):
        result += [v+p for p in perms(s[:i]+s[i+1:])]
    return result

def replace_offsets(metadata_path, uuid):
    contents = []    
    with open(metadata_path, "rb") as metadata:
        contents = metadata.readlines()
    decoded_line = ""
    prev_line = ""
    for i, line in enumerate(contents):
        try:
            prev_line = decoded_line
            decoded_line = line.decode("utf-8")
        except UnicodeDecodeError:
            continue
        if "\tuuid ="  in decoded_line and "\tname =" in prev_line:
            contents[i] = "\tuuid = {};\n".format(uuid).encode()
        #if "\tuuid ="  in decoded_line and "\tminor =" in prev_line:
        #     contents[i] = "\tuuid = {};\n".format(trace_UUID).encode()
        #if "\tproduct_uuid ="  in decoded_line:
        #     contents[i] = "\tproduct_uuid = {};\n".format(product_UUID).encode()

  

    with open(metadata_path, "wb") as metadata:
        metadata.write(b"".join(contents))

def detect_metadata_files(folder_path):
    metadata_paths = []
    for folder in os.scandir(folder_path):
        kernel_folder = os.path.join(folder.path, "kernel")
        if os.path.exists(os.path.join(folder.path, "kernel/metadata")):
            metadata_paths.append(os.path.join(folder.path, "kernel/metadata"))
    return metadata_paths

if __name__ == "__main__":
    if len(sys.argv) != 2:
        exit("1 argument required, {} given".format(len(sys.argv)))
    metadata_paths = detect_metadata_files(sys.argv[1])
    #print(metadata_paths)
    # Assumes only one clock offset for each trace

    #uuid = "713186bd-8d46-4a4a-89df-f6425d3a76b9"
    #Trace uuid = "84e2dd02-f77a-cc45-9f59-6da824c964cb"
    #Product uuid = "4c4c4544-0032-3110-804e-b6c04f583332"
    
    liste1 = perms("713186bd")
    liste2 = perms("8d46e9y")
    liste3 = perms("4a2kf0i")
    liste4 = perms("6h9p1so")
    liste5 = perms("f6425dh")

    liste6 = perms("84e2dd02")
    liste7 = perms("5f6s1m3")
    liste8 = perms("cu45w2x")
    liste9 = perms("9f52zq7")
    liste10 = perms("6da824")

    liste11 = perms("v7pm1j8d")
    liste12 = perms("1234abc")
    liste13 = perms("5678def")
    liste14 = perms("901ghij")
    liste15 = perms("b6c04f")
    # UUIDlist =[]
    # for i in range(10):
    #     champs2 = liste2[6*i]
    #     champs3 = liste3[6*i]
    #     champs4 = liste4[6*i]
    #     UUID = liste1[i]+"-"+champs2[0:4]+"-"+champs3[0:4]+"-"+champs4[0:4]+"-"+liste5[i]+liste5[i]
    #     print(UUID)
        #print(liste4)
    #print(UUIDlist)
    i=0
    for metadata_path in metadata_paths[1:]:
        champs2 = liste2[6*i]
        champs3 = liste3[6*i]
        champs4 = liste4[6*i]
        champs5 = liste5[i]

        champs7 = liste7[5*i]
        champs8 = liste8[5*i]
        champs9 = liste9[5*i]

        champs12 = liste12[5*i]
        champs13 = liste13[5*i]
        champs14 = liste14[5*i]

        UUID = "\""+liste1[i]+"-"+champs2[0:4]+"-"+champs3[0:4]+"-"+champs4[0:4]+"-"+champs5[0:6]+champs5[0:6]+"\""
        #trace_UUID = "\""+liste6[i]+"-"+champs7[0:4]+"-"+champs8[0:4]+"-"+champs9[0:4]+"-"+liste10[i]+liste10[i]+"\""
        #product_UUID = "\""+liste11[i]+"-"+champs12[0:4]+"-"+champs13[0:4]+"-"+champs14[0:4]+"-"+liste15[i]+liste15[i]+"\""


        replace_offsets(metadata_path, UUID)
        i = i+1
        #print(UUID)


        
