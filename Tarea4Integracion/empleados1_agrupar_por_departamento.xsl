<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Registro de Empleados - Agrupado por Departamento</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .departamento { margin: 30px 0; }
                    .departamento-header { 
                        background-color: #007bff; 
                        color: white; 
                        padding: 15px; 
                        border-radius: 8px 8px 0 0;
                        font-size: 20px;
                        font-weight: bold;
                    }
                    .departamento-info { 
                        background-color: #e3f2fd; 
                        padding: 10px 15px; 
                        color: #333;
                        font-style: italic;
                    }
                    table { 
                        width: 100%; 
                        border-collapse: collapse; 
                        margin-top: 0;
                        border: 1px solid #ddd;
                    }
                    th { 
                        background-color: #f8f9fa; 
                        padding: 12px; 
                        text-align: left; 
                        border-bottom: 2px solid #007bff;
                        font-weight: bold;
                    }
                    td { 
                        padding: 10px 12px; 
                        border-bottom: 1px solid #eee; 
                    }
                    tr:nth-child(even) { background-color: #f8f9fa; }
                    tr:hover { background-color: #e3f2fd; }
                    .salario { text-align: right; font-weight: bold; color: #28a745; }
                    .posicion { color: #666; }
                    h1 { color: #333; text-align: center; margin-bottom: 30px; }
                    .stats { 
                        background-color: #e9ecef; 
                        padding: 15px; 
                        border-radius: 8px; 
                        margin-bottom: 20px; 
                        text-align: center; 
                    }
                </style>
            </head>
            <body>
                <h1>👥 Registro de Empleados - Agrupado por Departamento</h1>
                
                <div class="stats">
                    <strong>Total de empleados: <xsl:value-of select="count(registro_empleados/empleado)"/></strong> | 
                    <strong>Total de departamentos: <xsl:value-of select="count(registro_empleados/empleado[not(preceding-sibling::empleado[departamento/nombre = current()/departamento/nombre])])"/></strong>
                </div>
                
                <!-- Agrupar empleados por departamento -->
                <xsl:for-each select="registro_empleados/empleado">
                    <xsl:sort select="departamento/nombre"/>
                    <xsl:variable name="departamento-actual" select="departamento/nombre"/>
                    
                    <!-- Solo mostrar el encabezado del departamento si es el primero o diferente al anterior -->
                    <xsl:if test="not(preceding-sibling::empleado[departamento/nombre = $departamento-actual])">
                        <div class="departamento">
                            <div class="departamento-header">
                                <xsl:value-of select="$departamento-actual"/>
                            </div>
                            <div class="departamento-info">
                                📍 <xsl:value-of select="departamento/localizacion"/> | 
                                Empleados: <xsl:value-of select="count(../empleado[departamento/nombre = $departamento-actual])"/>
                            </div>
                            
                            <table>
                                <thead>
                                    <tr>
                                        <th>Nombre Completo</th>
                                        <th>Posición</th>
                                        <th>Salario</th>
                                        <th>Fecha Contratación</th>
                                        <th>Tipo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Mostrar todos los empleados de este departamento -->
                                    <xsl:for-each select="../empleado[departamento/nombre = $departamento-actual]">
                                        <xsl:sort select="apellido"/>
                                        <tr>
                                            <td>
                                                <strong><xsl:value-of select="nombre"/> <xsl:value-of select="apellido"/></strong>
                                            </td>
                                            <td class="posicion">
                                                <xsl:value-of select="posicion"/>
                                            </td>
                                            <td class="salario">
                                                $<xsl:value-of select="format-number(salario, '#,##0')"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="fecha_contratacion"/>
                                            </td>
                                            <td>
                                                <xsl:choose>
                                                    <xsl:when test="tiempo_completo = 'true'">
                                                        <span style="color: #28a745; font-weight: bold;">Tiempo Completo</span>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <span style="color: #ffc107; font-weight: bold;">Tiempo Parcial</span>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>
                        </div>
                    </xsl:if>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
