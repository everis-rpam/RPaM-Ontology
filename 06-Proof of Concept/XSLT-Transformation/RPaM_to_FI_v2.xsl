<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:PAM="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:PAMResp="urn:isa2:names:specification:rpam:ubl:schema:xsd:MandateResponse-1MandateResponse"
    xmlns:xhb="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    exclude-result-prefixes="xs xd PAM xhb PAMResp"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 24, 2019</xd:p>
            <xd:p><xd:b>Modified on:</xd:b> Nov 12, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> everis (mfontsan)</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no" standalone="yes" indent="yes"/>
    <xd:doc>
        <xd:desc>
            <xd:p>Main function that creates the Finland XML with the main structure.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <Mandate>
            <startdate/>
            <enddate/>
            
            <xsl:apply-templates select="/PAMResp:MandateResponse/PAM:ProvidesMandate/PAM:Mandator/PAM:Power/PAM:RepresentationGrantedToMandatee/PAM:NaturalPerson">
                <xsl:with-param name="element_name">Mandatee</xsl:with-param>
            </xsl:apply-templates>
            <xsl:apply-templates select="/PAMResp:MandateResponse/PAM:ProvidesMandate/PAM:Mandator/PAM:NaturalPerson">
                <xsl:with-param name="element_name">Mandator</xsl:with-param>
            </xsl:apply-templates>
            <xsl:call-template name="create_MandateInfo"/>
        </Mandate>
    </xsl:template>
        
    
    <xd:doc>
        <xd:desc><xd:p>Create Mandator or Mandatee element and its subelements.</xd:p></xd:desc>
        <xd:param name="element_name"/>
    </xd:doc>
    <xsl:template match="PAM:NaturalPerson">
        <xsl:param name="element_name"/>
        
        <xsl:element name="{$element_name}">
            <firstname><xsl:value-of select="PAM:NaturalPersonPerson/xhb:FirstName"/></firstname>
            <lastname><xsl:value-of select="PAM:NaturalPersonPerson/xhb:FamilyName"/></lastname>
            <identifier><xsl:value-of select="PAM:NaturalPersonIdentifier/xhb:ID"/></identifier>
        </xsl:element>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc><xd:p>Create Mandate Information elements and its subelements.</xd:p></xd:desc>
    </xd:doc>
    <xsl:template name="create_MandateInfo">        
        <Power>
            <name/>
            <definition/>
        </Power>
    </xsl:template>
    
</xsl:stylesheet>
