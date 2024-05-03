from collections import Dict
from pathlib import Path


struct ConfigLoader:
    var accestokens: Dict[String, String]
    var propVFed: Dict[String, String]
    # var panopPwd: Dict[String, String]
    #var settings: Dict[String, String]
    var acclist: List[String]
    
    var MaxScrapingS: Int
    var httpallowedS: Bool
    fn __init__(inout self):
        self.accestokens.__init__()
        self.propVFed.__init__()
        self.acclist.__init__()
        self.MaxScrapingS = 30
        self.httpallowedS = False
        self.file2DictNList["propVFed.cfg"](
            self.propVFed, self.accestokens, self.acclist
        )
        var settingspath: Path = "settings.cfg"
        if(settingspath.exists()):
            
                var settings = Dict[String,String]()
                self.fileToDict["settings.cfg"](settings)
                try:
                    self.MaxScrapingS = settings["MaxScraping"].__int__()
                except: print("MaxScraping unreadable using default: 30")
                try:
                    self.httpallowedS = settings["httpallowed"] == "true"
                except: print("httpallowed unreadable using default: false")
        else:
                self.createFIles("settings.cfg")
                print("settings file not found or unreadable")



    fn reload(inout self):
        self.file2DictNList["propVFed.cfg"](
            self.propVFed, self.accestokens, self.acclist
        )
        self.fileToDict["accestokens.cfg"](self.accestokens)
        var settings = Dict[String,String]()
        self.fileToDict["settings.cfg"](settings)

    fn createFIles(self, Filepath: String):
        print(
            "It seams like the file "
            + Filepath
            + "was changed or does not exsist, pleas re-create it since i am to stupid"
            " for that"
        )

    fn fileToDict[filename: String](self, inout dict: Dict[String, String]):
        try:
            var facc = open(filename, "r")
            var faccr = facc.read()
            # the for func takes every line split it by the ":" and than puts the first half as key of the dict and the second as the value
            for x in range(0, faccr.split("\n").size):
                if faccr.split("\n")[x].__contains__("###"):
                    pass
                else:
                    var s = faccr.split("\n")[x].split(":")
                    dict[s[0]] = s[1]
            facc.close()
        except:
            self.createFIles(filename)

    # overloaded function to create the list
    fn file2DictNList[
        filename: String
    ](
        self,
        inout dict: Dict[String, String],
        inout dict2: Dict[String, String],
        inout acclist: List[String],
    ):
        try:
            var facc = open(filename, "r")
            var faccr = facc.read()
            # the for func takes every line split it by the ":" and than puts the first half as key of the dict and the second as the value
            for x in range(0, faccr.split("\n").size):
                if faccr.split("\n")[x].__contains__("###"):
                    pass
                else:
                    var s = faccr.split("\n")[x].split(":")
                    var p1 = s[0].split("%P%")
                    var p2 = s[1].split("%P%")
                    dict[p1[0]] = p2[0]
                    dict2[p2[0]] = p2[1]
                    acclist.append(s[0])
            facc.close()
        except:
            self.createFIles(filename)


