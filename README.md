# DevOps-FlyPass
Este repositorio contiene todo el código fuente para la solución del reto técnico para el rol de **DevOps Engineer** en **FlyPass**.

## Explicación:
El proyecto consta de 4 partes importantes, que son `.github/`, `Dockerfiles/`, `Terraform/` y `k8s/`. A continuación, se presenta una explicación del contenido de cada una de las carpetas:

- **.github/**: Contiene los pipelines necesarios para el `CI/CD` del proyecto, permitiendo automatizar la integración y el despliegue de cada uno de los componentes (*Infraestructura, Pods, Imágenes Docker*). 

- **Dockerfiles/**: Contiene 2 aplicaciones con su lógica y `Dockerfiles`, las cuales son construidas y desplegadas en `ECR` mediante uno de los pipelines.

- **Terraform/**: Contiene toda la infraestructura necesaria para que el proyecto funcione con servicios de AWS como `ECR`, `IAM`, `EKS`, `VPC` y `S3`. Su validación y despliegue también se realizan automáticamente mediante pipelines.

- **k8s/**: Contiene el manifiesto para generar el pod principal que contiene los 2 contenedores generados anteriormente. El pod se despliega desde uno de los pipelines de manera automatizada.

Entendiendo todo lo anterior, considero importante proporcionar algunos detalles que permitan entender mejor la estructura del proyecto.

En primer lugar, la arquitectura definida para manejar la infraestructura de `Terraform` se basa en "[`terraform-aws-provider-best-practices`](https://docs.aws.amazon.com/es_es/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html)", que forma parte de la documentación oficial de AWS sobre cómo se recomienda manejar los proyectos en `Terraform` para permitir una mayor escalabilidad.

Por otro lado, decidí manejar la definición y el despliegue del `pod` de manera independiente a `Terraform` ya que quería tener todo más segmentado. Tras leer algunos foros, se recomendaba tener esa parte fuera de `Terraform`, ya que de este modo lograríamos *mayor flexibilidad al realizar cambios*.

También hice uso de técnicas como el `replace token` con `envsubst` para autenticar uno de los contenedores con AWS y generar dinámicamente las `URIs de ECR` en el `manifiesto del pod`. Con esto, garantizamos la seguridad de no exponer datos sensibles y modificamos archivos del repositorio en tiempo de ejecución del pipeline.

## Branching y Seguridad:
Principalmente diseñé el siguiente gitflow como propuesta para tener una mayor robustez al desplegar en los diferentes ambientes y seguridad al realizar cambios en el repositorio, ya que las ramas como `develop`, `release` y `master` están protegidas y solo se pueden modificar a través de `pull requests`.

<p align="center">
<img src="https://i.ibb.co/QMKPzMS/Items.png" alt="Items" border="0">
</p>

Como medida de seguridad, utilicé [`GitGuardian`](https://www.gitguardian.com), el cual me permite realizar diferentes acciones como escanear los `pull requests` antes de hacer merge, escanear de manera automatizada o bajo demanda el repositorio en busca de fallos de seguridad, con el fin de asegurar la mayor calidad del código y evitar que se introduzcan brechas de seguridad indeseadas.

Aquí un ejemplo de una de las validaciones en un `pull request`:

<p align="center">
<img src="https://i.ibb.co/mt0YBxj/Git-Guardian.png" alt="Git-Guardian" border="0">
</p>

Otra de las acciones tomadas, y que formaban parte del reto, fue proteger las ramas principales `develop`, `release` y `master`, lo cual se realizó agregando nuevas reglas con la ayuda de las configuraciones de ramas que proporciona GitHub.

En mi caso y según la definición de la prueba, se habilitaron las siguientes reglas:

- Requerir un `pull request` antes de hacer merge (*Requiriendo 1 aprobador*).
- Requerir que los `status checks` pasen.
- Restringir la eliminación de ramas.

## Notas finales:
En la infraestructura de Terraform, generé 4 subnets (*2 públicas y 2 privadas*) en mi VPC como medida adicional, por si fueran necesarias.

Finalmente, agradezco la oportunidad y la confianza depositada en mí, dándome la posibilidad de pertenecer al equipo. Me divertí realizando el proyecto y, independientemente del resultado, agradecería que me brindaran retroalimentación con respecto a mi desempeño en la prueba.

<p align="center">
  <b>Hecho con &#10084; por: Sebastián. </b>
</p>
