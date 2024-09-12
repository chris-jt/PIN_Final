#!/bin/bash

# Agregar repositorios de Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Desplegar Prometheus
kubectl create namespace prometheus
helm install prometheus prometheus-community/prometheus \
  --namespace prometheus \
  --set alertmanager.persistentVolume.storageClass="gp2" \
  --set server.persistentVolume.storageClass="gp2"

# Exponer Prometheus (esto se hará en segundo plano)
kubectl port-forward -n prometheus deploy/prometheus-server 8080:9090 --address 0.0.0.0 &

# Desplegar Grafana
kubectl create namespace grafana
helm install grafana grafana/grafana \
  --namespace grafana \
  --set persistence.storageClassName="gp2" \
  --set persistence.enabled=true \
  --set adminPassword='EKS!sAWSome' \
  --values /home/ubuntu/grafana-values.yaml \
  --set service.type=LoadBalancer

# Esperar a que el servicio de Grafana obtenga una IP externa
echo "Esperando a que Grafana obtenga una IP externa..."
while [ -z "$GRAFANA_IP" ]; do
  GRAFANA_IP=$(kubectl get svc -n grafana grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  [ -z "$GRAFANA_IP" ] && sleep 10
done

echo "Grafana está disponible en: http://$GRAFANA_IP"
echo "GRAFANA_URL=http://$GRAFANA_IP" >> $GITHUB_OUTPUT