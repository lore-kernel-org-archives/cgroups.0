From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: fix cpus_allowed mask for offline/online CPUs
Date: Mon, 4 Jan 2016 09:52:09 +0800
Message-ID: <5689D049.4040500@huawei.com>
References: <2f805346f87680dddfa9253dc9031db3b6ead8ad.1451648318.git.yu.c.chen@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2f805346f87680dddfa9253dc9031db3b6ead8ad.1451648318.git.yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vishnu Pratap Singh <vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Pintu Kumar <pintu.k-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 2016/1/1 20:09, Chen Yu wrote:
> Commit be4c9dd7aee5 ("cpuset: enable onlined cpu/node in effective masks")
> leverages cpuset's cpus_allowed and its parent's effective_cpus to calculate
> the new_cpus by:
>
> cpumask_and(&new_cpus, cs->cpus_allowed, parent_cs(cs)->effective_cpus);
>
> However cpus_allowed will also be updated after the CPU is offline, in
> hotplug_update_tasks_legacy, so when the CPU is online again, it will use
> the old cpus_allowed mask to calculate the new_cpus, thus new_cpus will get
> incorrect value after each round of offline/online.
>
> This problem is found on ubuntu 15.10 with cpuset mounted:
>
> 1. echo 0 > /sys/devices/system/cpu/cpu2/online
> 2. echo 1 > /sys/devices/system/cpu/cpu2/online
> 3. cat /sys/fs/cgroup/cpuset/cpuset.cpus
>     0-3
> 4. cat /sys/fs/cgroup/cpuset/user.slice/cpuset.cpus
>     0-1,3
> 5. taskset -c 2 ls
>     taskset: failed to set pid 0's affinity: Invalid argument
>

This is the expected behavior...In legacy hierachy onlining an offlined cpu
won't restore cpuset configurations automatically.

Commit be4c9dd7aee5 changed this behavior, but only for unified hierachy.
