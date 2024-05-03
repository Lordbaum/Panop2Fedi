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
    var httpallowed: Bool

    fn __init__(inout self, cfgldr: ConfigLoader, panopacc: String):
        var adismissing: Bool = True
        self.httpallowed = cfgldr.httpallowedS
        self.failed = False
        self.fedisoftwear = "" # inits the string
        self.account.__init__()
        self.apilibary.__init__()
        try:
            self.username = cfgldr.propVFed[panopacc] # takes the username
            self.instance = self.username.split("@")[1] # gets the instance from the username
            adismissing = False
            self.fedisoftwear = self.fedirecognize(self.instance)
            self.account = self.initfedisync(cfgldr.accestokens[self.username], self.instance, self.fedisoftwear, self.failed)
        except:
            try:
                print("init of syncronizer failed of "+ cfgldr.propVFed[panopacc] )
            except: print("init failed becaus of the configloader cfgldr.propVFed[panopacc]")
            if (adismissing): print("i did not found an @ symbol in your fedi name don't forget the pattern [fediacc]@[instance]")
            self.username = ""
            self.instance = ""
            self.failed = True




        
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
                    if self.httpallowed:
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
                    else: print("https connection failed trial for http skipped because it is not enabled")
            return
        except:
            print("the Python Libary to interact with " + self.fedisoftwear + " is not installed pleas make sure that all dependecies are installed")
            failed = True
        failed = True 
        return
    fn post(inout self, post: Post):
        if self.fedisoftwear == "mastodon":
            try:
                var description: String = post.description.strip()
                if description.__len__() >= 500: 
                    description = textshortener(description,500)
                #this secton takes the paths of the media and adds it to the mastodon post
                if (post.mediapath[1] != ""):
                    print("hi")
                    var ids = List[PythonObject]()
                    try:
                        
                        for mediacount in range(1, post.mediapath.__len__()):
                            print("media count:" + mediacount.__str__() + "\n medipath" + post.mediapath[mediacount] )
                            ids.append(self.account.media_post(post.mediapath[mediacount]))
                        if post.mediapath.__len__() > 2: 
                            print("sorry but at the moment Mojo dose not support list passing to python so we can only post one picture for the post")
                    except: print("ids failed")
                    print(ids.__len__())
                    print("will post with pictures")
                    var str = post.mediapath[1]
                    print("str: " + str)
                    var id = self.account.media_post(str)
                    print("description: " + description)
                    self.account.status_post(status= description, mediaid = id)
                    
                else: 
                    self.account.status_post(status= description)
            except: 
                print("posting to Mastodon failed and I don't know why")

                
    
    fn updateprofile(inout self, bio: String):
        if self.fedisoftwear == "mastodon":
            try:
                var changedacc = self.account.account_update_credentials(note= bio)
            except: print("failed to update masto Profile")
    
fn textshortener( str: String, maxlength: Int) -> String: 
        if str.__len__() >= maxlength:
            print("your text is mostlikely to long i will shorten it for you")
            var shortstr: String = ""
            var i: Int = 0
            #shortens the text to about 3 chars and than adds a ...
            var pointlen = maxlength - 3
            while shortstr.__len__() < pointlen:
                shortstr.__iadd__(str.__getitem__(i).__str__())
                i +=1
            shortstr.__iadd__("...")
            return shortstr
        return str