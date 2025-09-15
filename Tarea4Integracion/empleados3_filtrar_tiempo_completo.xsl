<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Registro de Empleados - Solo Tiempo Completo</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .filtro-info { 
                        background-color: #d4edda; 
                        padding: 15px; 
                        border-radius: 8px; 
                        margin-bottom: 20px; 
                        border-left: 5px solid #28a745; 
                    }
                    .empleado { 
                        background-color: #f8f9fa; 
                        padding: 15px; 
                        margin: 10px 0; 
                        border-radius: 8px; 
                        border-left: 5px solid #28a745; 
                    }
                    .empleado-header { 
                        font-size: 18px; 
                        font-weight: bold; 
                        color: #333; 
                        margin-bottom: 8px; 
                    }
                    .empleado-info { 
                        color: #666; 
                        margin-bottom: 5px; 
                    }
                    .salario { 
                        color: #28a745; 
                        font-weight: bold; 
                        font-size: 16px; 
                    }
                    .departamento { 
                        color: #007bff; 
                        font-weight: bold; 
                    }
                    .posicion { 
                        color: #6c757d; 
                        font-style: italic; 
                    }
                    .fecha { 
                        color: #6c757d; 
                    }
                    h1 { color: #333; text-align: center; margin-bottom: 30px; }
                    .stats { 
                        background-color: #e9ecef; 
                        padding: 15px; 
                        border-radius: 8px; 
                        margin-bottom: 20px; 
                        text-align: center; 
                    }
                    .no-resultados { 
                        text-align: center; 
                        color: #666; 
                        font-style: italic; 
                        margin-top: 50px; 
                        padding: 20px; 
                        background-color: #f8f9fa; 
                        border-radius: 8px; 
                    }
                    .resumen-departamentos { 
                        background-color: #e3f2fd; 
                        padding: 20px; 
                        border-radius: 10px; 
                        margin-top: 30px; 
                    }
                    .departamento-resumen { 
                        background-color: white; 
                        padding: 10px; 
                        margin: 8px 0; 
                        border-radius: 5px; 
                        border: 1px solid #dee2e6; 
                    }
                </style>
            </head>
            <body>
                <h1>👥 Empleados a Tiempo Completo</h1>
                
                <div class="filtro-info">
                    <h2>✅ Filtro Aplicado: Solo Empleados a Tiempo Completo</h2>
                    <p>Mostrando únicamente los empleados que trabajan a tiempo completo (tiempo_completo = "true")</p>
                </div>
                
                <div class="stats">
                    <strong>Empleados a tiempo completo: <xsl:value-of select="count(registro_empleados/empleado[tiempo_completo='true'])"/></strong> | 
                    <strong>Total de empleados: <xsl:value-of select="count(registro_empleados/empleado)"/></strong> | 
                    <strong>Porcentaje: <xsl:value-of select="format-number((count(registro_empleados/empleado[tiempo_completo='true']) div count(registro_empleados/empleado)) * 100, '#0.0')"/>%</strong>
                </div>
                
                <!-- Filtrar y mostrar solo empleados a tiempo completo -->
                <xsl:choose>
                    <xsl:when test="registro_empleados/empleado[tiempo_completo='true']">
                        <xsl:for-each select="registro_empleados/empleado[tiempo_completo='true']">
                            <xsl:sort select="apellido"/>
                            <div class="empleado">
                                <div class="empleado-header">
                                    <xsl:value-of select="nombre"/> <xsl:value-of select="apellido"/>
                                </div>
                                <div class="empleado-info">
                                    <span class="posicion">Posición: <xsl:value-of select="posicion"/></span> | 
                                    <span class="departamento">Departamento: <xsl:value-of select="departamento/nombre"/></span>
                                </div>
                                <div class="empleado-info">
                                    <span class="salario">Salario: $<xsl:value-of select="format-number(salario, '#,##0')"/></span> | 
                                    <span class="fecha">Contratado: <xsl:value-of select="fecha_contratacion"/></span>
                                </div>
                                <div class="empleado-info">
                                    📍 <xsl:value-of select="departamento/localizacion"/>
                                </div>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="no-resultados">
                            <h3>No se encontraron empleados a tiempo completo</h3>
                            <p>No hay empleados que trabajen a tiempo completo en el registro.</p>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- Resumen por departamentos -->
                <xsl:if test="registro_empleados/empleado[tiempo_completo='true']">
                    <div class="resumen-departamentos">
                        <h3>📊 Empleados a Tiempo Completo por Departamento</h3>
                        
                        <xsl:for-each select="registro_empleados/empleado[tiempo_completo='true']">
                            <xsl:sort select="departamento/nombre"/>
                            <xsl:variable name="departamento-actual" select="departamento/nombre"/>
                            
                            <!-- Solo mostrar si es el primer empleado de este departamento -->
                            <xsl:if test="not(preceding-sibling::empleado[departamento/nombre = $departamento-actual and tiempo_completo='true'])">
                                <xsl:variable name="empleados-tc-departamento" select="../empleado[departamento/nombre = $departamento-actual and tiempo_completo='true']"/>
                                <xsl:variable name="total-empleados-departamento" select="count(../empleado[departamento/nombre = $departamento-actual])"/>
                                
                                <div class="departamento-resumen">
                                    <strong><xsl:value-of select="$departamento-actual"/></strong> 
                                    <span style="color: #666;">
                                        - <xsl:value-of select="count($empleados-tc-departamento)"/> de <xsl:value-of select="$total-empleados-departamento"/> empleados a tiempo completo
                                        (<xsl:value-of select="format-number((count($empleados-tc-departamento) div $total-empleados-departamento) * 100, '#0.0')"/>%)
                                    </span>
                                </div>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </xsl:if>
                
                <!-- Estadísticas adicionales -->
                <xsl:if test="registro_empleados/empleado[tiempo_completo='true']">
                    <div class="stats" style="margin-top: 30px;">
                        <h3>💰 Estadísticas de Salarios (Tiempo Completo)</h3>
                        <p>
                            <strong>Salario promedio:</strong> $<xsl:value-of select="format-number(sum(registro_empleados/empleado[tiempo_completo='true']/salario) div count(registro_empleados/empleado[tiempo_completo='true']), '#,##0.00')"/> | 
                            <strong>Salario total:</strong> $<xsl:value-of select="format-number(sum(registro_empleados/empleado[tiempo_completo='true']/salario), '#,##0')"/> | 
                            <strong>Salario mínimo:</strong> $<xsl:value-of select="format-number(min(registro_empleados/empleado[tiempo_completo='true']/salario), '#,##0')"/> | 
                            <strong>Salario máximo:</strong> $<xsl:value-of select="format-number(max(registro_empleados/empleado[tiempo_completo='true']/salario), '#,##0')"/>
                        </p>
                    </div>
                </xsl:if>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
