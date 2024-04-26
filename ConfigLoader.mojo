from collections import Dict
struct ConfigLoader:

    var accestokens: Dict[String, String]
    var propVFed: Dict[String, String]
    var settings: Dict[String, String]
    var acclist: List[String]
    
    fn __init__(inout self):
        self.accestokens.__init__() 
        self.propVFed.__init__()
        self.settings.__init__()
        self.acclist.__init__()
        self.fileToDict["propVFed.cfg"](self.propVFed, self.acclist)
        self.fileToDict["accestokens.cfg"](self.accestokens)
        self.fileToDict["settings.cfg"](self.settings)
        
    fn reload(inout self):
        self.fileToDict["propVFed.cfg"](self.propVFed, self.acclist)
        self.fileToDict["accestokens.cfg"](self.accestokens)
        self.fileToDict["settings.cfg"](self.settings)
    fn createFIles(self, Filepath: String):
        print("It seams like the file " + Filepath +"was changed or does not exsist, pleas re-create it since i am to stupid for that")


    fn fileToDict[filename: String](self, inout dict: Dict[String, String]):
        try:
            var facc = open(filename, "r")
            var faccr = facc.read()
            # the for func takes every line split it by the ":" and than puts the first half as key of the dict and the second as the value
            for x in range(0, faccr.split("\n").size):
                var s = faccr.split("\n")[x].split(":")
                dict[s[0]] = s[1]
            facc.close()
        except: 
            self.createFIles(filename)
    # overloaded function to create the list 
    fn fileToDict[filename: String](self, inout dict: Dict[String, String], inout acclist: List[String]):
        
        try:
            var facc = open(filename, "r")
            var faccr = facc.read()
            # the for func takes every line split it by the ":" and than puts the first half as key of the dict and the second as the value
            for x in range(0, faccr.split("\n").size):
                if faccr.split("\n")[x].__contains__("###"): pass
                else:
                    var s = faccr.split("\n")[x].split(":")
                    dict[s[0]] = s[1]
                    acclist.append(s[0])
            facc.close()
        except: 
            self.createFIles(filename)