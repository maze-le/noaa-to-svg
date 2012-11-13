PYTHON = python
PYTHON_DIR = ./py
JAVA = java -jar
SAXON = ~/saxon/saxon9he.jar
XML = data.xml
DTD = weatherdata.dtd
NULL = /dev/null

OUTPUT = svg
OUTPUT_DIR = ./output
OUTPUT_EXT = .svg

conv:
	$(PYTHON) $(PYTHON_DIR)/dataextract.py;\
	cp $(PYTHON_DIR)/output.xml ./$(XML)
val:
	xmllint $(XML) -dtdvalid $(DTD) > $(NULL)
html:
	$(JAVA) $(SAXON) $(XML) ./xslt/html.xsl > $(OUTPUT_DIR)/overview.xhtml
svg:	
	$(JAVA) $(SAXON) $(XML) ./xslt/svg.xslt $(XSLT_OPTIONS) parameter=$(PARAM) mon=$(MON) mode=$(MODE) > $(OUTPUT_DIR)/$(OUTPUT)_$(PARAM)_$$i$(OUTPUT_EXT)
svg_all:
	for i in {01,02,03,04,05,06,07,08,09,10,11,12};\
	do \
		mkdir $(OUTPUT_DIR)/$$i;\
		$(JAVA) $(SAXON) $(XML) ./xslt/svg.xslt  mode=airtemp parameter=tempAvg mon=$$i > $(OUTPUT_DIR)/$$i/$(OUTPUT)_tempAvg_$$i$(OUTPUT_EXT);\
		$(JAVA) $(SAXON) $(XML) ./xslt/svg.xslt  mode=solar parameter=solarRadAvg mon=$$i > $(OUTPUT_DIR)/$$i/$(OUTPUT)_solarRadAvg_$$i$(OUTPUT_EXT);\
		$(JAVA) $(SAXON) $(XML) ./xslt/svg.xslt mode=rh parameter=rhAvg mon=$$i > $(OUTPUT_DIR)/$$i/$(OUTPUT)_rhAvg_$$i$(OUTPUT_EXT);\
		$(JAVA) $(SAXON) $(XML) ./xslt/svg.xslt mode=surfacetemp parameter=surfaceTempAvg mon=$$i > $(OUTPUT_DIR)/$$i/$(OUTPUT)_surfaceTempAvg_$$i$(OUTPUT_EXT);\
		$(JAVA) $(SAXON) $(XML) ./xslt/svg.xslt mode=prec parameter=precipitation mon=$$i > $(OUTPUT_DIR)/$$i/$(OUTPUT)_precipitation_$$i$(OUTPUT_EXT);\
	done
clean:
	for i in {01,02,03,04,05,06,07,08,09,10,11,12};\
	do \
		rm -rf $(OUTPUT_DIR)/$$i;\
	done




