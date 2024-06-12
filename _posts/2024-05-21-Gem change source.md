---
layout: post
title: Mermaid 基于文本的图表创建语言
tags: [daily]
categories:
- blog
---

## Mermaid  
---

##### markdown 渲染工具

Mermaid是一种基于文本的图表创建语言，它允许用户使用文本和代码块来生成流程图、序列图、甘特图等。在Markdown编辑器中，通过Mermaid，可以方便地创建图表，并且很多支持Markdown的平台上都能渲染这些图表。

比如：

```
graph LR
    A[API服务器] -- 客户端证书 --> B(Kubelet)
    A -- 客户端证书 --> C(etcd)
    A -- 服务端证书 --> D(前端代理)
    E(集群管理员) -- 客户端证书 --> A
    F(控制器管理器) -- 客户端证书/kubeconfig --> A
    G(调度器) -- 客户端证书/kubeconfig --> A

    classDef cert fill:#f96;
    class A,B,C,D,E,F,G cert;
```
效果图：
![success pic](https://raw.githubusercontent.com/xyzsss/xyzsss.github.io/master/assets/images/mermaid.png)


Mermaid语法的基本结构如下：

graph LR：这指定了一个图的类型，LR代表“Left to Right”，即从左到右布局。
A -- 描述 --> B：这定义了节点A和节点B之间的连接，以及连接的描述。
classDef：定义了一个类，可以用来给一组节点设置样式。
class：将类应用到特定的节点上。
 

---
