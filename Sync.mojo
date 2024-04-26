from ConfigLoader import ConfigLoader
from python import Python
from ScrapeNSync import Post
struct Syncronizer:
    var fedisoftwear: String
    var username: String
    var instance: String
    var account: PythonObject
    var apilibary: PythonObject
    var failed: Bool

    fn __init__(inout self, cfgldr: ConfigLoader, panopacc: String) raises: 
        self.username = cfgldr.propVFed[panopacc] # takes the username
        self.fedisoftwear = "" # inits the string
        self.account.__init__()
        self.instance = self.username.split("@")[1] # gets the instance from the username
        self.failed = False
        self.apilibary.__init__()
        self.fedisoftwear = self.fedirecognize(self.instance)
        self.account = self.initfedisync(cfgldr.accestokens[self.username], self.instance, self.fedisoftwear, self.failed)
        
    fn fedirecognize(self, instance: String) -> String:
        # later it will try to recognize the runnung softwear but for now only mastodon.py is suported
        return "mastodon"

    fn initfedisync(inout self, accestoken: String, instance: String, fedisoftwear: String, inout failed: Bool) -> PythonObject:
        try:
            var account: PythonObject
            self.apilibary = Python.import_module("mastodon")
            if fedisoftwear == "mastodon":
                
                try:
                    print("try to connect to https://" + instance + " with " + accestoken )
                    account = self.apilibary.Mastodon(access_token= accestoken, api_base_url=  "https://" + instance)
                    account.me() # checks if the connection is build
                    failed = False
                    print("succes")
                    return account
                except:
                    print("unable to connect to https trying http instead")
                    try:
                        account =  self.apilibary.Mastodon(access_token= accestoken, api_base_url= "http://" + instance)
                        account.me() # checks if the connection is build
                        failed = False
                        print("succes")
                        return account
                    except: 
                        print("unable to connect to " + instance) 
                        failed = True 
            return
        except:
            print("the Python Libary to interact with " + self.fedisoftwear + " is not installed pleas make sure that all dependecies are installed")
            failed = True
        failed = True 
        return
    fn post(inout self, post: Post):
        if self.fedisoftwear == "mastodon":
            try:  
                #self.account.media_post()
                self.account.status_post(status=post.description.strip())
            except: 
                var str: String = post.description.strip()
                if str.__len__() >= 500:
                    print("your text is mostlikely to long i will shorten it for you")
                    var shortstr: String = ""
                    var i: Int = 0
                    #shortens the text to 497 chars and than adds a ...
                    while shortstr.__len__() < 497:
                        shortstr.__iadd__(str.__getitem__(i).__str__())
                        i +=1
                    shortstr.__iadd__("...")
                    try:
                        self.account.status_post(status= shortstr)
                    except: print("posting to Mastodon failed and I don't know why")
                        
                else:
                    print("posting to Mastodon failed and I don't know why")

                
    
    fn updateprofile(inout self, bio: String):
        if self.fedisoftwear == "mastodon":
            try:
                var changedacc = self.account.account_update_credentials(note= bio)
            except: print("failed to update masto Profile")