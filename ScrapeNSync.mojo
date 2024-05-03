from python import Python as py
from Sync import Syncronizer
from ConfigLoader import ConfigLoader
from time import sleep
from pathlib import Path
from pathlib import cwd
struct scraper:
    var softwear: String
    var username: String
    var bio:      String
    fn __init__(inout self, acclist: String,):
        self.softwear = ""
        self.username = ""
        self.bio = ""
        try:
            var s: List[String] = acclist.split("@")
            self.username = s[0]
            self.softwear = s[1]
        except: 
            print("account name and Prop instance was not put in correctly maybe you forgot the @ between username and softwear")
            return
    fn scrape(inout self, inout sync: Syncronizer, inout scrapedInt: Int, cfgldr: ConfigLoader):
        if self.softwear == "instagram":
            self.scrapeinsta(scrapedInt, cfgldr, sync)
            return
        

    

    fn  scrapeinsta(inout self, inout scrapedInt: Int, cfgldr: ConfigLoader, inout sync: Syncronizer):
       
        try:
            #loads Instaloader
            var ILmod = py.import_module("instaloader")
            var IL = ILmod.Instaloader(quiet = True, save_metadata = False, compress_json = False)
            #gets the profile
            var profile = ILmod.Profile.from_username(IL.context, self.username)
            self.bio = profile.biography
            
            var posts = profile.get_posts()
            for post in posts:
                if scrapedInt >= cfgldr.MaxScrapingS: return
                scrapedInt += 1
                IL.format_filename(post, "post")
                sleep(random.random_float64(0.05, 0.2))
                try: 
                    IL.download_post(post, self.username)
                    var mediapaths: List[String] = List[String]("")
                    var paths: List[Path] = cwd().joinpath(self.username).listdir()
                    var description: String = ""
                    for x in range(0,paths.__len__()):
                        var path: Path = paths[x]
                        var suffix = path.suffix()
                        print(path)
                        if suffix == ".txt": pass
                            #description = path.read_text()
                            #print("nicht zu dumm zum lesen")
                        if suffix == ".jpg": 
                            mediapaths.append("./" + self.username + "/" + path.__str__())
                            print("mediapath appended: " + mediapaths[x])
                    print(description)
                    if description == "": description = post.caption
                    var postpipe = Post(description = description, ori = "Instagram", mediapath = mediapaths)
                    sync.post(postpipe)
                except:
                    print("an exception occord while creating the post")
                    #var postpipe = Post(description = post.caption, ori = "Instagram")
                    #sync.post(postpipe)
                
        except: print ("failed to scrape instaaccount of " + self.username)
        
        
        

@value
struct Post:
    var description: String
    #var media: List[PythonObject]
    var accesbility_description: List[String]
    var mimetypes: List[String]
    var mediapath: List[String]
    var listlength: Int
    var ori: String

    fn __init__(inout self, ori: String, description: String, mediapath: List[String] = List[String]("", "") ,titel: String = "",  accesbility_description: List[String] = List[String]("", ""),
                 mimetypes: List[String] = List[String]("", "")):
        self.description = description
        #self.media =  media
        self.accesbility_description = accesbility_description
        self.mimetypes = mimetypes
        self.mediapath = mediapath
        self.ori = ori
        self.listlength = 0
