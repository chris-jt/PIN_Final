#!/bin/bash

# Crear cluster EKS
eksctl create cluster --name my-cluster --region us-east-1 --nodegroup-name standard-workers --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4 --managed

# Actualizar kubeconfig
aws eks get-token --cluster-name my-cluster | kubectl apply -f -

# Instalar el driver EBS CSI
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

echo "Cluster EKS creado y configurado."