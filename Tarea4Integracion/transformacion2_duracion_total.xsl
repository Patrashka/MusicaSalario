<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Catálogo de Música - Duración de Canciones</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    table { border-collapse: collapse; width: 100%; margin: 20px 0; }
                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                    th { background-color: #f2f2f2; font-weight: bold; }
                    .album-header { background-color: #e6f3ff; font-weight: bold; }
                    .total-row { background-color: #f0f8ff; font-weight: bold; }
                    .cancion-row { background-color: white; }
                    h1 { color: #333; text-align: center; }
                    .album-info { font-size: 16px; margin: 20px 0 10px 0; }
                </style>
            </head>
            <body>
                <h1>Catálogo de Música - Duración de Canciones por Álbum</h1>
                
                <xsl:for-each select="catalogo_musica/album">
                    <xsl:sort select="titulo"/>
                    
                    <div class="album-info">
                        <strong><xsl:value-of select="titulo"/></strong> - 
                        <xsl:value-of select="artista/nombre"/> 
                        (<xsl:value-of select="año_lanzamiento"/>)
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>Canción</th>
                                <th>Duración</th>
                                <th>Es Sencillo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="canciones/cancion">
                                <tr class="cancion-row">
                                    <td><xsl:value-of select="titulo"/></td>
                                    <td><xsl:value-of select="duracion"/></td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="es_sencillo = 'true'">Sí</xsl:when>
                                            <xsl:otherwise>No</xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                            </xsl:for-each>
                            <tr class="total-row">
                                <td><strong>DURACIÓN TOTAL DEL ÁLBUM</strong></td>
                                <td><strong>
                                    <xsl:call-template name="calcular-duracion-total">
                                        <xsl:with-param name="canciones" select="canciones/cancion"/>
                                    </xsl:call-template>
                                </strong></td>
                                <td>-</td>
                            </tr>
                        </tbody>
                    </table>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    
    <!-- Template para calcular la duración total de un álbum -->
    <xsl:template name="calcular-duracion-total">
        <xsl:param name="canciones"/>
        <xsl:variable name="total-minutos">
            <xsl:call-template name="sumar-duraciones">
                <xsl:with-param name="canciones" select="$canciones"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$total-minutos"/>
    </xsl:template>
    
    <!-- Template para sumar todas las duraciones -->
    <xsl:template name="sumar-duraciones">
        <xsl:param name="canciones"/>
        <xsl:param name="total-minutos" select="0"/>
        <xsl:param name="total-segundos" select="0"/>
        
        <xsl:choose>
            <xsl:when test="count($canciones) = 0">
                <!-- Convertir segundos a minutos si es necesario -->
                <xsl:variable name="minutos-finales" select="$total-minutos + floor($total-segundos div 60)"/>
                <xsl:variable name="segundos-finales" select="$total-segundos mod 60"/>
                <xsl:value-of select="concat($minutos-finales, ':', format-number($segundos-finales, '00'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="duracion-actual" select="$canciones[1]/duracion"/>
                <xsl:variable name="minutos-actuales">
                    <xsl:choose>
                        <xsl:when test="contains($duracion-actual, ':')">
                            <xsl:value-of select="substring-before($duracion-actual, ':')"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="segundos-actuales">
                    <xsl:choose>
                        <xsl:when test="contains($duracion-actual, ':')">
                            <xsl:value-of select="substring-after($duracion-actual, ':')"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:call-template name="sumar-duraciones">
                    <xsl:with-param name="canciones" select="$canciones[position() > 1]"/>
                    <xsl:with-param name="total-minutos" select="$total-minutos + $minutos-actuales"/>
                    <xsl:with-param name="total-segundos" select="$total-segundos + $segundos-actuales"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
