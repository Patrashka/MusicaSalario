<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Registro de Empleados - Vista Jerárquica de la Empresa</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; background-color: #f8f9fa; }
                    .empresa { 
                        background-color: white; 
                        padding: 20px; 
                        border-radius: 10px; 
                        box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
                        margin-bottom: 20px; 
                    }
                    .departamento { 
                        background-color: #e3f2fd; 
                        padding: 20px; 
                        margin: 15px 0; 
                        border-radius: 10px; 
                        border-left: 6px solid #007bff; 
                        box-shadow: 0 2px 5px rgba(0,0,0,0.1); 
                    }
                    .departamento-header { 
                        font-size: 22px; 
                        font-weight: bold; 
                        color: #007bff; 
                        margin-bottom: 10px; 
                        display: flex; 
                        align-items: center; 
                    }
                    .departamento-info { 
                        color: #666; 
                        margin-bottom: 15px; 
                        font-style: italic; 
                    }
                    .departamento-stats { 
                        background-color: #f8f9fa; 
                        padding: 10px; 
                        border-radius: 5px; 
                        margin-bottom: 15px; 
                        font-size: 14px; 
                    }
                    .empleados-container { 
                        display: grid; 
                        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); 
                        gap: 15px; 
                        margin-top: 15px; 
                    }
                    .empleado { 
                        background-color: white; 
                        padding: 15px; 
                        border-radius: 8px; 
                        border: 1px solid #dee2e6; 
                        box-shadow: 0 1px 3px rgba(0,0,0,0.1); 
                        transition: transform 0.2s; 
                    }
                    .empleado:hover { 
                        transform: translateY(-2px); 
                        box-shadow: 0 4px 8px rgba(0,0,0,0.15); 
                    }
                    .empleado-header { 
                        font-size: 16px; 
                        font-weight: bold; 
                        color: #333; 
                        margin-bottom: 8px; 
                        display: flex; 
                        align-items: center; 
                    }
                    .empleado-info { 
                        color: #666; 
                        margin-bottom: 5px; 
                        font-size: 14px; 
                    }
                    .posicion { 
                        color: #6c757d; 
                        font-style: italic; 
                        font-weight: bold; 
                    }
                    .salario { 
                        color: #28a745; 
                        font-weight: bold; 
                    }
                    .tiempo-completo { 
                        color: #28a745; 
                        font-weight: bold; 
                    }
                    .tiempo-parcial { 
                        color: #ffc107; 
                        font-weight: bold; 
                    }
                    .fecha { 
                        color: #6c757d; 
                        font-size: 12px; 
                    }
                    h1 { 
                        color: #333; 
                        text-align: center; 
                        margin-bottom: 30px; 
                        background: linear-gradient(135deg, #007bff, #28a745); 
                        -webkit-background-clip: text; 
                        -webkit-text-fill-color: transparent; 
                        background-clip: text; 
                    }
                    .empresa-stats { 
                        background: linear-gradient(135deg, #e3f2fd, #e8f5e8); 
                        padding: 20px; 
                        border-radius: 10px; 
                        margin-bottom: 30px; 
                        text-align: center; 
                    }
                    .stat-item { 
                        display: inline-block; 
                        margin: 0 20px; 
                        text-align: center; 
                    }
                    .stat-number { 
                        font-size: 24px; 
                        font-weight: bold; 
                        color: #007bff; 
                    }
                    .stat-label { 
                        color: #666; 
                        font-size: 14px; 
                    }
                    .icon { 
                        margin-right: 8px; 
                        font-size: 18px; 
                    }
                    .departamento-icon { 
                        margin-right: 10px; 
                        font-size: 20px; 
                    }
                    .empleado-icon { 
                        margin-right: 8px; 
                        font-size: 16px; 
                    }
                </style>
            </head>
            <body>
                <h1>🏢 Estructura Jerárquica de la Empresa</h1>
                
                <!-- Estadísticas generales de la empresa -->
                <div class="empresa-stats">
                    <div class="stat-item">
                        <div class="stat-number"><xsl:value-of select="count(registro_empleados/empleado[not(preceding-sibling::empleado[departamento/nombre = current()/departamento/nombre])])"/></div>
                        <div class="stat-label">Departamentos</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number"><xsl:value-of select="count(registro_empleados/empleado)"/></div>
                        <div class="stat-label">Total Empleados</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number"><xsl:value-of select="count(registro_empleados/empleado[tiempo_completo='true'])"/></div>
                        <div class="stat-label">Tiempo Completo</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number"><xsl:value-of select="count(registro_empleados/empleado[tiempo_completo='false'])"/></div>
                        <div class="stat-label">Tiempo Parcial</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">$<xsl:value-of select="format-number(sum(registro_empleados/empleado/salario) div count(registro_empleados/empleado), '#,##0')"/></div>
                        <div class="stat-label">Salario Promedio</div>
                    </div>
                </div>
                
                <!-- Vista jerárquica por departamentos -->
                <xsl:for-each select="registro_empleados/empleado">
                    <xsl:sort select="departamento/nombre"/>
                    <xsl:variable name="departamento-actual" select="departamento/nombre"/>
                    
                    <!-- Solo mostrar el departamento si es el primero o diferente al anterior -->
                    <xsl:if test="not(preceding-sibling::empleado[departamento/nombre = $departamento-actual])">
                        <xsl:variable name="empleados-departamento" select="../empleado[departamento/nombre = $departamento-actual]"/>
                        <xsl:variable name="total-empleados" select="count($empleados-departamento)"/>
                        <xsl:variable name="tiempo-completo" select="count($empleados-departamento[tiempo_completo='true'])"/>
                        <xsl:variable name="tiempo-parcial" select="count($empleados-departamento[tiempo_completo='false'])"/>
                        <xsl:variable name="salario-promedio" select="sum($empleados-departamento/salario) div $total-empleados"/>
                        
                        <div class="departamento">
                            <div class="departamento-header">
                                <span class="departamento-icon">🏢</span>
                                <xsl:value-of select="$departamento-actual"/>
                            </div>
                            
                            <div class="departamento-info">
                                <span class="icon">📍</span><xsl:value-of select="departamento/localizacion"/>
                            </div>
                            
                            <div class="departamento-stats">
                                <strong>Estadísticas del Departamento:</strong><br/>
                                👥 <strong>Total Empleados:</strong> <xsl:value-of select="$total-empleados"/> | 
                                ⏰ <strong>Tiempo Completo:</strong> <xsl:value-of select="$tiempo-completo"/> | 
                                ⏱️ <strong>Tiempo Parcial:</strong> <xsl:value-of select="$tiempo-parcial"/> | 
                                💰 <strong>Salario Promedio:</strong> $<xsl:value-of select="format-number($salario-promedio, '#,##0.00')"/>
                            </div>
                            
                            <div class="empleados-container">
                                <xsl:for-each select="$empleados-departamento">
                                    <xsl:sort select="apellido"/>
                                    <div class="empleado">
                                        <div class="empleado-header">
                                            <span class="empleado-icon">👤</span>
                                            <xsl:value-of select="nombre"/> <xsl:value-of select="apellido"/>
                                        </div>
                                        
                                        <div class="empleado-info">
                                            <span class="posicion">📋 <xsl:value-of select="posicion"/></span>
                                        </div>
                                        
                                        <div class="empleado-info">
                                            <span class="salario">💰 $<xsl:value-of select="format-number(salario, '#,##0')"/></span>
                                        </div>
                                        
                                        <div class="empleado-info">
                                            <xsl:choose>
                                                <xsl:when test="tiempo_completo = 'true'">
                                                    <span class="tiempo-completo">⏰ Tiempo Completo</span>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <span class="tiempo-parcial">⏱️ Tiempo Parcial</span>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </div>
                                        
                                        <div class="empleado-info">
                                            <span class="fecha">📅 Contratado: <xsl:value-of select="fecha_contratacion"/></span>
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                
                <!-- Resumen final -->
                <div class="empresa">
                    <h2>📊 Resumen Ejecutivo de la Empresa</h2>
                    <p>Esta vista jerárquica muestra la estructura organizacional completa de la empresa, 
                    organizando a todos los empleados por sus respectivos departamentos. Cada departamento 
                    incluye información detallada sobre su ubicación, número de empleados, distribución 
                    de tipos de contrato y salario promedio.</p>
                    
                    <div style="background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: 15px;">
                        <h3>🎯 Características de la Vista Jerárquica:</h3>
                        <ul>
                            <li><strong>Organización por Departamentos:</strong> Cada departamento se muestra como una unidad organizacional independiente</li>
                            <li><strong>Información Detallada:</strong> Cada empleado incluye posición, salario, tipo de contrato y fecha de contratación</li>
                            <li><strong>Estadísticas por Departamento:</strong> Métricas específicas para cada área de la empresa</li>
                            <li><strong>Vista Visual:</strong> Diseño que facilita la comprensión de la estructura organizacional</li>
                        </ul>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
