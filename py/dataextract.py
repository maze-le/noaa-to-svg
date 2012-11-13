#-*-encoding: utf-8

#LXML-Parser
from lxml import etree

#Datenmodell
from data import *

#Element-Tree-Dokument und Output
from etreeDoc import elementTreeDocument

class weathertoxml:
    # Dateispezifische Member
    etree = None
    infile = "CRNH0202-2011-AK_Barrow_4_ENE.txt"
    # Globale Var für Programmlgik
    isPreProcessed = False
    linectr = 0
    fixdata = None
    vardata = None
    
    def __init__(self):
        self.etree = elementTreeDocument()
        self.read()
    
    def preprocess(self, line):
        '''Fixe Daten verarbeiten'''
        wban = int(line[0:5])
        lon = float(line[41:48])
        lat = float(line[49:56])
        startdate_utc = line[6:14]
        starttime_utc = line[15:19]
        self.fixdata = fix_data(wban, lon, lat, startdate_utc, starttime_utc, '20120101', '0000')
            self.fixdata.startdate_utc, 
            self.fixdata.starttime_utc, 
            self.fixdata.wban, 
            self.fixdata.lon, 
            self.fixdata.lat)
        
        self.etree.addMetaData(self.fixdata)

        
    def processline(self, line):
        '''Variable Daten verarbeiten'''
        udat = line[6:14]
	utime = line[15:19]
	ldate = line[20:28]
	ltime = line[29:33]
	sversion = line[34:40]
        tcurr = float(line[57:64])
	tavg = float(line[65:72])
	tmax = float(line[73:80])
        tmin = float(line[81:88])
	precp = float(line[89:96])
        
        reldata = reliable_data(udat, utime, ldate, ltime, sversion, 
                 tcurr, tavg, tmin, tmax, precp)
        
        radAvg = float(line[97:103])
	radAvg_flag = int(line[104:105])
	radMax = float(line[106:112])
	radMax_flag = int(line[113:114])
	radMin = float(line[115:121])
	radMin_flag = int(line[122:123])
	stAvg = float(line[124:131])
	stAvg_flag = int(line[132:133])
	stMax = float(line[135:141])
	stMax_flag = int(line[142:143])
	stMin = float(line[144:151])
	stMin_flag = int(line[152:153])
	rhAvg = float(line[154:159])
	rhAvg_flag = int(line[160:161])
        
        errdata = erroneous_data(radAvg, radAvg_flag, radMin, radMin_flag, radMax, radMax_flag, stAvg, stAvg_flag, stMin, stMin_flag, stMax, stMax_flag, rhAvg, rhAvg_flag)
        
        self.etree.addDataRow(reldata, errdata, self.linectr)
        
    def read(self):
        if not self.isPreProcessed:
            with open(self.infile) as f:
                self.preprocess(f.readline())
                self.isPreProcessed=True
            self.read()
        else:
            with open(self.infile) as f:
                for line in f.readlines():
                    self.processline(line)
                    self.linectr = self.linectr+1

    def outputxml(self):
        self.etree.writeFile()

prog = weathertoxml()
prog.outputxml()
