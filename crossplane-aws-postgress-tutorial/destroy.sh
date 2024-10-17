#!/bin/sh

echo "Delete everything"
kubectl --namespace a-team delete --filename xc-sqlclaim.yaml

echo "Wait for everything to be deletd."
echo "If the db doesn't go away try kubectl patch database.postgresql.sql.crossplane.io my-db  --patch '{\"metadata\":{\"finalizers\":[]}}' --type=merge"

COUNTER=$(kubectl get managed --no-headers | grep -v database | wc -l)
while [ $COUNTER -ne 0 ]; do
	echo "$COUNTER resources still exist. Waiting for them to be deleted..."
	sleep 30
	COUNTER=$(kubectl get managed --no-headers | grep -v database | wc -l)
done

# delete the cluster created with kind
kind delete cluster --name "crossplane-cluster"
