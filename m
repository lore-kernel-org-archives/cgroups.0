From: Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Date: Fri, 19 May 2023 10:53:27 +0800
Message-ID: <ZGbkp2nx7k+qXOBl@xsang-OptiPlex-9020>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com>
 <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
 <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020>
 <20230517162447.dztfzmx3hhetfs2q@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684464844; x=1716000844;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1+DJOwujSInK2wEZ/m3KNn7TmTvUBzY4klP7FESkpPE=;
  b=O+Msi0tfNCsg8ah8zkP2wDNvMus2Ll2ReTltKvhkTpBK407eqcQ+6uVd
   Z0ZMje1v7JDVIJI344Fuw0mrRCAUEef2D9iHAVcVtGQsJZ9Eqdo74KuTl
   9d02Bh4aDfSJO7Qf9pDMwAa5QZZ4IwgZOB4BFuAHCsEpK20AjPZ0wB+mY
   1P8yXJVeIZ30xWVho1ocqKKk+DeZMZpbEClvil/owEliKRWCgZuknzeiU
   yX/N3v+MA0Z2u1Ul9w/QGslycVfQjn1b38hfNm3VrHJYqvfAbtWLn0Zj9
   BHGT9wyLY9BivAVnXRYs1wdCBwqaI5t0jkPHjEAa+YvXjDWUCONVBziVT
   g==;
Content-Disposition: inline
In-Reply-To: <20230517162447.dztfzmx3hhetfs2q-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zhang Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yin Fengwei <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Brandeburg Jesse <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Suresh <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chen Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, You Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, philip.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

hi Shakeel,

On Wed, May 17, 2023 at 04:24:47PM +0000, Shakeel Butt wrote:
> On Tue, May 16, 2023 at 01:46:55PM +0800, Oliver Sang wrote:
> > hi Shakeel,
> > 
> > On Mon, May 15, 2023 at 12:50:31PM -0700, Shakeel Butt wrote:
> > > +Feng, Yin and Oliver
> > > 
> > > >
> > > > > Thanks a lot Cathy for testing. Do you see any performance improvement for
> > > > > the memcached benchmark with the patch?
> > > >
> > > > Yep, absolutely :- ) RPS (with/without patch) = +1.74
> > > 
> > > Thanks a lot Cathy.
> > > 
> > > Feng/Yin/Oliver, can you please test the patch at [1] with other
> > > workloads used by the test robot? Basically I wanted to know if it has
> > > any positive or negative impact on other perf benchmarks.
> > 
> > is it possible for you to resend patch with Signed-off-by?
> > without it, test robot will regard the patch as informal, then it cannot feed
> > into auto test process.
> > and could you tell us the base of this patch? it will help us apply it
> > correctly.
> > 
> > on the other hand, due to resource restraint, we normally cannot support
> > this type of on-demand test upon a single patch, patch set, or a branch.
> > instead, we try to merge them into so-called hourly-kernels, then distribute
> > tests and auto-bisects to various platforms.
> > after we applying your patch and merging it to hourly-kernels sccussfully,
> > if it really causes some performance changes, the test robot could spot out
> > this patch as 'fbc' and we will send report to you. this could happen within
> > several weeks after applying.
> > but due to the complexity of whole process (also limited resourse, such like
> > we cannot run all tests on all platforms), we cannot guanrantee capture all
> > possible performance impacts of this patch. and it's hard for us to provide
> > a big picture like what's the general performance impact of this patch.
> > this maybe is not exactly what you want. is it ok for you?
> > 
> > 
> 
> Yes, that is fine and thanks for the help. The patch is below:

Thanks! we've already fetched the patch in our hourly kernels which under
performance testing now (in fact, as well as func tests)

the testing and bisection could last several days to several weeks, and if
bisected to this commit for any changes such like performance regression or
improvement, we will send report to you.

however, again, if you didn't see any report, it just mean our test robot
cannot sucessfully spot out this commit as the reason for  any performance/func
changes.

> 
> 
> From 93b3b4c5f356a5090551519522cfd5740ae7e774 Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Date: Tue, 16 May 2023 20:30:26 +0000
> Subject: [PATCH] memcg: skip stock refill in irq context
> 
> The linux kernel processes incoming packets in softirq on a given CPU
> and those packets may belong to different jobs. This is very normal on
> large systems running multiple workloads. With memcg enabled, network
> memory for such packets is charged to the corresponding memcgs of the
> jobs.
> 
> Memcg charging can be a costly operation and the memcg code implements
> a per-cpu memcg charge caching optimization to reduce the cost of
> charging. More specifically, the kernel charges the given memcg for more
> memory than requested and keep the remaining charge in a local per-cpu
> cache. The insight behind this heuristic is that there will be more
> charge requests for that memcg in near future. This optimization works
> well when a specific job runs on a CPU for long time and majority of the
> charging requests happen in process context. However the kernel's
> incoming packet processing does not work well with this optimization.
> 
> Recently Cathy Zhang has shown [1] that memcg charge flushing within the
> memcg charge path can become a performance bottleneck for the memcg
> charging of network traffic.
> 
> Perf profile:
> 
> 8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter_cancel
>     |
>      --8.97%--page_counter_cancel
> 	       |
> 		--8.97%--page_counter_uncharge
> 			  drain_stock
> 			  __refill_stock
> 			  refill_stock
> 			  |
> 			   --8.91%--try_charge_memcg
> 				     mem_cgroup_charge_skmem
> 				     |
> 				      --8.91%--__sk_mem_raise_allocated
> 						__sk_mem_schedule
> 						|
> 						|--5.41%--tcp_try_rmem_schedule
> 						|          tcp_data_queue
> 						|          tcp_rcv_established
> 						|          tcp_v4_do_rcv
> 						|          tcp_v4_rcv
> 
> The simplest way to solve this issue is to not refill the memcg charge
> stock in the irq context. Since networking is the main source of memcg
> charging in the irq context, other users will not be impacted. In
> addition, this will preseve the memcg charge cache of the application
> running on that CPU.
> 
> There are also potential side effects. What if all the packets belong to
> the same application and memcg? More specifically, users can use Receive
> Flow Steering (RFS) to make sure the kernel process the packets of the
> application on the CPU where the application is running. This change may
> cause the kernel to do slowpath memcg charging more often in irq
> context.
> 
> Link: https://lore.kernel.org/all/IA0PR11MB73557DEAB912737FD61D2873FC749-py0Qfd72Ncwkr2bXB6wcV5PPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org [1]
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5abffe6f8389..2635aae82b3e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2652,6 +2652,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool raised_max_event = false;
>  	unsigned long pflags;
>  
> +	/*
> +	 * Skip the refill in irq context as it may flush the charge cache of
> +	 * the process running on the CPUs or the kernel may have to process
> +	 * incoming packets for different memcgs.
> +	 */
> +	if (!in_task())
> +		batch = nr_pages;
> +
>  retry:
>  	if (consume_stock(memcg, nr_pages))
>  		return 0;
> -- 
> 2.40.1.606.ga4b1b128d6-goog
> 
