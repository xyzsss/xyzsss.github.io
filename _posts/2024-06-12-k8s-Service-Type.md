---
layout: post
title: K8s service Type
tags: [k8s]
categories:
- blog
---

## k8s service type  



---
v1 

### 什么是Kubernetes Service？

在Kubernetes中，Service是一种抽象，它定义了一种访问容器化应用的方式，无论这些应用如何分布。Service使得外部可以访问到集群内部的Pod，而不需要知道Pod的具体IP地址。

### Service的类型

Kubernetes提供了多种Service类型，以满足不同的访问需求：

- ClusterIP：默认类型，仅在集群内部可以访问。
- NodePort：在集群的每个节点上开放一个端口，外部可以通过<NodeIP>:<NodePort>访问。
- LoadBalancer：使用云提供商的负载均衡器，对外提供访问。
- ExternalName：通过返回CNAME和其值，可以将服务映射到外部服务。

注意： 在使用这些服务类型时，应考虑服务的安全性和成本。

### 例子

- ClusterIP 示例
这是最基本的Service类型，它只在集群内部可见。

```
yaml
apiVersion: v1
kind: Service
metadata:
  name: example-clusterip
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

- NodePort 示例
NodePort类型允许你通过集群中任何节点的特定端口访问Service。注意： 考虑到安全性，确保只允许必要的外部访问。

```
yaml
apiVersion: v1
kind: Service
metadata:
  name: example-nodeport
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
      nodePort: 30000
```

在这个例子中，你可以使用任何节点的IP地址加上端口30000来访问服务。

- LoadBalancer 示例
使用云服务的负载均衡器，可以对外提供服务。注意： 云提供商的负载均衡器可能产生额外费用。

```
yaml
apiVersion: v1
kind: Service
metadata:
  name: example-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
ExternalName 示例
```

- externalName
将服务映射到外部的DNS名称。

```
yaml
apiVersion: v1
kind: Service
metadata:
  name: example-externalname
spec:
  type: ExternalName
  externalName: my.database.example.com
```

这个Service不路由到任何选择器，而是返回一个CNAME记录my.database.example.com。

---
---


#### prompt / 费曼 / 小狗
```
你是个IT领域专家，你现在要对一些小狗狗们进行k8s service type 科普，然后还需要type的具体例子，包含代码，请你给出这篇稿子，便于小猫、小狗们学习领悟。
```

---
---

## Kubernetes Service Type 科普：小猫小狗版

欢迎小猫和小狗们！
大家好，我是IT领域的专家，今天我们要学习一些关于Kubernetes（k8s）的有趣知识。Kubernetes是一个帮助我们管理很多小容器（就像你们的小玩具一样）的系统。现在，我们要学习如何让这些小容器互相找到对方，或者让外面的世界找到它们。

### 什么是Service？
想象一下，如果你们有很多玩具，但是它们都散落在不同的地方，要找到它们可能会很麻烦。Service就像是一个玩具箱，它帮助我们把所有玩具聚在一起，这样我们就可以很容易地找到它们了。

### Service的类型
Kubernetes提供了几种不同的玩具箱（Service类型），每种都有它自己的特殊功能：

ClusterIP：这是一个只有你们自己才能看到的玩具箱，别人看不到。
NodePort：这个玩具箱在每个房间都有一个小窗口，别人可以通过窗口看到玩具。
LoadBalancer：这是一个超级玩具箱，它有很多小窗口，而且还能自动帮我们把玩具分发给所有想看的人。
ExternalName：这是一个魔法玩具箱，它可以让我们的玩具看起来像是别人的玩具。

### example
ClusterIP 示例
这个玩具箱只有你们自己能看到。

```
apiVersion: v1
kind: Service
metadata:
  name: my-secret-toy-box
spec:
  selector:
    app: my-favorite-toys
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

NodePort 示例
这个玩具箱在每个房间都有一个小窗口。

```
apiVersion: v1
kind: Service
metadata:
  name: my-window-toy-box
spec:
  type: NodePort
  selector:
    app: my-favorite-toys
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
      nodePort: 30000
```

LoadBalancer 示例
这个超级玩具箱有很多小窗口，可以让更多的人看到玩具。

```
apiVersion: v1
kind: Service
metadata:
  name: my-super-toy-box
spec:
  type: LoadBalancer
  selector:
    app: my-favorite-toys
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

ExternalName 示例
这个魔法玩具箱可以让我们的玩具看起来像是别人的玩具。

```
apiVersion: v1
kind: Service
metadata:
  name: my-magic-toy-box
spec:
  type: ExternalName
  externalName: my.neighbor-toys.example.com
```

结束语
小猫和小狗们，希望你们喜欢今天的课程。Service类型就像是不同的玩具箱，帮助我们更好地管理和分享我们的玩具。记得，无论你是小猫还是小狗，都可以通过学习Kubernetes来更好地玩耍和工作。如果你们有任何问题，随时可以问我哦！

