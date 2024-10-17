Crossplane Tutorial
-------------------

This tutorial creates a progres db in AWS and the networking infrastructure that allows you to connect to the db from your local cluster.

This is based on this video series by DevOps Toolkit: [https://youtube.com/playlist?list=PLyicRj904Z99i8U5JaNW5X3AyBvfQz-16&si=0hCXxJO8gg_B1WDM](https://youtube.com/playlist?list=PLyicRj904Z99i8U5JaNW5X3AyBvfQz-16&si=0hCXxJO8gg_B1WDM)

Weirdly, the database that gets created in AWS is called `terraform-XXX`. Why is that?

shell.nix
---------

Contains a bunch of packages  kubectl, upbound cli, aws cli, crossplane cli, github cli...
Sets up some aliases like k for kubectl, nvim for vi...

`nix-shell`

pkg/aws-postgres.xpkg
---------------------

Contains the dependencies, composition and xrd.
A composite resource definition for "SQL", which in this case is a postres database. It's "inheriting" from `https://doc.crds.dev/github.com/crossplane/crossplane/apiextensions.crossplane.io/CompositeResourceDefinition/v1@v1.2.4`

Hosted in my repo at upbound. `xpkg.upbound.io/r0undbrackets/aws-postgres:v0.0.1` If you recreate it and store it somewhere else you need to update `pkg-configuration.yaml`.

Built with `build-aws-postgres.sh`.

1 setup.sh
----------

Creates a local cluster with kind.
Install crossplane with helm.
Collects AWS credentials - in this access key + secret = acct#
Writes the creds to a file.
Creates a secret in the crossplane-system namespace with the aws creds.

`setup.sh`

2 .env
-------

Source to set AWS env vars.

3 pkg-configuration.yaml
------------------------

Loads the package created above.

`kubectl apply --filename pkg-configuration.yaml`

It should up with `pkgrev` and `compositions`.

See [packages.md](shelloutput/packages.md).
See [compositions.md](shelloutput/compositions.md).

4 aws-provider-config.yaml
--------------------------

Configures credentials for the aws provider.

`kubectl apply --filename aws-provider-config.yaml`

See [providers.md](shelloutput/providers.md).

5 provider-kubernetes-incluster.yaml
------------------------------------

Configures the kubernetes provider. Don't know what's happening here. Need to read more.

`kubectl apply --filename provider-kubernetes-incluster.yaml`

See [providers.md](shelloutput/providers.md).

6 xc-sqlclaim.yaml
------------------

Create a namespace and create a claim inside it.

```
kubectl create namespace a-team
kubectl --namespace a-team apply --filename xc-sqlclaim.yaml
```

Watch it go!!

```
watch -n 5 crossplane beta trace sqlclaim my-db --namespace a-team
```

See [claim.md](shelloutput/claim.md).

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

See [connect-to-db.md](shelloutput/connect-to-db.md).

8 destroy.sh
------------

Tear everything down.

`./destroy.sh`
