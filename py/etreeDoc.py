from lxml import etree
from data import *

class elementTreeDocument:
    # Dokumentenspezifische Member
    outfile = "output.xml"
    root    = None
    station = None
    data    = None

    def __init__(self):
        self.root = etree.Element("weatherdata")
        self.station = etree.SubElement(self.root,"station")
        self.data = etree.SubElement(self.root,"data")

    def writeFile(self):
        with open(self.outfile,'w') as f:
            f.write('<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE weatherdata >\n' + etree.tostring(self.root, pretty_print=True))
            
    def addRelData(self, value, tagname, parent):
        item = etree.SubElement(parent,tagname)
        item.set("value", value)
        if(value == "-9999.0"): 
            item.set("error", "1")
        
        
    def addMetaData(self, fixdata):
        wban = etree.SubElement(self.station,"wban")
        wban.text = str(fixdata.wban)

        longitude = etree.SubElement(self.station,"longitude")
        longitude.text = str(fixdata.lon)

        latitude = etree.SubElement(self.station,"latitude")
        latitude.text = str(fixdata.lat)

        startdate_utc = etree.SubElement(self.station,"startdate_utc")
        startdate_utc.text = str(fixdata.startdate_utc)

        starttime_utc = etree.SubElement(self.station,"starttime_utc")
        starttime_utc.text = str(fixdata.starttime_utc)

        enddate_utc = etree.SubElement(self.station,"enddate_utc")
        enddate_utc.text = str(fixdata.enddate_utc)

        endtime_utc = etree.SubElement(self.station,"endtime_utc")
        endtime_utc.text = str(fixdata.endtime_utc)

    def addDataRow(self, reliableData, erroneousData, ctr):
        row = etree.SubElement(self.data,"row")
        row.set("localdate", reliableData.localdate)
        row.set("localtime", reliableData.localtime)
        row.set("id", "row-%s"%(int(ctr),))
        
        reldata = etree.SubElement(row,"directSensorData")
        errdata = etree.SubElement(row,"sensorArrayData")
        
        utc = etree.SubElement(row,"utc")
        utc.set("utctime", reliableData.utctime)
        utc.set("utcdate", reliableData.utcdate)
        
        sw = etree.SubElement(row,"sw")
        sw.set("version", reliableData.swversion)
        
        self.addRelData(str(reliableData.tempCurrent),"tempCurrent",reldata)
        self.addRelData(str(reliableData.tempAvg), "tempAvg",reldata)
        self.addRelData(str(reliableData.tempMin), "tempMin",reldata)
        self.addRelData(str(reliableData.tempMax), "tempMax",reldata)
        self.addRelData(str(reliableData.precp), "precipitation", reldata)
        
        solarRadAvg = etree.SubElement(errdata,"solarRadAvg")
        solarRadAvg.set("value", str(erroneousData.solarRadAvg.value))
        if(erroneousData.solarRadAvg.value == -9999.0): 
            solarRadAvg.set("error", "1")
        
        solarRadAvg.set("qcflag", str(erroneousData.solarRadAvg.qcflag))
        
        solarRadMax = etree.SubElement(errdata,"solarRadMax")
        solarRadMax.set("value", str(erroneousData.solarRadMax.value))
        if(erroneousData.solarRadMax.value == -9999.0): 
            solarRadMax.set("error", "1")
        
        solarRadMax.set("qcflag", str(erroneousData.solarRadMax.qcflag))
        
        solarRadMin = etree.SubElement(errdata,"solarRadMin")
        solarRadMin.set("value", str(erroneousData.solarRadMin.value))
        if(erroneousData.solarRadMin.value == -9999.0): 
            solarRadMin.set("error", "1")
        
        solarRadMin.set("qcflag", str(erroneousData.solarRadMin.qcflag))
        
        surfaceTempAvg = etree.SubElement(errdata,"surfaceTempAvg")
        surfaceTempAvg.set("value", str(erroneousData.surfaceTempAvg.value))
        if(erroneousData.surfaceTempAvg.value == -9999.0): 
            surfaceTempAvg.set("error", "1")
        
        surfaceTempAvg.set("qcflag", str(erroneousData.surfaceTempAvg.qcflag))
        
        surfaceTempMax = etree.SubElement(errdata,"surfaceTempMax")
        surfaceTempMax.set("value", str(erroneousData.surfaceTempMax.value))
        if(erroneousData.surfaceTempMax.value == -9999.0): 
            surfaceTempMax.set("error", "1")
        
        surfaceTempMax.set("qcflag", str(erroneousData.surfaceTempMax.qcflag))
        
        surfaceTempMin = etree.SubElement(errdata,"surfaceTempMin")
        surfaceTempMin.set("value", str(erroneousData.surfaceTempMin.value))
        if(erroneousData.surfaceTempMin.value == -9999.0): 
            surfaceTempMin.set("error", "1")
        
        surfaceTempMin.set("qcflag", str(erroneousData.surfaceTempMin.qcflag))
        
        rhAvg = etree.SubElement(errdata,"rhAvg")
        rhAvg.set("value", str(erroneousData.rhAvg.value))
        if(erroneousData.rhAvg.value == -9999.0): 
            rhAvg.set("error", "1")
        
        rhAvg.set("qcflag", str(erroneousData.rhAvg.qcflag))
        
        
        
    

