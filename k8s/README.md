
![Wolfenstein: Enemy Territory](../docs/Kubernetes-Loot-Box.webp)

# Deploying with Kubernetes

This guide will walk you through deploying the ET Legacy game server using Kubernetes. The deployment will consist of a single replica of the game server running in a Kubernetes cluster. The server will be accessible via a LoadBalancer service, allowing players to connect to the game from outside the cluster.

## Prerequisites for Production Deployment

- Ensure you have created a secrets.yaml in the `k8s/overlays/prod` directory.



## Creating your `secrets.yaml` file
You need to define your rconpassword and refereepassword by first base64 encoding them. You can do this by running the following command:

```bash
echo -n 'Start123!' | base64
```

Then create a `secrets.yaml` file in the `k8s/overlays/prod` directory with the following content:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: etlegacy-secret
type: Opaque
data:
  rconpassword: U3RhcnQxMjMh
  refereepassword: U3RhcnQxMjMh

  ```

## Deploying
The install uses kustomize to apply the configuration to the cluster. 

### Deploying the Game Server to Local Dev
To deploy the game server, run the following command from the root of the repository:

```bash
kubectl apply -k k8s/overlays/dev
```


### Deploying the Game Server to Production
To deploy the game server, run the following command from the root of the repository:

```bash
kubectl apply -k k8s/overlays/prod
```


## Notes:

- The deployment does not create a LoadBalancer, instead it uses a NodePort for the service. You can access the game server by connecting to the NodePort of the service. The main reason for this is because the server uses a UDP protocol that is not easily configurable with the existing ingress-controller I have set up for other apps that is currently providing TLS termination. Rather than creating additional LoadBalancers (higher billing), I opted to just use the NodePort. You can find the NodePort by running the following command:

  ```bash
    kubectl get nodes -o wide
  ```

- Swapping out `NodePort` with `LoadBalancer` in `k8s/overlays/prod/service.yaml` will give you a reliable public IP to the Game Server though. 

