# Proyecto Devops 2024


Este proyecto tiene como idea principal el aprendizaje sobre distintos temas y poner en práctica lo aprendido a través de un laboratorio que permita integrar diferentes herramientas y tecnologías.

Durante la  primera parte nos centramos en la creación de una instancia de `EC2` en AWS para poder desde allí realizar todas las tareas necesarias. 

dentro de esta instancia crear un Cluster con eksctl y cloudFormation.

El objetivo es desplegar un pod de nginx, utilizando cualquier metodo valido, hasta la misma consola de aws
Instalar herramientas de monitoreo de pods 

Workflow:

    Crea una instancia EC2.
    Instala las herramientas necesarias en la instancia.
    Crea un cluster EKS.
    Instala el driver EBS CSI.
    Despliega un pod de Nginx.
    Instala Prometheus y Grafana para monitoreo.

Pasos detallados:

    La instancia EC2 se crea con las herramientas necesarias (Docker, kubectl, eksctl, etc.).
    Se crea un cluster EKS usando eksctl.
    Se actualiza el kubeconfig para interactuar con el cluster.
    Se instala el driver EBS CSI para soporte de volúmenes persistentes.
    Se despliega un Deployment y un Service de Nginx.
    Se instala Prometheus y Grafana para monitoreo usando Helm.



    Crean un rol IAM llamado EC2EKSRole con una política de confianza que permite a EC2 asumir este rol.

    Adjuntan las políticas necesarias al rol:
        AmazonEKSClusterPolicy
        AmazonEKSWorkerNodePolicy
        AmazonEC2ContainerRegistryFullAccess
        AmazonEKS_CNI_Policy

    Crean un perfil de instancia llamado EC2EKSProfile y asocian el rol a este perfil.

    Esperan a que el perfil de instancia esté disponible.

    Lanzan la instancia EC2 con el perfil de instancia recién creado.

Para usar este workflow:

    Se Agregan los archivos ec2_user_data.sh, create_eks_cluster.sh, deploy_nginx y setup_monitoring.
    Ajustar los permisos de los scripts antes de commitearlos al repositorio
        
        chmod +x create_eks_cluster.sh
        chmod +x deploy_nginx.sh
        chmod +x setup_monitoring.sh
        chmod +x ec2_user_data.sh
        Alternativa para dar permisos a todos--> find . -name "*.sh" -exec chmod +x {} \;

    Las credenciales de AWS tienen los permisos necesarios para crear recursos EC2 y EKS.
    Se ejecuta el workflow desde la interfaz de GitHub Actions.

El workflow para que al final del proceso, muestra la URL donde se puede acceder a la página con el mensaje "HOLA MUNDO DESDE PIN_Final".

    En el script deploy_nginx.sh, creamos un ConfigMap con un archivo HTML personalizado que contiene el mensaje "HOLA MUNDO DESDE PIN_Final".

    El Deployment de Nginx monta este ConfigMap como un volumen, reemplazando el archivo index.html predeterminado.

    Se añade un bucle para esperar hasta que el servicio de LoadBalancer obtenga una IP externa.

    En el job deploy-nginx del workflow, capturamos la IP externa y la guardamos como output del job.

    El job display-url al final del workflow que muestra la URL de la aplicación Nginx.

El workflow delete.yaml eliminará todos los recursos creados en AWS, incluyendo el cluster EKS, la instancia EC2, la VPC y sus recursos asociados, el key pair y los roles IAM.