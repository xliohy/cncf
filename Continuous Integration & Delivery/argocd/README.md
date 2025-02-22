What Is Argo CD?
Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

<img src="https://argo-cd.readthedocs.io/en/stable/assets/argocd-ui.gif" alt="argocd.getstarted">

Argo CD UI

Why Argo CD?
Application definitions, configurations, and environments should be declarative and version controlled. Application deployment and lifecycle management should be automated, auditable, and easy to understand.

Getting Started¶
Quick Start¶

```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
Follow our getting started guide. Further user oriented documentation is provided for additional features. If you are looking to upgrade Argo CD, see the upgrade guide. Developer oriented documentation is available for people interested in building third-party integrations.