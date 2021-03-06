<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (c) 2011. betterForm Project - http://www.betterform.de
  ~ Licensed under the terms of BSD License
  -->

<xsl:stylesheet version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xf="http://www.w3.org/2002/xforms"
                xmlns:bf="http://betterform.sourceforge.net/xforms"
                xmlns:bfc="http://betterform.sourceforge.net/xforms/controls"
                exclude-result-prefixes="xhtml xf bf bfc"
                xpath-default-namespace="http://www.w3.org/1999/xhtml">

    <!-- ####################################################################################################### -->
    <!-- This stylesheet handles the XForms UI constructs [XForms 1.0, Chapter 9]'group', 'repeat' and           -->
    <!-- 'switch' and offers some standard interpretations for the appearance attribute.                         -->
    <!-- author: joern turner                                                                                    -->
    <!-- author: lars windauer                                                                                   -->
    <!-- ####################################################################################################### -->

    <xsl:param name="betterform-pseudo-item" select="'betterform-pseudo-item'"/>
    <!-- ############################################ PARAMS ################################################### -->
    <!-- ##### should be declared in dojo.xsl ###### -->
    <!-- ############################################ VARIABLES ################################################ -->


    <xsl:preserve-space elements="*"/>

    <!-- ####################################################################################################### -->
    <!-- #################################### DIALOG ########################################################### -->
    <!-- ####################################################################################################### -->

    <xsl:template match="bfc:dialog" name="dialog" priority="10">
        <xsl:variable name="dialog-id" select="@id"/>
        <xsl:variable name="dialog-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dialog-label">
            <xsl:call-template name="create-label">
                <xsl:with-param name="label-elements" select="xf:label"/>
            </xsl:call-template>
        </xsl:variable>

        <span id="{$dialog-id}" class="{$dialog-classes}" dojoType="betterform.ui.container.Dialog"
              title="{$dialog-label}">

            <xsl:call-template name="copy-style-attribute"/>

            <xsl:apply-templates select="*[not(self::xf:label)] | text()"/>

        </span>
    </xsl:template>

    <xsl:template match="bfc:dialog" mode="compact-repeat" priority="10">
        <xsl:variable name="dialog-id" select="@id"/>
        <xsl:variable name="dialog-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dialog-label">
            <xsl:call-template name="create-label">
                <xsl:with-param name="label-elements" select="xf:label"/>
            </xsl:call-template>
        </xsl:variable>

        <span id="{$dialog-id}" class="{$dialog-classes}" dojoType="betterform.ui.container.Dialog"
              title="{$dialog-label}">

            <xsl:call-template name="copy-style-attribute"/>

            <xsl:apply-templates select="*[not(self::xf:label)] | text()" mode="#current"/>

        </span>
    </xsl:template>

    <xsl:template match="bfc:dialog" mode="repeated-compact-prototype" priority="10">
        <xsl:variable name="dialog-id" select="@id"/>
        <xsl:variable name="dialog-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dialog-label">
            <xsl:call-template name="create-label">
                <xsl:with-param name="label-elements" select="xf:label"/>
            </xsl:call-template>
        </xsl:variable>

        <button dojoType="dijit.form.Button" id="{$dialog-id}-button" type="button" iconClass="dijitIconSearch"
                showLabel="false" onCLick="show{$dialog-id}Dialog()">
            <script type="dojo/method" event="onClick">alert("Ronald");</script>

            <xsl:choose>
                <xsl:when test="@button-label">
                    <xsl:value-of select="@button-label"/>
                </xsl:when>
                <xsl:otherwise>Open Dialog</xsl:otherwise>
            </xsl:choose>
        </button>

        <span id="{$dialog-id}" dojoType="betterform.ui.container.Dialog" title="{$dialog-label}">
            <xsl:attribute name="class" select="concat($dialog-classes,' xfRepeated')"/>
            <xsl:attribute name="controlType" select="local-name()"/>
            <xsl:attribute name="appearance" select="@appearance"/>

            <xsl:call-template name="copy-style-attribute"/>

            <xsl:apply-templates select="*[not(self::xf:label)] | text()" mode="#current"/>

        </span>
    </xsl:template>

    <!-- ####################################################################################################### -->
    <!-- #################################### GROUPS ########################################################### -->
    <!-- ####################################################################################################### -->

    <xsl:template match="xf:group" name="group" priority="10">
        <xsl:variable name="group-id" select="@id"/>
        <xsl:variable name="group-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="group-body">
            <xsl:with-param name="group-id" select="$group-id"/>
            <xsl:with-param name="group-classes" select="$group-classes"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="group-body">
        <xsl:param name="group-id"/>
        <xsl:param name="group-classes"/>
        <xsl:param name="group-label" select="true()"/>


        <div id="{$group-id}" class="{$group-classes}" dojoType="betterform.ui.container.Group">

            <xsl:call-template name="copy-style-attribute"/>

            <span class="xfGroupLabel">
                <xsl:choose>
                    <xsl:when test="$group-label and xf:label">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat($group-id, '-label')"/>
                        </xsl:attribute>
                        <xsl:attribute name="class">
                            <xsl:call-template name="assemble-group-label-classes"/>
                        </xsl:attribute>
                        <xsl:call-template name="create-label">
                            <xsl:with-param name="label-elements" select="xf:label"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style">display:none;</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </span>

            <xsl:apply-templates select="*[not(self::xf:label)] | text()"/>
        </div>
    </xsl:template>

    <xsl:template name="group-body-repeated">
        <xsl:param name="group-id"/>
        <xsl:param name="group-classes"/>
        <xsl:param name="group-label" select="true()"/>

        <div id="{$group-id}" class="{$group-classes}" controlType="{local-name()}">
            <div class="xfGroupLabel">
                <xsl:choose>
                    <xsl:when test="$group-label and xf:label">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat($group-id, '-label')"/>
                        </xsl:attribute>
                        <xsl:attribute name="class">
                            <xsl:call-template name="assemble-group-label-classes"/>
                        </xsl:attribute>
                        <xsl:call-template name="create-label">
                            <xsl:with-param name="label-elements" select="xf:label"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style">display:none;</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </div>

            <xsl:apply-templates select="*[not(self::xf:label)]" mode="repeated-full-prototype"/>
        </div>
    </xsl:template>


    <!-- ######################################################################################################## -->
    <!-- ####################################### custom group with vertical layout ############################## -->
    <!-- ######################################################################################################## -->

    <xsl:template match="xf:group[@appearance='bf:verticalTable']" priority="15">
        <xsl:variable name="group-id" select="@id"/>

        <xsl:variable name="mip-classes">
            <xsl:call-template name="get-mip-classes"/>
        </xsl:variable>


        <xsl:variable name="bfGroupLabelLeft"> </xsl:variable>
        <table cellspacing="0" cellpadding="0" class="xfContainer bfVerticalTable {$mip-classes}" id="{$group-id}"
               dojoType="betterform.ui.container.Group">
            <xsl:if test="exists(xf:label)">
                <caption class="xfGroupLabel">
                    <xsl:apply-templates select="./xf:label"/>
                </caption>
            </xsl:if>
            <tbody>
                <xsl:for-each select="*[not(local-name()='label')]">
                    <xsl:choose>
                        <!-- if we got a group with appearance bf:GroupLabelLeft we put the label
                of the first control into the lefthand column -->
                        <xsl:when test="local-name()='group' and ./@appearance='bf:GroupLabelLeft'">
                            <tr class="bfGroupLabelLeft">
                                <td>
                                    <!-- use the label of the nested group for the left column -->
                                    <xsl:value-of select="xf:label"/>
                                </td>
                                <td>
                                    <xsl:apply-templates select="."/>
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:when test="local-name()='group' or local-name()='repeat' or local-name()='switch'">
                            <tr>
                                <td colspan="3">
                                    <xsl:apply-templates select="."/>
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:when test="namespace-uri()='http://www.w3.org/1999/xhtml'">
                            <tr>
                                <td colspan="3">
                                    <xsl:apply-templates select="."/>
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="exists(node())">
                                <tr>
                                    <td class="bfVerticalTableLabel" valign="top">
                                        <xsl:variable name="label-classes">
                                            <xsl:call-template name="assemble-label-classes"/>
                                        </xsl:variable>
                                        <xsl:if test="local-name(.) != 'trigger'">
                                            <label id="{@id}-label" for="{@id}-value" class="{$label-classes}">
                                                <xsl:apply-templates select="xf:label"/>
                                            </label>
                                        </xsl:if>
                                    </td>
                                    <td class="bfVerticalTableValue" valign="top">
                                        <xsl:apply-templates select="." mode="table"/>
                                    </td>
                                    <td class="bfVerticalTableInfo" valign="top">
                                        <xsl:apply-templates select="xf:alert"/>
                                        <xsl:apply-templates select="xf:hint"/>
                                        <xsl:apply-templates select="xf:help"/>
                                        <span class="info" style="display:none;" id="{concat(@id,'-info')}">ok</span>
                                    </td>
                                </tr>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>


    <xsl:template match="xf:trigger" mode="table">
        <xsl:variable name="control-classes">
            <xsl:call-template name="assemble-control-classes">
                <!--<xsl:with-param name="appearance" select="@appearance"/>-->
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="trigger">
            <xsl:with-param name="classes" select="$control-classes"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template
            match="xf:input|xf:output|xf:range|xf:secret|xf:select|xf:select1|xf:textarea|xf:upload"
            mode="table">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="control-classes">
            <xsl:call-template name="assemble-control-classes">
                <!--<xsl:with-param name="appearance" select="@appearance"/>-->
            </xsl:call-template>
        </xsl:variable>

        <div id="{$id}"
             dojoType="betterform.ui.Control"
             class="{$control-classes}">
            <xsl:call-template name="copy-style-attribute"/>
            <xsl:call-template name="buildControl"/>
            <xsl:copy-of select="xhtml:script"/>
        </div>
    </xsl:template>
    <!--<xsl:template match="bf:data" mode="table" priority="10"/>-->

    <!-- ######################################################################################################## -->
    <!-- ####################################### custom group with horizontal layout ############################## -->
    <!-- ######################################################################################################## -->

    <!-- appearance ColumnLeft allows to be nested into a verticalTable and display its labels in the left
    column of the vertical table. All other controls will be wrapped in a horizontal group and be written to the
    right column. -->
    <xsl:template match="xf:group[@appearance='bf:GroupLabelLeft']" priority="15">
        <xsl:call-template name="copy-style-attribute"/>
        <xsl:call-template name="horizontalTable"/>
    </xsl:template>

    <!-- this template is used for horizontalTable AND for ColumnLeft appearance -->
    <xsl:template match="xf:group[@appearance='bf:horizontalTable']" priority="15" name="horizontalTable">
        
        <xsl:variable name="mip-classes">
            <xsl:call-template name="get-mip-classes"/>
        </xsl:variable>


        <table id="{@id}" class="xfContainer bfHorizontalTable {$mip-classes}" dojoType="betterform.ui.container.Group">
            <tr>
                <td colspan="{count(*[position() &gt; 1])}" class="xfGroupLabel">
                    <xsl:if test="exists(xf:label) and @appearance !='bf:GroupLabelLeft'">
                        <xsl:apply-templates select="./xf:label"/>
                    </xsl:if>
                </td>
            </tr>
            <tr>
                <xsl:for-each select="*[position() &gt; 1]">
                    <td class="bfHorizontalTableLabel  bfTableCol{position()}">
                        <xsl:if test="local-name(.) != 'trigger'">
                            <label id="{@id}-label" for="{@id}-value" class="bfTableLabel">
                                <xsl:apply-templates select="xf:label"/>
                            </label>
                        </xsl:if>
                    </td>
                </xsl:for-each>
            </tr>
            <tr>
                <xsl:for-each select="*[position() &gt; 1 and *[position() != last()]]">
                    <td class="bfHorizontalTableValue">
                        <xsl:apply-templates select="."/>
                    </td>
                </xsl:for-each>
            </tr>
        </table>
    </xsl:template>

    <xsl:template match="bf:data" priority="10"/>
    <!-- ######################################################################################################## -->
    <!-- ####################################### REPEAT ######################################################### -->
    <!-- ######################################################################################################## -->
    <!-- ### COMPACT REPEAT ### -->
    <xsl:template match="xf:repeat[@appearance='compact']" name="compact-repeat">
        <xsl:variable name="repeat-id" select="@id"/>
        <xsl:variable name="repeat-index" select="bf:data/@bf:index"/>
        <xsl:variable name="repeat-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="'compact'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="not(ancestor::xf:repeat)">
            <!-- generate prototype(s) for scripted environment -->
            <xsl:for-each select="bf:data/xf:group[@appearance='repeated']">
                <xsl:call-template name="processCompactPrototype">
                    <xsl:with-param name="id" select="$repeat-id"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="bf:data/xf:group[@appearance='repeated']//xf:repeat">
                <xsl:call-template name="processRepeatPrototype"/>
            </xsl:for-each>
            <xsl:for-each select="bf:data/xf:group[@appearance='repeated']//xf:itemset">
                <xsl:call-template name="processItemsetPrototype"/>
            </xsl:for-each>
        </xsl:if>


        <table repeatId="{$repeat-id}"
               jsId="{$repeat-id}"
               class="{$repeat-classes}"
               dojoType="betterform.ui.container.Repeat"
               appearance="compact"
               border="0"
               cellpadding="0"
               cellspacing="0"
                >
            <!-- build table header -->
            <!-- <xsl:for-each select="bf:data/xf:group[@appearance='repeated'][1]"> -->
            <!-- Don´t use Prototype for RepeatHeader but first Repeatitem -->
            <xsl:for-each select="xf:group[@appearance='repeated'][1]">
                <tr class="xfRepeatHeader">
                    <xsl:call-template name="processCompactHeader"/>
                </tr>
            </xsl:for-each>

            <!-- loop repeat entries -->
            <xsl:for-each select="xf:group[@appearance='repeated']">
                <xsl:variable name="id" select="@id"/>
                <xsl:variable name="repeat-item-classes">
                    <xsl:call-template name="assemble-repeat-item-classes">
                        <xsl:with-param name="selected" select="$repeat-index=position()"/>
                    </xsl:call-template>
                </xsl:variable>

                <tr repeatItemId="{$id}"
                    class="{$repeat-item-classes}"
                    dojoType="betterform.ui.container.RepeatItem"
                    appearance="compact">
                    <xsl:call-template name="processCompactChildren"/>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>

    <!-- header for compact repeat -->
    <xsl:template name="processCompactHeader">
        <xsl:for-each select="xf:*|bfc:*">
            <xsl:variable name="col-classes">
                <xsl:choose>
                    <xsl:when test="./bf:data/@bf:enabled='false'">
                        <xsl:value-of select="concat('bfTableCol-',position(),' ','xfDisabled')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('bfTableCol-',position())"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <td class="{$col-classes}">


                <xsl:choose>
                    <xsl:when
                            test="self::xf:*[local-name(.)='trigger' or local-name(.)='submit' or (local-name(.)='output' and @appearance='caLink')][xf:label]">
                        <xsl:variable name="label-classes">
                            <xsl:call-template name="assemble-label-classes"/>
                        </xsl:variable>
                        <label id="{@id}-label-header" class="{$label-classes}">
                            <!-- Needed for IE and Chrome to size the label -->
                            <xsl:call-template name="copy-style-attribute"/>
                            <xsl:value-of select="xf:label/@header"/>
                        </label>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="label-classes">
                            <xsl:call-template name="assemble-label-classes"/>
                        </xsl:variable>

                        <label id="{@id}-label" class="{$label-classes}">
                            <xsl:attribute name="title">
                                <xsl:call-template name="create-label">
                                    <xsl:with-param name="label-elements" select="xf:label"/>
                                </xsl:call-template>
                            </xsl:attribute>

                            <!-- Needed for IE and Chrome to size the label
                            -->
                            <xsl:call-template name="copy-style-attribute"/>
                            <xsl:call-template name="create-label">
                                <xsl:with-param name="label-elements" select="xf:label"/>
                            </xsl:call-template>
                        </label>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </xsl:for-each>
    </xsl:template>

    <!-- prototype for compact repeat -->
    <xsl:template name="processCompactPrototype">
        <xsl:param name="id"/>

        <table style="display:none;">
            <tr class="xfRepeatHeader">
                <!-- build table header -->
                <!-- <xsl:for-each select="bf:data/xf:group[@appearance='repeated'][1]"> -->
                <!-- Don´t use Prototype for RepeatHeader but first Repeatitem -->
                <xsl:for-each select="xf:group[@appearance='repeated'][1]">
                    <xsl:call-template name="processCompactHeader"/>
                </xsl:for-each>
            </tr>
            <tr id="{$id}-prototype" class="xfRepeatPrototype xfDisabled xfReadWrite xfOptional xfValid">
                <xsl:for-each select="xf:*">
                    <xsl:variable name="col-classes">
                        <xsl:choose>
                            <xsl:when test="./bf:data/@bf:enabled='false'">
                                <xsl:value-of select="concat('bfTableCol-',position(),' ','xfDisabled')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('bfTableCol-',position())"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <td valign="top" class="{$col-classes}">
                        <xsl:apply-templates select="." mode="repeated-compact-prototype"/>
                    </td>
                </xsl:for-each>
            </tr>
        </table>
    </xsl:template>

    <!-- overridden control template for compact repeat -->
    <xsl:template
            match="xf:input|xf:output|xf:range|xf:secret|xf:select|xf:select1|xf:textarea|xf:upload"
            mode="repeated-compact-prototype" priority="10">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="control-classes">
            <xsl:call-template name="assemble-control-classes"/>
        </xsl:variable>

        <xsl:variable name="htmlElem">
            <xsl:choose>
                <xsl:when test="local-name()='output'">span</xsl:when>
                <xsl:otherwise>div</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="incrementaldelay">
            <xsl:value-of select="if (exists(@bf:incremental-delay)) then @bf:incremental-delay else 'undef'"/>
        </xsl:variable>

        <xsl:element name="{$htmlElem}">
            <xsl:attribute name="id" select="$id"/>
            <xsl:attribute name="class" select="concat($control-classes,' xfRepeated')"/>
            <xsl:attribute name="controlType" select="local-name()"/>
            <xsl:attribute name="appearance" select="@appearance"/>
            <xsl:attribute name="dojoAttachEvent">onfocus:_onFocus</xsl:attribute>
            <xsl:if test="$incrementaldelay ne 'undef'">
                <xsl:message>
                    <xsl:value-of select="concat(' incremental-delay: ', $incrementaldelay)"/>
                </xsl:message>
                <xsl:attribute name="delay" select="$incrementaldelay"/>
            </xsl:if>

            <xsl:call-template name="copy-style-attribute"/>

            <xsl:choose>
                <xsl:when test="'output' = local-name() and exists(@mediatype)">
                    <xsl:attribute name="mediatype" select="@mediatype"/>
                </xsl:when>
                <xsl:when test="'select' = local-name()">
                    <xsl:call-template name="select"/>
                </xsl:when>
                <xsl:when test="'select1' = local-name()">
                    <xsl:call-template name="select1"/>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="xf:alert"/>
            <xsl:apply-templates select="xf:hint"/>
            <xsl:apply-templates select="xf:help"/>

        </xsl:element>

    </xsl:template>

    <xsl:template match="xf:group" mode="repeated-compact-prototype" priority="10">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="control-classes">
            <xsl:call-template name="assemble-control-classes"/>
        </xsl:variable>
        <xsl:variable name="appearance" select="@appearance"/>

        <xsl:variable name="htmlElem">
            <xsl:choose>
                <xsl:when test="$appearance='minimal'">span</xsl:when>
                <xsl:otherwise>div</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <xsl:element name="{$htmlElem}">
            <xsl:attribute name="id" select="$id"/>
            <xsl:attribute name="class" select="concat($control-classes,' xfRepeated')"/>
            <xsl:attribute name="controlType" select="local-name()"/>
            <xsl:attribute name="appearance" select="$appearance"/>
            <xsl:attribute name="dojoAttachEvent">onfocus:_onFocus</xsl:attribute>
            <xsl:call-template name="copy-style-attribute"/>
            <!-- prevent xf:label for groups within compact repeat-->
            <xsl:apply-templates select="*[not(self::xf:label)]" mode="repeated-compact-prototype"/>
        </xsl:element>

    </xsl:template>

    <xsl:template match="xf:switch" mode="repeated-compact-prototype" priority="10">
        <xsl:variable name="switch-id" select="@id"/>
        <xsl:variable name="switch-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>
        <div id="{$switch-id}" class="{$switch-classes}" dojoType="betterform.ui.container.Switch">
            <xsl:apply-templates mode="repeated-compact-prototype"/>
        </div>
    </xsl:template>


    <xsl:template match="xf:case[bf:data/@bf:selected='true']" mode="repeated-compact-prototype" priority="10">
        <xsl:variable name="case-id" select="@id"/>
        <xsl:variable name="case-classes" select="'xfCase xfSelectedCase'"/>

        <div id="{$case-id}" class="{$case-classes}">
            <xsl:apply-templates select="*[not(self::xf:label)]" mode="repeated-compact-prototype"/>
        </div>
    </xsl:template>

    <!-- ### DE-SELECTED/NON-SELECTED CASE ### -->
    <xsl:template match="xf:case" mode="repeated-compact-prototype" priority="10">
        <!-- render only in scripted environment -->
        <xsl:variable name="case-id" select="@id"/>
        <xsl:variable name="case-classes" select="'xfCase xfDeselectedCase'"/>

        <div id="{$case-id}" class="{$case-classes}">
            <xsl:apply-templates select="*[not(self::xf:label)]" mode="repeated-compact-prototype"/>
        </div>
    </xsl:template>


    <xsl:template match="xf:repeat" mode="repeated-compact-prototype" priority="10">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="control-classes">
            <xsl:call-template name="assemble-control-classes"/>
        </xsl:variable>
        <table id="{$id}" class="{$control-classes} xfRepeated" controlType="{local-name()}" appearance="{@appearance}"
               dojoAttachEvent='onfocus:_onFocus' repeatId="{$id}">
            <tr class="xfRepeatHeader">
                <xsl:call-template name="processCompactHeader"/>
            </tr>
        </table>
    </xsl:template>


    <xsl:template match="xf:trigger" mode="repeated-compact-prototype" priority="10">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="appearance">
            <xsl:choose>
                <xsl:when test="string-length(@appearance) &gt;0">
                    <xsl:value-of select="@appearance"/>
                </xsl:when>
                <xsl:otherwise>full</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="control-classes">
            <xsl:call-template name="assemble-control-classes"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists(@ref) or exists(@bind)">
                <div id="{$id}" class="{$control-classes} xfRepeated" controlType="{local-name()}"
                     appearance="{$appearance}">
                    <xsl:call-template name="create-label">
                        <xsl:with-param name="label-elements" select="xf:label"/>
                    </xsl:call-template>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div id="{$id}" class="{$control-classes} xfRepeated" unbound="true">
                    <div id="{$id}-value" class="xfValue" appearance="{$appearance}" controlType="trigger"
                         label="{xf:label}" name="d_{$id}" title="" navindex="" accesskey="" source=""></div>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
            match="xf:input|xf:output|xf:range|xf:secret|xf:select|xf:select1|xf:textarea|xf:upload"
            mode="repeated-full-prototype"
            priority="20">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="control-classes">
            <xsl:call-template name="assemble-control-classes"/>
        </xsl:variable>

        <xsl:variable name="htmlElem">
            <xsl:choose>
                <xsl:when test="local-name()='output'">span</xsl:when>
                <xsl:otherwise>div</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="{$htmlElem}">
            <xsl:attribute name="id" select="$id"/>
            <xsl:attribute name="class" select="concat($control-classes,' xfRepeated')"/>
            <xsl:attribute name="controlType" select="local-name()"/>
            <xsl:attribute name="appearance" select="@appearance"/>
            <xsl:attribute name="title" select="normalize-space(xf:hint)"/>
            <xsl:attribute name="dojoAttachEvent">onfocus:_onFocus</xsl:attribute>

            <xsl:if test="'output' = local-name() and exists(@mediatype)">
                <xsl:attribute name="mediatype" select="@mediatype"/>
            </xsl:if>
            <label class="xfLabel">
                <xsl:call-template name="create-label">
                    <xsl:with-param name="label-elements" select="xf:label"/>
                </xsl:call-template>
            </label>

            <!--<xsl:apply-templates select="xf:alert"/>-->
            <xsl:choose>
                <xsl:when test="'select' = local-name()">
                    <xsl:call-template name="select"/>
                    <!--<xsl:apply-templates select="xf:alert"/>-->
                </xsl:when>
                <xsl:when test="'select1' = local-name()">
                    <xsl:call-template name="select1"/>
                    <!--<xsl:apply-templates select="xf:alert"/>-->
                </xsl:when>
            </xsl:choose>

            <xsl:apply-templates select="xf:alert"/>
            <xsl:apply-templates select="xf:hint"/>
            <xsl:apply-templates select="xf:help"/>

        </xsl:element>
    </xsl:template>

    <xsl:template match="xf:group"
                  mode="repeated-full-prototype"
                  priority="10">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="appearance" select="@appearance"/>

        <xsl:variable name="htmlElem">
            <xsl:choose>
                <xsl:when test="$appearance='minimal'">span</xsl:when>
                <xsl:otherwise>div</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="group-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:element name="{$htmlElem}">
            <xsl:attribute name="id" select="$id"/>
            <xsl:attribute name="class" select="concat($group-classes,' xfRepeated dijitContentPane')"/>
            <xsl:attribute name="controlType" select="local-name()"/>
            <xsl:attribute name="appearance" select="$appearance"/>
            <xsl:attribute name="dojoAttachEvent">onfocus:_onFocus</xsl:attribute>

            <xsl:element name="{$htmlElem}">
                <xsl:attribute name="class">xfGroupLabel</xsl:attribute>
                <xsl:call-template name="create-label">
                    <xsl:with-param name="label-elements" select="xf:label"/>
                </xsl:call-template>
            </xsl:element>

            <xsl:apply-templates select="*[not(self::xf:label)]" mode="repeated-full-prototype"/>
        </xsl:element>


    </xsl:template>

    <xsl:template match="xf:switch"
                  mode="repeated-full-prototype"
                  priority="10">
        <xsl:variable name="switch-id" select="@id"/>
        <xsl:variable name="switch-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>
        <div id="{$switch-id}" class="{$switch-classes}" dojoType="betterform.ui.container.Switch">
            <xsl:apply-templates mode="repeated-full-prototype"/>
        </div>
    </xsl:template>


    <xsl:template match="xf:case[bf:data/@bf:selected='true']"
                  mode="repeated-full-prototype"
                  priority="10">
        <xsl:variable name="case-id" select="@id"/>
        <xsl:variable name="case-classes" select="'xfCase xfSelectedCase'"/>

        <div id="{$case-id}" class="{$case-classes}">
            <xsl:apply-templates select="*[not(self::xf:label)]" mode="repeated-full-prototype"/>
        </div>
    </xsl:template>

    <!-- ### DE-SELECTED/NON-SELECTED CASE ### -->
    <xsl:template match="xf:case"
                  mode="repeated-full-prototype"
                  priority="10">
        <!-- render only in scripted environment -->
        <xsl:variable name="case-id" select="@id"/>
        <xsl:variable name="case-classes" select="'xfCase xfDeselectedCase'"/>

        <div id="{$case-id}" class="{$case-classes}">
            <xsl:apply-templates select="*[not(self::xf:label)]" mode="repeated-full-prototype"/>
        </div>
    </xsl:template>

    <xsl:template match="xf:repeat"
                  mode="repeated-full-prototype"
                  priority="10">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="control-classes">
            <xsl:call-template name="assemble-control-classes"/>
        </xsl:variable>

        <div id="{$id}" class="{$control-classes} xfRepeated" controlType="{local-name()}" appearance="{@appearance}"
             dojoAttachEvent='onfocus:_onFocus' repeatId="{$id}">
        </div>
    </xsl:template>

    <xsl:template match="xf:trigger" mode="repeated-full-prototype" priority="10">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="appearance">
            <xsl:choose>
                <xsl:when test="string-length(@appearance) &gt;0">
                    <xsl:value-of select="@appearance"/>
                </xsl:when>
                <xsl:otherwise>full</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="control-classes">
            <xsl:call-template name="assemble-control-classes"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists(@ref) or exists(@bind)">
                <div id="{$id}" class="{$control-classes} xfRepeated" controlType="{local-name()}"
                     appearance="{$appearance}">
                    <xsl:value-of select="xf:label"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div id="{$id}" class="{$control-classes} xfRepeated" unbound="true">
                    <div id="{$id}-value" class="xfValue" appearance="{$appearance}" controlType="trigger"
                         label="{xf:label}" name="d_{$id}" title="" navindex="" accesskey="" source=""></div>
                </div>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- copys non xform nodes into the full protoype -->
    <xsl:template match="xhtml:*"
                  mode="repeated-full-prototype"
                  priority="1">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="repeated-full-prototype"/>
        </xsl:copy>
    </xsl:template>


    <!-- children for compact repeat -->
    <xsl:template name="processCompactChildren">
        <xsl:for-each select="xf:*|bfc:*">
            <xsl:variable name="col-classes">
                <xsl:choose>
                    <xsl:when test="./bf:data/@bf:enabled='false'">
                        <xsl:value-of select="concat('bfTableCol-',position(),' ','xfDisabled')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('bfTableCol-',position())"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <td valign="top" class="{$col-classes}">
                <xsl:apply-templates select="." mode="compact-repeat"/>
            </td>
        </xsl:for-each>
    </xsl:template>

    <!-- overridden control template for compact repeat -->
    <xsl:template
            match="xf:input|xf:output|xf:range|xf:secret|xf:select|xf:select1|xf:textarea|xf:upload"
            mode="compact-repeat">
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="control-classes">
            <xsl:call-template name="assemble-control-classes"/>
        </xsl:variable>

        <div id="{$id}" class="{$control-classes} xfRepeated" dojoType="betterform.ui.Control"
             dojoAttachEvent='onfocus:_onFocus'>
            <xsl:call-template name="copy-style-attribute"/>
            <label for="{$id}-value" id="{$id}-label" style="display:none">
                <xsl:call-template name="create-label">
                    <xsl:with-param name="label-elements" select="xf:label"/>
                </xsl:call-template>
            </label>

            <xsl:call-template name="buildControl"/>
            <xsl:apply-templates select="xf:alert"/>
            <xsl:apply-templates select="xf:hint"/>
            <xsl:apply-templates select="xf:help"/>


        </div>
    </xsl:template>

    <!-- overridden group template for compact repeat -->
    <xsl:template match="xf:group" mode="compact-repeat">
        <xsl:variable name="group-id" select="@id"/>
        <xsl:variable name="group-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="group-body">
            <xsl:with-param name="group-id" select="$group-id"/>
            <xsl:with-param name="group-classes" select="$group-classes"/>
            <xsl:with-param name="group-label" select="false()"/>
        </xsl:call-template>
    </xsl:template>

    <!-- overridden dialog template for compact repeat -->
    <!-- It is in fact the same as the normal one but due to the mode it needs to be copied -->
    <xsl:template match="bfc:dialog" mode="compact-repeat">
        <xsl:call-template name="dialog"/>
    </xsl:template>


    <!-- default templates for compact repeat -->
    <xsl:template match="xf:*" mode="compact-repeat">
        <xsl:apply-templates select="."/>
    </xsl:template>


    <!-- ### FULL REPEAT ### -->
    <xsl:template match="xf:repeat[@appearance='full']" name="full-repeat">
        <xsl:variable name="repeat-id" select="@id"/>
        <xsl:variable name="repeat-index" select="bf:data/@bf:index"/>
        <xsl:variable name="repeat-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="'full'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="not(ancestor::xf:repeat)">
            <!-- generate prototype(s) for scripted environment -->
            <xsl:for-each select="bf:data/xf:group[@appearance='repeated']">
                <xsl:call-template name="processFullPrototype">
                    <xsl:with-param name="id" select="$repeat-id"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="bf:data/xf:group[@appearance='repeated']//xf:repeat">
                <xsl:call-template name="processRepeatPrototype"/>
            </xsl:for-each>
            <xsl:for-each select="bf:data/xf:group[@appearance='repeated']//xf:itemset">
                <xsl:call-template name="processItemsetPrototype"/>
            </xsl:for-each>
        </xsl:if>


        <div repeatId="{$repeat-id}" class="{$repeat-classes}" dojoType="betterform.ui.container.Repeat">
            <!-- loop repeat entries -->
            <xsl:for-each select="xf:group[@appearance='repeated']">
                <xsl:variable name="repeat-item-id" select="@id"/>
                <xsl:variable name="repeat-item-classes">
                    <xsl:call-template name="assemble-repeat-item-classes">
                        <xsl:with-param name="selected" select="$repeat-index=position()"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="group-label" select="true()"/>

                <div repeatItemId="{$repeat-item-id}"
                     class="{$repeat-item-classes}"
                     dojoType="betterform.ui.container.RepeatItem"
                     appearance="full">
                    <div class="xfGroupLabel">
                        <xsl:choose>
                            <xsl:when test="$group-label and xf:label">
                                <xsl:attribute name="id">
                                    <xsl:value-of select="concat($repeat-item-id, '-label')"/>
                                </xsl:attribute>
                                <xsl:attribute name="class">
                                    <xsl:call-template name="assemble-group-label-classes"/>
                                </xsl:attribute>
                                <xsl:call-template name="create-label">
                                    <xsl:with-param name="label-elements" select="xf:label"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style">display:none;</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>

                    <xsl:apply-templates select="*[not(self::xf:label)]"/>
                </div>

            </xsl:for-each>
        </div>
    </xsl:template>

    <!-- #### caObjectContainer #### -->
    <!--
        <xsl:template match="xf:repeat[@appearance='caRepeatedTab']">
            <xsl:variable name="repeat-id" select="@id"/>
            <xsl:variable name="repeat-index" select="bf:data/@bf:index"/>
            <xsl:variable name="repeat-classes">
                <xsl:call-template name="assemble-compound-classes">
                    <xsl:with-param name="appearance" select="'caObjectContainer'"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:for-each select="bf:data/xf:group[@appearance='repeated']">
                <xsl:call-template name="processFullPrototype">
                    <xsl:with-param name="id" select="$repeat-id"/>
                </xsl:call-template>
            </xsl:for-each>


            <div id="{$repeat-id}" repeatId="{$repeat-id}" class="{$repeat-classes}" dojoType="betterform.ui.container.RepeatTabContainer" doLayout="false">

                <xsl:for-each select="xf:group[@appearance='repeated']">
                    <xsl:variable name="repeat-item-id" select="@id"/>
                    <xsl:variable name="repeat-item-classes">
                        <xsl:call-template name="assemble-repeat-item-classes">
                            <xsl:with-param name="selected" select="$repeat-index=position()"/>
                        </xsl:call-template>
                    </xsl:variable>

                        <xsl:variable name="group-label" select="true()"/>

                        <div repeatItemId="{$repeat-item-id}"
                             class="{$repeat-item-classes}"
                             title="{.//xf:output[1]/bf:data}"
                             appearance="full">
                            <div class="xfGroupLabel">
                                <xsl:choose>
                                    <xsl:when test="$group-label and xf:label">
                                        <xsl:attribute name="id">
                                            <xsl:value-of select="concat($repeat-item-id, '-label')"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="class">
                                            <xsl:call-template name="assemble-group-label-classes"/>
                                        </xsl:attribute>
                                        <xsl:apply-templates select="xf:label"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="style">display:none;</xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>

                            <xsl:apply-templates select="*[not(self::xf:label)]"/>
                        </div>

                </xsl:for-each>
            </div>
        </xsl:template>
    -->


    <!-- prototype for full repeat -->
    <xsl:template name="processFullPrototype">
        <xsl:param name="id"/>

        <xsl:call-template name="group-body-repeated">
            <xsl:with-param name="group-id" select="concat($id, '-prototype')"/>
            <xsl:with-param name="group-classes"
                            select="'xfRepeatPrototype xfDisabled xfReadWrite xfOptional xfValid'"/>
        </xsl:call-template>
    </xsl:template>


    <!-- ### DEFAULT REPEAT ### -->
    <xsl:template match="xf:repeat" name="repeat">
        <!-- full appearance as default -->
        <xsl:call-template name="full-repeat"/>
    </xsl:template>

    <!-- ### FOREIGN NAMESPACE REPEAT ### -->
    <xsl:template match="*[@xf:repeat-bind]|*[@xf:repeat-nodeset]|@repeat-bind|@repeat-nodeset"
                  name="generic-repeat">
        <xsl:variable name="repeat-id" select="@id"/>
        <xsl:variable name="repeat-index" select="bf:data/@bf:index"/>
        <xsl:variable name="repeat-classes">
            <xsl:call-template name="assemble-compound-classes"/>
        </xsl:variable>

        <xsl:element name="{local-name(.)}" namespace="">
            <xsl:attribute name="repeatId"><xsl:value-of select="$repeat-id"/></xsl:attribute>
            <xsl:attribute name="jsId"><xsl:value-of select="@id"/></xsl:attribute>
            <xsl:attribute name="dojoType">betterform.ui.container.Repeat</xsl:attribute>
            <xsl:attribute name="class"><xsl:value-of select="$repeat-classes"/></xsl:attribute>
            <xsl:copy-of select="@*"/>

            <xsl:if test="not(ancestor::xf:repeat)">
                <!-- generate prototype(s) for scripted environment -->
                <xsl:for-each select="bf:data/xf:group[@appearance='repeated']">
                    <xsl:call-template name="processTableRepeatPrototype">
                        <xsl:with-param name="id" select="$repeat-id"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="bf:data/xf:group[@appearance='repeated']//xf:repeat">
                    <xsl:call-template name="processRepeatPrototype"/>
                </xsl:for-each>
                <xsl:for-each select="bf:data/xf:group[@appearance='repeated']//xf:itemset">
                    <xsl:call-template name="processItemsetPrototype"/>
                </xsl:for-each>
            </xsl:if>

            <xsl:for-each select="xf:group[@appearance='repeated']">
                <xsl:variable name="id" select="@id"/>

                <xsl:variable name="repeat-item-classes">
                    <xsl:call-template name="assemble-repeat-item-classes">
                        <xsl:with-param name="selected" select="$repeat-index=position()"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:for-each select="xhtml:tr">

                    <tr repeatItemId="{$id}"
                        class="{$repeat-item-classes}"
                        dojoType="betterform.ui.container.RepeatItem"
                        appearance="compact">
                        <xsl:apply-templates select="*" mode="compact-repeat"/>
                    </tr>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="processTableRepeatPrototype">
        <xsl:param name="id"/>
        <xsl:variable name="col-classes">
            <xsl:choose>
                <xsl:when test="./bf:data/@bf:enabled='false'">
                    <xsl:value-of select="concat('bfTableCol-',position(),' ','xfDisabled')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('bfTableCol-',position())"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="*">
            <xsl:element name="{local-name(.)}" namespace="">
                <xsl:attribute name="id"><xsl:value-of select="$id"/>-prototype</xsl:attribute>
                <xsl:attribute name="class">xfRepeatPrototype xfDisabled xfReadWrite xfOptional xfValid<xsl:value-of select="$col-classes"/></xsl:attribute>
                <xsl:apply-templates select="*" mode="repeated-compact-prototype"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*|@*|text()|comment()" mode="repeated-compact-prototype">
        <xsl:choose>
            <xsl:when test="namespace-uri(.)='http://www.w3.org/1999/xhtml'">
                <xsl:element name="{local-name(.)}" namespace="">
                    <xsl:apply-templates select="*|@*|text()|comment()" mode="repeated-compact-prototype"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="*|@*|text()|comment()" mode="repeated-compact-prototype"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*|@*|text()|comment()" mode="compact-repeat">
        <xsl:choose>
            <xsl:when test="namespace-uri(.)='http://www.w3.org/1999/xhtml'">
                <xsl:element name="{local-name(.)}" namespace="">
                    <xsl:apply-templates select="*|@*|text()|comment()" mode="compact-repeat"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="*|@*|text()|comment()" mode="compact-repeat"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- repeat prototype helper -->
    <xsl:template name="processRepeatPrototype">
        <xsl:variable name="id" select="@id"/>

        <xsl:choose>
            <xsl:when test="@appearance='compact'">
                <xsl:call-template name="processCompactPrototype">
                    <xsl:with-param name="id" select="$id"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processFullPrototype">
                    <xsl:with-param name="id" select="$id"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- itemset prototype helper -->
    <xsl:template name="processItemsetPrototype">
        <xsl:variable name="item-id" select="$betterform-pseudo-item"/>
        <xsl:variable name="itemset-id" select="@id"/>
        <xsl:variable name="name" select="concat($data-prefix,../@id)"/>
        <xsl:variable name="parent" select=".."/>

        <xsl:choose>
            <xsl:when test="local-name($parent)='select1' and $parent/@appearance='full'">
                <xsl:call-template name="build-radiobutton-prototype">
                    <xsl:with-param name="item-id" select="$item-id"/>
                    <xsl:with-param name="itemset-id" select="$itemset-id"/>
                    <xsl:with-param name="name" select="$name"/>
                    <xsl:with-param name="parent" select="$parent"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="local-name($parent)='select' and $parent/@appearance='full'">
                <xsl:call-template name="build-checkbox-prototype">
                    <xsl:with-param name="item-id" select="$item-id"/>
                    <xsl:with-param name="itemset-id" select="$itemset-id"/>
                    <xsl:with-param name="name" select="$name"/>
                    <xsl:with-param name="parent" select="$parent"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="build-item-prototype">
                    <xsl:with-param name="item-id" select="$item-id"/>
                    <xsl:with-param name="itemset-id" select="$itemset-id"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- ######################################################################################################## -->
    <!-- ####################################### SWITCH ######################################################### -->
    <!-- ######################################################################################################## -->

    <!-- ### FULL SWITCH ### -->
    <!--
        Renders a tabsheet. This template requires that the author sticks to an
        authoring convention: The triggers for toggling the different cases MUST
        all appear in a case with id 'switch-toggles'. This convention makes it
        easier to maintain the switch cause all relevant markup is kept under the
        same root element.
    -->

    <!-- ### DEFAULT SWITCH ### -->
    <xsl:template match="xf:switch">
        <xsl:variable name="switch-id" select="@id"/>
        <xsl:variable name="switch-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>


        <div id="{$switch-id}" class="{$switch-classes}" dojoType="betterform.ui.container.Switch">
            <xsl:call-template name="copy-style-attribute"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- ### SELECTED CASE ### -->
    <xsl:template match="xf:case[bf:data/@bf:selected='true']" name="selected-case">
        <xsl:variable name="case-id" select="@id"/>
        <xsl:variable name="case-classes" select="'xfCase xfSelectedCase'"/>

        <div id="{$case-id}" class="{$case-classes}">
            <xsl:apply-templates select="*[not(self::xf:label)]"/>
        </div>
    </xsl:template>

    <!-- ### DE-SELECTED/NON-SELECTED CASE ### -->
    <xsl:template match="xf:case" name="deselected-case">
        <!-- render only in scripted environment -->
        <xsl:variable name="case-id" select="@id"/>
        <xsl:variable name="case-classes" select="'xfCase xfDeselectedCase'"/>

        <div id="{$case-id}" class="{$case-classes}">
            <xsl:apply-templates select="*[not(self::xf:label)]"/>
        </div>
    </xsl:template>


    <xsl:template match="xf:switch[@appearance='dijit:AccordionContainer']">
        <xsl:variable name="switch-id" select="@id"/>
        <xsl:variable name="switch-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>


        <div id="{$switch-id}" class="{$switch-classes} xfSwitch" dojoType="dijit.layout.AccordionContainer"
             duration="200"
             style="float: left; margin-right: 30px; width: 400px; height: 300px; overflow: hidden">
            <xsl:for-each select="xf:case[.//xf:label]">
                <xsl:variable name="label">
                    <xsl:call-template name="create-label">
                        <xsl:with-param name="label-elements" select=".//xf:label"/>
                    </xsl:call-template>
                </xsl:variable>
                <div dojoType="dijit.layout.AccordionPane" selected="{@selected}" title="{$label}">
                    <xsl:apply-templates select="*[not(self::xf:label)]"/>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="xf:switch[@appearance='bf:AccordionContainer']">
        <xsl:variable name="switch-id" select="@id"/>
        <xsl:variable name="switch-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>
        <div style="display:none">
            <xsl:for-each select="xf:case[@name='switch-toggles']/xf:trigger">
                <xsl:call-template name="trigger"/>
            </xsl:for-each>
        </div>

        <div id="{$switch-id}" class="{$switch-classes} xfAccordion" dojoType="betterform.ui.container.AccordionSwitch"
             duration="200">
            <!--
                    <div id="{$switch-id}" class="{$switch-classes}" dojoType="betterform.ui.container.TabSwitch"
                            style="width: 900px; height: 400px;">
            -->
            <xsl:for-each select="xf:case[./xf:label]">
                <xsl:variable name="selected">
                    <xsl:choose>
                        <xsl:when test="@selected='true'">true</xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="label">
                    <xsl:call-template name="create-label">
                        <xsl:with-param name="label-elements" select="xf:label"/>
                    </xsl:call-template>
                </xsl:variable>
                <div dojoType="betterform.ui.container.AccordionSwitchPane" class="xfCase" caseId="{@id}"
                     selected="{$selected}" title="{$label}">
                    <xsl:apply-templates select="*[not(self::xf:label)]"/>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="xf:switch[@appearance='dijit:TabContainer']">
        <xsl:variable name="switch-id" select="@id"/>
<!--
        <xsl:variable name="switch-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>
-->

        <div style="display:none">
            <xsl:for-each select="xf:case[@name='switch-toggles']/xf:trigger">
                <xsl:call-template name="trigger"/>
            </xsl:for-each>
        </div>
        <div id="{$switch-id}" class="xfSwitch bfTabContainer" dojoType="betterform.ui.container.TabSwitch">
            <xsl:call-template name="copy-style-attribute"/>
            <xsl:for-each select="xf:case[./xf:label]">
                <xsl:variable name="selected">
                    <xsl:choose>
                        <xsl:when test="@selected='true'">true</xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <!--<div dojoType="dijit.layout.ContentPane" style="width:100%;height:100%;" class="xfCase" caseId="{@id}" selected="{$selected}" title="{xf:label}" onscroll="betterform.ui.util.closeSelect1(this);">-->
                <xsl:variable name="label">
                    <xsl:call-template name="create-label">
                        <xsl:with-param name="label-elements" select="xf:label"/>
                    </xsl:call-template>
                </xsl:variable>
                <div dojoType="dijit.layout.ContentPane" style="width:100%;height:100%;" class="xfCase" caseId="{@id}"
                     selected="{$selected}" title="{$label}">
                    <xsl:apply-templates select="*[not(self::xf:label)]"/>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="xf:switch[@appearance='dijit:TitlePane']">
        <xsl:variable name="switch-id" select="@id"/>
        <xsl:variable name="switch-classes">
            <xsl:call-template name="assemble-compound-classes">
                <xsl:with-param name="appearance" select="@appearance"/>
            </xsl:call-template>
        </xsl:variable>

        <div id="{$switch-id}" class="{$switch-classes}"
             style="width: 600px; height: 300px;">
            <xsl:for-each select="xf:case[.//xf:label]">
                <div dojoType="betterform.ui.container.TitlePaneGroup" title="{.//xf:label[1]}">
                    <xsl:apply-templates select="*[not(self::xf:label)]"/>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>

</xsl:stylesheet>

