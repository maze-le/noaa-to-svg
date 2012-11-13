<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

  <xsl:variable name="color_dashlines" select="'7c7c7c'"/>
  <xsl:variable name="color_outerbox" select="'fafaff'"/>
  <xsl:variable name="color_innerbox" select="'eafcfc'"/>
  <xsl:variable name="color_axislegend" select="'000000'"/>
  <xsl:variable name="year" select="2011"/>
  
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>
  
  <xsl:template match="//station">
    <h2>Wetterdaten: Point Barrow; <xsl:value-of select="$year"/>; <xsl:value-of select="latitude"/>° N; <xsl:value-of select="longitude"/>° W</h2>
    <ul>
      <xsl:for-each select="//station/*">
	<li><xsl:value-of select="name()"/> : <xsl:value-of select="text()"/></li>
      </xsl:for-each>
    </ul>
    <p style="margin-top:1.5em;"><b>Fehlerhafte Daten</b> werden mit <span style="font-color:#000000; background-color:#ff7777;">roten Boxen</span> gekennzeichnet.</p> 
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:variable name="root" select="/"/>
    <html xmlns="http://www.w3.org/1999/xhtml" 
	  xmlns:html="http://www.w3.org/1999/xhtml">
      <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="content-language" content="de" />
	<meta name="author" content="Jörg Schließer, Mathias Vonende" />
	<meta http-equiv="content-style-type" content="text/css" />
	<title>XSLT/SVG-Visualisierung - Wetterdaten: Point Barrow <xsl:value-of select="$year"/></title>
	<link rel="stylesheet" href="./stylesheet.css" type="text/css" media="screen" />
      </head>
      <body>
	<h1>XSLT/SVG-Visualisierung</h1>
	<xsl:apply-templates select="//station"/>
	<xsl:for-each select="for $m in (1 to 12) return $m">
	  <xsl:variable name="month" select="if (position() &lt; 10)
					     then concat('0',position())
					     else position()"/>
	  <hr/>
	  <h3><xsl:value-of select="$month"/>/<xsl:value-of select="$year"/></h3>	      
	  <xsl:for-each select="for $m in (1 to 5) return $m">
	    <xsl:choose>
	      <xsl:when test="position() = 1">
		<xsl:variable name="parameter" select="'tempAvg'"/>
		<xsl:variable name="source" select="concat($month,'/svg_',$parameter,'_',$month,'.svg')"/>
		<xsl:variable name="max" select="max($root//row[starts-with(@localdate, concat($year, $month))]//tempMax/@value)"/>
		<xsl:variable name="min" select="min($root//row[not(.//tempMin/@error) and starts-with(@localdate, concat($year, $month))]//tempMin/@value)"/>
		<xsl:variable name="maxdate" select="string($root//row[(.//tempMax/@value = $max) and starts-with(@localdate, concat($year, $month))]/@localdate)"/>
		<xsl:variable name="mindate" select="string($root//row[(.//tempMin/@value = $min) and starts-with(@localdate, concat($year, $month))]/@localdate)"/>
		<xsl:variable name="maxtime" select="string($root//row[(.//tempMax/@value = $max) and starts-with(@localdate, concat($year, $month))]/@localtime)"/>
		<xsl:variable name="mintime" select="string($root//row[(.//tempMin/@value = $min) and starts-with(@localdate, concat($year, $month))]/@localtime)"/>
		<div class="diagram">
		  <div class="caption">
		    <p class="description">Lufttemperatur (Durchschnitt)</p>
		    <p class="wert">Wert: Mittelwert über alle 12h-Perioden</p>
		    <table class="extrema">
		      <tr>
			<th colspan="2">Extrempunkte pro Stunde</th>
		      </tr>
		      <tr>
			<td class="li">Maximum</td>
			<td><xsl:value-of select="$max"/> °C</td>
		      </tr>
		      <tr>
			<td class="li">am</td>
			<td><xsl:value-of select="substring($maxdate,7,2)"/>.<xsl:value-of select="substring($maxdate,5,2)"/>, <xsl:value-of select="substring($maxtime,1,2)"/>:<xsl:value-of select="substring($maxtime,3,2)"/></td>
		      </tr>
		      <tr>
			<td class="li">Minimum</td>
			<td><xsl:value-of select="$min"/> °C</td>
		      </tr>
		      <tr>
			<td class="li">am</td>
			<td><xsl:value-of select="substring($mindate,7,2)"/>.<xsl:value-of select="substring($mindate,5,2)"/>, <xsl:value-of select="substring($mintime,1,2)"/>:<xsl:value-of select="substring($mintime,3,2)"/></td>
		      </tr>
		    </table>
		  </div>
		  <div class="image">
		    <img src="{$source}"/>
		  </div>
		</div>
	      </xsl:when>
	      <xsl:when test="position() = 2">
		<xsl:variable name="parameter" select="'surfaceTempAvg'"/>
		<xsl:variable name="source" select="concat($month,'/svg_',$parameter,'_',$month,'.svg')"/>
		<xsl:variable name="max" select="max($root//row[starts-with(@localdate, concat($year, $month))]//surfaceTempMax/@value)"/>
		<xsl:variable name="min" select="min($root//row[not(.//surfaceTempMin/@error) and starts-with(@localdate, concat($year, $month))]//surfaceTempMin/@value)"/>
		<xsl:variable name="maxdate" select="string($root//row[(.//surfaceTempMax/@value = $max) and starts-with(@localdate, concat($year, $month))]/@localdate)"/>
		<xsl:variable name="mindate" select="string($root//row[(.//surfaceTempMin/@value = $min) and starts-with(@localdate, concat($year, $month))]/@localdate)"/>
		<xsl:variable name="maxtime" select="string($root//row[(.//surfaceTempMax/@value = $max) and starts-with(@localdate, concat($year, $month))]/@localtime)"/>
		<xsl:variable name="mintime" select="string($root//row[(.//surfaceTempMin/@value = $min) and starts-with(@localdate, concat($year, $month))]/@localtime)"/>
		<div class="diagram">
		  <div class="caption">
		    <p class="description">Oberflächentemperatur (Durchschnitt)</p>
		    <p class="wert">Wert: Mittelwert über alle 12h-Perioden</p>
		    <table class="extrema">
		      <tr>
			<th colspan="2">Extrempunkte pro Stunde</th>
		      </tr>
		      <tr>
			<td class="li">Maximum</td>
			<td><xsl:value-of select="$max"/> °C</td>
		      </tr>
		      <tr>
			<td class="li">am</td>
			<td><xsl:value-of select="substring($maxdate,7,2)"/>.<xsl:value-of select="substring($maxdate,5,2)"/>, <xsl:value-of select="substring($maxtime,1,2)"/>:<xsl:value-of select="substring($maxtime,3,2)"/></td>
		      </tr>
		      <tr>
			<td class="li">Minimum</td>
			<td><xsl:value-of select="$min"/> °C</td>
		      </tr>
		      <tr>
			<td class="li">am</td>
			<td><xsl:value-of select="substring($mindate,7,2)"/>.<xsl:value-of select="substring($mindate,5,2)"/>, <xsl:value-of select="substring($mintime,1,2)"/>:<xsl:value-of select="substring($mintime,3,2)"/></td>
		      </tr>
		    </table>
		  </div>
		  <div class="image">
		    <img src="{$source}"/>
		  </div>
		</div>
	      </xsl:when>
	      <xsl:when test="position() = 3">
		<xsl:variable name="parameter" select="'solarRadAvg'"/>
		<xsl:variable name="source" select="concat($month,'/svg_',$parameter,'_',$month,'.svg')"/>
		<xsl:variable name="max" select="max($root//row[starts-with(@localdate, concat($year, $month))]/
						 sensorArrayData/solarRadMax/@value)"/>
		<xsl:variable name="maxdate" select="string($root//row[(.//solarRadMax/@value = $max) and starts-with(@localdate, concat($year, $month))]/@localdate)"/>
		<xsl:variable name="maxtime" select="string($root//row[(.//solarRadMax/@value = $max) and starts-with(@localdate, concat($year, $month))]/@localtime)"/>
		<div class="diagram">
		  <div class="caption">
		    <p class="description">Sonneneinstrahlung (Durchschnitt)</p>
		    <p class="wert">Wert: Mittelwert über alle 24h-Perioden</p>
		    <table class="extrema">
		      <tr>
			<th colspan="2">Extrempunkte pro Stunde</th>
		      </tr>
		      <tr>
			<td class="li">Maximum</td>
			<td><xsl:value-of select="$max"/>W/m<sup>2</sup></td>
		      </tr>
		      <tr>
			<td class="li">am</td>
			<td><xsl:value-of select="substring($maxdate,7,2)"/>.<xsl:value-of select="substring($maxdate,5,2)"/>, <xsl:value-of select="substring($maxtime,1,2)"/>:<xsl:value-of select="substring($maxtime,3,2)"/></td>
		      </tr>
		    </table>
		  </div>
		  <div class="image">
		    <img src="{$source}"/>
		  </div>
		</div>
	      </xsl:when>
	      <xsl:when test="position() = 4">
		<xsl:variable name="parameter" select="'rhAvg'"/>
		<xsl:variable name="source" select="concat($month,'/svg_',$parameter,'_',$month,'.svg')"/>
		<xsl:variable name="max" select="max($root//row[starts-with(@localdate, concat($year, $month))]//rhAvg/@value)"/>
		<xsl:variable name="maxdate" select="string($root//row[(.//rhAvg/@value = $max) and starts-with(@localdate, concat($year, $month))]/@localdate)"/>
		<xsl:variable name="maxtime" select="string($root//row[(.//rhAvg/@value = $max) and starts-with(@localdate, concat($year, $month))]/@localtime)"/>
		<div class="diagram">
		  <div class="caption">
		    <p class="description">Relative Luftfeuchtigkeit</p>
		    <p class="wert">Wert: Mittelwert über alle 24h-Perioden</p>
		    <table class="extrema">
		      <tr>
			<th colspan="2">Extrempunkte pro Stunde</th>
		      </tr>
		      <tr>
			<td class="li">Maximum</td>
			<td><xsl:value-of select="$max"/> %</td>
		      </tr>
		      <tr>
			<td class="li">am</td>
			<td><xsl:value-of select="substring($maxdate,7,2)"/>.<xsl:value-of select="substring($maxdate,5,2)"/>, <xsl:value-of select="substring($maxtime,1,2)"/>:<xsl:value-of select="substring($maxtime,3,2)"/></td>
		      </tr>
		    </table>
		  </div>
		  <div class="image">
		    <img src="{$source}"/>
		  </div>
		</div>
	      </xsl:when>
	      <xsl:when test="position() = 5">
		<xsl:variable name="parameter" select="'precipitation'"/>
		<xsl:variable name="sum" select="sum($root//row[not(.//precipitation/@error) and starts-with(@localdate, concat($year, $month))]//precipitation/@value)"/>
		<xsl:variable name="source" select="concat($month,'/svg_',$parameter,'_',$month,'.svg')"/>
		<div class="diagram">
		  <div class="caption">
		    <p class="description">Niederschlag</p>
		    <p class="wert">Wert: Summe über alle Werte pro 24h-Perioden</p>
		    <table class="extrema">
		      <tr>
			<th colspan="2">Summe über gesamten Monat</th>
		      </tr>
		      <tr>
			<td class="li"><span class="sum">&#931;</span></td>
			<td><xsl:value-of select="format-number($sum, '###.###')"/> mm</td>
		      </tr>
		    </table>
		  </div>
		  <div class="image">
		    <img src="{$source}"/>
		  </div>
		</div>
	      </xsl:when>
	    </xsl:choose>
	  </xsl:for-each>
	</xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
