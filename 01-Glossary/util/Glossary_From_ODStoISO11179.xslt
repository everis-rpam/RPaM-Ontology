<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2010 rel. 3 (x64) (http://www.altova.com) by everis Spain, S.L. (everis Spain, S.L.) -->
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
xmlns:ccts="urn:un:unece:uncefact:documentation:2"
xmlns:sembu="http://www.everis.com/sembu/glossary/ods2iso11179#"> 

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/" priority="1">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="office:body" priority="2">
			<!-- output ISO 11179 root element starting tag -->
			<DataElementDictionary xmlns:epo="http://data.europa.eu/ePO/ontology#" xmlns:ccts="urn:un:unece:uncefact:documentation:2">
			<xsl:apply-templates select="office:spreadsheet/table:table"/>
			<!-- output ISO 11179 root element closing tag -->
			</DataElementDictionary>		
	</xsl:template>
	
	<xsl:template match="office:spreadsheet/table:table" priority="3">
		<xsl:choose>
			<xsl:when test="upper-case(@table:name)='GLOSSARY'">
				<xsl:apply-templates select="table:table-row"/>				
			</xsl:when>
			<xsl:when test="upper-case(@table:name)='METADATA'">
				<xsl:call-template name="createMetadata"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="sembu:getCellContent">
		<xsl:param name="node"/>
		<xsl:param name="colpos"/>
		<xsl:value-of select="$node/table:table-cell[sum(preceding-sibling::*/@table:number-columns-repeated) + position() - count(preceding-sibling::*/@table:number-columns-repeated) &lt;= $colpos][last()]/text:p/text()"/>	
	</xsl:function>
	<xsl:function name="sembu:getURL">
		<xsl:param name="node"/>
		<xsl:param name="colpos"/>
		<xsl:value-of select="$node/table:table-cell[sum(preceding-sibling::*/@table:number-columns-repeated) + position() - count(preceding-sibling::*/@table:number-columns-repeated) &lt;= $colpos][last()]/text:p/text:a/text()"/>	
	</xsl:function>
	
	<xsl:template match="table:table-row" priority="4">
		<!-- Let's skip the column number (row #1) and the column names (row #2) --> 
		<xsl:if test="position() >2">
				<xsl:call-template name="createComponent"/>					
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="createComponent">
	
		<xsl:variable name="CONCEPT" select="2"/>
		<xsl:variable name="DEFINITION" select="3"/>
		<xsl:variable name="ADDITIONAL_INFORMATION" select="4"/>
		<xsl:variable name="EXAMPLES" select="5"/>
		<xsl:variable name="SYNONYMS" select="6"/>
		<xsl:variable name="DEFINITION_SOURCE" select="7"/>
		<xsl:variable name="SOURCE_URL" select="8"/>
		<xsl:variable name="ENTRY_TYPE" select="9"/>
		
		<xsl:variable name="conceptNotEmpty" select="string-length(sembu:getCellContent(., $CONCEPT)) != 0"/>
		<xsl:variable name="definitionNotEmpy" select="string-length(sembu:getCellContent(., $DEFINITION)) != 0"/>
		<xsl:variable name="additionalInformationNotEmpy" select="string-length(sembu:getCellContent(., $ADDITIONAL_INFORMATION)) != 0"/>
		<xsl:variable name="examplesNotEmpty" select="string-length(sembu:getCellContent(., $EXAMPLES)) != 0"/>
		<xsl:variable name="synonymsNotEmpty" select="string-length(sembu:getCellContent(., $SYNONYMS)) != 0 "/>
		<xsl:variable name="definitionSourceNotEmpty" select="string-length(sembu:getCellContent(., $DEFINITION_SOURCE)) != 0 "/>
		<xsl:variable name="sourceURLNotEmpty" select="string-length(sembu:getURL(., $SOURCE_URL)) != 0 "/>
		<xsl:variable name="entryTypeNotEmpty" select="string-length(sembu:getCellContent(., $ENTRY_TYPE)) != 0 "/>
		
		<!-- NICE TO HAVE : TOKENIZE EXAMPLES SEPARATED WITH ; OR SIMILAR. See Ken's templates if necessary. --> 
		
		<xsl:if test="$conceptNotEmpty">
			<sembu:DictionaryEntry>				
				<xsd:annotation>
					<xsd:documentation xml:lang="en">
						<ccts:DictionaryEntryName><xsl:value-of select="sembu:getCellContent(., $CONCEPT)"/></ccts:DictionaryEntryName>
						<ccts:Definition><xsl:value-of select="sembu:getCellContent(., $DEFINITION)"/></ccts:Definition>
						<xsl:if test="$additionalInformationNotEmpy"><ccts:AdditionalInformation><xsl:value-of select="sembu:getCellContent(., $ADDITIONAL_INFORMATION)"/></ccts:AdditionalInformation></xsl:if>
						<xsl:if test="$examplesNotEmpty"><ccts:Examples><xsl:value-of select="sembu:getCellContent(., $EXAMPLES)"/></ccts:Examples></xsl:if>
						<xsl:if test="$synonymsNotEmpty"><ccts:AlternativeTerm><xsl:value-of select="sembu:getCellContent(., $SYNONYMS)"/></ccts:AlternativeTerm></xsl:if>
						<xsl:if test="$definitionSourceNotEmpty"><ccts:Source><xsl:value-of select="sembu:getCellContent(., $DEFINITION_SOURCE)"/></ccts:Source></xsl:if>
						<xsl:if test="$sourceURLNotEmpty"><ccts:SourceURL><xsl:value-of select="sembu:getURL(., $SOURCE_URL)"/></ccts:SourceURL></xsl:if>
						<xsl:if test="$entryTypeNotEmpty"><ccts:EntryType><xsl:value-of select="sembu:getCellContent(., $ENTRY_TYPE)"/></ccts:EntryType></xsl:if>						
					</xsd:documentation>
				</xsd:annotation>
			</sembu:DictionaryEntry>
		</xsl:if>
	</xsl:template>	
	
	<xsl:template name="createMetadata">
		
		<xsl:variable name="projectShortName" select="lower-case('${shortname}')"/>
		<xsl:variable name="projectLongName" select="lower-case('${longname}')"/>
		<xsl:variable name="projectVersionID" select="lower-case('${versionid}')"/>
		<xsl:variable name="projectStatus" select="lower-case('${projectstatus}')"/>
		<xsl:variable name="glossaryTitle" select="lower-case('${glossarytitle}')"/>
		<xsl:variable name="descriptionLine" select="lower-case('${descriptionline}')"/>
		<sembu:ProjectMetadata>
		<xsl:for-each select="table:table-row">
			<xsl:choose>
				<xsl:when test="lower-case(sembu:getCellContent(., 5)) = $projectShortName">
					<sembu:ProjectShortName><xsl:value-of select="sembu:getCellContent(., 3)"/></sembu:ProjectShortName>
				</xsl:when>
				<xsl:when test="lower-case(sembu:getCellContent(., 5)) = $projectLongName">
					<sembu:ProjectLongName><xsl:value-of select="sembu:getCellContent(., 3)"/></sembu:ProjectLongName>
				</xsl:when>
				<xsl:when test="lower-case(sembu:getCellContent(., 5)) = $projectVersionID">
					<sembu:ProjectVersionID><xsl:value-of select="sembu:getCellContent(., 3)"/></sembu:ProjectVersionID>
				</xsl:when>
				<xsl:when test="lower-case(sembu:getCellContent(., 5)) = $projectStatus">
					<sembu:ProjectStatus><xsl:value-of select="sembu:getCellContent(., 3)"/></sembu:ProjectStatus>
				</xsl:when>
				<xsl:when test="lower-case(sembu:getCellContent(., 5)) = $glossaryTitle">
					<sembu:ProjectGlossaryTitle><xsl:value-of select="sembu:getCellContent(., 3)"/></sembu:ProjectGlossaryTitle>
				</xsl:when>
				<xsl:when test="lower-case(sembu:getCellContent(., 5)) = $descriptionLine">
					<sembu:ProjectDescriptionLine><xsl:value-of select="sembu:getCellContent(., 3)"/></sembu:ProjectDescriptionLine>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		</sembu:ProjectMetadata>
	</xsl:template>
</xsl:stylesheet>
