<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:svg="http://www.w3.org/2000/svg">

  <!-- externe parameter: muessen beim aufruf mit angegeben werden
    parameter: Elementname von aufgenommenen Datenwert in XML z.B. (tempMin, solarRadAvg, etc.)
    mon: aktueller Monat
    mode: Zeichenmodus
  -->
  <xsl:param name="parameter"/>
  <xsl:template match="//row">
    <xsl:apply-templates>
      <xsl:with-param name="parameter"/>
    </xsl:apply-templates>    
  </xsl:template>

  <xsl:param name="mon"/>
  <xsl:variable name="month" select="$mon"/>

  <xsl:param name="mode"/>
  <xsl:variable name="modus" select="$mode"/>

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  
  <!-- globale variablen: immer fuer alle modi gleich -->
  <xsl:variable name="outXmin" select="0.00000"/>
  <xsl:variable name="outYmin" select="0.00000"/>
  <xsl:variable name="outXmax" select="700.00000"/>
  <xsl:variable name="outYmax" select="256.00000"/>    
  <xsl:variable name="inXmin" select="50.00000"/>
  <xsl:variable name="inYmin" select="12.00000"/>
  <xsl:variable name="inXmax" select="685.00000"/>
  <xsl:variable name="inYmax" select="246.00000"/>
  <xsl:variable name="color_dashlines" select="'7c7c7c'"/>
  <xsl:variable name="color_outerbox" select="'fafaff'"/>
  <xsl:variable name="color_innerbox" select="'eaeafc'"/>
  <xsl:variable name="color_axislegend" select="'000000'"/>
  <xsl:variable name="year" select="2011"/>
  <xsl:variable name="month_str" select="concat($year,$month)"/>
   
  <xsl:template match="/">
    

    <!-- vom modus anbaengige variablen -->
    <xsl:variable name="pathcolor"><!-- Farbe des Kurven-pfades -->
      <xsl:choose>
	<xsl:when test="$modus = 'airtemp'">0a0afc</xsl:when>
	<xsl:when test="$modus = 'surfacetemp'">0afc0a</xsl:when>
	<xsl:when test="$modus = 'solar'">fc7c0a</xsl:when>
	<xsl:when test="$modus = 'rh'">fc2c2a</xsl:when>
	<xsl:when test="$modus = 'prec'">ff7777</xsl:when>
	<xsl:otherwise>000000</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="base_zero"><!-- 0-durchgang der y-achse -->
      <xsl:choose>
	<xsl:when test="$modus = 'airtemp'">64.0</xsl:when>
	<xsl:when test="$modus = 'surfacetemp'">64.0</xsl:when>
	<xsl:when test="$modus = 'solar'">246.0</xsl:when>
	<xsl:when test="$modus = 'rh'">246.0</xsl:when>
	<xsl:when test="$modus = 'prec'">246.0</xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="xscale"><!-- skalierung der x-achse -->
      <xsl:choose>
	<xsl:when test="$modus = 'airtemp'">10.0</xsl:when>
	<xsl:when test="$modus = 'surfacetemp'">10.0</xsl:when>
	<xsl:when test="$modus = 'solar'">20.0</xsl:when>
	<xsl:when test="$modus = 'rh'">20.0</xsl:when>
	<xsl:when test="$modus = 'prec'">20.0</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="xmag"><!-- labelintervall der x-achse -->
      <xsl:choose>
	<xsl:when test="$modus = 'airtemp'">4.0</xsl:when>
	<xsl:when test="$modus = 'surfacetemp'">4.0</xsl:when>
	<xsl:when test="$modus = 'solar'">2.0</xsl:when>
	<xsl:when test="$modus = 'rh'">2.0</xsl:when>
	<xsl:when test="$modus = 'prec'">2.0</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="yscale"><!-- skalierung der y-achse -->
      <xsl:choose>
	<xsl:when test="$modus = 'airtemp'">4.0</xsl:when>
	<xsl:when test="$modus = 'surfacetemp'">4.0</xsl:when>
	<xsl:when test="$modus = 'solar'">0.5</xsl:when>
	<xsl:when test="$modus = 'rh'">2.2</xsl:when>
	<xsl:when test="$modus = 'prec'">10.0</xsl:when>
	<xsl:otherwise>4.0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="ymag"><!-- labelintervall der y-achse -->
      <xsl:choose>
	<xsl:when test="$modus = 'airtemp'">10.0</xsl:when>
	<xsl:when test="$modus = 'surfacetemp'">10.0</xsl:when>
	<xsl:when test="$modus = 'solar'">80.0</xsl:when>
	<xsl:when test="$modus = 'rh'">20.0</xsl:when>
	<xsl:when test="$modus = 'prec'">4.0</xsl:when>
	<xsl:otherwise>10.0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    

    <svg
	xmlns="http://www.w3.org/2000/svg"
	id="barrowsvg0.1"
	version="1.1"
	width="700"
	height="256">
      <defs
	  id="defines_barrowsvg0.1"/>
      
      <!-- koordinatensystem : Fuer alle modi gleich-->
      <svg:path
	  style="fill:#{$color_outerbox};"
	  d="M {$outXmin}.0,{$outYmin}.0 L {$outXmax}.0,{$outYmin}.0 {$outXmax}.0,{$outYmax}.0 {$outXmin}.0,{$outYmax}.0 Z"
	  id="bg"/>
      <svg:path
	  style="fill:#{$color_innerbox};"
	  d="M {$inXmin},{$inYmin} L {$inXmax},{$inYmin} {$inXmax},{$inYmax} {$inXmin},{$inYmax} Z"
	  id="bg2"/>
      <svg:path
	  style="fill:#0d0d0d;stroke:#0d0d0d;"
	  d="M {$inXmin},{$base_zero} L {$inXmin},{$inYmin}"
	  id="coordypos"/>
      <svg:path
	  style="fill:#0d0d0d;stroke:#0d0d0d;"
	  d="M {$inXmin},{$inYmin - 5.0} L {$inXmin + 5.0},{$inYmin + 2.0} {$inXmin},{$inYmin} {$inXmin - 5.0},{$inYmin + 2.0} Z"
	  id="arrowypos"/>
      <svg:path
	  style="fill:#0d0d0d;stroke:#0d0d0d;"
	  d="M {$inXmin},{$base_zero} L {$inXmin},{$inYmax}"
	  id="coordyneg"/>
      <svg:path
	  style="fill:#0d0d0d;stroke:#0d0d0d;"
	  d="M {$inXmin},{$inYmax - 5.0} L {$inXmin + 5.0},{$inYmax + 2.0} {$inXmin},{$inYmax} {$inXmin - 5.0},{$inYmax + 2.0} Z"
	  transform="rotate(180 {$inXmin} {$inYmax})"
	  id="arrowyneg"/>
      <svg:path
	  style="fill:#0d0d0d;stroke:#0d0d0d;"
	  d="M {$inXmin},{$base_zero} L {$inXmax},{$base_zero}"
	  id="coordxpos"/>
      <svg:path
	  style="fill:#0d0d0d;stroke:#0d0d0d;"
	  d="M {$inXmax},{$base_zero - 5.0} L {$inXmax + 5.0},{$base_zero + 2.0} {$inXmax},{$base_zero} {$inXmax - 5.0},{$base_zero + 2.0} Z"
	  transform="rotate(90 {$inXmax},{$base_zero})"
	  id="arrowxpos"/>
      
      <!-- X-Achse - Legende : Fuer alle modi gleich  -->
      <xsl:for-each select="for $m in (0 to 14) return $m">
	<xsl:variable name="pos" select="position()" />
	<svg:text style="font-size:8pt;font-face: monospace, Courier;font-color:#{$color_axislegend};" x="{$inXmin + $pos * $xmag *$xscale - 13.0}" y="{$inYmax + 10.0}"><xsl:value-of select="$pos * 2 + 1" />.<xsl:value-of select="$month" />.</svg:text>
	<svg:path style="stroke-width: 0.5; stroke:#{$color_dashlines}; stroke-dasharray:3.2;" 
		  d="M {$inXmin + $pos * $xmag * $xscale},{$inYmax} L {$inXmin + $pos * $xmag * $xscale},{$inYmin}"/>
      </xsl:for-each>      

      <!-- Y-Achse - Legende : Abhaengig von Modus -->
      <xsl:choose>
	
	<!-- Y-Achse: Temperaturmodus -->
	<xsl:when test="($modus = 'airtemp') or ($modus = 'surfacetemp')">
	  <svg:text style="font-size:8pt;font-face: monospace, Courier;font-color:#{$color_axislegend};" x="5" y="{$base_zero}">  0°C</svg:text>
	  <svg:path style="stroke-width: 0.5; stroke:#{$color_dashlines}; stroke-dasharray:3.2;" 
		    d="M {$inXmin - 5.0},{$base_zero} L {$inXmax},{$base_zero}"/>
	  <xsl:for-each select="for $n in (0 to 3) return $n">
	    <xsl:variable name="pos" select="position()" />
	    <xsl:variable name="tstr" select="$pos * $ymag" />
	    <svg:text style="font-size:8pt;font-face: monospace, Courier;font-color:#{$color_axislegend};" x="5" y="{$base_zero + $yscale * $pos * $ymag}">-<xsl:value-of select="$tstr" />°C</svg:text>
	    <svg:path style="stroke-width: 0.5; stroke:#{$color_dashlines}; stroke-dasharray:3.2;" 
		      d="M {$inXmin - 5.0},{$base_zero + $yscale * $pos * $ymag} L {$inXmax},{$base_zero + $yscale * $pos * $ymag}"/>
	  </xsl:for-each>
	  <svg:text style="font-size:8pt;font-face: monospace, Courier;font-color:#{$color_axislegend};" x="5" y="{$base_zero - $yscale * $ymag}">+10°C</svg:text>
	  <svg:path style="stroke-width: 0.5; stroke:#{$color_dashlines}; stroke-dasharray:3.2;" 
		    d="M {$inXmin - 5.0},{$base_zero - $yscale * $ymag} L {$inXmax},{$base_zero - $yscale * $ymag}"/>
	</xsl:when>
	
	
	<!-- Y-Achse: Sonneneinstrahlungs-Modus -->
	<xsl:when test="$modus = 'solar'">
	  <svg:text style="font-size:8pt;font-face: monospace, Courier;font-color:#{$color_axislegend};" x="5" y="{$base_zero}">0 W/m<svg:tspan style="margin-top:.25em;font-size: .85em;baseline-shift: super;">2</svg:tspan></svg:text>
	  <svg:path style="stroke-width: 0.5; stroke:#{$color_dashlines}; stroke-dasharray:3.2;" 
		    d="M {$inXmin - 5.0},{$base_zero} L {$inXmax},{$base_zero}"/>
	  <xsl:for-each select="for $n in (0 to 4) return $n">
	    <xsl:variable name="pos" select="position()" />
	    <xsl:variable name="tstr" select="$pos * $ymag" />
	    <svg:text style="font-size:7.5pt;font-face: monospace, Courier;font-color:#{$color_axislegend};" x="5" y="{$base_zero - $yscale * $pos * $ymag}"><xsl:value-of select="$tstr" />W/m<svg:tspan style="font-size: .75em;baseline-shift: super;">2</svg:tspan></svg:text>
	    <svg:path style="stroke-width: 0.5; stroke:#{$color_dashlines}; stroke-dasharray:3.2;" 
		      d="M {$inXmin - 5.0},{$base_zero - $yscale * $pos * $ymag} L {$inXmax},{$base_zero - $yscale * $pos * $ymag}"/>
	  </xsl:for-each>	  
	</xsl:when>
	
	
	<!-- Y-Achse: Relatve Luftfeuchtigkeit-Modus -->
	<xsl:when test="$modus = 'rh'">
	  <svg:text style="font-size:8pt;font-face: monospace, Courier;font-color:#{$color_axislegend};" x="5" y="{$base_zero}">0 %</svg:text>
	  <svg:path style="stroke-width: 0.5; stroke:#{$color_dashlines}; stroke-dasharray:3.2;" 
		    d="M {$inXmin - 5.0},{$base_zero} L {$inXmax},{$base_zero}"/>
	  <xsl:for-each select="for $n in (0 to 4) return $n">
	    <xsl:variable name="pos" select="position()" />
	    <xsl:variable name="tstr" select="$pos * $ymag" />
	    <svg:text style="font-size:7.5pt;font-face: monospace, Courier;font-color:#{$color_axislegend};" x="5" y="{$base_zero - $yscale * $pos * $ymag}"><xsl:value-of select="$tstr" /> %</svg:text>
	    <svg:path style="stroke-width: 0.5; stroke:#{$color_dashlines}; stroke-dasharray:3.2;"
		      d="M {$inXmin - 5.0},{$base_zero - $yscale * $pos * $ymag} L {$inXmax},{$base_zero - $yscale * $pos * $ymag}"/>
	  </xsl:for-each>
	</xsl:when>
	
	
	<!-- Y-Achse: Niederschlags-Modus -->
	<xsl:when test="$modus = 'prec'">
	  <svg:text style="font-size:8pt;font-face: monospace, Courier;font-color:#{$color_axislegend};" x="5" y="{$base_zero}">0 mm</svg:text>
	  <svg:path style="stroke-width: 0.5; stroke:#{$color_dashlines}; stroke-dasharray:3.2;" 
		    d="M {$inXmin - 5.0},{$base_zero} L {$inXmax},{$base_zero}"/>
	  <xsl:for-each select="for $n in (0 to 4) return $n">
	    <xsl:variable name="pos" select="position()" />
	    <xsl:variable name="tstr" select="$pos * $ymag" />
	    <svg:text style="font-size:7.5pt;font-face: monospace, Courier;font-color:#{$color_axislegend};" x="5" y="{$base_zero - $yscale * $pos * $ymag}"><xsl:value-of select="$tstr" /> mm</svg:text>
	    <svg:path style="stroke-width: 0.5; stroke:#{$color_dashlines}; stroke-dasharray:3.2;"
		      d="M {$inXmin - 5.0},{$base_zero - $yscale * $pos * $ymag} L {$inXmax},{$base_zero - $yscale * $pos * $ymag}"/>
	  </xsl:for-each>
	</xsl:when>
      </xsl:choose>
      

      <!-- output der Rechtecke fuer Fehlerhafte Datenbereiche
	    - fuer alle Modi gleich
            - Abtastung im 12-h Takt
            - Wenn ein Fehlerwert in einer 12h-Periode auftaucht, wird dieser Bereich markiert-->
      <xsl:for-each select="//row[(@localtime = 0000 or @localtime = 1200) and starts-with(@localdate, $month_str)]">
	<xsl:variable name="max" select="12"/>
	<xsl:variable name="counter" select="position() - 1"/>
	<xsl:if test="sum(for $n in (0 to $max) 
		      return 
		      if (preceding-sibling::*[$n]//*[name() = $parameter]/@error or (preceding-sibling::*[$n]//*[name() = $parameter]/@qcflag &gt; 2))
		      then 1.0
		      else 0.0) &gt; 0.0">
	  <svg:rect x="{$inXmin + $xscale * ($counter - 1)}"
		    y="{$inYmin}"
		    width="{$xscale}"
		    height="236"
		    style="fill:#ff7777;fill-opacity:0.4;"/>
	</xsl:if>
      </xsl:for-each>
      



      <!-- hier beginnt die eigentliche datenverarbeitung -->


      <xsl:choose>
	<xsl:when test="$modus = 'prec'">
	  <!-- Wenn Niederschlag: 
	       - Abtastung im 24-h Takt
	       - Summe ueber alle 24 Werte pro Takt bilden 
	       - Wert von 0-Durchgang (Y-Achse) abziehen 
	       - Balkendiagramm als svg:rect zeichnen
	  -->
	  <xsl:for-each select="//row[@localtime = 0000 and starts-with(@localdate, $month_str)]">
	    <xsl:variable name="counter" select="position()"/>
	    <xsl:variable name="max" select="24"/>
	    <xsl:if test="sum(for $n in (0 to $max) 
			  return 
			  if (preceding-sibling::*[$n]//*[name() = $parameter]/@error or (preceding-sibling::*[$n]//*[name() = $parameter]/@qcflag &gt; 2))
			  then 1.0
			  else 0.0) = 0.0">
	      <xsl:variable name="sumval" select="sum(for $n in (0 to $max) 
						  return preceding-sibling::*[$n]//*[name() = $parameter]/@value)"/>
	      <svg:rect x="{$inXmin + $xscale * ($counter - 1)}"
			y="{$base_zero - ($sumval * $yscale)}"
			height="{$sumval * $yscale}"
			width="{$xscale}"
			style="fill:#7777ff;fill-opacity:0.7;"/>
	    </xsl:if>
	  </xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
	  <!-- Sonst: Diagramme als Messkurven -->
	  
	  <!-- Konstruiere SVG-Pfad aus Werten in der XML-Datei -->
	  <xsl:variable name="svgstring">
	    <xsl:choose>
	      <!-- Wenn Temperaturkurve (Luft oder Boden):
		   - Abtastung im 12-h Takt
	           - Mittelwert ueber alle 12 Werte pro Takt bilden 
	           - Wert von 0-Durchgang (Y-Achse) abziehen 
	           - String verketten mit SVG-Pfad-Symbol L -->
	      <xsl:when test="($modus = 'airtemp') or ($modus = 'surfacetemp')">
		<xsl:for-each select="//row[(@localtime = 0000 or @localtime = 1200) and starts-with(@localdate, $month_str)]">
		  <xsl:variable name="counter" select="position()"/>
		  <xsl:variable name="max" select="12"/>
		  <xsl:if test="sum(for $n in (0 to $max) 
				return 
				if (preceding-sibling::*[$n]//*[name() = $parameter]/@error)
				then 1.0
				else 0.0) = 0.0">
		    <xsl:variable name="meanval" select="sum(for $n in (0 to $max) 
							 return preceding-sibling::*[$n]//*[name() = $parameter]/@value) div $max"/>
		    <xsl:value-of select="concat(' L ',$inXmin + ($counter - 1) * $xscale,',',$base_zero - $meanval * $yscale)" />
		  </xsl:if>
		</xsl:for-each>
	      </xsl:when>
	      <!-- Wenn Sonneneinstrahlung oder Luftfeuchtigkeit:
		   - Abtastung im 24-h Takt
	           - Mittelwert ueber alle 24 Werte pro Takt bilden 
	           - Wert von 0-Durchgang (Y-Achse) abziehen 
	           - String verketten mit SVG-Pfad-Symbol L -->
	      <xsl:when test="($modus = 'solar') or ($modus = 'rh')">
		<xsl:for-each select="//row[@localtime = 0000 and starts-with(@localdate, $month_str)]">
		  <xsl:variable name="counter" select="position()"/>
		  <xsl:variable name="max" select="24"/>
		  <xsl:if test="sum(for $n in (0 to $max) 
				return 
				if (preceding-sibling::*[$n]//*[name() = $parameter]/@error)
				then 1.0
				else 0.0) = 0.0">
		    <xsl:variable name="meanval" select="sum(for $n in (0 to $max) 
							 return preceding-sibling::*[$n]//*[name() = $parameter]/@value) div $max"/>
		    <xsl:value-of select="concat(' L ',$inXmin + ($counter - 1) * $xscale,',',$base_zero - $meanval * $yscale)" />
		  </xsl:if>
		</xsl:for-each>
	      </xsl:when>	      
	    </xsl:choose>
	  </xsl:variable>
	  
	  
	  <!-- Die SVG-Pfad-Variable ist nun vollständig spezifiziert
	       => Startpunkt der Kurve bestimmen und svg:path zeichnen
	  -->
	  <xsl:variable name="ystart">
	    <xsl:for-each select="//row[@localtime = 0000 and @localdate = concat($month_str,'01')]">
	      <xsl:variable name="counter" select="position()"/>
	      <xsl:variable name="max" select="24"/>
	      <xsl:variable name="meanval" select="sum(for $n in (0 to $max) 
						   return 
						   if (preceding-sibling::*[$n]//*[name() = $parameter]/@error)
						   then 0.0
						   else preceding-sibling::*[$n]//*[name() = $parameter]/@value) div $max"/>
	      <xsl:value-of select="$base_zero - $yscale*$meanval" />
	    </xsl:for-each>
	  </xsl:variable>
	  
	  <!-- Kurve Zeichnen-->
	  <svg:path
	      style="stroke:#{$pathcolor};fill:none;"
	      d="M {$inXmin},{$ystart} {$svgstring}"
	      id="curveTempCurrent"/>	  
	</xsl:otherwise>
      </xsl:choose>
    </svg>
  </xsl:template>
</xsl:stylesheet>
