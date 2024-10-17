```
bash-3.2$ cat  xrc-sqlclaim.yaml

---
apiVersion: v1
kind: Secret
metadata:
  name: my-db-password
data:
  password: XXX
---
apiVersion: devopstoolkitseries.com/v1alpha1
kind: SQLClaim
metadata:
  name: my-db
  annotations:
    organization: DevOps Toolkit
    author: Viktor Farcic <viktor@farcic.com>
spec:
  id: my-db
  compositionSelector:
    matchLabels:
      provider: aws
      db: postgresql
  parameters:
    version: "13"
    size: small

bash-3.2$ kubectl config set-context --current --namespace=a-team
Context "kind-crossplane-cluster" modified.

bash-3.2$ k get secret

NAME             TYPE     DATA   AGE
my-db            Opaque   4      26m
my-db-password   Opaque   1      34m

bash-3.2$ kubectl get secret my-db -o=yaml

apiVersion: v1
data:
  endpoint: XXX
  password: XXX
  port: XXX
  username: XXX
kind: Secret
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: ...
  creationTimestamp: "2024-10-17T16:38:42Z"
  name: my-db
  namespace: a-team
  resourceVersion: "13459"
  uid: XXX
type: Opaque

bash-3.2$ kubectl get secret my-db -o=yaml

apiVersion: v1
data:
  password: XXX
kind: Secret
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: ...
  creationTimestamp: "2024-10-17T16:30:44Z"
  finalizers:
  - kubernetes.crossplane.io/referred-by-object-41fe8583-ddff-4c6c-a2f5-33c0fe8bb27c
  name: my-db-password
  namespace: a-team
  resourceVersion: "13457"
  uid: XXX
type: Opaque

bash-3.2$ kubectl get SQLClaim

NAME    SYNCED   READY   CONNECTION-SECRET   AGE
my-db   True     True                        35m

bash-3.2$ kubectl get SQLClaim my-db -o=yaml

apiVersion: devopstoolkitseries.com/v1alpha1
kind: SQLClaim
metadata:
  annotations:
    author: Viktor Farcic <viktor@farcic.com>
    kubectl.kubernetes.io/last-applied-configuration: ...
    organization: DevOps Toolkit
  creationTimestamp: "2024-10-17T16:30:44Z"
  finalizers:
  - finalizer.apiextensions.crossplane.io
  generation: 4
  name: my-db
  namespace: a-team
  resourceVersion: "13989"
  uid: XXX
spec:
  compositeDeletePolicy: Background
  compositionRef:
    name: aws-postgresql
  compositionRevisionRef:
    name: aws-postgresql-d0bada3
  compositionSelector:
    matchLabels:
      db: postgresql
      provider: aws
  compositionUpdatePolicy: Automatic
  id: my-db
  parameters:
    size: small
    version: "13"
  resourceRef:
    apiVersion: devopstoolkitseries.com/v1alpha1
    kind: SQL
    name: my-db-fcp7w
status:
  conditions:
  - lastTransitionTime: "2024-10-17T16:30:44Z"
    reason: ReconcileSuccess
    status: "True"
    type: Synced
  - lastTransitionTime: "2024-10-17T16:42:12Z"
    reason: Available
    status: "True"
    type: Ready

bash-3.2$ crossplane beta trace sqlclaim my-db --namespace a-team

NAME                                    SYNCED   READY   STATUS
SQLClaim/my-db (a-team)                 True     True    Available
└─ SQL/my-db-fcp7w                      True     True    Available
   ├─ InternetGateway/my-db             True     True    Available
   ├─ MainRouteTableAssociation/my-db   True     True    Available
   ├─ RouteTableAssociation/my-db-1a    True     True    Available
   ├─ RouteTableAssociation/my-db-1b    True     True    Available
   ├─ RouteTableAssociation/my-db-1c    True     True    Available
   ├─ RouteTable/my-db                  True     True    Available
   ├─ Route/my-db                       True     True    Available
   ├─ SecurityGroupRule/my-db           True     True    Available
   ├─ SecurityGroup/my-db               True     True    Available
   ├─ Subnet/my-db-a                    True     True    Available
   ├─ Subnet/my-db-b                    True     True    Available
   ├─ Subnet/my-db-c                    True     True    Available
   ├─ VPC/my-db-fcp7w-5gdt7             True     True    Available
   ├─ Object/my-db                      True     True    Available
   ├─ ProviderConfig/my-db-sql          -        -
   ├─ Database/my-db                    True     True    Available
   ├─ ProviderConfig/my-db              -        -
   ├─ Instance/my-db                    True     True    Available
   └─ SubnetGroup/my-db                 True     True    Available

bash-3.2$ kubectl get managed

NAME                             SYNCED   READY   EXTERNAL-NAME                       AGE
route.ec2.aws.upbound.io/my-db   True     True    r-rtb-091422ec341e7ca451080289494   36m

NAME                                       SYNCED   READY   EXTERNAL-NAME           AGE
internetgateway.ec2.aws.upbound.io/my-db   True     True    igw-039a161cb81b97a85   36m

NAME                                                 SYNCED   READY   EXTERNAL-NAME                AGE
mainroutetableassociation.ec2.aws.upbound.io/my-db   True     True    rtbassoc-056d5a23a4766672f   36m

NAME                                                SYNCED   READY   EXTERNAL-NAME                AGE
routetableassociation.ec2.aws.upbound.io/my-db-1a   True     True    rtbassoc-0c4f48b3c4605c0be   36m
routetableassociation.ec2.aws.upbound.io/my-db-1b   True     True    rtbassoc-0ab65623b79b7de94   36m
routetableassociation.ec2.aws.upbound.io/my-db-1c   True     True    rtbassoc-035a2d2e0ff076e03   36m

NAME                                  SYNCED   READY   EXTERNAL-NAME           AGE
routetable.ec2.aws.upbound.io/my-db   True     True    rtb-091422ec341e7ca45   36m

NAME                                         SYNCED   READY   EXTERNAL-NAME      AGE
securitygrouprule.ec2.aws.upbound.io/my-db   True     True    sgrule-455732039   36m

NAME                                     SYNCED   READY   EXTERNAL-NAME          AGE
securitygroup.ec2.aws.upbound.io/my-db   True     True    sg-0c0d213485cff6ed4   36m

NAME                                SYNCED   READY   EXTERNAL-NAME              AGE
subnet.ec2.aws.upbound.io/my-db-a   True     True    subnet-0dc3e93aabfb32d55   36m
subnet.ec2.aws.upbound.io/my-db-b   True     True    subnet-0a525c34fd29db69b   36m
subnet.ec2.aws.upbound.io/my-db-c   True     True    subnet-0c6dbc5f2cc7b51cb   36m

NAME                                       SYNCED   READY   EXTERNAL-NAME           AGE
vpc.ec2.aws.upbound.io/my-db-fcp7w-5gdt7   True     True    vpc-02e37e89e1e9a1564   36m

NAME                                    KIND     PROVIDERCONFIG   SYNCED   READY   AGE
object.kubernetes.crossplane.io/my-db   Secret   my-db-sql        True     True    36m

NAME                                          READY   SYNCED   AGE
database.postgresql.sql.crossplane.io/my-db   True    True     36m

NAME                                SYNCED   READY   EXTERNAL-NAME                   AGE
instance.rds.aws.upbound.io/my-db   True     True    db-RUI6LSZHAA5REMDZGQLCFLORBM   36m

NAME                                   SYNCED   READY   EXTERNAL-NAME   AGE
subnetgroup.rds.aws.upbound.io/my-db   True     True    my-db           36m
```
