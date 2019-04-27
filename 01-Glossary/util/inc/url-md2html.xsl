<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:sembu="http://www.everis.com/sembu/glossary/ods2iso11179#"
extension-element-prefixes="sembu">
    
    <!-- 
        Given a string containing a markdown URL with the pattern [text](URL), the template `sembu:url` returns 
        the same string with the URL converted to an HTML `<a href="url">text</a>`. 
    -->

    <xsl:template name="sembu:url">
		<xsl:param name="line"/>
		<xsl:value-of select="sembu:noURL($line)[1]"/>
		<xsl:text disable-output-escaping="yes">&lt;a href=&quot;</xsl:text>
		<xsl:value-of select="sembu:a($line)"/>
		<xsl:text disable-output-escaping="yes">&quot;&gt;</xsl:text>
		<xsl:value-of select="sembu:href($line)"/>
		<xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
		<xsl:value-of select="sembu:noURL($line)[2]"/>		
	</xsl:template>

    <xsl:function name="sembu:a">
		<xsl:param name="line"/>
		<xsl:analyze-string select="$line" regex="\s*\([^)]*\)">
				<xsl:matching-substring>
					<xsl:value-of select="substring(regex-group(0),2,string-length(regex-group(0))-2)"/>
              </xsl:matching-substring>
			</xsl:analyze-string>
	</xsl:function>

	<xsl:function name="sembu:noURL">
		<xsl:param name="line"/>
		<xsl:sequence select="(substring-before($line, '['), substring-after($line, ')'))"/>
	</xsl:function>

	<xsl:function name="sembu:href">
		<xsl:param name="line"/>
			<xsl:analyze-string select="$line" regex="\s*\[[^)]*\]">
				<xsl:matching-substring>
					<xsl:value-of select="substring(
							substring-after(regex-group(0), '['), 1,
							string-length(substring-after(regex-group(0), '['))-1)"/>
              </xsl:matching-substring>
			</xsl:analyze-string>
	</xsl:function>	

</xsl:stylesheet>