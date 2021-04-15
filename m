From: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/5] mm/memcg: Reduce kmemcache memory accounting
 overhead
Date: Wed, 14 Apr 2021 23:26:42 -0400
Message-ID: <20210415032642.gfaevezaxoj4od3d@gabell>
References: <20210414012027.5352-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7ELJgZAB0/MDsT4s31FFYWkqnQ9XSl76WVBBR9IJO1c=;
        b=t528pCYvS51nm/69P94WlzjraUcBRoYhV1mwN/WUsURBWiaUdqIiJW0x7GvN+c679B
         2FJpV0XfBUE7PthAYwdSXqkWAhsbL63OuuIrtaTeoO45oFfWY9FahsNxOsRY3lOEuSNU
         F4TD+03q5Lr6hIVk/ZLD7lx4CDn4DQQEzUul5FgRzHyEiV3WUzWysaKVpVfZLxq8j2u6
         pLxuQDhGeWAOSltbuPZ5uabQx9R0Qyor4AM/yD2MrU/KYb2Q7aAWP/PhI6KPt1zicqDP
         UMnt9Gvr1J50tMHcewLTfsUzZjJ5BZYT6OGfvc9HF0Ah2Prk/wB6O72tGHROYyY7CvyZ
         gE9w==
Content-Disposition: inline
In-Reply-To: <20210414012027.5352-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Tue, Apr 13, 2021 at 09:20:22PM -0400, Waiman Long wrote:
>  v3:
>   - Add missing "inline" qualifier to the alternate mod_obj_stock_state()
>     in patch 3.
>   - Remove redundant current_obj_stock() call in patch 5.
> 
>  v2:
>   - Fix bug found by test robot in patch 5.
>   - Update cover letter and commit logs.
> 
> With the recent introduction of the new slab memory controller, we
> eliminate the need for having separate kmemcaches for each memory
> cgroup and reduce overall kernel memory usage. However, we also add
> additional memory accounting overhead to each call of kmem_cache_alloc()
> and kmem_cache_free().
> 
> For workloads that require a lot of kmemcache allocations and
> de-allocations, they may experience performance regression as illustrated
> in [1] and [2].
> 
> A simple kernel module that performs repeated loop of 100,000,000
> kmem_cache_alloc() and kmem_cache_free() of a 64-byte object at module
> init time is used for benchmarking. The test was run on a CascadeLake
> server with turbo-boosting disable to reduce run-to-run variation.
> 
> With memory accounting disable, the run time was 2.848s. With memory
> accounting enabled, the run times with the application of various
> patches in the patchset were:
> 
>   Applied patches   Run time   Accounting overhead   Overhead %age
>   ---------------   --------   -------------------   -------------
>        None          10.800s         7.952s              100.0%
>         1-2           9.140s         6.292s               79.1%
>         1-3           7.641s         4.793s               60.3%
>         1-5           6.801s         3.953s               49.7%
> 
> Note that this is the best case scenario where most updates happen only
> to the percpu stocks. Real workloads will likely have a certain amount
> of updates to the memcg charges and vmstats. So the performance benefit
> will be less.
> 
> It was found that a big part of the memory accounting overhead
> was caused by the local_irq_save()/local_irq_restore() sequences in
> updating local stock charge bytes and vmstat array, at least in x86
> systems. There are two such sequences in kmem_cache_alloc() and two
> in kmem_cache_free(). This patchset tries to reduce the use of such
> sequences as much as possible. In fact, it eliminates them in the common
> case. Another part of this patchset to cache the vmstat data update in
> the local stock as well which also helps.
> 
> [1] https://lore.kernel.org/linux-mm/20210408193948.vfktg3azh2wrt56t@gabell/T/#u

Hi Longman,

Thank you for your patches.
I rerun the benchmark with your patches, it seems that the reduction
is small... The total duration of sendto() and recvfrom() system call 
during the benchmark are as follows.

- sendto
  - v5.8 vanilla:                      2576.056 msec (100%)
  - v5.12-rc7 vanilla:                 2988.911 msec (116%)
  - v5.12-rc7 with your patches (1-5): 2984.307 msec (115%)

- recvfrom
  - v5.8 vanilla:                      2113.156 msec (100%)
  - v5.12-rc7 vanilla:                 2305.810 msec (109%)
  - v5.12-rc7 with your patches (1-5): 2287.351 msec (108%)

kmem_cache_alloc()/kmem_cache_free() are called around 1,400,000 times during
the benchmark. I ran a loop in a kernel module as following. The duration
is reduced by your patches actually.

  ---
  dummy_cache = KMEM_CACHE(dummy, SLAB_ACCOUNT);
  for (i = 0; i < 1400000; i++) {
	p = kmem_cache_alloc(dummy_cache, GFP_KERNEL);
	kmem_cache_free(dummy_cache, p);
  }
  ---

- v5.12-rc7 vanilla:                 110 msec (100%)
- v5.12-rc7 with your patches (1-5):  85 msec (77%)

It seems that the reduction is small for the benchmark though...
Anyway, I can see your patches reduce the overhead.
Please feel free to add:

	Tested-by: Masayoshi Mizuma <m.mizuma-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Thanks!
Masa

> [2] https://lore.kernel.org/lkml/20210114025151.GA22932@xsang-OptiPlex-9020/
> 
> Waiman Long (5):
>   mm/memcg: Pass both memcg and lruvec to mod_memcg_lruvec_state()
>   mm/memcg: Introduce obj_cgroup_uncharge_mod_state()
>   mm/memcg: Cache vmstat data in percpu memcg_stock_pcp
>   mm/memcg: Separate out object stock data into its own struct
>   mm/memcg: Optimize user context object stock access
> 
>  include/linux/memcontrol.h |  14 ++-
>  mm/memcontrol.c            | 199 ++++++++++++++++++++++++++++++++-----
>  mm/percpu.c                |   9 +-
>  mm/slab.h                  |  32 +++---
>  4 files changed, 196 insertions(+), 58 deletions(-)
> 
> -- 
> 2.18.1
> 
