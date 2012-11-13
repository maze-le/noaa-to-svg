
class fix_data:
    wban = None
    lon = None
    lat = None
    startdate_utc = None
    starttime_utc = None
    enddate_utc = None
    endtime_utc = None
    
    def __init__(self, w, lo, la, sd, st, ed, et):
        self.wban = w
        self.lon = lo
        self.lat = la
        self.startdate_utc = sd
        self.starttime_utc = st
        self.enddate_utc = ed
        self.endtime_utc = et
        
    def set_enddate_utc(self, ed):
        self.enddate_utc = ed
        
    def set_endtime_utc(self, et):
        self.endtime_utc = et

class err_pair:
    value  = None
    qcflag = None
    
    def __init__(self, val, flag):
        self.value = val
        self.qcflag = flag
        
class erroneous_data:
    solarRadAvg = None
    solarRadMax = None
    solarRadMin = None
    surfaceTempAvg = None
    surfaceTempMax = None
    surfaceTempMin = None
    rhAvg = None

    def __init__(self,
                 radAvg, radAvg_flag,
                 radMin, radMin_flag,
                 radMax, radMax_flag,
                 stAvg, stAvg_flag,
                 stMin, stMin_flag,
                 stMax, stMax_flag,
                 rhAvg, rhAvg_flag):
        
        self.solarRadAvg = err_pair(radAvg, radAvg_flag)
        self.solarRadMax = err_pair(radMax, radMax_flag)
        self.solarRadMin = err_pair(radMin, radMin_flag)
        self.surfaceTempAvg = err_pair(stAvg, stAvg_flag)
        self.surfaceTempMax = err_pair(stMax, stMax_flag)
        self.surfaceTempMin = err_pair(stMin, stMin_flag)
        self.rhAvg = err_pair(rhAvg, rhAvg_flag)

class reliable_data:
    utcdate = None
    utctime = None
    localdate = None
    localtime = None
    swversion = None
    tempCurrent = None
    tempAvg = None
    tempMin = None
    tempMax = None
    precp   = None
    
    def __init__(self, udate, utime, ldate, ltime, sversion, 
                 tcurr, tavg, tmin, tmax, precp):
        self.utcdate = udate
        self.utctime = utime
        self.localdate = ldate
        self.localtime = ltime
        self.swversion = sversion
        self.tempCurrent = tcurr
        self.tempAvg = tavg
        self.tempMin = tmin
        self.tempMax = tmax
        self.precp   = precp
