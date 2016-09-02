From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Why would cpu cgroup get disabled by the kernel?
Date: Fri, 2 Sep 2016 17:54:38 +0800
Message-ID: <57C94C5E.3020202@huawei.com>
References: <CAGmahrS4P7kS6_5MOhHA=ge6mcq0C2f85iN9S3z5dgi+qsEh9g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGmahrS4P7kS6_5MOhHA=ge6mcq0C2f85iN9S3z5dgi+qsEh9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sverd Johnsen <sverd.johnsen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2016/9/2 17:12, Sverd Johnsen wrote:
> Hi! I'am on 4.4.19 (arm)  and seem to have all requirements for CPU
> cgroups build into the kernel:
> 
>  # zgrep -P "CGROUP|GROUP|FAIR" /proc/config.gz
> CONFIG_CGROUPS=y
> # CONFIG_CGROUP_DEBUG is not set
> # CONFIG_CGROUP_FREEZER is not set
> CONFIG_CGROUP_PIDS=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CGROUP_CPUACCT=y
> # CONFIG_CGROUP_PERF is not set
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_RT_GROUP_SCHED=y
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> CONFIG_CFQ_GROUP_IOSCHED=y
> # CONFIG_NET_CLS_CGROUP is not set
> # CONFIG_CGROUP_NET_PRIO is not set
> # CONFIG_CGROUP_NET_CLASSID is not set
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> 
> Other cgroups also work:
> 
> # findmnt -a
> TARGET                       SOURCE
> FSTYPE     OPTIONS
> |-/sys                       sysfs
> sysfs      rw,nosuid,nodev,noexec,relatime
> | |-/sys/kernel/security     securityfs
> securityfs rw,nosuid,nodev,noexec,relatime
> | |-/sys/fs/cgroup           tmpfs
> tmpfs      ro,nosuid,nodev,noexec,mode=755
> | | |-/sys/fs/cgroup/systemd cgroup
> cgroup     rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd
> | | |-/sys/fs/cgroup/devices cgroup
> cgroup     rw,nosuid,nodev,noexec,relatime,devices
> | | |-/sys/fs/cgroup/blkio   cgroup
> cgroup     rw,nosuid,nodev,noexec,relatime,blkio
> | | |-/sys/fs/cgroup/pids    cgroup
> cgroup     rw,nosuid,nodev,noexec,relatime,pids
> | | `-/sys/fs/cgroup/cpuacct cgroup
> cgroup     rw,nosuid,nodev,noexec,relatime,cpuacct
> 
> However I get this:
> 
> # dmesg | egrep "cgroup|control group"
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.001242] Disabling cpu control group subsystem

dmesg | grep "Command line", and then I guess we'll get to know why.

> [    0.001263] Initializing cgroup subsys io
> [    0.001289] Initializing cgroup subsys devices
> [    0.001304] Initializing cgroup subsys pids
> 
> # column -t /proc/cgroups
> #subsys_name  hierarchy  num_cgroups  enabled
> cpu           0          1            0
> cpuacct       5          59           1
> blkio         3          9            1
> devices       2          56           1
> pids          4          64           1
> 
> Why? really weird. I control the boot process (systemd 231)
> and nothing there apparently disables it. When I try to mount cpu
> cgroup manually I just
> get ENOENT
