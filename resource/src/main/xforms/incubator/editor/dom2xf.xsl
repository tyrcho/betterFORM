<xsl:stylesheet version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:xf="http://www.w3.org/2002/xforms"
                xmlns:ev="http://www.w3.org/2001/xml-events"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
    <!-- author: Joern Turner -->
    <!-- author: Lars Windauer -->


    <xsl:template match="/*">
        <div id="xforms">
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="*[@data-xf-type]"  priority="10">
        <xsl:variable name="curr" select="."/>
        <xsl:element name="{concat('xf:',@data-xf-type)}" namespace="http://www.w3.org/2002/xforms">
            <xsl:if test="exists(@oid)">
                <xsl:attribute name="oid"><xsl:value-of select="@oid"/></xsl:attribute>
            </xsl:if>
            <xsl:variable name="attrs" select="normalize-space(substring-after(substring-before(@data-xf-attrs,'}'),'{'))"/>
            <xsl:if test="string-length($attrs) != 0">
                <xsl:for-each select="tokenize($attrs,',')">
                    <xsl:variable name="thisAttr"><xsl:value-of select="normalize-space(.)"/></xsl:variable>                    
                    <xsl:variable name="quotedValue" select="substring-after($thisAttr,':')"/>
                    <xsl:variable name="unquoted">                        
                        <xsl:value-of select="substring($quotedValue,2,string-length($quotedValue)-2)"/>
                    </xsl:variable>
                    <!--<xsl:message>unquoted: <xsl:value-of select="$unquoted"/></xsl:message>-->
                    <xsl:if test="string-length($unquoted) != 0">
                        <xsl:variable name="xfAttrName">
                            <xsl:choose>
                                <xsl:when test="starts-with($thisAttr, '&#34;')">
                                    <xsl:value-of select=" substring-before(substring-after(substring-before($thisAttr,':'),'&#34;'),'&#34;')"/>
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="substring-before($thisAttr,':')"/> </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$xfAttrName = 'event'">
                                <xsl:attribute name="{concat('ev:',$xfAttrName)}"><xsl:value-of select="$unquoted"/></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{$xfAttrName}"><xsl:value-of select="$unquoted"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>

                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="*/*[@class='textNode']">
                <xsl:copy-of select="*/*[@class='textNode']/* | */*[@class='textNode']/text()"/>
            </xsl:if>
            <xsl:apply-templates  />
        </xsl:element>
    </xsl:template>


    <xsl:template match="*[@data-xf-type='document']" priority="30">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="*">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="text()"/>
</xsl:stylesheet>
