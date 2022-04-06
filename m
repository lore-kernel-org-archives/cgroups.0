From: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH v2 0/4] Introduce group balancer
Date: Wed, 6 Apr 2022 10:47:53 +0800
Message-ID: <b8c08e6f-bb34-7266-0dbc-1e673b6a965c@linux.alibaba.com>
References: <20220308092629.40431-1-dtcccc@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <20220308092629.40431-1-dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michael Wang <yun.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Cruz Zhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Masahiro Yamada <masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nathan Chancellor <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Gustavo A. R. Silva" <gustavoars@ker>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Ping~
Any idea for this patchset? :-)

On 2022/3/8 17:26, Tianchen Ding wrote:
> Modern platform are growing fast on CPU numbers. To achieve better
> utility of CPU resource, multiple apps are starting to sharing the CPUs.
> 
> What we need is a way to ease confliction in share mode,
> make groups as exclusive as possible, to gain both performance
> and resource efficiency.
> 
> The main idea of group balancer is to fulfill this requirement
> by balancing groups of tasks among groups of CPUs, consider this
> as a dynamic demi-exclusive mode. Task trigger work to settle it's
> group into a proper partition (minimum predicted load), then try
> migrate itself into it. To gradually settle groups into the most
> exclusively partition.
> 
> GB can be seen as an optimize policy based on load balance,
> it obeys the main idea of load balance and makes adjustment
> based on that.
> 
> Our test on ARM64 platform with 128 CPUs shows that,
> throughput of sysbench memory is improved about 25%,
> and redis-benchmark is improved up to about 10%.
> 
> See each patch for detail:
> The 1st patch introduces infrastructure.
> The 2nd patch introduces detail about partition info.
> The 3rd patch is the main part of group balancer.
> The 4th patch is about stats.
> 
> v2:
> Put partition info and period settings to cpuset subsys of cgroup_v2.
> 
> v1: https://lore.kernel.org/all/98f41efd-74b2-198a-839c-51b785b748a6-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org/
> 
> Michael Wang (1):
>    sched: Introduce group balancer
> 
> Tianchen Ding (3):
>    sched, cpuset: Introduce infrastructure of group balancer
>    cpuset: Handle input of partition info for group balancer
>    cpuset, gb: Add stat for group balancer
> 
>   include/linux/cpuset.h   |   5 +
>   include/linux/sched.h    |   5 +
>   include/linux/sched/gb.h |  70 ++++++
>   init/Kconfig             |  12 +
>   kernel/cgroup/cpuset.c   | 405 +++++++++++++++++++++++++++++++-
>   kernel/sched/Makefile    |   1 +
>   kernel/sched/core.c      |   5 +
>   kernel/sched/debug.c     |  10 +-
>   kernel/sched/fair.c      |  26 ++-
>   kernel/sched/gb.c        | 487 +++++++++++++++++++++++++++++++++++++++
>   kernel/sched/sched.h     |  14 ++
>   11 files changed, 1037 insertions(+), 3 deletions(-)
>   create mode 100644 include/linux/sched/gb.h
>   create mode 100644 kernel/sched/gb.c
> 

