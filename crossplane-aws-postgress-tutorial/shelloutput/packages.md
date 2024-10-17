```
kubectl get pkgrev

NAME                                                                  HEALTHY   REVISION   IMAGE                                               STATE    DEP-FOUND   DEP-INSTALLED   AGE
configurationrevision.pkg.crossplane.io/crossplane-sql-37cc0dcc5cf9   True      1          xpkg.upbound.io/XXX/aws-postgres:v0.0.1   Active   4           4               88m

NAME                                                                                     HEALTHY   REVISION   IMAGE                                                            STATE    DEP-FOUND   DEP-INSTALLED   AGE
providerrevision.pkg.crossplane.io/crossplane-contrib-provider-kubernetes-6ef2ebb6f1db   True      1          xpkg.upbound.io/crossplane-contrib/provider-kubernetes:v0.12.1   Active                               79m
providerrevision.pkg.crossplane.io/crossplane-contrib-provider-sql-a2c547580f15          True      1          xpkg.upbound.io/crossplane-contrib/provider-sql:v0.9.0           Active                               88m
providerrevision.pkg.crossplane.io/upbound-provider-aws-ec2-707aff347376                 True      1          xpkg.upbound.io/upbound/provider-aws-ec2:v1.15.0                 Active   1           1               88m
providerrevision.pkg.crossplane.io/upbound-provider-aws-rds-a141cb8ee729                 True      1          xpkg.upbound.io/upbound/provider-aws-rds:v1.15.0                 Active   1           1               88m
providerrevision.pkg.crossplane.io/upbound-provider-family-aws-08179c904ccc              True      1          xpkg.upbound.io/upbound/provider-family-aws:v1.15.0              Active                               88m

bash-3.2$ kubectl get configurationrevision

NAME                          HEALTHY   REVISION   IMAGE                                               STATE    DEP-FOUND   DEP-INSTALLED   AGE
crossplane-sql-37cc0dcc5cf9   True      1          xpkg.upbound.io/XXX/aws-postgres:v0.0.1   Active   4           4               89m

bash-3.2$ kubectl get configurationrevision.pkg.crossplane.io/crossplane-sql-37cc0dcc5cf9 -o=yam l

apiVersion: pkg.crossplane.io/v1
kind: ConfigurationRevision
metadata:
  annotations:
    meta.crossplane.io/description: Fully operational PostgreSQL databases in AWS,
      Google Cloud Platform, and Azure.
    meta.crossplane.io/license: MIT
    meta.crossplane.io/maintainer: Viktor Farcic (@vfarcic)
    meta.crossplane.io/readme: A Configuration package that defines a SQL and SQLClaim
      types that can be used to create and provision fully operational databases in
      AWS, Google Cloud Platform, and Azure.
    meta.crossplane.io/source: github.com/vfarcic/crossplane-tutorial
  creationTimestamp: "2024-10-17T15:27:38Z"
  finalizers:
  - revision.pkg.crossplane.io
  generation: 1
  labels:
    pkg.crossplane.io/package: crossplane-sql
  name: crossplane-sql-37cc0dcc5cf9
  ownerReferences:
  - apiVersion: pkg.crossplane.io/v1
    blockOwnerDeletion: true
    controller: true
    kind: Configuration
    name: crossplane-sql
    uid: XXX
  resourceVersion: "2161"
  uid: XXX
spec:
  desiredState: Active
  ignoreCrossplaneConstraints: false
  image: xpkg.upbound.io/XXX/aws-postgres:v0.0.1
  packagePullPolicy: IfNotPresent
  revision: 1
  skipDependencyResolution: false
status:
  conditions:
  - lastTransitionTime: "2024-10-17T15:27:53Z"
    reason: HealthyPackageRevision
    status: "True"
    type: Healthy
  foundDependencies: 4
  installedDependencies: 4
  objectRefs:
  - apiVersion: apiextensions.crossplane.io/v1
    kind: Composition
    name: aws-postgresql
    uid: XXX
  - apiVersion: apiextensions.crossplane.io/v1
    kind: CompositeResourceDefinition
    name: sqls.devopstoolkitseries.com
    uid: XXX
```   
