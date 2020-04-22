#!/bin/bash

DEFAULT_ARGS="-nn -i any -w ktcpdump.pacp -c 100"
EXTRA_ARGS=""
KUBE_FILTERS=""
EXTRA_FILTERS=""

echo "/usr/sbin/tcpdump $DEFAULT_ARGS $EXTRA_ARGS $KUBE_FILTERS $EXTRA_FILTERS"
sed -e "s/__DEFAULT_ARGS__/$DEFAULT_ARGS/" \
    -e "s/__EXTRA_ARGS__/$EXTRA_ARGS/" \
    -e "s/__KUBE_FILTERS__/$KUBE_FILTERS/" \
    -e "s/__EXTRA_FILTERS__/$EXTRA_FILTERS/" \
    kube/ds.yaml | kubectl apply --validate=true -f -
