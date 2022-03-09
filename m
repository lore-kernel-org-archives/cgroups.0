From: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH v2 0/4] Introduce group balancer
Date: Wed, 9 Mar 2022 16:30:51 +0800
Message-ID: <defa02c1-9660-f335-a764-d89dbe2f502e@linux.alibaba.com>
References: <20220308092629.40431-1-dtcccc@linux.alibaba.com>
 <YieOvaqJeEW2lta/@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <YieOvaqJeEW2lta/@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michael Wang <yun.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Cruz Zhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Masahiro Yamada <masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nathan Chancellor <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <ar>

On 2022/3/9 01:13, Tejun Heo wrote:
> Hello,
> 
> On Tue, Mar 08, 2022 at 05:26:25PM +0800, Tianchen Ding wrote:
>> Modern platform are growing fast on CPU numbers. To achieve better
>> utility of CPU resource, multiple apps are starting to sharing the CPUs.
>>
>> What we need is a way to ease confliction in share mode,
>> make groups as exclusive as possible, to gain both performance
>> and resource efficiency.
>>
>> The main idea of group balancer is to fulfill this requirement
>> by balancing groups of tasks among groups of CPUs, consider this
>> as a dynamic demi-exclusive mode. Task trigger work to settle it's
>> group into a proper partition (minimum predicted load), then try
>> migrate itself into it. To gradually settle groups into the most
>> exclusively partition.
>>
>> GB can be seen as an optimize policy based on load balance,
>> it obeys the main idea of load balance and makes adjustment
>> based on that.
>>
>> Our test on ARM64 platform with 128 CPUs shows that,
>> throughput of sysbench memory is improved about 25%,
>> and redis-benchmark is improved up to about 10%.
> 
> The motivation makes sense to me but I'm not sure this is the right way to
> architecture it. We already have the framework to do all these - the sched
> domains and the load balancer. Architecturally, what the suggested patchset
> is doing is building a separate load balancer on top of cpuset after using
> cpuset to disable the existing load balancer, which is rather obviously
> convoluted.
> 

"the sched domains and the load balancer" you mentioned are the ways to 
"balance" tasks on each domains. However, this patchset aims to "group" 
them together to win hot cache and less competition, which is different 
from load balancer. See commit log of the patch 3/4 and this link:
https://lore.kernel.org/all/11d4c86a-40ef-6ce5-6d08-e9d0bc9b512a-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org/

> * AFAICS, none of what the suggested code does is all that complicated or
>    needs a lot of input from userspace. it should be possible to parametrize
>    the existing load balancer to behave better.
> 

Group balancer mainly needs 2 inputs from userspace: cpu partition info 
and cgroup info.
Cpu partition info does need user input (and maybe a bit complicated). 
As a result, the division methods are __free__ to users(can refer to 
NUMA nodes, clusters, cache, etc.)
Cgroup info doesn't need extra input. It's naturally configured.

It do parametrize the existing load balancer to behave better.
Group balancer is a kind of optimize policy, and should obey the basic
policy (load balance) and improve it.
The relationship between load balancer and group balancer is explained 
in detail at the above link.

> * If, for some reason, you need more customizable behavior in terms of cpu
>    allocation, which is what cpuset is for, maybe it'd be better to build the
>    load balancer in userspace. That'd fit way better with how cgroup is used
>    in general and with threaded cgroups, it should fit nicely with everything
>    else.
> 

We put group balancer in kernel space because this new policy does not 
depend on userspace apps. It's a "general" feature.
Doing "dynamic cpuset" in userspace may also introduce performance 
issue, since it may need to bind and unbind different cpusets for 
several times, and is too strict(compared with our "soft bind").

