<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:PAM="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:xhb="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs xd fn"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 8, 2019</xd:p>
            <xd:p><xd:b>Updated on:</xd:b> Nov 6, 2019</xd:p>
            <xd:p><xd:b>Updated on:</xd:b> Nov 12, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> everis (mfontsan)</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no" standalone="yes" indent="yes"/>
    <xd:doc>
        <xd:desc>
            <xd:p>Main function that creates the Mandate XML with the main structure.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:for-each select="/JSON/mandate">
            <PAM:Mandate>   
                <xsl:call-template name="create_Mandator"/>
                <xsl:call-template name="create_MandateIdentifier">
                    <xsl:with-param name="identifier" select="mandate_id"/>
                </xsl:call-template>
                <xsl:call-template name="create_MandateIdentifier">
                    <xsl:with-param name="identifier" select="arbitraryMandateContent_id"/>
                </xsl:call-template>
            </PAM:Mandate>            
        </xsl:for-each>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc><xd:p>Create NaturalPerson element and its elements.</xd:p></xd:desc>
        <xd:param name="person_type"/>
    </xd:doc>
    <xsl:template name="create_NaturalPerson">
        <xsl:param name="person_type"/>
        
        <xsl:for-each select="/JSON/child::*[local-name()=$person_type]">
            <PAM:NaturalPerson>
                <PAM:NaturalPersonIdentifier>
                    <xhb:ID schemeName="ss_pin_type"><xsl:value-of select="ss_pin_type"/></xhb:ID>
                </PAM:NaturalPersonIdentifier>
                <PAM:NaturalPersonIdentifier>
                    <xhb:ID schemeName="ss_pin_value"><xsl:value-of select="ss_pin_value"/></xhb:ID>
                </PAM:NaturalPersonIdentifier>
                <PAM:NaturalPersonPerson>
                    <xsl:call-template name="create_element">
                        <xsl:with-param name="element_name">xhb:FirstName</xsl:with-param>
                        <xsl:with-param name="value"><xsl:value-of select="given_name"/></xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="create_element">
                        <xsl:with-param name="element_name">xhb:FamilyName</xsl:with-param>
                        <xsl:with-param name="value"><xsl:value-of select="family_name"/></xsl:with-param>
                    </xsl:call-template>
                </PAM:NaturalPersonPerson>
            </PAM:NaturalPerson>
        </xsl:for-each>
    </xsl:template>
    
    <xd:doc>
        <xd:desc><xd:p>Create MandateIdentifier element and its ID.</xd:p></xd:desc>
        <xd:param name="identifier"/>
    </xd:doc>
    <xsl:template name="create_MandateIdentifier">
        <xsl:param name="identifier"/>
        
        <xsl:if test="not(empty($identifier)) and $identifier!=''">
            <PAM:MandateIdentifier>
                <xhb:ID><xsl:value-of select="$identifier"/></xhb:ID>            
            </PAM:MandateIdentifier>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc><xd:p>Create Mandator element (the elements Description and Power are mandatory).</xd:p></xd:desc>
    </xd:doc>
    <xsl:template name="create_Mandator">
        <PAM:Mandator>
            <xsl:call-template name="create_NaturalPerson">
                <xsl:with-param name="person_type">mnadator</xsl:with-param>
            </xsl:call-template>
            <PAM:Power>
                <xhb:RpaMPowerCode>BE_TOP.BE_ENFORCEMENT_MATTERS.AC_MANAGING.OB_RECEIVABLES_SUBJECT_TO_ENFORCED_COLLECTION.OT_RECEIPT</xhb:RpaMPowerCode>
                <xhb:StatusTypeStatusCode>VALID</xhb:StatusTypeStatusCode>
                <xsl:if test="count(/JSON/mandatee) &gt; 0">
                    <PAM:RepresentationGrantedToMandatee>
                        <xsl:call-template name="create_NaturalPerson">
                            <xsl:with-param name="person_type">mandatee</xsl:with-param>
                        </xsl:call-template>                        
                    </PAM:RepresentationGrantedToMandatee>
                </xsl:if>
            </PAM:Power>
        </PAM:Mandator>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Create the element with the name send via parameter 'element_name' and the value 'value'.</xd:desc>
        <xd:param name="value"/>
        <xd:param name="element_name"/>
    </xd:doc>
    <xsl:template name="create_element">
        <xsl:param name="value"/>
        <xsl:param name="element_name"/>
        <xsl:if test="not(empty($value)) and $value!=''">
            <xsl:element name="{$element_name}"><xsl:value-of select="$value"/></xsl:element>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
