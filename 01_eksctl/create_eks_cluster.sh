#!/bin/bash

# Verificar que tenemos las credenciales de AWS
if ! aws sts get-caller-identity &>/dev/null; then
    echo "Error: No se pueden obtener las credenciales de AWS. Asegúrate de que la instancia EC2 tiene un rol IAM apropiado."
    exit 1
fi

# Crear cluster EKS
#eksctl create cluster --name my-cluster --region us-east-1 --nodegroup-name standard-workers --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4 --managed

# Crear el cluster EKS
echo "Creando el cluster EKS..."
eksctl create cluster -f 01_eksctl/eksctl_config.yaml

# Verificar que el cluster se ha creado correctamente
if ! kubectl get nodes &>/dev/null; then
    echo "Error: No se pudo crear el cluster EKS."
    exit 1
fi

# Actualizar kubeconfig
aws eks get-token --cluster-name my-cluster | kubectl apply -f -

# Instalar el driver EBS CSI
#kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

# Aplicar configuraciones adicionales
echo "Aplicando configuraciones adicionales..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/deploy/kubernetes/overlays/stable/ecr/ebs-csi-driver.yaml


echo "Cluster EKS creado y configurado."

# Obtener información del cluster
echo "Información del cluster:"
kubectl cluster-info

echo "Nodos del cluster:"
kubectl get nodes