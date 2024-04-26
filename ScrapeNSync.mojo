from python import Python as py
from Sync import Syncronizer
from ConfigLoader import ConfigLoader
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
            var IL = ILmod.Instaloader()
            #gets the profile
            var profile = ILmod.Profile.from_username(IL.context, self.username)
            self.bio = profile.biography
            
            var posts = profile.get_posts()
            for post in posts:
                if scrapedInt >= cfgldr.settings["MaxScraping"].__int__(): return
                scrapedInt += 1
                #IL.format_filename(post, "post")

                try: 
                    var postpipe = Post(description = post.caption, ori = "Instagram", accesbility_description = List[String](post.accesbility_description) )
                    sync.post(postpipe)
                except:
                    var postpipe = Post(description = post.caption, ori = "Instagram")
                    sync.post(postpipe)
                
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
        
        """try:
                if media[0] != None:
                    self.listlength = media.__len__()
        except: print("the init of the post failed at the media check")
        """
