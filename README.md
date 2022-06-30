# ktcpdump
A simple wrapper script to run tcpdump nicely on Kubernetes.

This tool will deploy a DaemonSet in the Kubernetes cluster using `kubectl` and run `tcpdump` on host network to capture network traffic.

The DaemonSet is based on [wbitt/network-multitool](https://hub.docker.com/r/wbitt/network-multitool) Docker image.

### !! Important Note: Please use this tool in production by **CAUTION** !!

## What's new
The script extends the `tcpdump` filter expressions by translating them to `pcap-filter` format.
1. [***namespace***/]pod/***pod_name***
2. [***namespace***/]deploy/***deployment_name***
3. [***namespace***/]ds/***daemonset_name***

Some default behaviors:
* If namespace is not specified, current namespace will be used.
* The script runs `tcpdump` with [some options](https://github.com/PandaXass/ktcpdump/blob/fc20475fde6c98608171a984c559551684b5e07f/ktcpdump#L95) by default, so it will not exhaust the disk space and create unnecessary DNS requests by accident.

## Prerequisites
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) 1.15 or higher
* [jq](https://stedolan.github.io/jq/) 1.6 or higher
* (optional) [Wireshark](https://www.wireshark.org/#download) 3.0 or higher

## Install from source
Check out the ktcpdump repository. And then, run the provided `install.sh` command with the location to the prefix in which you want to install `ktcpdump`. By default, it installs the tool into `/usr/local`.

```bash
git clone https://git@github.com:PandaXass/ktcpdump.git
cd ktcpdump
sudo ./install.sh
```

### Uninstall
```bash
# Remove the installed directory
sudo rm -r /usr/local/ktcpdump
# Remove the symlink
rm /usr/local/bin/ktcpdump
```

## Usage examples
Some examples about how to use the tool.

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
# Capture RST and FIN packets between Pod and Deployment in different Namespaces
ktcpdump run <ns1_name>/pod/<pod_name> and <ns2_name>/deploy/<deploy_name> and 'tcp[tcpflags] & (tcp-rst|tcp-fin) != 0'
# Capture all TCP packets on destination Deployment port 8080
./ktcpdump run -v dst <ns_name>/deploy/<deploy_name> and 'tcp port 8080'
# Rerun previous "run" command
ktcpdump rerun
# Show ktcpdump status
ktcpdump status
# Show ktcpdump DaemonSet logs
ktcpdump logs
# Copy ktcpdump.pcap file from DaemonSet Pods to local folder
ktcpdump cp ktcpdump.pcap
# Merge all capture files
mergecap -w outfile.pcap *.pcap
# Delete the DaemonSet
ktcpdump purge
```

## Known Limitations
* Running this tool could potentially generate a long `tcpdump` command. And the total size of the command line argument is limited to `getconf ARG_MAX`.
* The tool retrieves the pods IPs in the beginning of each `run`. In Kubenetes, the pods (together with IPs) can be created and terminated dynamically. However those changes will not be reflected in the output. In other words, this tool might miss capturing some network packets due to pod changes.
