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
  
  <xsl:template match="tei:body">
    <div class="grid3">
      <xsl:apply-templates
        select=".//tei:pb
                | .//tei:head
                | .//tei:seg[@xml:lang='la' and starts-with(@xml:id,'la-')]"/>
    </div>
  </xsl:template>

<xsl:template match="tei:seg[@xml:lang='la' and starts-with(@xml:id,'la-')]">
  <xsl:variable name="id" select="@xml:id"/>

  <div class="row">
    <!-- Apparatsøyle (venstre) -->
    <div class="cell ap">
      <xsl:variable name="notes"
        select="//tei:note[@place='margin'
          and contains(concat(' ', normalize-space(@target), ' '),
                       concat(' #', $id, ' '))]"/>
      <xsl:if test="exists($notes)">
        <button class="note-btn"
                type="button"
                data-target="{$id}"
                title="Marginalia">
          &#128172;
        </button>
      </xsl:if>
    </div>

    <!-- Latin -->
    <div class="cell la">
      <div class="seg la-seg" id="{$id}">
        <xsl:apply-templates/>
      </div>
    </div>

    <!-- Norsk -->
    <div class="cell no" id="no-{$id}">
      <xsl:for-each select="//tei:seg[@xml:lang='no'
                                     and @corresp = concat('#', $id)]">
        <div class="seg no-seg">
          <xsl:apply-templates/>
        </div>
      </xsl:for-each>
    </div>
  </div>
</xsl:template>


  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="tei:pb">
    <xsl:variable name="f" select="normalize-space(string(@facs))"/>
    <xsl:variable name="pageStr" select="replace($f, '.*_([0-9]{4})\.jpg$', '$1')"/>
    <xsl:variable name="pageNum" select="number($pageStr)"/>
  
    <div class="row pb-row" id="pb-{$pageStr}">
      <!-- Apparat -->
      <div class="cell ap">
        <a class="pb-link"
           href="https://www.nb.no/items/URN:NBN:no-nb_digibok_2015121628005?page={$pageNum}"
           target="_blank" rel="noopener"
           title="Åpne faksimile (side {$pageNum})">
          &#128279;
        </a>
      </div>
  
      <!-- Latin -->
      <div class="cell la"></div>
  
      <!-- Norsk -->
      <div class="cell no"></div>
    </div>
  </xsl:template>

  <xsl:template match="tei:head">
    <div class="row head-row">
      <div class="cell head" style="grid-column: 1 / -1;">
        <h2><xsl:apply-templates/></h2>
      </div>
    </div>
  </xsl:template>


</xsl:stylesheet>
