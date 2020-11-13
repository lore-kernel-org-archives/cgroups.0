From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2] cpuset: fix race between hotplug work and later CPU
 offline
Date: Fri, 13 Nov 2020 09:16:22 +0100
Message-ID: <20201113081622.GA2628@hirez.programming.kicks-ass.net>
References: <20201112171711.639541-1-daniel.m.jordan@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5N5ehk3YooE5n4GR5V5uz/RJicpr7z7QnkGAwp8KO2A=; b=rGcsjmb6Ec1d59cbz4DPDP5avQ
        tBYlssuVPlOQRd7IQGAs6HvG3sBQcymPGh2EstQP0iJVQA7qHUMv2lueYRUgsHLhYJJHH4F5O5NlH
        bJVF8gHc9F/qQL//ML2j+l4L7AcGInQj8zHWPooYKv8D3l/Wcn6E2SgBowN48KqHYCMnGt0byuA09
        TbF6ry258EDdl1UDyn2Eqd5R2L3r5KK497XRKYohBRBhp3S+VeYclYdXCYfQvLZ9eahoZbzBOy+h1
        RYpc1K+MUYIQgP9SmOhiY/C6XP4rU6ycKy6GgC28UC3lGMTQwMryN5nU5h6PzOGdjiPUgrhewv4Pt
        Y0UzRtbQ==;
Content-Disposition: inline
In-Reply-To: <20201112171711.639541-1-daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 12, 2020 at 12:17:11PM -0500, Daniel Jordan wrote:
> One of our machines keeled over trying to rebuild the scheduler domains.
> Mainline produces the same splat:
> 
>   BUG: unable to handle page fault for address: 0000607f820054db
>   CPU: 2 PID: 149 Comm: kworker/1:1 Not tainted 5.10.0-rc1-master+ #6
>   Workqueue: events cpuset_hotplug_workfn
>   RIP: build_sched_domains
>   Call Trace:
>    partition_sched_domains_locked
>    rebuild_sched_domains_locked
>    cpuset_hotplug_workfn
> 
> It happens with cgroup2 and exclusive cpusets only.  This reproducer
> triggers it on an 8-cpu vm and works most effectively with no
> preexisting child cgroups:
> 
>   cd $UNIFIED_ROOT
>   mkdir cg1
>   echo 4-7 > cg1/cpuset.cpus
>   echo root > cg1/cpuset.cpus.partition
> 
>   # with smt/control reading 'on',
>   echo off > /sys/devices/system/cpu/smt/control
> 
> RIP maps to
> 
>   sd->shared = *per_cpu_ptr(sdd->sds, sd_id);
> 
> from sd_init().  sd_id is calculated earlier in the same function:
> 
>   cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
>   sd_id = cpumask_first(sched_domain_span(sd));
> 
> tl->mask(cpu), which reads cpu_sibling_map on x86, returns an empty mask
> and so cpumask_first() returns >= nr_cpu_ids, which leads to the bogus
> value from per_cpu_ptr() above.
> 
> The problem is a race between cpuset_hotplug_workfn() and a later
> offline of CPU N.  cpuset_hotplug_workfn() updates the effective masks
> when N is still online, the offline clears N from cpu_sibling_map, and
> then the worker uses the stale effective masks that still have N to
> generate the scheduling domains, leading the worker to read
> N's empty cpu_sibling_map in sd_init().
> 
> rebuild_sched_domains_locked() prevented the race during the cgroup2
> cpuset series up until the Fixes commit changed its check.  Make the
> check more robust so that it can detect an offline CPU in any exclusive
> cpuset's effective mask, not just the top one.
> 
> Fixes: 0ccea8feb980 ("cpuset: Make generate_sched_domains() work with partition")
> Signed-off-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Works for me. TJ, do I take this or do you want it in the cgroup tree?

In that case:

Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
