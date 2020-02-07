![](https://github.com/GEEKSHUBS-DEVOPS2020/trabajando-con-contenedores/blob/master/logo.png?raw=true)

# Alta Disponibilidad


```
Fecha: 07 y 08 de febrero de 2020
Profesor: David Pestana
Horas: 10
```

En esta unidad vamos a trabajar con diferentes técnicas para lograr **Alta Disponibilidad** (*HA*) en nuestros entornos de producción. Teniendo en cuenta que HA no solo es poder ofrecer un servicio continuado y sin cortes el 100% del tiempo si no que también es garantizar una **Calidad de Servicio** (*QoS*) dentro de unos parámetros durante todo este tiempo, sea cual sea el escenario.

## setup
* docker y docker-compose instalado y operativo en tu equipo.
* awscli
* kubectl
* kops
* microk8s o minikube

> nota: tanto awscli, kubectl y kops puedes ejecutarlos desde un contenedor y por tanto puedes ahorrarte su instalación
[https://hub.docker.com/r/skyscrapers/kops](https://hub.docker.com/r/skyscrapers/kops)

## contenidos
-   Que es y que no es alta disponibilidad (HA)
-   Como lograr alta disponibilidad (HA)
	- Viejas y nuevas técnicas.
	- Indice de disponibilidad 
- Objetivo Calidad de Servicio (QoS)
- Alta disponibilidad frente a la alta concurrencia.
	- Escalados Horizontal y Vertical
- Coste de la Alta disponibilidad.
	- El Auto escalado
- Alerta Tsunami !!!
	- Estudio de caso real
- Análisis de cuellos de botella
	- Becnhmarks (jmeter, locust)
	- Practica 1
- Infraestructura
	- Self provided
	- IaaS
	- PaaS
	- Practica 2
- Kubernetes, HPA y CA.
	- Kops
	- EKS, GKE, etc.
	- Practicas 3 y 4
 
> **dia 1**

# Alta disponibilidad	
### según wikipedia: 
Alta disponibilidad es un protocolo de diseño del sistema y su implementación asociada que asegura un cierto grado absoluto de continuidad operacional durante un período de medición dado.
## indice de disponibilidad
se mide dividiendo el tiempo durante el cual el servicio está disponible por el tiempo total en un periodo determinado, por ejemplo un año.
| Indice |Tiempo de inactividad  |
|--|--|
|97 %  |11 días  |
|99 %  |3 días y 15 horas  |
|99'9999 %  |32 segundos  |

> ¿ es el indice de disponibilidad 100% un valor utópico ?

## como lograr alta disponibilidad
### redundancia
al menos dos sistemas para resolver una sola función.
### balanceo
un reparto equitativo de la carga de trabajo
### tolerancia
los sistemas deben ser tolerantes a fallos
### resurrección
los sistemas deben tener mecanismos para volver a la vida sin intervención humana si llegan a morir

## Alta disponibilidad durante el despliegue
Ya estudiamos diferentes estrategias de despliegue que aseguraban un tiempo de *downtime* cero, y cualquiera de estas nos va a servir en nuestro protocolo de Alta Disponibilidad, pero ademas de esto tenemos que garantizar la posibilidad de *RollBack* en caso de fallo durante el despliegue. Disponer de un entorno de producción en un ambiente contenerizado nos va a facilitar mucho esta tarea aunque no es imprescindible. Capistrano, Capifony, Jenkins...  son algunas herramientas que nos permiten lograr Alta disponibilidad durante el despliegue sin trabajar con contenedores.
## Monitorización
Aunque la monitorización de por si no aporta ninguna garantía para lograr la alta disponibilidad, no podemos plantearnos prescindir de un correcto monitoreo a todos los niveles para detectar riesgos que puedan afectar a nuestro indice de disponibilidad.
## Cuellos de botella
La búsqueda constante de cuellos de botella mediante bechmarks y análisis de los monitores para que la prioridad sea siempre suavizar la incidencia de dichos cuellos de botella.

> Test de Braun.

## Viejas y nuevas técnicas básicas.

 - Implantar un servicio de CDN ( cloudflare, cloudfront )
	 - ventajas y posibles problemas
 - RoundRobin DNS como sistema básico de balanceo
 - Uso de NFS para compartir estado
 - ¿ Que nos puede aportar el servicio S3 de AWS ?
 - Proxy Inverso ( Nginx ) un balanceador mas evolucionado.
 - ¿ que mas conocemos ? 
	 
# Calidad de servicio ( QoS )
Según el servicio que estemos ofreciendo los parámetros de Calidad de Servicio podrán ser diversos, pero en habitual caso de ofrecer servicios web basados en las diferentes variantes del protocolo HTTP(s), el parámetro a medir para determinar la calidad del servicio es el tiempo de respuesta. Dejando de lado la tasa de bit que depende de la velocidad de conexión, generalmente la velocidad de conexión del cliente sera muy inferior a la que pueda ofrecer nuestra infraestructura tanto en upstream como en downstream. Consideraremos el tiempo de respuesta como el tiempo que tarda el sistema en entregar la respuesta una vez recibida la petición. Así como en la cantidad de respuestas por segundo que estamos siendo capaces de entregar.
En otros servicios tcp como por ejemplo WebSocket, la calidad de servicio se apalanca mas en la estabilidad de la conexión, ping y tasa de bit, asi como en la concurrencia de clientes suscritos.

En servicios HTTP ( request/response) ... consideraremos calidad de servicio mínima respuestas del orden de 200 a 500 milisegundos y una calidad de servicio optima tiempos del orden de 20 a 50 milisegundos,  tiempos por encima de 500 milisegundos son considerados inaceptables, y por tanto estar fuera de estos parámetros es igual a no estar ofreciendo alta disponibilidad.


# Alta disponibilidad frente a alta concurrencia
Los escenarios de producción pueden ser muy diferentes, pero existen escenarios en los que tenemos que garantizar alta disponibilidad cuando la concurrencia de conexiones es extremadamente elevada. Vease el caso de las redes sociales, periódicos digitales, servicios de streaming, etc.

### escalado vertical
>consiste en dotar de mas recursos a los sistemas que conforman la infraestructura, memoria, cpu... etc, el escalado vertical es limitado.

### escalado horizontal
>consiste en dotar de mas sistemas a la infraestructura, lo cual aumenta la redundancia y la capacidad de computación de manera infinita.


# ¿Cuanto cuesta la Alta disponibilidad?

El uso de sistemas escalados tanto vertical como horizontalmente aumenta los costes para poder garantizar la alta disponibilidad en casi cualquier escenario, sin embargo este posible escenario no se va a dar el 100% del tiempo.

### autoescalado
> consiste en disponer de mecanismos que aumenten o disminuyan de manera automática la dotación de recursos a un determinado servicio en función de la demanda, ahorrando muchísimos costes, pero a su vez aumenta la complejidad de implantación, gestión, despliegue... etc.

# Alerta Tsunami !!! 
En ocasiones también en algunos contextos o escenarios, podemos encontrarnos con crecimientos abismales en la concurrencia, tanto de manera prevista como imprevista, aumentos del 1000 o 10mil por ciento de la concurrencia en muy pocos segundos, el efecto de esto es similar al de un ataque por denegación de servicio ( DDoS ) y estar preparados para ello requiere mucho análisis.

### vamos a estudiar un caso real a través del siguiente informe.
https://github.com/GEEKSHUBS-DEVOPS2020/alta-disponibilidad/blob/master/informe.pdf



# Analisis de cuellos de botella
### benchmarks
Practica: https://github.com/GEEKSHUBS-DEVOPS2020/locust-environment


# Infraestructura
Para poder desempeñar correctamente un protocolo de alta disponibilidad necesitamos dotar la infraestructura necesaria, esta infraestructura puede ser propia o ser proveída como servicio.

### infraestructura self-provided
Tanto los elementos computacionales ( servidores ) como los elementos de red o interconexión ( cableado, routers, firewalls ) etc. son determinantes para lograr Alta Disponibilidad con Calidad de Servicio. En función del tipo de servicio que estemos ofreciendo tendremos que trabajar con el software adecuado tanto para la virtualización como para poder clusterizar nuestra infraestructura. 
Podemos también alojar nuestros servidores en un CPD y de este modo solo preocuparnos de su configuración.
Cabe notar que las técnicas de auto escalado no estarán disponibles ya que la capacidad de computación esta fijada, pudiendo estar sobredimensionada o infradimensionada según escenarios.
> software libre para virtualización y alta disponibilidad self-provided: [https://clusterlabs.org/](https://clusterlabs.org/)
> también podemos disponer de nodos K8S self hosted.

### Infraestructura como servicio IaaS
* AWS
* Google Cloud
* Digital Ocean
* Azure
* SoftLayer
### Plataforma como servicio  PaaS
* Heroku
* Platform
* BlueMix


> Practica:  AWS Auto Scaling

# Kubernetes, cluster autoescalado.

### kops
también conocido como Kubernetes Operations, es una herramienta cliente que nos permite desplegar, gestionar y optimizar nuestros clusters de kubernetes prácticamente en cualquier IaaS e incluso en modo SelfProvided

### EKS
producto de Amazon AWS, que nos provee un cluster de K8S preconfigurado aunque no auto escalado por defecto.

### GKE
producto de Google Cloud, que nos provee un cluster de K8S preconfigurado aunque no auto escalado por defecto.

### Kubernetes on DigitalOcean
producto de Digital Ocean, que nos provee un cluster de K8S preconfigurado aunque no auto escalado por defecto


## práctica: HPA ( Horizontal Pod Autoscaler )
efectuando esta practica sobre microk8s (utilizado en otras clases ) entenderemos los mecanismos por los cuales K8S gestiona la movilidad de los pods a través de los nodos, agregando o eliminando pods según los criterios configurados y la necesidad en cada instante.
[https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/)

## práctica: CA ( Cluster Autoscaler)
esta practica requiere mucho tiempo, pero iremos avanzando hasta donde sea posible
* montar un cluster K8S mediante Kops, existen muchos tutoriales y documentacion oficial:
	* [https://www.adictosaltrabajo.com/2018/09/05/kubernetes-en-aws-con-kops/](https://www.adictosaltrabajo.com/2018/09/05/kubernetes-en-aws-con-kops/)
	* [https://aws.amazon.com/es/blogs/compute/kubernetes-clusters-aws-kops/](https://aws.amazon.com/es/blogs/compute/kubernetes-clusters-aws-kops/)
*instalamos todas las herramientas y servicios basicos en nuestro cluster, como prometheus, grafana, etc.
	* [https://medium.com/faun/monitoring-with-prometheus-and-grafana-in-kubernetes-42727866562c](https://medium.com/faun/monitoring-with-prometheus-and-grafana-in-kubernetes-42727866562c)
* instalamos en nuestro cluster los servicios de Cluster Autoescaler y definimos los permisos en nuestro proveedor de IaaS
	* [https://aws-autoscaling.github.io/kops/](https://aws-autoscaling.github.io/kops/)
* en el repositorio que usamos para la practica con Locust, puedes encontrar el despliegue para subir a nuestro cluster K8S el API MOVIES y poder testear con Locust como nuestro cluster escala y desescala sus nodos.