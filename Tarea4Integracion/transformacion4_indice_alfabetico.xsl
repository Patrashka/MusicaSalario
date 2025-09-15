<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Catálogo de Música - Índice Alfabético de Artistas</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .artista { background-color: #f8f9fa; padding: 20px; margin: 20px 0; border-radius: 10px; border-left: 6px solid #007bff; }
                    .artista-nombre { font-size: 24px; font-weight: bold; color: #007bff; margin-bottom: 10px; }
                    .artista-pais { color: #666; font-style: italic; margin-bottom: 15px; }
                    .album { background-color: white; padding: 12px; margin: 8px 0; border-radius: 6px; border: 1px solid #dee2e6; }
                    .album-titulo { font-weight: bold; color: #333; font-size: 16px; }
                    .album-info { color: #666; margin-top: 5px; }
                    .album-year { color: #007bff; font-weight: bold; }
                    h1 { color: #333; text-align: center; margin-bottom: 30px; }
                    .indice { background-color: #e9ecef; padding: 15px; border-radius: 8px; margin-bottom: 30px; }
                    .indice h2 { margin-top: 0; color: #495057; }
                    .indice ul { list-style-type: none; padding: 0; }
                    .indice li { padding: 5px 0; }
                    .indice a { text-decoration: none; color: #007bff; }
                    .indice a:hover { text-decoration: underline; }
                </style>
            </head>
            <body>
                <h1>📚 Índice Alfabético de Artistas</h1>
                
                <!-- Crear índice de navegación -->
                <div class="indice">
                    <h2>Navegación Rápida</h2>
                    <ul>
                        <xsl:for-each select="catalogo_musica/album">
                            <xsl:sort select="artista/nombre"/>
                            <xsl:variable name="artista-actual" select="artista/nombre"/>
                            <xsl:if test="not(preceding-sibling::album[artista/nombre = $artista-actual])">
                                <li>
                                    <a href="#{translate($artista-actual, ' ', '_')}">
                                        <xsl:value-of select="$artista-actual"/>
                                    </a>
                                </li>
                            </xsl:if>
                        </xsl:for-each>
                    </ul>
                </div>
                
                <!-- Mostrar artistas en orden alfabético -->
                <xsl:for-each select="catalogo_musica/album">
                    <xsl:sort select="artista/nombre"/>
                    <xsl:variable name="artista-actual" select="artista/nombre"/>
                    
                    <!-- Solo mostrar el encabezado del artista si es el primero o diferente al anterior -->
                    <xsl:if test="not(preceding-sibling::album[artista/nombre = $artista-actual])">
                        <div class="artista" id="{translate($artista-actual, ' ', '_')}">
                            <div class="artista-nombre">
                                <xsl:value-of select="$artista-actual"/>
                            </div>
                            <div class="artista-pais">
                                País de origen: <xsl:value-of select="artista/pais_origen"/>
                            </div>
                            
                            <!-- Mostrar todos los álbumes de este artista, ordenados por año -->
                            <xsl:for-each select="../album[artista/nombre = $artista-actual]">
                                <xsl:sort select="año_lanzamiento" data-type="number"/>
                                <div class="album">
                                    <div class="album-titulo">
                                        <xsl:value-of select="titulo"/>
                                    </div>
                                    <div class="album-info">
                                        <span class="album-year">Año: <xsl:value-of select="año_lanzamiento"/></span> | 
                                        Género: <xsl:value-of select="genero"/> | 
                                        Canciones: <xsl:value-of select="count(canciones/cancion)"/>
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                
                <!-- Estadísticas al final -->
                <div class="indice" style="margin-top: 40px;">
                    <h2>Estadísticas del Catálogo</h2>
                    <p><strong>Total de artistas:</strong> 
                        <xsl:value-of select="count(catalogo_musica/album[not(preceding-sibling::album[artista/nombre = current()/artista/nombre])])"/>
                    </p>
                    <p><strong>Total de álbumes:</strong> 
                        <xsl:value-of select="count(catalogo_musica/album)"/>
                    </p>
                    <p><strong>Total de canciones:</strong> 
                        <xsl:value-of select="count(catalogo_musica/album/canciones/cancion)"/>
                    </p>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
