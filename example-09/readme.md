# Introduction
PoC to deploy in multiple environments using ApplicationSet, Helm and overriding some values per environment.

- Helm chart pull from repository instead of git
- Values file inside of this repo



Installation instructions

Adding Helm repo to your console
```bash
helm repo add deliveryhero https://charts.deliveryhero.io/
```

Adding Helm repo to ArgoCD
```bash
argocd repo add https://charts.deliveryhero.io/ --type helm --name deliveryhero
```

Creating

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-09/example-09.appset.yaml
```

As per config in a separate git repo there is only one replica for DEV.
![3 environments](./example-09-dev.png)


As per config in a separate git repo there are three replicas for UAT.
![3 environments](./example-09-uat.png)

Deleting

```bash
kubectl delete -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-09/example-09.appset.yaml
```


Unable to load data: error getting cached app managed resources: 
InvalidSpecError: spec.source.repoURL and either source.path, 
source.chart, or source.ref are required for source {deliveryhero/wiremock &ApplicationSourceHelm{ValueFiles:
[$values/example-09/environment-config/dev/values.yaml],Parameters:[]HelmParameter{},ReleaseName:,Values:,FileParameters:
[]HelmFileParameter{},Version:,PassCredentials:false,IgnoreMissingValueFiles:false,SkipCrds:false,ValuesObject:nil,} nil nil nil }

Unable to save changes: application spec for example-09-dev is invalid: InvalidSpecError: Unable to generate manifests in : 
rpc error: code = Unknown desc = failed to get git client for repo https://github.com/Emmerson-Miranda/argocd.git;InvalidSpecError: 
Unable to generate manifests in : rpc error: code = Unknown desc = Unable to resolve '{{config.targetRevision}}' to a commit SHA