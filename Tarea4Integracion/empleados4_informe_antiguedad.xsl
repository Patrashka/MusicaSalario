<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Registro de Empleados - Informe de Antigüedad</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .empleado { 
                        background-color: #f8f9fa; 
                        padding: 15px; 
                        margin: 10px 0; 
                        border-radius: 8px; 
                        border-left: 5px solid #007bff; 
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
                    .fecha-contratacion { 
                        color: #007bff; 
                        font-weight: bold; 
                        font-size: 16px; 
                    }
                    .departamento { 
                        color: #28a745; 
                        font-weight: bold; 
                    }
                    .posicion { 
                        color: #6c757d; 
                        font-style: italic; 
                    }
                    .salario { 
                        color: #28a745; 
                        font-weight: bold; 
                    }
                    .antiguedad { 
                        background-color: #e3f2fd; 
                        padding: 8px; 
                        border-radius: 4px; 
                        margin-top: 8px; 
                        font-weight: bold; 
                        color: #007bff; 
                    }
                    h1 { color: #333; text-align: center; margin-bottom: 30px; }
                    .stats { 
                        background-color: #e9ecef; 
                        padding: 15px; 
                        border-radius: 8px; 
                        margin-bottom: 20px; 
                        text-align: center; 
                    }
                    .resumen-antiguedad { 
                        background-color: #fff3cd; 
                        padding: 20px; 
                        border-radius: 10px; 
                        margin-bottom: 30px; 
                        border-left: 5px solid #ffc107; 
                    }
                    .rango-antiguedad { 
                        background-color: white; 
                        padding: 10px; 
                        margin: 8px 0; 
                        border-radius: 5px; 
                        border: 1px solid #dee2e6; 
                    }
                    .mas-antiguo { border-left-color: #dc3545; }
                    .mas-nuevo { border-left-color: #28a745; }
                    .intermedio { border-left-color: #ffc107; }
                </style>
            </head>
            <body>
                <h1>📅 Informe de Antigüedad de Empleados</h1>
                
                <div class="stats">
                    <strong>Total de empleados: <xsl:value-of select="count(registro_empleados/empleado)"/></strong> | 
                    <strong>Empleado más antiguo: <xsl:value-of select="registro_empleados/empleado[not(fecha_contratacion > preceding-sibling::empleado/fecha_contratacion) and not(fecha_contratacion > following-sibling::empleado/fecha_contratacion)]/nombre"/> <xsl:value-of select="registro_empleados/empleado[not(fecha_contratacion > preceding-sibling::empleado/fecha_contratacion) and not(fecha_contratacion > following-sibling::empleado/fecha_contratacion)]/apellido"/></strong> | 
                    <strong>Empleado más nuevo: <xsl:value-of select="registro_empleados/empleado[not(fecha_contratacion &lt; preceding-sibling::empleado/fecha_contratacion) and not(fecha_contratacion &lt; following-sibling::empleado/fecha_contratacion)]/nombre"/> <xsl:value-of select="registro_empleados/empleado[not(fecha_contratacion &lt; preceding-sibling::empleado/fecha_contratacion) and not(fecha_contratacion &lt; following-sibling::empleado/fecha_contratacion)]/apellido"/></strong>
                </div>
                
                <!-- Resumen de antigüedad por rangos -->
                <div class="resumen-antiguedad">
                    <h3>📊 Resumen de Antigüedad por Rangos</h3>
                    
                    <!-- Empleados más antiguos (antes de 2020) -->
                    <div class="rango-antiguedad">
                        <h4>🏆 Empleados Más Antiguos (Contratados antes de 2020)</h4>
                        <xsl:for-each select="registro_empleados/empleado[fecha_contratacion &lt; '2020-01-01']">
                            <xsl:sort select="fecha_contratacion"/>
                            <div style="margin: 5px 0; padding: 5px; background-color: #f8f9fa; border-radius: 3px;">
                                <strong><xsl:value-of select="nombre"/> <xsl:value-of select="apellido"/></strong> - 
                                <xsl:value-of select="fecha_contratacion"/> - 
                                <xsl:value-of select="departamento/nombre"/>
                            </div>
                        </xsl:for-each>
                        <p><strong>Total: <xsl:value-of select="count(registro_empleados/empleado[fecha_contratacion &lt; '2020-01-01'])"/> empleados</strong></p>
                    </div>
                    
                    <!-- Empleados intermedios (2020-2021) -->
                    <div class="rango-antiguedad">
                        <h4>⭐ Empleados Intermedios (Contratados entre 2020-2021)</h4>
                        <xsl:for-each select="registro_empleados/empleado[fecha_contratacion >= '2020-01-01' and fecha_contratacion &lt; '2022-01-01']">
                            <xsl:sort select="fecha_contratacion"/>
                            <div style="margin: 5px 0; padding: 5px; background-color: #f8f9fa; border-radius: 3px;">
                                <strong><xsl:value-of select="nombre"/> <xsl:value-of select="apellido"/></strong> - 
                                <xsl:value-of select="fecha_contratacion"/> - 
                                <xsl:value-of select="departamento/nombre"/>
                            </div>
                        </xsl:for-each>
                        <p><strong>Total: <xsl:value-of select="count(registro_empleados/empleado[fecha_contratacion >= '2020-01-01' and fecha_contratacion &lt; '2022-01-01'])"/> empleados</strong></p>
                    </div>
                    
                    <!-- Empleados más nuevos (2022 en adelante) -->
                    <div class="rango-antiguedad">
                        <h4>🆕 Empleados Más Nuevos (Contratados desde 2022)</h4>
                        <xsl:for-each select="registro_empleados/empleado[fecha_contratacion >= '2022-01-01']">
                            <xsl:sort select="fecha_contratacion"/>
                            <div style="margin: 5px 0; padding: 5px; background-color: #f8f9fa; border-radius: 3px;">
                                <strong><xsl:value-of select="nombre"/> <xsl:value-of select="apellido"/></strong> - 
                                <xsl:value-of select="fecha_contratacion"/> - 
                                <xsl:value-of select="departamento/nombre"/>
                            </div>
                        </xsl:for-each>
                        <p><strong>Total: <xsl:value-of select="count(registro_empleados/empleado[fecha_contratacion >= '2022-01-01'])"/> empleados</strong></p>
                    </div>
                </div>
                
                <!-- Lista completa ordenada por fecha de contratación (más antiguos primero) -->
                <h2>📋 Lista Completa de Empleados por Antigüedad</h2>
                <p style="color: #666; font-style: italic; margin-bottom: 20px;">
                    Ordenados de más antiguos a más nuevos por fecha de contratación
                </p>
                
                <xsl:for-each select="registro_empleados/empleado">
                    <xsl:sort select="fecha_contratacion"/>
                    <xsl:variable name="fecha-actual" select="fecha_contratacion"/>
                    <xsl:variable name="es-mas-antiguo" select="not($fecha-actual > preceding-sibling::empleado/fecha_contratacion) and not($fecha-actual > following-sibling::empleado/fecha_contratacion)"/>
                    <xsl:variable name="es-mas-nuevo" select="not($fecha-actual &lt; preceding-sibling::empleado/fecha_contratacion) and not($fecha-actual &lt; following-sibling::empleado/fecha_contratacion)"/>
                    
                    <div class="empleado">
                        <xsl:choose>
                            <xsl:when test="$es-mas-antiguo">
                                <xsl:attribute name="class">empleado mas-antiguo</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$es-mas-nuevo">
                                <xsl:attribute name="class">empleado mas-nuevo</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="class">empleado intermedio</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <div class="empleado-header">
                            <xsl:value-of select="nombre"/> <xsl:value-of select="apellido"/>
                            <xsl:if test="$es-mas-antiguo">
                                <span style="color: #dc3545; font-size: 14px;"> (MÁS ANTIGUO)</span>
                            </xsl:if>
                            <xsl:if test="$es-mas-nuevo">
                                <span style="color: #28a745; font-size: 14px;"> (MÁS NUEVO)</span>
                            </xsl:if>
                        </div>
                        
                        <div class="empleado-info">
                            <span class="posicion">Posición: <xsl:value-of select="posicion"/></span> | 
                            <span class="departamento">Departamento: <xsl:value-of select="departamento/nombre"/></span>
                        </div>
                        
                        <div class="empleado-info">
                            <span class="fecha-contratacion">📅 Fecha de Contratación: <xsl:value-of select="fecha_contratacion"/></span> | 
                            <span class="salario">Salario: $<xsl:value-of select="format-number(salario, '#,##0')"/></span>
                        </div>
                        
                        <div class="empleado-info">
                            📍 <xsl:value-of select="departamento/localizacion"/> | 
                            <xsl:choose>
                                <xsl:when test="tiempo_completo = 'true'">
                                    <span style="color: #28a745; font-weight: bold;">Tiempo Completo</span>
                                </xsl:when>
                                <xsl:otherwise>
                                    <span style="color: #ffc107; font-weight: bold;">Tiempo Parcial</span>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        
                        <div class="antiguedad">
                            <xsl:call-template name="calcular-antiguedad">
                                <xsl:with-param name="fecha-contratacion" select="fecha_contratacion"/>
                            </xsl:call-template>
                        </div>
                    </div>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    
    <!-- Template para calcular la antigüedad -->
    <xsl:template name="calcular-antiguedad">
        <xsl:param name="fecha-contratacion"/>
        <xsl:variable name="año-contratacion" select="substring($fecha-contratacion, 1, 4)"/>
        <xsl:variable name="año-actual" select="2024"/>
        <xsl:variable name="antiguedad-años" select="$año-actual - $año-contratacion"/>
        
        <xsl:choose>
            <xsl:when test="$antiguedad-años = 0">
                ⏰ Antigüedad: Menos de 1 año
            </xsl:when>
            <xsl:when test="$antiguedad-años = 1">
                ⏰ Antigüedad: 1 año
            </xsl:when>
            <xsl:otherwise>
                ⏰ Antigüedad: <xsl:value-of select="$antiguedad-años"/> años
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
