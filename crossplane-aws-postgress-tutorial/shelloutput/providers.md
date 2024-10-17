Note that there is a difference between Provider and provider and I don't know what it is or why.

```
bash-3.2$ cat aws-provider-config.yaml
---
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: aws-creds
      key: creds

bash-3.2$ kubectl get ProviderConfig -n crossplane-system default -o=yaml

apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: ...
  creationTimestamp: "2024-10-17T15:32:51Z"
  finalizers:
  - in-use.crossplane.io
  generation: 1
  name: default
  resourceVersion: "12558"
  uid: XXX
spec:
  credentials:
    secretRef:
      key: creds
      name: aws-creds
      namespace: crossplane-system
    source: Secret
status:
  users: 15

bash-3.2$ kubectl get secrets -n crossplane-system

NAME                                                TYPE                 DATA   AGE
aws-creds                                           Opaque               1      94m
crossplane-contrib-provider-kubernetes-tls-client   Opaque               3      83m
crossplane-contrib-provider-kubernetes-tls-server   Opaque               3      83m
crossplane-contrib-provider-sql-tls-client          Opaque               3      91m
crossplane-contrib-provider-sql-tls-server          Opaque               3      91m
crossplane-root-ca                                  Opaque               2      96m
crossplane-tls-client                               Opaque               3      96m
crossplane-tls-server                               Opaque               3      96m
sh.helm.release.v1.crossplane.v1                    helm.sh/release.v1   1      96m
upbound-provider-aws-ec2-tls-client                 Opaque               3      91m
upbound-provider-aws-ec2-tls-server                 Opaque               3      91m
upbound-provider-aws-rds-tls-client                 Opaque               3      91m
upbound-provider-aws-rds-tls-server                 Opaque               3      91m
upbound-provider-family-aws-tls-client              Opaque               3      91m
upbound-provider-family-aws-tls-server              Opaque               3      91m

bash-3.2$ kubectl get secrets -n crossplane-system aws-creds

NAME        TYPE     DATA   AGE
aws-creds   Opaque   1      94m

bash-3.2$ kubectl get secrets -n crossplane-system aws-creds -o=yaml

apiVersion: v1
data:
  creds: XXX
kind: Secret
metadata:
  creationTimestamp: "2024-10-17T15:24:36Z"
  name: aws-creds
  namespace: crossplane-system
  resourceVersion: "903"
  uid: XXX
type: Opaque

bash-3.2$ yq ".kind, .metadata.name, .metadata.namespace" provider-kubernetes-incluster.yaml  

ServiceAccount
crossplane-provider-kubernetes
crossplane-system
---
ClusterRoleBinding
crossplane-provider-kubernetes
null
---
ControllerConfig
crossplane-provider-kubernetes
null
---
Provider
crossplane-contrib-provider-kubernetes
null

bash-3.2$ kubectl get ServiceAccount crossplane-provider-kubernetes -n crossplane-system

NAME                             SECRETS   AGE
crossplane-provider-kubernetes   0         84m

bash-3.2$ kubectl get ServiceAccount crossplane-provider-kubernetes -n crossplane-system -o=yaml

apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: ...
  creationTimestamp: "2024-10-17T15:36:03Z"
  name: crossplane-provider-kubernetes
  namespace: crossplane-system
  ownerReferences:
  - apiVersion: pkg.crossplane.io/v1
    blockOwnerDeletion: true
    controller: true
    kind: ProviderRevision
    name: crossplane-contrib-provider-kubernetes-6ef2ebb6f1db
    uid: XXX
  resourceVersion: "3461"
  uid: XXX

bash-3.2$ kubectl get ClusterRoleBinding

NAME                                                                             ROLE                                                                                         AGE
cluster-admin                                                                    ClusterRole/cluster-admin                                                                    98m
crossplane                                                                       ClusterRole/crossplane                                                                       98m
crossplane-admin                                                                 ClusterRole/crossplane-admin                                                                 98m
crossplane-provider-kubernetes                                                   ClusterRole/cluster-admin                                                                    84m
crossplane-rbac-manager                                                          ClusterRole/crossplane-rbac-manager                                                          98m
crossplane:provider:crossplane-contrib-provider-kubernetes-6ef2ebb6f1db:system   ClusterRole/crossplane:provider:crossplane-contrib-provider-kubernetes-6ef2ebb6f1db:system   84m
crossplane:provider:crossplane-contrib-provider-sql-a2c547580f15:system          ClusterRole/crossplane:provider:crossplane-contrib-provider-sql-a2c547580f15:system          93m
crossplane:provider:upbound-provider-aws-ec2-707aff347376:system                 ClusterRole/crossplane:provider:upbound-provider-aws-ec2-707aff347376:system                 93m
crossplane:provider:upbound-provider-aws-rds-a141cb8ee729:system                 ClusterRole/crossplane:provider:upbound-provider-aws-rds-a141cb8ee729:system                 93m
crossplane:provider:upbound-provider-family-aws-08179c904ccc:system              ClusterRole/crossplane:provider:upbound-provider-family-aws-08179c904ccc:system              93m
ingress-nginx                                                                    ClusterRole/ingress-nginx                                                                    98m
ingress-nginx-admission                                                          ClusterRole/ingress-nginx-admission                                                          98m
kindnet                                                                          ClusterRole/kindnet                                                                          98m
kubeadm:cluster-admins                                                           ClusterRole/cluster-admin                                                                    98m
kubeadm:get-nodes                                                                ClusterRole/kubeadm:get-nodes                                                                98m
kubeadm:kubelet-bootstrap                                                        ClusterRole/system:node-bootstrapper                                                         98m
kubeadm:node-autoapprove-bootstrap                                               ClusterRole/system:certificates.k8s.io:certificatesigningrequests:nodeclient                 98m
kubeadm:node-autoapprove-certificate-rotation                                    ClusterRole/system:certificates.k8s.io:certificatesigningrequests:selfnodeclient             98m
kubeadm:node-proxier                                                             ClusterRole/system:node-proxier                                                              98m
local-path-provisioner-bind                                                      ClusterRole/local-path-provisioner-role                                                      98m
system:basic-user                                                                ClusterRole/system:basic-user                                                                98m
system:controller:attachdetach-controller                                        ClusterRole/system:controller:attachdetach-controller                                        98m
system:controller:certificate-controller                                         ClusterRole/system:controller:certificate-controller                                         98m
system:controller:clusterrole-aggregation-controller                             ClusterRole/system:controller:clusterrole-aggregation-controller                             98m
system:controller:cronjob-controller                                             ClusterRole/system:controller:cronjob-controller                                             98m
system:controller:daemon-set-controller                                          ClusterRole/system:controller:daemon-set-controller                                          98m
system:controller:deployment-controller                                          ClusterRole/system:controller:deployment-controller                                          98m
system:controller:disruption-controller                                          ClusterRole/system:controller:disruption-controller                                          98m
system:controller:endpoint-controller                                            ClusterRole/system:controller:endpoint-controller                                            98m
system:controller:endpointslice-controller                                       ClusterRole/system:controller:endpointslice-controller                                       98m
system:controller:endpointslicemirroring-controller                              ClusterRole/system:controller:endpointslicemirroring-controller                              98m
system:controller:ephemeral-volume-controller                                    ClusterRole/system:controller:ephemeral-volume-controller                                    98m
system:controller:expand-controller                                              ClusterRole/system:controller:expand-controller                                              98m
system:controller:generic-garbage-collector                                      ClusterRole/system:controller:generic-garbage-collector                                      98m
system:controller:horizontal-pod-autoscaler                                      ClusterRole/system:controller:horizontal-pod-autoscaler                                      98m
system:controller:job-controller                                                 ClusterRole/system:controller:job-controller                                                 98m
system:controller:legacy-service-account-token-cleaner                           ClusterRole/system:controller:legacy-service-account-token-cleaner                           98m
system:controller:namespace-controller                                           ClusterRole/system:controller:namespace-controller                                           98m
system:controller:node-controller                                                ClusterRole/system:controller:node-controller                                                98m
system:controller:persistent-volume-binder                                       ClusterRole/system:controller:persistent-volume-binder                                       98m
system:controller:pod-garbage-collector                                          ClusterRole/system:controller:pod-garbage-collector                                          98m
system:controller:pv-protection-controller                                       ClusterRole/system:controller:pv-protection-controller                                       98m
system:controller:pvc-protection-controller                                      ClusterRole/system:controller:pvc-protection-controller                                      98m
system:controller:replicaset-controller                                          ClusterRole/system:controller:replicaset-controller                                          98m
system:controller:replication-controller                                         ClusterRole/system:controller:replication-controller                                         98m
system:controller:resourcequota-controller                                       ClusterRole/system:controller:resourcequota-controller                                       98m
system:controller:root-ca-cert-publisher                                         ClusterRole/system:controller:root-ca-cert-publisher                                         98m
system:controller:route-controller                                               ClusterRole/system:controller:route-controller                                               98m
system:controller:service-account-controller                                     ClusterRole/system:controller:service-account-controller                                     98m
system:controller:service-controller                                             ClusterRole/system:controller:service-controller                                             98m
system:controller:statefulset-controller                                         ClusterRole/system:controller:statefulset-controller                                         98m
system:controller:ttl-after-finished-controller                                  ClusterRole/system:controller:ttl-after-finished-controller                                  98m
system:controller:ttl-controller                                                 ClusterRole/system:controller:ttl-controller                                                 98m
system:controller:validatingadmissionpolicy-status-controller                    ClusterRole/system:controller:validatingadmissionpolicy-status-controller                    98m
system:coredns                                                                   ClusterRole/system:coredns                                                                   98m
system:discovery                                                                 ClusterRole/system:discovery                                                                 98m
system:kube-controller-manager                                                   ClusterRole/system:kube-controller-manager                                                   98m
system:kube-dns                                                                  ClusterRole/system:kube-dns                                                                  98m
system:kube-scheduler                                                            ClusterRole/system:kube-scheduler                                                            98m
system:monitoring                                                                ClusterRole/system:monitoring                                                                98m
system:node                                                                      ClusterRole/system:node                                                                      98m
system:node-proxier                                                              ClusterRole/system:node-proxier                                                              98m
system:public-info-viewer                                                        ClusterRole/system:public-info-viewer                                                        98m
system:service-account-issuer-discovery                                          ClusterRole/system:service-account-issuer-discovery                                          98m
system:volume-scheduler                                                          ClusterRole/system:volume-scheduler                                                          98m

bash-3.2$ kubectl get ClusterRoleBinding crossplane-provider-kubernetes

NAME                             ROLE                        AGE
crossplane-provider-kubernetes   ClusterRole/cluster-admin   85m

bash-3.2$ kubectl get ClusterRoleBinding crossplane-provider-kubernetes -o=yaml

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: ...
  creationTimestamp: "2024-10-17T15:36:03Z"
  name: crossplane-provider-kubernetes
  resourceVersion: "3426"
  uid: XXX
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: crossplane-provider-kubernetes
  namespace: crossplane-system

bash-3.2$ kubectl get ControllerConfig

NAME                             AGE
crossplane-provider-kubernetes   86m

bash-3.2$ kubectl get ControllerConfig crossplane-provider-kubernetes -o=yaml

apiVersion: pkg.crossplane.io/v1alpha1
kind: ControllerConfig
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: ...
  creationTimestamp: "2024-10-17T15:36:03Z"
  generation: 1
  name: crossplane-provider-kubernetes
  resourceVersion: "3427"
  uid: XXX
spec:
  serviceAccountName: crossplane-provider-kubernetes

bash-3.2$ kubectl get Provider

NAME                                     INSTALLED   HEALTHY   PACKAGE                                                          AGE
crossplane-contrib-provider-kubernetes   True        True      xpkg.upbound.io/crossplane-contrib/provider-kubernetes:v0.12.1   86m
crossplane-contrib-provider-sql          True        True      xpkg.upbound.io/crossplane-contrib/provider-sql:v0.9.0           94m
upbound-provider-aws-ec2                 True        True      xpkg.upbound.io/upbound/provider-aws-ec2:v1.15.0                 94m
upbound-provider-aws-rds                 True        True      xpkg.upbound.io/upbound/provider-aws-rds:v1.15.0                 94m
upbound-provider-family-aws              True        True      xpkg.upbound.io/upbound/provider-family-aws:v1.15.0              94m

bash-3.2$ kubectl get Provider crossplane-contrib-provider-kubernetes
NAME                                     INSTALLED   HEALTHY   PACKAGE                                                          AGE
crossplane-contrib-provider-kubernetes   True        True      xpkg.upbound.io/crossplane-contrib/provider-kubernetes:v0.12.1   87m

bash-3.2$ kubectl get Provider crossplane-contrib-provider-kubernetes -o=yaml

apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: ...
  creationTimestamp: "2024-10-17T15:36:03Z"
  generation: 1
  name: crossplane-contrib-provider-kubernetes
  resourceVersion: "3528"
  uid: XXX
spec:
  controllerConfigRef:
    name: crossplane-provider-kubernetes
  ignoreCrossplaneConstraints: false
  package: xpkg.upbound.io/crossplane-contrib/provider-kubernetes:v0.12.1
  packagePullPolicy: IfNotPresent
  revisionActivationPolicy: Automatic
  revisionHistoryLimit: 1
  runtimeConfigRef:
    apiVersion: pkg.crossplane.io/v1beta1
    kind: DeploymentRuntimeConfig
    name: default
  skipDependencyResolution: false
status:
  conditions:
  - lastTransitionTime: "2024-10-17T15:36:09Z"
    reason: HealthyPackageRevision
    status: "True"
    type: Healthy
  - lastTransitionTime: "2024-10-17T15:36:04Z"
    reason: ActivePackageRevision
    status: "True"
    type: Installed
  currentIdentifier: xpkg.upbound.io/crossplane-contrib/provider-kubernetes:v0.12.1
  currentRevision: crossplane-contrib-provider-kubernetes-6ef2ebb6f1db
```  
