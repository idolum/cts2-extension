<?xml version="1.0" encoding="utf-8"?>
<!--
The MIT License (MIT)

Copyright (c) 2013 Veit Jahns

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cs="http://schema.omg.org/spec/CTS2/1.0/CodeSystem"
	xmlns:csv="http://schema.omg.org/spec/CTS2/1.0/CodeSystemVersion"
	xmlns:css="http://schema.omg.org/spec/CTS2/1.0/CoreService"
	xmlns:vls="http://schema.omg.org/spec/CTS2/1.0/ValueSet"
	xmlns:core="http://schema.omg.org/spec/CTS2/1.0/Core"
	version="1.0">

<xsl:output method="html" omit-xml-declaration="yes"/>

<!--
	Root
-->

<xsl:template match="/">
	<html>
		<head>
			<title>CTS2 REST UI</title>
			<style>
				.detail { font-size: 80%; background-color:#f8f8f8;margin:1%; }
				.synopsis { background-color:#f0f0f0; margin:1%; }
				dl { margin:2%; }
				dt { margin-top: 1% }
			</style>
		</head>
		<body>
			<xsl:apply-templates
				select="
					cs:CodeSystemCatalogEntryDirectory
						| cs:CodeSystemCatalogEntryMsg
						| csv:CodeSystemVersionCatalogEntryDirectory
						| css:BaseService
						| vls:ValueSetCatalogEntryDirectory
						| vls:ValueSetCatalogEntryMsg" />
		</body>
	</html>
</xsl:template>

<!--
	Directories
-->

<xsl:template
	match="
		cs:CodeSystemCatalogEntryDirectory
			| csv:CodeSystemVersionCatalogEntryDirectory
			| vls:ValueSetCatalogEntryDirectory">
	<xsl:apply-templates select="core:heading" />
	<dl>
		<xsl:apply-templates
			select="
				cs:entry
					| csv:entry
					| vls:entry" />
	</dl>
</xsl:template>

<xsl:template match="cs:CodeSystemCatalogEntryMsg">
	<xsl:apply-templates select="core:heading" />
	<xsl:apply-templates select="cs:codeSystemCatalogEntry" />
</xsl:template>

<xsl:template match="cs:codeSystemCatalogEntry">
	<h2><xsl:value-of select="@formalName" /></h2>
	<xsl:apply-templates select="core:resourceSynopsis" />
	<xsl:call-template name="Properties" />
</xsl:template>

<xsl:template match="@resourceName">
		<span title="Ressource Name">
			<xsl:value-of select="." />
		</span>
	<xsl:if test="position() != last()">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="@codeSystemVersionName">
	<span title="Code System Version Name">
		<xsl:value-of select="." />
	</span>
	<xsl:if test="position() != last()">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="@valueSetName">
	<span title="Valueset Name">
		<xsl:value-of select="." />
	</span>
	<xsl:if test="position() != last()">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="@documentURI">
	<span title="Document URI">
		<xsl:value-of select="." />
	</span>
	<xsl:if test="position() != last()">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="cs:entry|csv:entry|vls:entry">
	<dt>
		<a href="{@href}" title="Formal Name">
			<xsl:value-of select="@formalName" />
		</a>
		<xsl:text> (</xsl:text>
		<xsl:apply-templates select="@*" />
		<xsl:text>)</xsl:text>
	</dt>
	<dd>
		<xsl:apply-templates select="core:resourceSynopsis" />
		<div class="detail">
			<xsl:apply-templates select="core:officialResourceVersionId" />
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="csv:versionOf" />
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="cs:currentVersion" />
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="cs:versions" />
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="csv:codeSystemVersionTag" />
		</div>
	</dd>
</xsl:template>

<xsl:template match="cs:currentVersion">
	<xsl:text>[</xsl:text>
	<xsl:text>Current version: </xsl:text>
	<a href="{core:version/@href}">
		<xsl:value-of select="core:version" />
	</a>
	<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="csv:versionOf">
	<xsl:text>[</xsl:text>
	<xsl:text>Version of: </xsl:text>
	<a href="{@href}">
		<xsl:value-of select="." />
	</a>
	<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="csv:codeSystemVersionTag">
	<xsl:if test=". != ''">
		<xsl:text>[</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>]</xsl:text>
	</xsl:if>	
</xsl:template>

<!--
	ValueSetCatalogEntryMsg
-->

<xsl:template match="vls:ValueSetCatalogEntryMsg">
	<xsl:apply-templates select="vls:valueSetCatalogEntry" />
</xsl:template>

<xsl:template match="vls:valueSetCatalogEntry">
	<h1>
		<xsl:text>Valueset </xsl:text>
		<xsl:value-of select="@formalName" />
	</h1>
	<xsl:apply-templates select="core:resourceSynopsis" />
	<xsl:apply-templates select="vls:definitions" />
	<xsl:call-template name="Properties" />
</xsl:template>

<xsl:template match="vls:definitions">
	<div class="detail">
		<a href="{.}">
			<xsl:text>Definitions</xsl:text>
		</a>
	</div>
</xsl:template>

<!--
	Ressource service
-->

<xsl:template match="css:BaseService">
	<h1>
		<xsl:text>Service </xsl:text>
		<xsl:value-of select="css:serviceName" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="css:serviceVersion" />
	</h1>
	<p>
		<xsl:value-of select="css:serviceDescription/core:value" />
	</p>
	<p>
		<xsl:text>Provided by </xsl:text>
		<xsl:value-of select="css:serviceProvider" />
	</p>
	<h2>Default Format</h2>
	<ul>
		<xsl:apply-templates select="css:defaultFormat" />
	</ul>
	<h2>Supported Formats</h2>
	<ul>
		<xsl:apply-templates select="css:supportedFormat" />
	</ul>
	<h2>Supported Profiles</h2>
	<ul>
		<xsl:apply-templates select="css:supportedProfile" />
	</ul>
</xsl:template>

<xsl:template match="css:supportedProfile">
	<li>
		<span title="Structural Profile">
			<xsl:value-of select="css:structuralProfile" />
		</span>
		<xsl:text>, </xsl:text>
		<a href="{css:functionalProfile/@href}" title="Functional Profile">
			<xsl:value-of select="css:functionalProfile" />
		</a>
	</li>
</xsl:template>

<xsl:template match="css:defaultFormat">
	<li>
		<xsl:value-of select="." />
	</li>
</xsl:template>

<xsl:template match="css:supportedFormat">
	<li>
		<xsl:value-of select="." />
	</li>
</xsl:template>

<!--
	Core elements
-->

<xsl:template name="Properties">
	<table>
		<thead>
			<tr>
				<th>Typ</th>
				<th>Name</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<xsl:apply-templates select="core:sourceAndRole|core:property" />
		</tbody>
	</table>
</xsl:template>

<xsl:template match="core:officialResourceVersionId">
	<xsl:text>[Version: </xsl:text>
	<xsl:value-of select="." />
	<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="core:property">
	<tr>
		<td>Property</td>
		<td><xsl:value-of select="core:predicate/core:name" /></td>
		<td><xsl:value-of select="core:value/core:literal/core:value" /></td>
	</tr>
</xsl:template>

<xsl:template match="core:sourceAndRole">
	<tr>
		<td>Relationship</td>
		<td><xsl:value-of select="core:role" /></td>
		<td><xsl:value-of select="core:source" /></td>
	</tr>
</xsl:template>

<xsl:template match="core:heading">
	<h1><xsl:value-of select="core:resourceRoot" /></h1>
	<ul>
		<li>Access Date: <xsl:value-of select="core:accessDate" /></li>
		<xsl:if test="../@next|../@prev">
			<li>
				<xsl:if test="../@prev">
					<a href="{../@prev}">Previous Entries</a>
				</xsl:if>
				<xsl:text> </xsl:text>
				<a href="{../@next}">Next Entries</a>
			</li>
		</xsl:if>
	</ul>
</xsl:template>

<xsl:template match="core:resourceSynopsis">
	<div class="synopsis">
		<xsl:value-of select="core:value" />
	</div>
</xsl:template>

<xsl:template match="cs:versions">
	<xsl:text>[</xsl:text>
	<a href="{.}">All versions</a>
	<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="*|@*">
</xsl:template>

</xsl:stylesheet>
