From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 4/6] sched/deadline: Block DL tasks on non-exclusive
 cpuset if bandwitdh control is enable
Date: Thu, 14 Jan 2021 16:51:43 +0100
Message-ID: <4b37b32b-0e16-ffbc-ca6a-fbee935c0813@arm.com>
References: <cover.1610463999.git.bristot@redhat.com>
 <7b336c37cc3c38def6de181df8ba8c3148c5cc0c.1610463999.git.bristot@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7b336c37cc3c38def6de181df8ba8c3148c5cc0c.1610463999.git.bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Marco Perronet <perronet-41PbBDiSz5tAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 12/01/2021 16:53, Daniel Bristot de Oliveira wrote:
> The current SCHED_DEADLINE design supports only global scheduler,
> or variants of it, i.e., clustered and partitioned, via cpuset config.
> To enable the partitioning of a system with clusters of CPUs, the
> documentation advises the usage of exclusive cpusets, creating an
> exclusive root_domain for the cpuset.
> 
> Attempts to change the cpu affinity of a thread to a cpu mask different
> from the root domain results in an error. For instance:

[...]

> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 788a391657a5..c221e14d5b86 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -2878,6 +2878,13 @@ int dl_task_can_attach(struct task_struct *p,
>  	if (cpumask_empty(cs_cpus_allowed))
>  		return 0;
>  
> +	/*
> +	 * Do not allow moving tasks to non-exclusive cpusets
> +	 * if bandwidth control is enabled.
> +	 */
> +	if (dl_bandwidth_enabled() && !exclusive)
> +		return -EBUSY;
> +
>  	/*
>  	 * The task is not moving to another root domain, so it is
>  	 * already accounted.
> 

But doesn't this mean you only have to set this cgroup exclusive/root to
run into the same issue:

with this patch:

cgroupv1:

root@juno:/sys/fs/cgroup/cpuset# chrt -d --sched-period 1000000000
--sched-runtime 100000000 0 sleep 500 &
[1] 1668
root@juno:/sys/fs/cgroup/cpuset# PID1=$!

root@juno:/sys/fs/cgroup/cpuset# chrt -d --sched-period 1000000000
--sched-runtime 100000000 0 sleep 500 &
[2] 1669
root@juno:/sys/fs/cgroup/cpuset# PID2=$!

root@juno:/sys/fs/cgroup/cpuset# mkdir A

root@juno:/sys/fs/cgroup/cpuset# echo 0 > ./A/cpuset.mems
root@juno:/sys/fs/cgroup/cpuset# echo 0 > ./A/cpuset.cpus

root@juno:/sys/fs/cgroup/cpuset# echo $PID2 > ./A/cgroup.procs
-bash: echo: write error: Device or resource busy

root@juno:/sys/fs/cgroup/cpuset# echo 1 > ./A/cpuset.cpu_exclusive

root@juno:/sys/fs/cgroup/cpuset# echo $PID2 > ./A/cgroup.procs

root@juno:/sys/fs/cgroup/cpuset# cat /proc/$PID1/status | grep
Cpus_allowed_list | awk '{print $2}'
0-5
root@juno:/sys/fs/cgroup/cpuset# cat /proc/$PID2/status | grep
Cpus_allowed_list | awk '{print $2}'
0

cgroupv2:

root@juno:/sys/fs/cgroup# echo +cpuset > cgroup.subtree_control

root@juno:/sys/fs/cgroup# chrt -d --sched-period 1000000000
--sched-runtime 100000000 0 sleep 500 &
[1] 1687
root@juno:/sys/fs/cgroup# PID1=$!

root@juno:/sys/fs/cgroup# chrt -d --sched-period 1000000000
--sched-runtime 100000000 0 sleep 500 &
[2] 1688
root@juno:/sys/fs/cgroup# PID2=$!

root@juno:/sys/fs/cgroup# mkdir A

root@juno:/sys/fs/cgroup# echo 0 > ./A/cpuset.mems
root@juno:/sys/fs/cgroup# echo 0 > ./A/cpuset.cpus

root@juno:/sys/fs/cgroup# echo $PID2 > ./A/cgroup.procs
-bash: echo: write error: Device or resource busy

root@juno:/sys/fs/cgroup# echo root > ./A/cpuset.cpus.partition

root@juno:/sys/fs/cgroup# echo $PID2 > ./A/cgroup.procs

root@juno:/sys/fs/cgroup# cat /proc/$PID1/status | grep
Cpus_allowed_list | awk '{print $2}'
0-5
root@juno:/sys/fs/cgroup# cat /proc/$PID2/status | grep
Cpus_allowed_list | awk '{print $2}'
0
