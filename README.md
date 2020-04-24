# ktcpdump
A wrapper script for kubectl and tcpdump to work nicely on Kubernetes.

This tool will deploy a DaemonSet in the Kubernetes cluster using `kubectl` and run `tcpdump` on host network to capture network traffic.

The DaemonSet is based on [praqma/network-multitool](https://github.com/Praqma/Network-MultiTool) Docker image.

### !! Important Note: Please use this tool in production by **CAUTION** !!

## What's New
The script extends the `tcpdump` filter expressions by translating them to `pcap-filter` format.
1. [***namespace***/]pod/***pod_name***
2. [***namespace***/]deploy/***deployment_name***
3. [***namespace***/]ds/***daemonset_name***

Some default behaviors:
* If namespace is not specified, current namespace will be used.
* The script runs `tcpdump` with [some options](https://github.com/PandaXass/ktcpdump/blob/ebcdab4e534f301a344237dff5427323581faf32/ktcpdump#L82) by default, so it will not exhaust the disk space and create unnecessary DNS requests by accident.

## Prerequisites
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (1.15 or higher)
* [jq](https://stedolan.github.io/jq/) (1.6 or higher)

## Install
TODO

## Examples

```bash
# Show usage information
ktcpdump help
# Create ktcpdump DaemonSet
ktcpdump create
# Show versions (need DeamonSet to be created first)
ktcpdump version
# Capture traffic on all Kubenetes hosts
ktcpdump run
# Capture traffic on Pod and write to the file
ktcpdump run pod <pod_name> -w ktcpdump.pcap
# Capture traffic from the source Pod to the dest Pod with verbose mode
ktcpdump run -v src pod <pod1_name> and dst pod <pod2_name>
# Capture RST packets between Pod and Deployment in different Namespaces
ktcpdump run <ns1_name>/pod/<pod_name> and <ns2_name>/deploy/<deploy_name> and 'tcp[tcpflags] & tcp-rst != 0'
# Rerun previous "run" command
ktcpdump rerun
# Delete the DaemonSet
ktcpdump purge
```

## Known Limitations
* Running this tool could potentially generate a long `tcpdump` command. And the total size of the command line argument is limited to `getconf ARG_MAX`.
* The tool retrieves the pods IPs in the very beginning. In Kubenetes, the pods (together with IPs) can be terminated and created dynamically. However they will not be reflected in the results. In other words, this tool might miss to capture some network packets due to pod changes.
