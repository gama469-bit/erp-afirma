# Script para ejecutar ERP Afirma con Docker de forma simple
# Este script crea y ejecuta la aplicación sin Docker Compose

# Construir la imagen
docker build -t erp-afirma .

# Ejecutar PostgreSQL en contenedor separado
docker run -d \
  --name erp-postgres \
  -e POSTGRES_DB=BD_afirma \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=password123 \
  -p 5432:5432 \
  postgres:15

# Esperar a que PostgreSQL esté listo
echo "Esperando a que PostgreSQL esté listo..."
sleep 10

# Ejecutar la aplicación conectándose a PostgreSQL
docker run -d \
  --name erp-afirma-app \
  --link erp-postgres:db \
  -e NODE_ENV=production \
  -e DB_HOST=db \
  -e DB_PORT=5432 \
  -e DB_NAME=BD_afirma \
  -e DB_USER=postgres \
  -e DB_PASSWORD=password123 \
  -p 3000:3000 \
  erp-afirma

echo "🎉 ERP Afirma ejecutándose en:"
echo "📍 http://localhost:3000"
echo ""
echo "Para ver logs:"
echo "docker logs erp-afirma-app -f"
echo ""
echo "Para detener:"
echo "docker stop erp-afirma-app erp-postgres"
echo "docker rm erp-afirma-app erp-postgres"