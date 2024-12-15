# DevOps-FlyPass
Este repositorio contiene todo el codigo fuente para la solucion del reto tecnico para el rol DevOps Engineer en FlyPass.

## Explicacion:
El proyecto consta de 4 partes importantes, que son `.github/`, `Dockerfiles/`, `Terraform/`, `k8s/`. A continuacion, una explicacion del contenido de cada uno de los folders:

- **.github/**: Contiene los pipelines necesarios para el `CI/CD` del proyecto, permitiendo automatizar la integracion y despliegue de cada uno de los componentes (*Infraestructura, Pods, Imagenes Docker*). 

- **Dockerfiles/**: Contiene 2 aplicaciones con su logica y `Dockerfiles` las cuales son buildeadas y desplegadas en `ECR` por medio de uno de los pipelines.

- **Terraform/**: Contiene toda la infraestructura necesaria para que el proyecto funcione con servicios de AWS como `ECR`, `IAM`, `EKS`, `VPC` y `S3`. Su valdiacion y despliegue tambien se realiza automatcamente por medio de los pipelines.

- **k8s/**: Contiene el manifesto para generar el pod principal que contiene los 2 contenedores generados anteriormente. El pod se despliega desde uno de los pipelines de manera automatizada.

Entendiendo todo lo anterior, me parece importante dar algunos detalles que permitan entender de mejor manera el por que la estructura del proyecto.

En primer lugar la arquitectura definida para manejar la infraestructura de `Terraform` surge de "[`terraform-aws-provider-best-practices`](https://docs.aws.amazon.com/es_es/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html)", que forma parte de la documentacion oficial de AWS sobre como se recomienda manejar los proyectos en `Terraform`  para permitir una mayor escalabilidad.

Por otro lado decidi manejar la definicion y despliegue del `pod` de manera independiente a `Terraform` ya que queria tener todo mas segmentado y leyendo algunos foros se recomendaba tener esa parte por fuera de `Terraform`, ya que asi lograriamos tener *mayor flexibilidad a la hora de realizar cambios*.

Tambien hice uso de tecnicas como el `replace token` con `envsubst` con el fin de poder autenticar uno de los contenedores con AWS y generar dinamicamente las `URIs de ECR` en el `manifesto del pod`. Con esto tenemos la seguridad de no exponer datos sensibles y modificamos en tiempo de ejecucion del pipeline archivos del repositorio.

## Branching y Seguridad:
Principalmente disene el siguiente gitflow como propuesta para tener una mayor robustes a la hora desplegar en los diferentes ambientes y seguridad al realizar cambios en el repositorio ya que las ramas como `develop`, `release` y `master` estan protegidas y solo se puden modificar atraves de `pull requests`.

<img src="https://i.ibb.co/QMKPzMS/Items.png" alt="Items" border="0">

Como una medida de seguridad utilize [`GitGuardian`](https://www.gitguardian.com) el cual me permite realizar diferentes cosas como escanear los `pull requests` antes de hacer merge, escanear de manera automatizada o on demand el repositorio en busca de fallos de seguridad en el mismo, para con eso asegurar la mayor calidad del codigo y asegurar que en el despliegue del mismo no se vayan brechas de seguridad indeseadas.

Aca un ejemplo de una de las validaciones en uno de los `pull requests` :

<img src="https://i.ibb.co/mt0YBxj/Git-Guardian.png" alt="Git-Guardian" border="0">

Otra de las acciones tomadas, y que formaban parte del reto, fue proteger las ramas principales `develop`, `release` y `master`, lo cual se realizo agregando nuevas reglas con ayuda de las configuraciones de ramas que proporciona GitHub.

En mi caso y a definicion de la prueba se habilitaron las reglas:

- Require a pull request before merging (*Requiriendo 1 aprobador*)
- Require status checks to pass
- Restrict deletions

## Notas finales:

En la infraestructura de Terraform genere 4 subnets (*2 publicas y 2 privadas*) en mi VPC como extra en caso de se pudiesen necesitar.

Finalmente agradezco la oportunidad y el confiar en mi, dandome la posibilidad de pertenecer al equipo. Me diverti realizando el proyecto he independiendtemente del resultado, agradeceria que me ayudasen con el feedback con respecto a mi rendimiento en la prueba.


<p align="center">
  <b>Hecho con &#10084; por: Sebastián. </b>
</p>
