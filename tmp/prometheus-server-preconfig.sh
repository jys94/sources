#!/usr/bin/env bash

# create nfs directory & change owner
nfsdir=/nfs_shared/prometheus/server
echo "Task [Create NFS directory for prometheus-server]"
if [ ! -e "$nfsdir"  ]; then
  ./nfs-exporter.sh prometheus/server
  chown 1000:1000 $nfsdir
  echo "$nfsdir created"
  echo "Successfully completed"
else
  echo "failed: $nfsdir already exists"
  exit 1
fi

# create pv,pvc
pvc=$(kubectl get pvc prometheus-server -o jsonpath={.metadata.name} 2> /dev/null)
if [ "$pvc" == "" ]; then
  kubectl apply -f ./prometheus-server-volume.yaml
  echo "Successfully completed"
else
  echo "failed: prometheus-server pv,pvc already exist"
fi
