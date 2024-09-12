#!/bin/bash

# Instalar Prometheus y Grafana para monitoreo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

echo "Herramientas de monitoreo instaladas."