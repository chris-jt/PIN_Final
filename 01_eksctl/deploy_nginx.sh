#!/bin/bash
# Crear un ConfigMap con el contenido HTML
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-index-html-configmap
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head>
        <title>PIN_Final</title>
    </head>
    <body>
        <h1>HOLA MUNDO DESDE PIN_Final</h1>
    </body>
    </html>
EOF

# Desplegar Nginx
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
        volumeMounts:
        - name: nginx-index-html
          mountPath: /usr/share/nginx/html/
      volumes:
      - name: nginx-index-html
        configMap:
          name: nginx-index-html-configmap
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
EOF

# Esperar a que el servicio obtenga una IP externa
echo "Esperando a que el servicio obtenga una IP externa..."
while [ -z "$EXTERNAL_IP" ]; do
  EXTERNAL_IP=$(kubectl get service nginx-service --template="{{range .status.loadBalancer.ingress}}{{.hostname}}{{end}}")
  [ -z "$EXTERNAL_IP" ] && sleep 10
done

echo "Nginx desplegado. Accesible en: http://$EXTERNAL_IP"
echo "EXTERNAL_IP=$EXTERNAL_IP" >> $GITHUB_OUTPUT