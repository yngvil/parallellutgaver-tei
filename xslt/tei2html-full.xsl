<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="tei xs">

  <xsl:output method="html" html-version="5" encoding="UTF-8" indent="yes"/>

  <!-- NB base URL -->
  <xsl:param name="nbBase" as="xs:string"
    select="'https://www.nb.no/items/URN:NBN:no-nb_digibok_2015121628005?page='"/>


  <!-- ========== ROOT ========== -->
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
        <header class="site-header">
          <h1>Gert Miltzows Presbyterologia Norwegico Wos-Hardangriana med oversettelse</h1>
        </header>

        <!-- Render TEI body (layout bygges i tei:body-templaten) -->
        <xsl:apply-templates select="//tei:body"/>
      </body>
    </html>
  </xsl:template>

  <!-- ========== BODY / FLOW ========== -->
  <xsl:template match="tei:body">
    <main class="grid3">
      <!-- Viktig: dokumentrekkefølge -->
      <xsl:apply-templates select="node()"/>
    </main>
  </xsl:template>

  <!-- p: bare gå videre i rekkefølge -->
  <xsl:template match="tei:p">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <!-- head: rad som spenner over alle tre kolonner -->
  <xsl:template match="tei:head">
    <div class="row head-row">
      <div class="cell head" style="grid-column: 1 / -1;">
        <h2><xsl:apply-templates/></h2>
      </div>
    </div>
  </xsl:template>

  <!-- pb: rad med lenkeikon i apparatkolonnen -->
  <xsl:template match="tei:pb">
    <xsl:variable name="f" select="normalize-space(string(@facs))"/>
    <xsl:variable name="pageStr" select="replace($f, '.*_([0-9]{4})\.jpg$', '$1')"/>
    <xsl:variable name="pageNum" select="number($pageStr)"/>

    <div class="row pb-row" id="pb-{$pageStr}">
      <div class="cell ap">
        <a class="pb-link"
           href="{concat($nbBase, $pageNum)}"
           target="_blank" rel="noopener"
           title="Åpne faksimile (side {$pageNum})">
          &#128279;
        </a>
      </div>
      <div class="cell la"></div>
      <div class="cell no"></div>
    </div>
  </xsl:template>

  <!-- ========== SEGMENTS ========== -->

  <!-- Latin segment -> én rad -->
  <xsl:template match="tei:seg[@xml:lang='la' and starts-with(@xml:id,'la-')]">
    <xsl:variable name="id" select="@xml:id"/>

    <!-- Finn marginalia-noter som peker hit (token-sikker matching) -->
    <xsl:variable name="notes"
      select="//tei:note[@place='margin'
              and contains(concat(' ', normalize-space(@target), ' '),
                           concat(' #', $id, ' '))]"/>

    <div class="row">
      <!-- Apparatsøyle (venstre) -->
      <div class="cell ap">
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

      <!-- Norsk (alle seg som korresponderer) -->
      <div class="cell no" id="no-{$id}">
        <xsl:for-each select="//tei:seg[@xml:lang='no' and @corresp = concat('#', $id)]">
          <div class="seg no-seg">
            <xsl:apply-templates/>
          </div>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>

  <!-- Viktig: Ikke rendr norske seg direkte når vi går i dokumentrekkefølge -->
  <xsl:template match="tei:seg[@xml:lang='no']"/>

  <!-- (Valgfritt) Ignorér rå-segmenter hvis de finnes -->
  <xsl:template match="tei:seg[@type='raw']">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ========== TEXT NODES ========== -->

  <!-- Ignorér whitespace-only tekstnoder (innrykk/linjeskift i XML) -->
  <xsl:template match="text()[not(normalize-space())]"/>

  <!-- Behold vanlig tekst -->
  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>
