import xml.etree.ElementTree as ET
 
from xml.dom.minidom import *

def prettyfy(etNode):
    reparse = parse(ET.tostring(etNode))
    return reparse.toprettyxml()
