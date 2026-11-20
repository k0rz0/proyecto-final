const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Endpoint Principal: Portal Corporativo Expreso Brasilia
app.get('/', (req, res) => {
    res.json({
        empresa: "EXPRESO BRASILIA S.A.",
        eslogan: "Viajar es vivir",
        servicio: "Portal Institucional y Gestión de Pasajes",
        version: "1.0.0",
        entorno: process.env.NODE_ENV || "production",
        plataforma: "Dokploy PaaS (Docker Swarm)",
        cobertura: "+750 destinos nacionales e internacionales",
        sede_central: "Barranquilla, Colombia",
        timestamp: new Date().toISOString()
    });
});

// Endpoint Healthcheck para Traefik / Dokploy Ingress
app.get('/health', (req, res) => {
    res.status(200).json({
        estado: "saludable",
        servicio: "expreso-brasilia-api",
        uptime_segundos: Math.floor(process.uptime()),
        memoria_mb: Math.round(process.memoryUsage().rss / 1024 / 1024),
        nodo: process.env.HOSTNAME || "swarm-worker-01"
    });
});

// Endpoint de Rutas Comerciales
app.get('/api/rutas', (req, res) => {
    res.json([
        { id: "EB-101", origen: "Barranquilla", destino: "Bogotá", servicio: "Premium Plus", duracion_hrs: 18, tarifa_cop: 145000 },
        { id: "EB-204", origen: "Armenia", destino: "Medellín", servicio: "Gaviota Oro", duracion_hrs: 6, tarifa_cop: 75000 },
        { id: "EB-305", origen: "Cali", destino: "Cartagena", servicio: "Premium Plus", duracion_hrs: 20, tarifa_cop: 160000 },
        { id: "EB-410", origen: "Bogotá", destino: "Cúcuta", servicio: "Preferencial", duracion_hrs: 14, tarifa_cop: 110000 }
    ]);
});

// Endpoint de Despacho y Puestos de Control
app.get('/api/despacho', (req, res) => {
    res.json({
        puesto_control: "Terminal Armenia - Quindío",
        despachos_hoy: 42,
        flota_activa: "Scania Marcopolo Paradiso 1200",
        sincronizacion_ntp: "ACTIVA - Servidor Local 192.168.40.100",
        impresion_tiquetes: "CUPS Spooler Listo (Puerto 631)"
    });
});

// Endpoint de Información Técnica de Infraestructura
app.get('/api/info', (req, res) => {
    res.json({
        institucion: "Universidad del Quindío",
        facultad: "Facultad de Ingeniería de Sistemas y Computación",
        curso: "Administración de Infraestructura de TI",
        proyecto: "Proyecto Final de Servicios de Infraestructura",
        arquitectura: {
            paas: "Dokploy v0.8.x sobre Docker Swarm",
            proxy_inverso: "Traefik v2.10 con SSL/TLS automatizado",
            bd_transaccional: "MySQL 8.0 en Red Overlay interna",
            servicios_linux: ["NTP", "NFS v4", "NIS", "CUPS", "Samba"]
        }
    });
});

app.listen(port, '0.0.0.0', () => {
    console.log(`[EXPRESO BRASILIA] Portal ejecutándose en puerto ${port}`);
    console.log(`[DOKPLOY] Modo: ${process.env.NODE_ENV || 'production'}`);
});
