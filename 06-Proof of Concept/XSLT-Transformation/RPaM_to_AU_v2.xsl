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
            <xd:p><xd:b>Created on:</xd:b> Oct 10, 2019</xd:p>
            <xd:p><xd:b>Updated on:</xd:b> Nov 12, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> everis (mfontsan)</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no" standalone="yes" indent="yes"/>
    <xd:doc>
        <xd:desc>
            <xd:p>Main function that creates the Austrian XML with the main structure.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <JSON>
            <xsl:call-template name="create_Mandate"/>
            <xsl:apply-templates select="/PAMResp:MandateResponse/PAM:ProvidesMandate/PAM:Mandator/PAM:Power/PAM:RepresentationGrantedToMandatee/PAM:NaturalPerson">
                <xsl:with-param name="element_name">mandatee</xsl:with-param>
                <xsl:with-param name="id">2</xsl:with-param>
            </xsl:apply-templates>
            <xsl:apply-templates select="/PAMResp:MandateResponse/PAM:ProvidesMandate/PAM:Mandator/PAM:NaturalPerson">
                <xsl:with-param name="element_name">mnadator</xsl:with-param>
                <xsl:with-param name="id">1</xsl:with-param>
            </xsl:apply-templates>
            <xsl:call-template name="create_MandateInfo"/>
        </JSON>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc><xd:p>Create Mandate element and its subelements.</xd:p></xd:desc>
    </xd:doc>
    <xsl:template name="create_Mandate">
        <mandate>
            <id/>
            <user_description/>
            <mandate_id><xsl:value-of select="/PAMResp:MandateResponse/PAM:ProvidesMandate/PAM:MandateIdentifier/xhb:ID"/></mandate_id>
            <valid_from/>
            <valid_to/>
            <approved/>
            <status/>            
            <status_date/>
            <arbitraryMandateContent_id><xsl:value-of select="/PAMResp:MandateResponse/PAM:ProvidesMandate/PAM:MandateIdentifier/xhb:ID"/></arbitraryMandateContent_id>
            <fileUpload_id/>
            <mandator_id>1</mandator_id>
            <intermediary_id/>
            <representative_id>2</representative_id>
            <selectedAlternative_id/>
            <mandateContent_id>6</mandateContent_id>
            <reference_value/>
            <prep_identifier/>
            <onlineApplication_id/>
            <isStorkMandate/>
            <isTestIdentity/>
        </mandate>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc><xd:p>Create Mandator or Mandatee element and its subelements.</xd:p></xd:desc>
        <xd:param name="element_name"/>
        <xd:param name="id"/>
    </xd:doc>
    <xsl:template match="PAM:NaturalPerson">
        <xsl:param name="element_name"/>
        <xsl:param name="id"/>
        <xsl:element name="{$element_name}">
            <id><xsl:value-of select="$id"/></id>
            <ss_pin_type><xsl:value-of select="PAM:NaturalPersonIdentifier/xhb:ID[@schemeName='ss_pin_type']"/></ss_pin_type>
            <ss_pin_value><xsl:value-of select="PAM:NaturalPersonIdentifier/xhb:ID[@schemeName='ss_pin_value']"/></ss_pin_value>
            <given_name><xsl:value-of select="PAM:NaturalPersonPerson/xhb:FirstName"/></given_name>
            <family_name><xsl:value-of select="PAM:NaturalPersonPerson/xhb:FamilyName"/></family_name>
            <date_of_birth/>
            <common_name/>
            <email/>
            <living_address/>
        </xsl:element>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc><xd:p>Create Mandate Information elements and its subelements.</xd:p></xd:desc>
    </xd:doc>
    <xsl:template name="create_MandateInfo">        
        <mandate_information>
            <id>6</id>
            <name/>
            <description/>
            <sttb_name/>
            <explanation/>
            <selectedAlternative/>
            <guiType_id/>
            <category_id/>
            <select_explanation/>
            <sourcepin_types/>
            <deactivated/>
            <description_detail/>
            <ERsB_code/>
            <STORK_cod/>
            <oid/>
        </mandate_information>
    </xsl:template>
    
</xsl:stylesheet>
