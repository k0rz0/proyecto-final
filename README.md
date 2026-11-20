# Proyecto Final: Administración de Infraestructura de TI
## Implementación Integral de Servicios — EXPRESO BRASILIA S.A.

**Institución:** Universidad del Quindío  
**Facultad:** Facultad de Ingeniería de Sistemas y Computación  
**Docente:** Maycol Cárdenas Acevedo  
**Equipo Consultor / Estudiantes:** Leonardo Gallego Ríos (Leo) & Keren  
**Estación de Trabajo:** Windows 11  
**Servidor Implementado:** `MV1` (Ubuntu 24.04.4 LTS — Kernel 6.17.0-23-generic)  
**Semestre:** 2026-1  
**Ponderación:** 20% de la nota final  

---

## 📌 Resumen Ejecutivo

Este repositorio contiene la entrega integral y definitiva del Proyecto Final de la asignatura. Se diseñó, documentó y verificó una **arquitectura híbrida de infraestructura de TI** para la empresa de transporte terrestre de pasajeros y carga **EXPRESO BRASILIA S.A.**, respondiendo a sus necesidades de alta disponibilidad, sincronización horaria legal, soporte multiplataforma e interoperabilidad de servicios.

La infraestructura combina:
1. **Plataforma PaaS Dokploy v0.31.4 (Docker Swarm + Traefik Ingress):**
   * Panel de control gráfico centralizado en puerto TCP `3000`.
   * Enrutamiento dinámico mediante Traefik Ingress hacia el dominio corporativo `brasilia.localhost` (puerto HTTP :80 / HTTPS :443).
   * Despliegue de aplicación web institucional `brasilia-portal` con telemetría interactiva de flota de buses en tiempo real.
   * Base de datos relacional PostgreSQL 18 (`db-brasilia`) en red virtual *overlay* aislada.
   * Monitoreo de telemetría de CPU, memoria, disco y Docker en tiempo real y destinos de respaldos configurados a Amazon S3.
   * Motor de despliegues y control de compilaciones concurrentes (*Concurrent Builds*) serializadas para estabilidad del servidor.
2. **Servicios Tradicionales de Infraestructura Linux:**
   * **NTP (Chrony):** Sincronización horaria de precisión con servidores de Colombia, exigida por la Superintendencia de Transporte.
   * **NFS v4:** Repositorio centralizado de manuales y telemetría para estaciones Linux de talleres (`/srv/nfs/telemetria_buses`).
   * **NIS:** Directorio y autenticación unificada de cuentas para operadores de taquillas y despachos (`brasilia.corp`).
   * **CUPS 2.4:** Servidor de colas e impresión de tiquetes térmicos de pasajes en puerto 631 / 1631 (`Impresora_Termica_Tiquetes`).
   * **Samba (SMB/CIFS):** Compartición de archivos administrativos con permisos restringidos (`[brasilia-admin]`) para estaciones Windows 11.
3. **Seguridad Perimetral y Auditoría Automatizada:**
   * Cortafuegos UFW restrictivo (*Deny All Incoming* por defecto) con apertura estricta de puertos (22, 80, 443, 3000, 631, 123, 2049, 445).
   * Herramienta interactiva de auditoría en vivo `consola_demo.py` para diagnóstico en tiempo real.

---

## 📂 Estructura del Repositorio

El repositorio se encuentra estrictamente organizado según el estándar requerido por la rúbrica oficial de la asignatura:

```text
proyecto-final/
├── analisis.md                                        # Análisis de necesidades y diseño (Semana 1)
├── diagrama.mmd                                       # Diagrama de arquitectura en formato Mermaid
├── documentacion.md                                   # Documentación técnica completa (Semanas 2, 3 y 4)
├── README.md                                          # Instrucciones y resumen ejecutivo de entrega
├── capturas/                                          # Screenshots de servicios funcionando (18 evidencias)
│   ├── dokploy_01_dashboard.png                       # Panel web general de Dokploy v0.31.4
│   ├── dokploy_02_proyecto_app.png                    # Aplicación web Expreso Brasilia desplegada
│   ├── dokploy_03_traefik_ssl.png                     # Enrutamiento Traefik y gestión de dominios
│   ├── dokploy_04_bases_datos.png                     # Bases de datos PostgreSQL en Swarm
│   ├── dokploy_05_monitoreo_cpu_ram.png               # Monitoreo de telemetría de CPU, RAM y Docker
│   ├── dokploy_06_backups_s3.png                      # Destinos de respaldos en Amazon S3
│   ├── dokploy_07_deployments_git.png                 # Historial de despliegues y concurrent builds
│   ├── linux_01_verificacion_entorno.png              # Recursos del servidor e IP estática
│   ├── linux_02_ntp_sincronizacion.png                # Sincronización horaria con Chrony (Colombia)
│   ├── linux_03_nfs_servidor_export.png               # Servidor NFS v4 y exportación de carpetas
│   ├── linux_04_nfs_cliente_montaje.png               # Montaje en cliente Linux (/mnt/brasilia)
│   ├── linux_05_nis_servidor_ypcat.png                # Servidor NIS y consulta unificada ypcat
│   ├── linux_06_nis_cliente_login.png                 # Autenticación de usuario centralizada por NIS
│   ├── linux_07_cups_panel_web_631.png                # Interfaz web de CUPS en puerto 631 / 1631
│   ├── linux_08_cups_impresion_prueba.png             # Cola de impresión y tiquete procesado
│   ├── linux_09_samba_configuracion.png               # Configuración de Samba y testparm
│   ├── linux_10_samba_cliente_windows.png             # Acceso desde Explorador de Windows 11
│   └── extra_01_firewall_ufw.png                      # Reglas de cortafuegos UFW perimetral
└── codigo/                                            # Configuraciones y scripts propios
    ├── cupsd.conf                                     # Configuración de acceso y seguridad CUPS
    ├── docker-compose.yml                             # Multi-servicio portal y base de datos
    ├── exports                                        # Configuración de exportaciones NFS v4
    ├── ntp.conf                                       # Configuración de sincronización horaria
    ├── setup_infraestructura_brasilia.sh              # Script bash de aprovisionamiento automatizado
    ├── smb.conf                                       # Configuración de recursos compartidos Samba
    ├── yp.conf                                        # Configuración de cliente y servidor NIS
    ├── consola_demo.py                                # Auditor interactivo en vivo de servicios
    └── webapp/                                        # Aplicación Node.js del portal corporativo
        ├── package.json
        ├── .env
        └── src/index.js
```

---

## ⚙️ Instrucciones de Uso y Verificación

1. **Revisión de la Documentación:**
   * El diagnóstico empresarial y justificación de servicios se encuentra en [`analisis.md`](./analisis.md).
   * La bitácora técnica paso a paso con comandos y explicaciones está en [`documentacion.md`](./documentacion.md).
   * El diagrama de arquitectura de la solución se visualiza en [`diagrama.mmd`](./diagrama.mmd).

2. **Auditoría de Servicios en Vivo:**
   Para verificar interactivamente el estado y funcionamiento en tiempo real de cada servicio, se incluye el script auditor:
   ```bash
   python codigo/consola_demo.py
   ```
