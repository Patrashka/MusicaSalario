<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Registro de Empleados - Salario Promedio por Departamento</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .departamento { 
                        background-color: #f8f9fa; 
                        padding: 20px; 
                        margin: 15px 0; 
                        border-radius: 10px; 
                        border-left: 6px solid #007bff; 
                    }
                    .departamento-header { 
                        font-size: 20px; 
                        font-weight: bold; 
                        color: #007bff; 
                        margin-bottom: 10px; 
                    }
                    .departamento-info { 
                        color: #666; 
                        margin-bottom: 15px; 
                    }
                    .salario-promedio { 
                        background-color: #e8f5e8; 
                        padding: 15px; 
                        border-radius: 8px; 
                        text-align: center; 
                        margin-top: 10px; 
                    }
                    .salario-numero { 
                        font-size: 24px; 
                        font-weight: bold; 
                        color: #28a745; 
                    }
                    .salario-label { 
                        color: #666; 
                        font-size: 14px; 
                        margin-top: 5px; 
                    }
                    .empleados-lista { 
                        margin-top: 15px; 
                    }
                    .empleado { 
                        background-color: white; 
                        padding: 8px; 
                        margin: 5px 0; 
                        border-radius: 4px; 
                        border: 1px solid #dee2e6; 
                    }
                    .empleado-nombre { 
                        font-weight: bold; 
                        color: #333; 
                    }
                    .empleado-salario { 
                        color: #28a745; 
                        font-weight: bold; 
                    }
                    h1 { color: #333; text-align: center; margin-bottom: 30px; }
                    .resumen { 
                        background-color: #e3f2fd; 
                        padding: 20px; 
                        border-radius: 10px; 
                        margin-bottom: 30px; 
                        text-align: center; 
                    }
                    .resumen-item { 
                        display: inline-block; 
                        margin: 0 20px; 
                        text-align: center; 
                    }
                    .resumen-numero { 
                        font-size: 20px; 
                        font-weight: bold; 
                        color: #007bff; 
                    }
                    .resumen-label { 
                        color: #666; 
                        font-size: 14px; 
                    }
                </style>
            </head>
            <body>
                <h1>💰 Salario Promedio por Departamento</h1>
                
                <div class="resumen">
                    <div class="resumen-item">
                        <div class="resumen-numero"><xsl:value-of select="count(registro_empleados/empleado[not(preceding-sibling::empleado[departamento/nombre = current()/departamento/nombre])])"/></div>
                        <div class="resumen-label">Departamentos</div>
                    </div>
                    <div class="resumen-item">
                        <div class="resumen-numero"><xsl:value-of select="count(registro_empleados/empleado)"/></div>
                        <div class="resumen-label">Total Empleados</div>
                    </div>
                    <div class="resumen-item">
                        <div class="resumen-numero">$<xsl:value-of select="format-number(sum(registro_empleados/empleado/salario) div count(registro_empleados/empleado), '#,##0')"/></div>
                        <div class="resumen-label">Promedio General</div>
                    </div>
                </div>
                
                <!-- Calcular salario promedio por departamento -->
                <xsl:for-each select="registro_empleados/empleado">
                    <xsl:sort select="departamento/nombre"/>
                    <xsl:variable name="departamento-actual" select="departamento/nombre"/>
                    
                    <!-- Solo procesar si es el primer empleado de este departamento -->
                    <xsl:if test="not(preceding-sibling::empleado[departamento/nombre = $departamento-actual])">
                        <xsl:variable name="empleados-departamento" select="../empleado[departamento/nombre = $departamento-actual]"/>
                        <xsl:variable name="salario-promedio">
                            <xsl:value-of select="sum($empleados-departamento/salario) div count($empleados-departamento)"/>
                        </xsl:variable>
                        
                        <div class="departamento">
                            <div class="departamento-header">
                                <xsl:value-of select="$departamento-actual"/>
                            </div>
                            <div class="departamento-info">
                                📍 <xsl:value-of select="departamento/localizacion"/> | 
                                Empleados: <xsl:value-of select="count($empleados-departamento)"/>
                            </div>
                            
                            <div class="salario-promedio">
                                <div class="salario-numero">
                                    $<xsl:value-of select="format-number($salario-promedio, '#,##0.00')"/>
                                </div>
                                <div class="salario-label">Salario Promedio del Departamento</div>
                            </div>
                            
                            <div class="empleados-lista">
                                <h4>Empleados del Departamento:</h4>
                                <xsl:for-each select="$empleados-departamento">
                                    <xsl:sort select="apellido"/>
                                    <div class="empleado">
                                        <span class="empleado-nombre">
                                            <xsl:value-of select="nombre"/> <xsl:value-of select="apellido"/>
                                        </span> - 
                                        <span class="empleado-salario">
                                            $<xsl:value-of select="format-number(salario, '#,##0')"/>
                                        </span>
                                        <span style="color: #666; font-size: 12px;">
                                            (<xsl:value-of select="posicion"/>)
                                        </span>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                
                <!-- Resumen de salarios por departamento -->
                <div class="resumen" style="margin-top: 40px;">
                    <h3>📊 Resumen de Salarios por Departamento</h3>
                    <table style="width: 100%; border-collapse: collapse; margin-top: 15px;">
                        <thead>
                            <tr style="background-color: #f8f9fa;">
                                <th style="padding: 10px; text-align: left; border-bottom: 2px solid #007bff;">Departamento</th>
                                <th style="padding: 10px; text-align: right; border-bottom: 2px solid #007bff;">Empleados</th>
                                <th style="padding: 10px; text-align: right; border-bottom: 2px solid #007bff;">Salario Promedio</th>
                                <th style="padding: 10px; text-align: right; border-bottom: 2px solid #007bff;">Salario Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="registro_empleados/empleado">
                                <xsl:sort select="departamento/nombre"/>
                                <xsl:variable name="departamento-actual" select="departamento/nombre"/>
                                <xsl:if test="not(preceding-sibling::empleado[departamento/nombre = $departamento-actual])">
                                    <xsl:variable name="empleados-departamento" select="../empleado[departamento/nombre = $departamento-actual]"/>
                                    <xsl:variable name="salario-promedio" select="sum($empleados-departamento/salario) div count($empleados-departamento)"/>
                                    <xsl:variable name="salario-total" select="sum($empleados-departamento/salario)"/>
                                    
                                    <tr>
                                        <td style="padding: 10px; border-bottom: 1px solid #eee;">
                                            <strong><xsl:value-of select="$departamento-actual"/></strong>
                                        </td>
                                        <td style="padding: 10px; text-align: right; border-bottom: 1px solid #eee;">
                                            <xsl:value-of select="count($empleados-departamento)"/>
                                        </td>
                                        <td style="padding: 10px; text-align: right; border-bottom: 1px solid #eee; color: #28a745; font-weight: bold;">
                                            $<xsl:value-of select="format-number($salario-promedio, '#,##0.00')"/>
                                        </td>
                                        <td style="padding: 10px; text-align: right; border-bottom: 1px solid #eee; color: #007bff; font-weight: bold;">
                                            $<xsl:value-of select="format-number($salario-total, '#,##0')"/>
                                        </td>
                                    </tr>
                                </xsl:if>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
