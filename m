From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 0/5] mm/memcg: Reduce kmemcache memory accounting overhead
Date: Fri, 9 Apr 2021 18:51:20 -0700
Message-ID: <YHEEmGSVy3nl0obM@carbon.dhcp.thefacebook.com>
References: <20210409231842.8840-1-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=VohXgyTubbH1Px/q87HiemKrrAlwObQnOXkba6IiUtU=;
 b=CLxfce8vVIZ2kXgOQl+pOXWVfntDxU7r7Yw74ommWKk+CArXVlisK7TLyROWsWuKZa0k
 v1yt8Lt7XnMbAk4NqHNZmsSjx+LWmimUiZrsmaswDzPbaY8RlFuHPCxwO9pCnhd+2oa7
 Z/raLGLDoYB27bwQrHUnZ5HDxHtjNvhFvdc= 
Content-Disposition: inline
In-Reply-To: <20210409231842.8840-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Wei Yang <richard.weiyang@gmail.com>, Masayoshi Mizuma <msys.mizuma@gmail.co>

On Fri, Apr 09, 2021 at 07:18:37PM -0400, Waiman Long wrote:
> With the recent introduction of the new slab memory controller, we
> eliminate the need for having separate kmemcaches for each memory
> cgroup and reduce overall kernel memory usage. However, we also add
> additional memory accounting overhead to each call of kmem_cache_alloc()
> and kmem_cache_free().
> 
> For workloads that require a lot of kmemcache allocations and
> de-allocations, they may experience performance regression as illustrated
> in [1].
> 
> With a simple kernel module that performs repeated loop of 100,000,000
> kmem_cache_alloc() and kmem_cache_free() of 64-byte object at module
> init. The execution time to load the kernel module with and without
> memory accounting were:
> 
>   with accounting = 6.798s
>   w/o  accounting = 1.758s
> 
> That is an increase of 5.04s (287%). With this patchset applied, the
> execution time became 4.254s. So the memory accounting overhead is now
> 2.496s which is a 50% reduction.

Hi Waiman!

Thank you for working on it, it's indeed very useful!
A couple of questions:
1) did your config included lockdep or not?
2) do you have a (rough) estimation how much each change contributes
   to the overall reduction?

Thanks!

> 
> It was found that a major part of the memory accounting overhead
> is caused by the local_irq_save()/local_irq_restore() sequences in
> updating local stock charge bytes and vmstat array, at least in x86
> systems. There are two such sequences in kmem_cache_alloc() and two
> in kmem_cache_free(). This patchset tries to reduce the use of such
> sequences as much as possible. In fact, it eliminates them in the common
> case. Another part of this patchset to cache the vmstat data update in
> the local stock as well which also helps.
> 
> [1] https://lore.kernel.org/linux-mm/20210408193948.vfktg3azh2wrt56t@gabell/T/#u
> 
> Waiman Long (5):
>   mm/memcg: Pass both memcg and lruvec to mod_memcg_lruvec_state()
>   mm/memcg: Introduce obj_cgroup_uncharge_mod_state()
>   mm/memcg: Cache vmstat data in percpu memcg_stock_pcp
>   mm/memcg: Separate out object stock data into its own struct
>   mm/memcg: Optimize user context object stock access
> 
>  include/linux/memcontrol.h |  14 ++-
>  mm/memcontrol.c            | 198 ++++++++++++++++++++++++++++++++-----
>  mm/percpu.c                |   9 +-
>  mm/slab.h                  |  32 +++---
>  4 files changed, 195 insertions(+), 58 deletions(-)
> 
> -- 
> 2.18.1
> 
