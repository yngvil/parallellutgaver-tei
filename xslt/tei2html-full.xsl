<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei">

  <xsl:output method="html" html-version="5" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html lang="no">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Parallellutgave – test</title>
        <link rel="stylesheet" href="assets/site.css"/>
        <script defer="defer" src="assets/site.js"></script>
      </head>
      <body>
        <h1>Parallellutgave – test</h1>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;">
          <section>
            <h2>Latin</h2>
            <xsl:apply-templates select=".//tei:pb | .//tei:seg[@xml:lang='la' and starts-with(@xml:id,'la-')]"/>
          </section>

          <section>
            <h2>Norsk</h2>
            <xsl:for-each select="//tei:seg[@xml:lang='la' and starts-with(@xml:id,'la-')]">
              <xsl:variable name="id" select="@xml:id"/>
              <div id="no-{$id}">
                <xsl:for-each select="//tei:seg[@xml:lang='no' and @corresp=concat('#',$id)]">
                  <div>
                    <xsl:apply-templates/>
                  </div>
                </xsl:for-each>
              </div>
            </xsl:for-each>
          </section>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="tei:seg[@xml:lang='la']">
    <div id="{@xml:id}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="tei:pb">
  <xsl:variable name="f" select="string(@facs)"/>
  <!-- henter 0005 fra ..._0005.jpg -->
  <xsl:variable name="pageStr" select="replace($f, '^.*_([0-9]{4})\\.jpg$', '$1')"/>
  <xsl:variable name="pageNum" select="number($pageStr)"/>

  <div class="pb" id="pb-{$pageStr}">
    <a href="https://www.nb.no/items/URN:NBN:no-nb_digibok_2015121628005?page={$pageNum}" target="_blank" rel="noopener">
      Åpne faksimile (side <xsl:value-of select="$pageNum"/>)
    </a>
  </div>
</xsl:template>


</xsl:stylesheet>
