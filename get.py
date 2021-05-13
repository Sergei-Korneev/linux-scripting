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


#def getFilename_fromCd(cd):

#Get filename from content-disposition
# print (cd)
# if not cd:
#    return None
# fname = re.findall('filename=(.+)', cd)
 
# if len(fname) == 0:
#    return None
# return fname[0]




def Download(url): 
# try:


   if not re.search("^.*\/\/.*\/.*[^/]+$", url):
      print ("\nWrong url format.\n")
      return 1 
  
   response = requests.get(url, stream=True)
   for x in ["Response: \n",response.headers,"\n"]: print (x)
   firstpos=url.rfind("/")
   lastpos=len(url)
   filename=url[firstpos+1:lastpos]

   
   #print (response.headers.get('content-disposition'))

   #filename = getFilename_fromCd(response.headers.get('content-disposition'))
   #filename = rfc6266.parse_requests_response(r).filename_unsafe
   
   with open(filename, "wb") as f:
        
    #total_length = response.headers.get('content-length')

    #if total_length is None: # no content length header
        #f.write(response.content)
    #else:
    dl = 0
        #total_length = int(total_length)
    for data in response.iter_content(chunk_size=4096):
            dl += 4096/(1024*1024)
            f.write(data)
            #done = int(50 * dl / total_length)
            sys.stdout.write("\r%d Mb " % dl + " " + filename )    
            sys.stdout.flush()

   print("\n\nSaved" ) 
 #except:
   #print ("Cannot download file." + url)


#Download("https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz")
#extract_arc("ffmpeg-git-amd64-static.tar.xz","/media/NTRCD/MYDOCS/Downloads")

#print (find_all("ffmpeg","/media/NTRCD/MYDOCS/Downloads" ))
#t=find_all("ffmpeg","/media/NTRCD/MYDOCS/Downloads" )
#shutil.move(t[0], "./ffmpeg")
