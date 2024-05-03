from python import Python as py
from time import sleep
import random
import ConfigLoader as CoLo
from Sync import Syncronizer
from ScrapeNSync import scraper


fn main():
    var conf = CoLo.ConfigLoader()
    var scrapedInt: Int = 0
    var currentAccount: String
    for x in range(0, conf.acclist.size):
        var acc = conf.acclist[x]
        # creates the syncronizer
        var sync = Syncronizer(conf, acc)
        try:
            currentAccount = conf.propVFed[acc]
        except:
            currentAccount = (
                "Unkown (the configloader mostliekly is not working)"
            )
        if scrapedInt >= conf.MaxScrapingS:
            print(
                "the Scrape limit is reached pleas wait a minute and start the"
                " Panop2Fed-Bridge again this is build in so that your accounts"
                " don't look to sus \n your current scrape limit is set to: "
                + conf.MaxScrapingS.__str__()
            )
            return
        if sync.failed:
            print("sync start failed for " + currentAccount + "! skipping")
        else:
            print(acc + " to " + currentAccount)
            # creates the scraper
            sleep(random.random_float64(0.2, 1.5))
            var scrap = scraper(acc)
            scrap.scrape(sync, scrapedInt, conf)
            sync.updateprofile(scrap.bio)
