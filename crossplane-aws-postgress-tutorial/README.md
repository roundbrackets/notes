Deploying PostgreSQL in AWS with Crossplane and Kind
----------------------------------------------------

This tutorial creates a progres db in AWS and the networking infrastructure that allows you to connect to the db from your local cluster.

This is based on this video series by DevOps Toolkit: [https://youtube.com/playlist?list=PLyicRj904Z99i8U5JaNW5X3AyBvfQz-16&si=0hCXxJO8gg_B1WDM](https://youtube.com/playlist?list=PLyicRj904Z99i8U5JaNW5X3AyBvfQz-16&si=0hCXxJO8gg_B1WDM)

Weirdly, the database that gets created in AWS is called `terraform-XXX`. Why is that?

Prereqs
-------

You need docker running on your machine, so maybe [Docker Desktop](https://www.docker.com/products/docker-desktop/)?

Also see the `shell.nix` file for deps.

You need an aws key, secret key and acct#.

shell.nix (optional)
--------------------

This sets up all the tools you need. If you don't want to use `nix-shell`, then cat this file to see what you need to install.

- Contains a bunch of packages  kubectl, upbound cli, aws cli, crossplane cli, github cli...
- Sets up some aliases like k for kubectl, nvim for vi...

`nix-shell`

__Docs__

- [nix-shell](https://nix.dev/manual/nix/2.18/command-ref/nix-shell)

1 setup.sh - Setup up a crossplane cluster locally
--------------------------------------------------

- Creates a local cluster with kind.
- Install crossplane with helm.
- Collects AWS credentials - in this case, access key + secret = acct#
- Writes the creds to a file.
- Creates a secret in the crossplane-system namespace with the aws creds.

`setup.sh`

2 .env
-------

Source to set AWS env vars.

`source .env`

pkg/aws-postgres.xpkg - Creating a Crossplane Package (optional)
----------------------------------------------------------------

`pkg/` Contains the package configuration, Composition and Composite Resource Definition used to build `aws-postgres.xpkg`. 

The composition and its claim are SQL and SQLClaim, respetively.

The pkg is in my repo at upbound. `xpkg.upbound.io/r0undbrackets/aws-postgres:v0.0.1` 

If you want recreate it and store it somewhere else you need to update `pkg-configuration.yaml`.

Built with `build-aws-postgres.sh`.

__Docs__

- [Composite Resource Definitions](https://docs.crossplane.io/latest/concepts/composite-resource-definitions/)
- [Compositions](https://docs.crossplane.io/latest/concepts/compositions/)
- [Claims](https://docs.crossplane.io/latest/concepts/claims/)
- [Configuration Packages](https://docs.crossplane.io/latest/concepts/packages/)

3 pkg-configuration.yaml
------------------------

Loads the package created above.

`kubectl apply --filename pkg-configuration.yaml`

It should up with `pkgrev` and `compositions`.

- See [packages output](shelloutput/packages.md).
- See [compositions output](shelloutput/compositions.md).

__Docs__

- [Configuration Packages](https://docs.crossplane.io/latest/concepts/packages/)

4 aws-provider-config.yaml - Install Package Configuration
----------------------------------------------------------

Configures credentials for the aws provider.

`kubectl apply --filename aws-provider-config.yaml`

See [providers output](shelloutput/providers.md).

__Docs__

- [Providers](https://docs.crossplane.io/latest/concepts/providers/)

5 provider-kubernetes-incluster.yaml - Install the Kubernetes Provider
----------------------------------------------------------------------

Configures the kubernetes provider. Don't know what's happening here. Need to read more.

`kubectl apply --filename provider-kubernetes-incluster.yaml`

See [providers output](shelloutput/providers.md).

__Docs__

- [Providers](https://docs.crossplane.io/latest/concepts/providers/)
- [Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)
- [RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Controllers](https://kubernetes.io/docs/concepts/architecture/controller/)

6 xrc-sqlclaim.yaml - Create a SQLClaim
---------------------------------------

Create a namespace and create a claim inside it.

```
kubectl create namespace a-team
kubectl --namespace a-team apply --filename xrc-sqlclaim.yaml
```

Watch it go!!

```
watch -n 5 crossplane beta trace sqlclaim my-db --namespace a-team
```

See [claim output](shelloutput/claim.md).

__Docs__

- [Claims](https://docs.crossplane.io/latest/concepts/claims/)

7 Connecting to the DB
----------------------

Now you should be able to connect to the DB from the cluster.

```
export HOST_KEY=endpoint
export DB=my-db

export PGUSER=$(kubectl --namespace a-team \
    get secret $DB --output jsonpath="{.data.username}" \
    | base64 -d)

export PGPASSWORD=$(kubectl --namespace a-team \
    get secret $DB --output jsonpath="{.data.password}" \
    | base64 -d)

export PGHOST=$(kubectl --namespace a-team \
    get secret $DB --output jsonpath="{.data.$HOST_KEY}" \
    | base64 -d)

kubectl run postgresql-client --rm -ti --restart='Never' \
    --image docker.io/bitnami/postgresql:16 \
    --env PGPASSWORD=$PGPASSWORD --env PGHOST=$PGHOST \
    --env PGUSER=$PGUSER --command -- sh

psql --host $PGHOST -U $PGUSER -d postgres -p 5432

```

See [connect-to-db output](shelloutput/connect-to-db.md).

8 destroy.sh - Delete All Resources and Destroy the Cluster
-----------------------------------------------------------

Tear everything down.

`./destroy.sh`

This will take a while.
