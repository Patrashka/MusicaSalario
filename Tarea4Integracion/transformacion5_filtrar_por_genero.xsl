<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <!-- Parámetro para el género a filtrar (se puede cambiar desde fuera) -->
    <xsl:param name="genero-filtro" select="'Rock'"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Catálogo de Música - Filtrado por Género: <xsl:value-of select="$genero-filtro"/></title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .filtro-info { background-color: #e3f2fd; padding: 15px; border-radius: 8px; margin-bottom: 20px; border-left: 5px solid #2196f3; }
                    .album { background-color: #f8f9fa; padding: 20px; margin: 15px 0; border-radius: 10px; border-left: 6px solid #28a745; }
                    .album-header { font-size: 20px; font-weight: bold; color: #333; margin-bottom: 10px; }
                    .album-info { color: #666; margin-bottom: 15px; }
                    .artista-info { color: #007bff; font-weight: bold; }
                    .canciones { margin-top: 15px; }
                    .cancion { background-color: white; padding: 8px; margin: 5px 0; border-radius: 4px; border: 1px solid #dee2e6; }
                    .cancion-titulo { font-weight: bold; color: #333; }
                    .cancion-duracion { color: #666; font-size: 14px; }
                    .sencillo { color: #28a745; font-weight: bold; }
                    h1 { color: #333; text-align: center; margin-bottom: 30px; }
                    .no-resultados { text-align: center; color: #666; font-style: italic; margin-top: 50px; padding: 20px; background-color: #f8f9fa; border-radius: 8px; }
                    .generos-disponibles { background-color: #fff3cd; padding: 15px; border-radius: 8px; margin-bottom: 20px; border-left: 5px solid #ffc107; }
                    .genero-link { color: #007bff; text-decoration: none; margin-right: 10px; }
                    .genero-link:hover { text-decoration: underline; }
                </style>
            </head>
            <body>
                <h1>🎵 Catálogo de Música - Filtrado por Género</h1>
                
                <!-- Información del filtro aplicado -->
                <div class="filtro-info">
                    <h2>Filtro Aplicado: "<xsl:value-of select="$genero-filtro"/>"</h2>
                    <p>Mostrando únicamente los álbumes del género <strong><xsl:value-of select="$genero-filtro"/></strong></p>
                </div>
                
                <!-- Mostrar géneros disponibles -->
                <div class="generos-disponibles">
                    <h3>Géneros disponibles en el catálogo:</h3>
                    <xsl:for-each select="catalogo_musica/album">
                        <xsl:sort select="genero"/>
                        <xsl:variable name="genero-actual" select="genero"/>
                        <xsl:if test="not(preceding-sibling::album[genero = $genero-actual])">
                            <a href="#" class="genero-link" onclick="filtrarPorGenero('{$genero-actual}')">
                                <xsl:value-of select="$genero-actual"/>
                            </a>
                        </xsl:if>
                    </xsl:for-each>
                </div>
                
                <!-- Mostrar álbumes del género filtrado -->
                <xsl:choose>
                    <xsl:when test="catalogo_musica/album[genero = $genero-filtro]">
                        <xsl:for-each select="catalogo_musica/album[genero = $genero-filtro]">
                            <xsl:sort select="año_lanzamiento" data-type="number"/>
                            <div class="album">
                                <div class="album-header">
                                    <xsl:value-of select="titulo"/>
                                </div>
                                <div class="album-info">
                                    <span class="artista-info">Artista: <xsl:value-of select="artista/nombre"/></span> | 
                                    Año: <xsl:value-of select="año_lanzamiento"/> | 
                                    País: <xsl:value-of select="artista/pais_origen"/>
                                </div>
                                
                                <div class="canciones">
                                    <h4>Canciones (<xsl:value-of select="count(canciones/cancion)"/>):</h4>
                                    <xsl:for-each select="canciones/cancion">
                                        <xsl:sort select="titulo"/>
                                        <div class="cancion">
                                            <div class="cancion-titulo">
                                                <xsl:value-of select="titulo"/>
                                                <xsl:if test="es_sencillo = 'true'">
                                                    <span class="sencillo"> (Sencillo)</span>
                                                </xsl:if>
                                            </div>
                                            <div class="cancion-duracion">
                                                Duración: <xsl:value-of select="duracion"/>
                                            </div>
                                        </div>
                                    </xsl:for-each>
                                </div>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="no-resultados">
                            <h3>No se encontraron álbumes del género "<xsl:value-of select="$genero-filtro"/>"</h3>
                            <p>Intenta con uno de los géneros disponibles mostrados arriba.</p>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- Estadísticas del filtro -->
                <xsl:if test="catalogo_musica/album[genero = $genero-filtro]">
                    <div class="filtro-info" style="margin-top: 30px;">
                        <h3>Estadísticas del Filtro</h3>
                        <p><strong>Álbumes encontrados:</strong> 
                            <xsl:value-of select="count(catalogo_musica/album[genero = $genero-filtro])"/>
                        </p>
                        <p><strong>Total de canciones:</strong> 
                            <xsl:value-of select="count(catalogo_musica/album[genero = $genero-filtro]/canciones/cancion)"/>
                        </p>
                        <p><strong>Sencillos:</strong> 
                            <xsl:value-of select="count(catalogo_musica/album[genero = $genero-filtro]/canciones/cancion[es_sencillo='true'])"/>
                        </p>
                    </div>
                </xsl:if>
                
                <script>
                    function filtrarPorGenero(genero) {
                        // Esta función permitiría cambiar el filtro dinámicamente
                        // En un entorno real, se regeneraría el XSLT con el nuevo parámetro
                        alert('Para cambiar el filtro, modifica el parámetro "genero-filtro" en el archivo XSLT y vuelve a procesar el XML.');
                    }
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
