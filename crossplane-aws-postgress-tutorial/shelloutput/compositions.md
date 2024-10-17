```
k get compositions

NAME             XR-KIND   XR-APIVERSION                      AGE
aws-postgresql   SQL       devopstoolkitseries.com/v1alpha1   84s

k get composition aws-postgresql -o=yaml | tee -a compositions.md

apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  creationTimestamp: "2024-10-17T15:27:53Z"
  generation: 1
  labels:
    db: postgresql
    provider: aws
  name: aws-postgresql
  ownerReferences:
  - apiVersion: pkg.crossplane.io/v1
    blockOwnerDeletion: true
    controller: true
    kind: ConfigurationRevision
    name: crossplane-sql-37cc0dcc5cf9
    uid: XXX
  - apiVersion: pkg.crossplane.io/v1
    blockOwnerDeletion: true
    controller: false
    kind: Configuration
    name: crossplane-sql
    uid: XXX
  resourceVersion: "2004"
  uid: XXX
spec:
  compositeTypeRef:
    apiVersion: devopstoolkitseries.com/v1alpha1
    kind: SQL
  mode: Resources
  patchSets:
  - name: metadata
    patches:
    - fromFieldPath: metadata.annotations
      toFieldPath: metadata.annotations
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: metadata.name
      type: FromCompositeFieldPath
  publishConnectionDetailsWithStoreConfigRef:
    name: default
  resources:
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: VPC
      metadata:
        name: my-special-vpc
      spec:
        forProvider:
          cidrBlock: 11.0.0.0/16
          enableDnsHostnames: true
          enableDnsSupport: true
          region: us-east-1
    name: vpc
    patches:
    - fromFieldPath: metadata.annotations
      toFieldPath: metadata.annotations
      type: FromCompositeFieldPath
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: Subnet
      metadata:
        labels:
          zone: us-east-1a
      spec:
        forProvider:
          availabilityZone: us-east-1a
          cidrBlock: 11.0.0.0/24
          region: us-east-1
          vpcIdSelector:
            matchControllerRef: true
    name: subnet-a
    patches:
    - fromFieldPath: metadata.annotations
      toFieldPath: metadata.annotations
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: metadata.name
      transforms:
      - string:
          fmt: '%s-a'
          type: Format
        type: string
      type: FromCompositeFieldPath
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: Subnet
      metadata:
        labels:
          zone: us-east-1b
      spec:
        forProvider:
          availabilityZone: us-east-1b
          cidrBlock: 11.0.1.0/24
          region: us-east-1
          vpcIdSelector:
            matchControllerRef: true
    name: subnet-b
    patches:
    - fromFieldPath: metadata.annotations
      toFieldPath: metadata.annotations
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: metadata.name
      transforms:
      - string:
          fmt: '%s-b'
          type: Format
        type: string
      type: FromCompositeFieldPath
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: Subnet
      metadata:
        labels:
          zone: us-east-1c
      spec:
        forProvider:
          availabilityZone: us-east-1c
          cidrBlock: 11.0.2.0/24
          region: us-east-1
          vpcIdSelector:
            matchControllerRef: true
    name: subnet-c
    patches:
    - fromFieldPath: metadata.annotations
      toFieldPath: metadata.annotations
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: metadata.name
      transforms:
      - string:
          fmt: '%s-c'
          type: Format
        type: string
      type: FromCompositeFieldPath
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: rds.aws.upbound.io/v1beta1
      kind: SubnetGroup
      spec:
        forProvider:
          description: I'm too lazy to write a good description
          region: us-east-1
          subnetIdSelector:
            matchControllerRef: true
    name: subnetgroup
    patches:
    - patchSetName: metadata
      type: PatchSet
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: InternetGateway
      spec:
        forProvider:
          region: us-east-1
          vpcIdSelector:
            matchControllerRef: true
    name: gateway
    patches:
    - patchSetName: metadata
      type: PatchSet
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: RouteTable
      spec:
        forProvider:
          region: us-east-1
          vpcIdSelector:
            matchControllerRef: true
    name: routeTable
    patches:
    - patchSetName: metadata
      type: PatchSet
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: Route
      spec:
        forProvider:
          destinationCidrBlock: 0.0.0.0/0
          gatewayIdSelector:
            matchControllerRef: true
          region: us-east-1
          routeTableIdSelector:
            matchControllerRef: true
    name: route
    patches:
    - patchSetName: metadata
      type: PatchSet
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: MainRouteTableAssociation
      spec:
        forProvider:
          region: us-east-1
          routeTableIdSelector:
            matchControllerRef: true
          vpcIdSelector:
            matchControllerRef: true
    name: mainRouteTableAssociation
    patches:
    - patchSetName: metadata
      type: PatchSet
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: RouteTableAssociation
      spec:
        forProvider:
          region: us-east-1
          routeTableIdSelector:
            matchControllerRef: true
          subnetIdSelector:
            matchControllerRef: true
            matchLabels:
              zone: us-east-1a
    name: routeTableAssociation1a
    patches:
    - fromFieldPath: metadata.annotations
      toFieldPath: metadata.annotations
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: metadata.name
      transforms:
      - string:
          fmt: '%s-1a'
          type: Format
        type: string
      type: FromCompositeFieldPath
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: RouteTableAssociation
      spec:
        forProvider:
          region: us-east-1
          routeTableIdSelector:
            matchControllerRef: true
          subnetIdSelector:
            matchControllerRef: true
            matchLabels:
              zone: us-east-1b
    name: routeTableAssociation1b
    patches:
    - fromFieldPath: metadata.annotations
      toFieldPath: metadata.annotations
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: metadata.name
      transforms:
      - string:
          fmt: '%s-1b'
          type: Format
        type: string
      type: FromCompositeFieldPath
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: RouteTableAssociation
      spec:
        forProvider:
          region: us-east-1
          routeTableIdSelector:
            matchControllerRef: true
          subnetIdSelector:
            matchControllerRef: true
            matchLabels:
              zone: us-east-1c
    name: routeTableAssociation1c
    patches:
    - fromFieldPath: metadata.annotations
      toFieldPath: metadata.annotations
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: metadata.name
      transforms:
      - string:
          fmt: '%s-1c'
          type: Format
        type: string
      type: FromCompositeFieldPath
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: SecurityGroup
      spec:
        forProvider:
          description: I am too lazy to write descriptions
          region: us-east-1
          vpcIdSelector:
            matchControllerRef: true
    name: securityGroup
    patches:
    - patchSetName: metadata
      type: PatchSet
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: ec2.aws.upbound.io/v1beta1
      kind: SecurityGroupRule
      spec:
        forProvider:
          cidrBlocks:
          - 0.0.0.0/0
          description: I am too lazy to write descriptions
          fromPort: 5432
          protocol: tcp
          region: us-east-1
          securityGroupIdSelector:
            matchControllerRef: true
          toPort: 5432
          type: ingress
    name: securityGroupRule
    patches:
    - patchSetName: metadata
      type: PatchSet
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: rds.aws.upbound.io/v1beta1
      kind: Instance
      spec:
        forProvider:
          allocatedStorage: 200
          dbSubnetGroupNameSelector:
            matchControllerRef: true
          engine: postgres
          passwordSecretRef:
            key: password
          publiclyAccessible: true
          region: us-east-1
          skipFinalSnapshot: true
          username: masteruser
          vpcSecurityGroupIdSelector:
            matchControllerRef: true
    name: rdsinstance
    patches:
    - patchSetName: metadata
      type: PatchSet
    - fromFieldPath: spec.parameters.size
      toFieldPath: spec.forProvider.instanceClass
      transforms:
      - map:
          large: db.m5.8xlarge
          medium: db.m5.2xlarge
          small: db.m5.large
        type: map
      type: FromCompositeFieldPath
    - fromFieldPath: spec.parameters.version
      toFieldPath: spec.forProvider.engineVersion
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: spec.forProvider.passwordSecretRef.name
      transforms:
      - string:
          fmt: '%s-password'
          type: Format
        type: string
      type: FromCompositeFieldPath
    - fromFieldPath: spec.claimRef.namespace
      toFieldPath: spec.forProvider.passwordSecretRef.namespace
      type: FromCompositeFieldPath
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: postgresql.sql.crossplane.io/v1alpha1
      kind: ProviderConfig
      metadata:
        name: default
      spec:
        credentials:
          source: PostgreSQLConnectionSecret
        sslMode: require
    name: sql-config
    patches:
    - patchSetName: metadata
      type: PatchSet
    - fromFieldPath: spec.id
      toFieldPath: spec.credentials.connectionSecretRef.name
      type: FromCompositeFieldPath
    - fromFieldPath: spec.claimRef.namespace
      toFieldPath: spec.credentials.connectionSecretRef.namespace
      type: FromCompositeFieldPath
    readinessChecks:
    - type: None
  - base:
      apiVersion: postgresql.sql.crossplane.io/v1alpha1
      kind: Database
      spec:
        forProvider: {}
    name: sql-db
    patches:
    - patchSetName: metadata
      type: PatchSet
    - fromFieldPath: spec.id
      toFieldPath: spec.providerConfigRef.name
      type: FromCompositeFieldPath
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
  - base:
      apiVersion: kubernetes.crossplane.io/v1alpha1
      kind: ProviderConfig
      spec:
        credentials:
          source: InjectedIdentity
    name: kubernetes
    patches:
    - fromFieldPath: metadata.annotations
      toFieldPath: metadata.annotations
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: metadata.name
      transforms:
      - string:
          fmt: '%s-sql'
          type: Format
        type: string
      type: FromCompositeFieldPath
    readinessChecks:
    - type: None
  - base:
      apiVersion: kubernetes.crossplane.io/v1alpha1
      kind: Object
      metadata:
        name: sql-secret
      spec:
        forProvider:
          manifest:
            apiVersion: v1
            data:
              port: XXX
            kind: Secret
            metadata:
              namespace: crossplane-system
        references:
        - patchesFrom:
            apiVersion: rds.aws.upbound.io/v1beta1
            fieldPath: spec.forProvider.username
            kind: Instance
            namespace: crossplane-system
          toFieldPath: stringData.username
        - patchesFrom:
            apiVersion: v1
            fieldPath: data.password
            kind: Secret
            namespace: crossplane-system
          toFieldPath: data.password
        - patchesFrom:
            apiVersion: rds.aws.upbound.io/v1beta1
            fieldPath: status.atProvider.address
            kind: Instance
            namespace: crossplane-system
          toFieldPath: stringData.endpoint
    name: sql-secret
    patches:
    - patchSetName: metadata
      type: PatchSet
    - fromFieldPath: spec.id
      toFieldPath: spec.references[0].patchesFrom.name
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: spec.references[1].patchesFrom.name
      transforms:
      - string:
          fmt: '%s-password'
          type: Format
        type: string
      type: FromCompositeFieldPath
    - fromFieldPath: spec.claimRef.namespace
      toFieldPath: spec.references[1].patchesFrom.namespace
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: spec.references[2].patchesFrom.name
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: spec.forProvider.manifest.metadata.name
      type: FromCompositeFieldPath
    - fromFieldPath: spec.id
      toFieldPath: spec.providerConfigRef.name
      transforms:
      - string:
          fmt: '%s-sql'
          type: Format
        type: string
      type: FromCompositeFieldPath
    - fromFieldPath: spec.claimRef.namespace
      toFieldPath: spec.forProvider.manifest.metadata.namespace
      type: FromCompositeFieldPath
    readinessChecks:
    - matchCondition:
        status: "True"
        type: Ready
      type: MatchCondition
```
