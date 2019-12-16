<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:espd-req="urn:oasis:names:specification:ubl:schema:xsd:QualificationApplicationRequest-2"
                xmlns:espd-resp="urn:oasis:names:specification:ubl:schema:xsd:QualificationApplicationResponse-2"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:PAMResp="urn:isa2:names:specification:rpam:ubl:schema:xsd:MandateResponse-1MandateResponse"
                xmlns:PAMReq="urn:isa2:names:specification:rpam:ubl:schema:xsd:MandateResponse-1MandateRequest"
                xmlns:PAM="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:xhb="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+   count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Common RPaM Business Rules"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="urn:isa2:names:specification:rpam:ubl:schema:xsd:MandateResponse-1MandateResponse"
                                             prefix="PAMResp"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:isa2:names:specification:rpam:ubl:schema:xsd:MandateResponse-1MandateRequest"
                                             prefix="PAMReq"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                                             prefix="PAM"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                                             prefix="xhb"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2005/xpath-functions" prefix="fn"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">BR-COM-RPAM</xsl:attribute>
            <xsl:attribute name="name">BR-COM-RPAM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Common RPaM Business Rules</svrl:text>

   <!--PATTERN BR-COM-RPAM-->


	<!--RULE -->
<xsl:template match="PAM:DrawnFromPowerSource" priority="1008" mode="M6">
      <xsl:variable name="evidence" select="parent::*[1]/parent::*[1]/parent::*[1]/PAM:Evidence"/>
      <xsl:variable name="equal_evidence"
                    select="count(PAM:PowerSourceTypeEvidence[(xhb:ID = $evidence/xhb:ID) and (xhb:EvidenceTypeCode = $evidence/xhb:EvidenceTypeCode) and (xhb:ConfidentialityLevelCode = $evidence/xhb:ConfidentialityLevelCode)])"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="($equal_evidence != 0) or ($equal_evidence = 0 and xhb:DelegationChainLevelNumeric=0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="($equal_evidence != 0) or ($equal_evidence = 0 and xhb:DelegationChainLevelNumeric=0)">
               <xsl:attribute name="id">BR01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In the case of an empowerement, the delegationChain Level must be 0.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="($equal_evidence != 0) or ($equal_evidence = 0 and (count(PAM:PowerSourceTypeLegislation)+count(PAM:NaturalPerson/xhb:RoleTypeRegulatedProfessionCode) &gt;0))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="($equal_evidence != 0) or ($equal_evidence = 0 and (count(PAM:PowerSourceTypeLegislation)+count(PAM:NaturalPerson/xhb:RoleTypeRegulatedProfessionCode) &gt;0))">
               <xsl:attribute name="id">BR03</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In the case of an empowerement, the Legislation or/and the role at the source of the power should be specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(xhb:DelegationChainLevelNumeric = 0) or (xhb:DelegationChainLevelNumeric &gt; 0 and count(PAM:PowerSourceTypeEvidence)&gt;0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(xhb:DelegationChainLevelNumeric = 0) or (xhb:DelegationChainLevelNumeric &gt; 0 and count(PAM:PowerSourceTypeEvidence)&gt;0)">
               <xsl:attribute name="id">BR04</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In the case of a delegation, the evidence at the source of the power should be specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="xhb:DelegationChainLevelNumeric" priority="1007" mode="M6">
      <xsl:variable name="delegationChain" select="."/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$delegationChain &lt; 3"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$delegationChain &lt; 3">
               <xsl:attribute name="id">BR02</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Delegations should not reach the level 3.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="PAM:Mandator | PAM:RepresentationGrantedToMandatee" priority="1006"
                 mode="M6">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="(PAM:NaturalPerson and not(PAM:LegalPersonPartyLegalEntity)) or (not(PAM:NaturalPerson) and PAM:LegalPersonPartyLegalEntity)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(PAM:NaturalPerson and not(PAM:LegalPersonPartyLegalEntity)) or (not(PAM:NaturalPerson) and PAM:LegalPersonPartyLegalEntity)">
               <xsl:attribute name="id">BR06</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The type of Agent should always be specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="xhb:StartDate" priority="1005" mode="M6">
      <xsl:variable name="startDate" select="."/>
      <xsl:variable name="endDate" select="parent::*[1]/xhb:EndDate"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$startDate &lt; $endDate"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$startDate &lt; $endDate">
               <xsl:attribute name="id">BR07</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Periods must check that the end date is not lesser than the start date.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="xhb:EndDate" priority="1004" mode="M6">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(parent::*[1]/xhb:DurationMeasure)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(parent::*[1]/xhb:DurationMeasure)">
               <xsl:attribute name="id">BR08</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Periods must check the non-co-occurrence of the end-date and the duration measure.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="PAMResp:MandateResponse" priority="1003" mode="M6">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(fn:distinct-values(PAM:ProvidesMandate/PAM:MandateIdentifier/xhb:ID)) = count(PAM:ProvidesMandate/PAM:MandateIdentifier/xhb:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(fn:distinct-values(PAM:ProvidesMandate/PAM:MandateIdentifier/xhb:ID)) = count(PAM:ProvidesMandate/PAM:MandateIdentifier/xhb:ID)">
               <xsl:attribute name="id">BR10.01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A mandate, power, mandator and mandatee must have an unique identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(fn:distinct-values(PAM:ProvidesMandate/PAM:Mandator/PAM:NaturalPerson/PAM:NaturalPersonIdentifier/xhb:ID)) = count(PAM:ProvidesMandate/PAM:Mandator/PAM:NaturalPerson/PAM:NaturalPersonIdentifier/xhb:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(fn:distinct-values(PAM:ProvidesMandate/PAM:Mandator/PAM:NaturalPerson/PAM:NaturalPersonIdentifier/xhb:ID)) = count(PAM:ProvidesMandate/PAM:Mandator/PAM:NaturalPerson/PAM:NaturalPersonIdentifier/xhb:ID)">
               <xsl:attribute name="id">BR10.02</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A mandate, power, mandator and mandatee must have an unique identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(fn:distinct-values(PAM:ProvidesMandate/PAM:Mandator/PAM:LegalPersonPartyLegalEntity/xhb:CompanyID)) = count(PAM:ProvidesMandate/PAM:Mandator/PAM:LegalPersonPartyLegalEntity/xhb:CompanyID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(fn:distinct-values(PAM:ProvidesMandate/PAM:Mandator/PAM:LegalPersonPartyLegalEntity/xhb:CompanyID)) = count(PAM:ProvidesMandate/PAM:Mandator/PAM:LegalPersonPartyLegalEntity/xhb:CompanyID)">
               <xsl:attribute name="id">BR10.03</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A mandate, power, mandator and mandatee must have an unique identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(PAM:ProvidesMandate)&gt;0) or (count(PAM:ReportsException)&gt;0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(count(PAM:ProvidesMandate)&gt;0) or (count(PAM:ReportsException)&gt;0)">
               <xsl:attribute name="id">BR11</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>At least one instance of mandate or exception must be present in an eMandate Response.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="PAM:Mandator" priority="1002" mode="M6">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(fn:distinct-values(PAM:Power/PAM:PowerIdentifier/xhb:ID)) = count(PAM:Power/PAM:PowerIdentifier/xhb:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(fn:distinct-values(PAM:Power/PAM:PowerIdentifier/xhb:ID)) = count(PAM:Power/PAM:PowerIdentifier/xhb:ID)">
               <xsl:attribute name="id">BR10.07</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A mandate, power, mandator and mandatee must have an unique identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(fn:distinct-values(PAM:Power/PAM:RepresentationGrantedToMandatee/PAM:NaturalPerson/PAM:NaturalPersonIdentifier/xhb:ID)) = count(PAM:Power/PAM:RepresentationGrantedToMandatee/PAM:NaturalPerson/PAM:NaturalPersonIdentifier/xhb:ID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(fn:distinct-values(PAM:Power/PAM:RepresentationGrantedToMandatee/PAM:NaturalPerson/PAM:NaturalPersonIdentifier/xhb:ID)) = count(PAM:Power/PAM:RepresentationGrantedToMandatee/PAM:NaturalPerson/PAM:NaturalPersonIdentifier/xhb:ID)">
               <xsl:attribute name="id">BR10.08</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A mandate, power, mandator and mandatee must have an unique identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(fn:distinct-values(PAM:Power/PAM:RepresentationGrantedToMandatee/PAM:LegalPersonPartyLegalEntity/xhb:CompanyID)) = count(PAM:Power/PAM:RepresentationGrantedToMandatee/PAM:LegalPersonPartyLegalEntity/xhb:CompanyID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(fn:distinct-values(PAM:Power/PAM:RepresentationGrantedToMandatee/PAM:LegalPersonPartyLegalEntity/xhb:CompanyID)) = count(PAM:Power/PAM:RepresentationGrantedToMandatee/PAM:LegalPersonPartyLegalEntity/xhb:CompanyID)">
               <xsl:attribute name="id">BR10.09</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A mandate, power, mandator and mandatee must have an unique identifier.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="PAM:ProvidesMandate[PAM:LifeSpanPeriod/xhb:EndDate] | PAM:RequestsMandate[PAM:LifeSpanPeriod/xhb:EndDate]"
                 priority="1001"
                 mode="M6">
      <xsl:variable name="currentDate" select="substring-before(string(fn:current-date()), '+')"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(PAM:LifeSpanPeriod/xhb:EndDate &gt; $currentDate) or (not(PAM:LifeSpanPeriod/xhb:EndDate &gt; $currentDate) and PAM:Mandator/PAM:Power/xhb:StatusTypeStatusCode = 'STRUCK-OFF')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(PAM:LifeSpanPeriod/xhb:EndDate &gt; $currentDate) or (not(PAM:LifeSpanPeriod/xhb:EndDate &gt; $currentDate) and PAM:Mandator/PAM:Power/xhb:StatusTypeStatusCode = 'STRUCK-OFF')">
               <xsl:attribute name="id">BR17</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>If the lifeSpan of the Mandate is over, the Power Status must be "Struck Off".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="PAM:SystemIdentifier" priority="1000" mode="M6">
      <xsl:variable name="identifier" select="normalize-space(xhb:ID/text())"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="fn:matches($identifier, '[a-zA-Z][a-zA-Z]-[0-9]+-[0-9]+')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="fn:matches($identifier, '[a-zA-Z][a-zA-Z]-[0-9]+-[0-9]+')">
               <xsl:attribute name="id">BR23</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The ID of a system´s  endpoint should follow the following pattern "Agent" + "-" + "Number". E.g. AT-001-001.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
</xsl:stylesheet>