#Get and unpack module
#Sergei Korneev 2020


import shutil, os, requests, re, sys




def find_all(name, path):
     result = []
     for root, dirs, files in os.walk(path):
         if name in files:
             result.append(os.path.join(root, name))
     return result



def extract_arc(file,extract_dir): 
 try:
  if re.search("^.*[zip|gz|7z|rar|tar|tar.gz|xz]$",file):
            shutil.unpack_archive(file, extract_dir)
            return 0

 except:
     print ("Cannot extract file " + file)



def Download(url): 
 try:


   if not re.search("^.*\/\/.*\/.*[^/]+$", url):
      print ("\nWrong url format.\n")
      return 1 
  
   response = requests.get(url, stream=True)
   for x in ["Response: \n",response.headers,"\n"]: print (x)
   firstpos=url.rfind("/")
   lastpos=len(url)
   filename=url[firstpos+1:lastpos]

   with open(filename, "wb") as f:
        
 
    dl = 0

    for data in response.iter_content(chunk_size=4096):
            dl += 4096/(1024*1024)
            f.write(data)
            sys.stdout.write("\r%d Mb " % dl + " " + filename )    
            sys.stdout.flush()

   print("\n\nSaved" ) 
 except:
   print ("Cannot download file." + url)

