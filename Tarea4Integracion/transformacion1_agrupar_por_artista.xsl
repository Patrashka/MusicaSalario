<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Catálogo de Música - Agrupado por Artista</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .artista { background-color: #f0f0f0; padding: 15px; margin: 10px 0; border-radius: 5px; }
                    .artista-info { font-size: 18px; font-weight: bold; color: #333; margin-bottom: 10px; }
                    .album { background-color: white; padding: 10px; margin: 5px 0; border-left: 4px solid #007acc; }
                    .album-titulo { font-weight: bold; color: #007acc; }
                    .album-info { color: #666; margin-top: 5px; }
                    h1 { color: #333; text-align: center; }
                </style>
            </head>
            <body>
                <h1>Catálogo de Música - Agrupado por Artista</h1>
                
                <!-- Agrupar álbumes por artista -->
                <xsl:for-each select="catalogo_musica/album">
                    <xsl:sort select="artista/nombre"/>
                    <xsl:variable name="artista-actual" select="artista/nombre"/>
                    
                    <!-- Solo mostrar el encabezado del artista si es el primero o diferente al anterior -->
                    <xsl:if test="not(preceding-sibling::album[artista/nombre = $artista-actual])">
                        <div class="artista">
                            <div class="artista-info">
                                <xsl:value-of select="artista/nombre"/>
                                <span style="font-weight: normal; color: #666;">
                                    - <xsl:value-of select="artista/pais_origen"/>
                                </span>
                            </div>
                            
                            <!-- Mostrar todos los álbumes de este artista -->
                            <xsl:for-each select="../album[artista/nombre = $artista-actual]">
                                <xsl:sort select="año_lanzamiento"/>
                                <div class="album">
                                    <div class="album-titulo">
                                        <xsl:value-of select="titulo"/>
                                    </div>
                                    <div class="album-info">
                                        Año: <xsl:value-of select="año_lanzamiento"/> | 
                                        Género: <xsl:value-of select="genero"/>
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </xsl:if>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
