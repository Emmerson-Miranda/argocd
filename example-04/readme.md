# Introduction
Simple PoC to deploy some containers using ApplicationSet to recreate multiple environments.

More info at: 
- https://argocd-applicationset.readthedocs.io/en/stable/Generators/
- https://github.com/argoproj/argocd-example-apps/tree/master/helm-guestbook
- https://amralaayassen.medium.com/how-to-create-argocd-applications-automatically-using-applicationset-automation-of-the-gitops-59455eaf4f72


Installation instructions

```
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-04/example-04.appset.yaml
```