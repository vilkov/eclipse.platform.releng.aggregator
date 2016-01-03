<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.w3.org/1999/xhtml">

  <xsl:output
    method="html"
    encoding="UTF-8"
    omit-xml-declaration="no"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    indent="yes" />
  <xsl:strip-space elements="*" />

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <body>
        <xsl:comment>
          This is subset of full unit test table. Includes only rows with
          errors or DNF's.
          <xsl:text>&#xa;</xsl:text>
          XSLT Version =
          <xsl:copy-of select="system-property('xsl:version')" />
          XSLT Vendor =
          <xsl:copy-of select="system-property('xsl:vendor')" />
          XSLT Vendor URL =
          <xsl:copy-of select="system-property('xsl:vendor-url')" />
          <xsl:text>&#xa;</xsl:text>
        </xsl:comment>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates select="node()" />
      </body>
    </html>
  </xsl:template>

  <xsl:template match="table[@class='junittable']" >
    <xsl:comment>
      Main Table matched.
    </xsl:comment>
    <xsl:copy>
      <xsl:apply-templates
        select="@*|node()"
        mode="table" />
    </xsl:copy>
  </xsl:template>

  <xsl:template
    match="node()"
    mode="table">
    <xsl:copy>
      <xsl:apply-templates
        select="@*|node()"
        mode="table" />
    </xsl:copy>
  </xsl:template>

  <xsl:template
    match="@*"
    mode="table">
    <xsl:copy />
  </xsl:template>

  <xsl:template match="@*|node()">
     <xsl:apply-templates select="node()" />
  </xsl:template>
  <!--
    <xsl:template match="*">
    <xsl:message terminate="no">
    WARNING: Unmatched element:
    <xsl:value-of select="name()" />
    </xsl:message>
    <xsl:apply-templates />
    </xsl:template>
  -->
</xsl:stylesheet>
