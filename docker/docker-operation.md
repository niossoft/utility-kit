## My Step from Spring Boot Application to Docker, and then Minikube

Create Docker Image for Spring Boot App: Step by Step

### Prerequisite

Making sure docker installed in your device.

```
    docker version
```

## Docker Configuration

#### Step 1. Create a Spring Boot application

For me, I fetch the validation-demo project as my demo Spring Boot Project.

#### Step 2. Create Executable JAR

```
    mvn clean install 
```

#### Step 3. Create the Docker File

```
FROM openjdk:17
VOLUME /tmp
EXPOSE 8080
ARG JAR_FILE=target/demo-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
```



| Tag | Description |
| -------- | -------- |
| FROM    | command imports the Java image from the docker library to our container so that our spring boot application can run.     |
| LABEL    | command specifies the label for this image and ADD command is used to add the JAR file of our spring boot application to the docker container.     |
| ENTRYPOINT    | is used to specify the run command. We can notice that the array of strings combinedly makes a command that we usually use to run the JAR file from the cmd/terminal. This command executes our spring boot application into the docker container.     |


#### Step 4. Build the image with Docker

```
    docker build -t ds-demo:latest .
```

**-t** is for image tag setup, colon(:) is for tag name and dot(.) is for current directory.


```
    docker image
```

display the image list with attributes.

#### Step 5. Run the builded image and test it!

```
    docker run -p 8090:8080 ds-demo
```

**-p** is for port number setup, mapping port 8080 to 8090. 8080 is defualt port number for Tomcat.

we can access with below URL format.
```
    GET http://localhost:8090/test/hello
```

then, we got the response string.

Result:
```
    Hello from Kevin!
```

## Minikube Configuration

### Prerequisite

Making sure minikube installed in your device.
and we can start the minikube with below command.

```
    minikube start
```

**Tips: before starting, please launch the cmd with admin mode.**

```
    minikube start --driver=hyperv 
```

Because Windows will launch it with Virtualbox as default, so that we can add below to setup for **hyperv**.

```
    minikube config set driver hyperv
```

After minikube started, using below command to re-use the Docker daemon.

> The command minikube docker-env returns a set of Bash environment variable exports to configure your local environment to re-use the Docker daemon inside the Minikube instance.

Official: https://minikube.sigs.k8s.io/docs/commands/docker-env/

Ref: https://stackoverflow.com/questions/52310599/what-does-minikube-docker-env-mean
```
    minikube docker-env
```

### yaml Creation

create service.yaml

```
apiVersion: v1
kind: Service
metadata:
  name: <service-name>
spec:
  type: NodePort
  selector:
    app: <image-name>
  ports:
    - name: http
      port: 80
      targetPort: 8080
      nodePort: 30005
```

create deployment.yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: <pod-name>
spec:
  replicas: 2
  selector:
    matchLabels:
      app: <image-name>
  template:
    metadata:
      labels:
        app: <image-name>
    spec:
      containers:
        - name: <image-name>
          image: <image-name>:<tag>
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8080
          env:
            - name: SAMPLE_SERVICE_URL
              value: "http://sample-service:80"            
```

deploy these deployments:

```      
    kubectl apply -f deployment.yaml
```

```      
    kubectl apply -f service.yaml
```

verify Deployments and Services

```
    kubectl get deployments
```

```
    kubectl get pods
```

```
    kubectl get services
```

```
    kubectl logs {name of the pod}