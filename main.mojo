from python import Python as py
import ConfigLoader as CoLo
from Sync import Syncronizer
from ScrapeNSync import scraper

fn main () raises:
    var conf = CoLo.ConfigLoader()
    var scrapedInt: Int = 0
    for x in range(0, conf.acclist.size):
        var acc = conf.acclist[x]
        var sync = Syncronizer(conf, acc)
        if scrapedInt >= conf.settings["MaxScraping"].__int__(): 
            print("the Scrape limit is reached pleas wait a minute and start Panop2Fed again this is build in so that your accounts don't look to sus")
            return
        if sync.failed:
            print("sync start failed for " + conf.propVFed[acc] + "! skipping")
        else:
            print(acc + " to " + conf.propVFed[acc])
            var scrap = scraper(acc)
            scrap.scrape(sync, scrapedInt, conf)
            sync.updateprofile(scrap.bio)





    
