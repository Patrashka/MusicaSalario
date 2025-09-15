<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Catálogo de Música - Solo Sencillos</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .album { background-color: #f8f9fa; padding: 15px; margin: 15px 0; border-radius: 8px; border-left: 5px solid #28a745; }
                    .album-header { font-size: 18px; font-weight: bold; color: #333; margin-bottom: 10px; }
                    .album-info { color: #666; margin-bottom: 15px; }
                    .sencillo { background-color: white; padding: 10px; margin: 8px 0; border-radius: 5px; border: 1px solid #dee2e6; }
                    .sencillo-titulo { font-weight: bold; color: #28a745; }
                    .sencillo-duracion { color: #666; margin-top: 5px; }
                    h1 { color: #333; text-align: center; margin-bottom: 30px; }
                    .stats { background-color: #e9ecef; padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center; }
                </style>
            </head>
            <body>
                <h1>🎵 Sencillos del Catálogo de Música</h1>
                
                <div class="stats">
                    <strong>Total de sencillos encontrados: 
                        <xsl:value-of select="count(catalogo_musica/album/canciones/cancion[es_sencillo='true'])"/>
                    </strong>
                </div>
                
                <xsl:for-each select="catalogo_musica/album">
                    <xsl:sort select="titulo"/>
                    
                    <!-- Solo mostrar álbumes que tengan al menos un sencillo -->
                    <xsl:if test="canciones/cancion[es_sencillo='true']">
                        <div class="album">
                            <div class="album-header">
                                <xsl:value-of select="titulo"/>
                            </div>
                            <div class="album-info">
                                <strong>Artista:</strong> <xsl:value-of select="artista/nombre"/> | 
                                <strong>Año:</strong> <xsl:value-of select="año_lanzamiento"/> | 
                                <strong>Género:</strong> <xsl:value-of select="genero"/>
                            </div>
                            
                            <!-- Mostrar solo los sencillos de este álbum -->
                            <xsl:for-each select="canciones/cancion[es_sencillo='true']">
                                <xsl:sort select="titulo"/>
                                <div class="sencillo">
                                    <div class="sencillo-titulo">
                                        🎶 <xsl:value-of select="titulo"/>
                                    </div>
                                    <div class="sencillo-duracion">
                                        Duración: <xsl:value-of select="duracion"/>
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                
                <!-- Mostrar mensaje si no hay sencillos -->
                <xsl:if test="not(catalogo_musica/album/canciones/cancion[es_sencillo='true'])">
                    <div style="text-align: center; color: #666; font-style: italic; margin-top: 50px;">
                        No se encontraron sencillos en el catálogo.
                    </div>
                </xsl:if>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
