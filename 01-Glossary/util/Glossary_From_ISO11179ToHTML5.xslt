<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
	xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
	xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
	xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
	xmlns:ccts="urn:un:unece:uncefact:documentation:2"
	xmlns:sembu="http://www.everis.com/sembu/glossary/ods2iso11179#"
	xmlns:math="http://exslt.org/math"
	extension-element-prefixes="math sembu office style table text">
	
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	<xsl:param name="title" select="//*/sembu:ProjectGlossaryTitle"/>
	
	<xsl:template match="/">
		<xsl:call-template name="HTMLHeader"/>
		<xsl:call-template name="beginBody"/>
		<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;td&gt;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;/td&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
		<xsl:call-template name="endBody"/>		
	</xsl:template>
	
	<xsl:template match="sembu:DictionaryEntry">
		<xsl:apply-templates select="xsd:annotation"/>
	</xsl:template>
	
	<xsl:template match="xsd:annotation">
		<xsl:apply-templates select="xsd:documentation"/>
	</xsl:template>
	
	<xsl:template match="xsd:documentation">
		
		<xsl:variable name="entryPos">
			<xsl:number count="sembu:DictionaryEntry" format="1"/>
		</xsl:variable>		
		
		<xsl:variable name="entry" select="upper-case(substring(ccts:DictionaryEntryName/text(), 1,1))"/>
		<xsl:variable name="nextEntry" select="upper-case(substring(../../../sembu:DictionaryEntry[$entryPos + 1]/xsd:annotation/xsd:documentation/ccts:DictionaryEntryName/text(), 1,1))"/>
		
		<xsl:variable name="additionalInformation" select="ccts:AdditionalInformation"/>
		<xsl:variable name="examples" select="ccts:examples"/>
		<xsl:variable name="source" select="ccts:Source"/>
		<xsl:variable name="sourceURL" select="ccts:SourceURL"/>
		
		
		<xsl:if test="$entryPos = 1">
			<div class="nqa">
				<hr style="height: 10px; border-style: solid; border-color: #8c8b8b; border-width: 1px 0 0 0; border-radius: 30px;"/>
				<entry_letter>
					<xsl:value-of select="$entry"/>
					<a href="#index" style="text-decoration:none;"> ↑ </a>
				</entry_letter>
			</div>
		</xsl:if>		
		
		<div class="qa">
			<xsl:text disable-output-escaping="yes">&lt;input type="checkbox" id="qa</xsl:text><xsl:value-of select="$entryPos"/><xsl:text disable-output-escaping="yes">"/&gt;</xsl:text>
			<xsl:text disable-output-escaping="yes">&lt;label for="qa</xsl:text><xsl:value-of select="$entryPos"/><xsl:text disable-output-escaping="yes">"&gt;</xsl:text><entry><xsl:value-of select="ccts:DictionaryEntryName"/></entry><xsl:text disable-output-escaping="yes">&lt;/label&gt;</xsl:text>
			<div>
				<br/>
				<definition><xsl:value-of select="ccts:Definition"/></definition><br/><br/><br/>
				<xsl:if test="$additionalInformation != ''">
					<additionalInformation><b>Additional Information</b>
						<p/><xsl:value-of select="$additionalInformation"/></additionalInformation></xsl:if>
				<xsl:if test="$examples !=''">
					<examples><p/><b>Example(s)</b>
						<p/><xsl:value-of select="$examples"/></examples></xsl:if>	
				<xsl:if test="$source !=''">
					<sources><p/><b>Source:&#160;&#160;</b>
						<xsl:choose>
							<xsl:when test="$sourceURL!=''">
								<xsl:text disable-output-escaping="yes">&lt;a href=&quot;</xsl:text>
								<xsl:value-of select="$sourceURL"/>
								<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
								<xsl:value-of select="$source"/>
								<xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>		
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="$source"/></xsl:otherwise>
						</xsl:choose>			
					</sources>					
				</xsl:if>				
			</div>		
			<br/>
		</div>
		
		<xsl:if test="$entry != $nextEntry">
			<div class="nqa">
				<hr style="height: 10px; border-style: solid; border-color: #8c8b8b; border-width: 1px 0 0 0; border-radius: 30px;"/>
				<entry_letter>
					<xsl:text disable-output-escaping="yes">&lt;div id="</xsl:text><xsl:value-of select="$nextEntry"/><xsl:text disable-output-escaping="yes">"&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
					<xsl:value-of select="$nextEntry"/>
					<a href="#index" style="text-decoration:none;"> ↑ </a>
				</entry_letter>				
			</div>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="HTMLHeader">
		
		<xsl:text disable-output-escaping="yes">&lt;html&gt;</xsl:text>	
		<head>
			<meta charset="UTF-8"/>
			<title>RPaM Ontology Glossary</title>
			<link rel = "stylesheet"   type = "text/css"   href = "./css/Glossary.css"/>
		</head>
	</xsl:template>
	
	<xsl:template name="beginBody">
		
		<xsl:text disable-output-escaping="yes">&lt;table width=70%" align="center"&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;td&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;body&gt;</xsl:text>
		<h1 class="title_font">RPaM Ontology Glossary</h1>
		<div class="normal_font">
			
			<p/>The following list of concepts have been identified through the analysis of the RPaM Business Domain. 
			<p/>Click on a term to hide/show the definition and related terms. 
			<p/>Each entry of the glossary represents a capital 
			concept of the business domain and the ontology. 
			<p/>For more details on the properties of a concept please visit the conceptual diagrams in the 
			<a href="https://github.com/everis-rpam/RPaM-Ontology/wiki/Conceptual-Model-v1.1">RPaM GitHub wiki</a>.
		</div>
		
		<p>
			<a class="anchor" href="#index"/>
			<div class="index" id="index">
				<a href="#A" style="text-decoration:none;">A </a>
				<a href="#B" style="text-decoration:none;"> B </a>
				<a href="#C" style="text-decoration:none;"> C </a>
				<a href="#D" style="text-decoration:none;"> D </a>
				<a href="#E" style="text-decoration:none;"> E </a>
				<a href="#F" style="text-decoration:none;"> F </a>
				<a href="#G" style="text-decoration:none;"> G </a>
				<a href="#H" style="text-decoration:none;"> H </a>
				<a href="#I" style="text-decoration:none;"> I </a>
				<a href="#J" style="text-decoration:none;"> J </a>
				<a href="#K" style="text-decoration:none;"> K </a>
				<a href="#L" style="text-decoration:none;"> L </a>
				<a href="#M" style="text-decoration:none;"> M </a>
				<a href="#N" style="text-decoration:none;"> N </a>
				<a href="#O" style="text-decoration:none;"> O </a>
				<a href="#P" style="text-decoration:none;"> P </a>
				<a href="#Q" style="text-decoration:none;"> Q </a>
				<a href="#R" style="text-decoration:none;"> R </a>
				<a href="#S" style="text-decoration:none;"> S </a>
				<a href="#T" style="text-decoration:none;"> T </a>
				<a href="#U" style="text-decoration:none;"> U </a>
				<a href="#V" style="text-decoration:none;"> V </a>
				<a href="#W" style="text-decoration:none;"> W </a>
				<a href="#X" style="text-decoration:none;"> X </a>
				<a href="#Y" style="text-decoration:none;"> Y </a>
				<a href="#Z" style="text-decoration:none;"> Z </a>
			</div>
		</p>
		<xsl:text disable-output-escaping="yes">&lt;/td&gt;</xsl:text>		
		<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>	
	</xsl:template>
	
	<xsl:template name="endBody">
		<xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;/body&gt;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>