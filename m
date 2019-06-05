From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v4 0/7] mm: reparent slab memory on cgroup removal
Date: Wed, 05 Jun 2019 00:39:24 -0700
Message-ID: <xr93ef48v5ub.fsf@gthelen.svl.corp.google.com>
References: <20190514213940.2405198-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EDTxCxcNHL556kqhPzcTfA1xZzULf1Gez0maK4Ox1iQ=;
        b=GvDUXyVvyxLCvV/+addi6w1Q4z3X2ywCTF++ZtLGrCnS35NqwNKaEoKggI1CuaorgB
         MQvfCkOJaobkMcHaGlSaoT0eLU8rzhhp6LxZvwdhQf880jxkj7M9ol5tok2ga3mnSTt3
         4hfcCTAxJfNh8eqFJbyLGoNcs6TUpWL1nE+NTRpF2arLgPQ3P6PmbtnRKyfi4zfvC/u3
         KI/rA/orx+IPk0qA9xZpK3jh2mCgApEAXZ8ElZvuxn4k/thGOWFVw71XwhCkJz52Rtt2
         YUJNZMHHeSGnU+UObziZhOF7qFByOUmtWQH22TS2OeVKtfvORrB9uWQg7FHLf4O7QZe+
         WGZw==
In-Reply-To: <20190514213940.2405198-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Roman Gushchin <guro@fb.com> wrote:

> # Why do we need this?
>
> We've noticed that the number of dying cgroups is steadily growing on most
> of our hosts in production. The following investigation revealed an issue
> in userspace memory reclaim code [1], accounting of kernel stacks [2],
> and also the mainreason: slab objects.
>
> The underlying problem is quite simple: any page charged
> to a cgroup holds a reference to it, so the cgroup can't be reclaimed unless
> all charged pages are gone. If a slab object is actively used by other cgroups,
> it won't be reclaimed, and will prevent the origin cgroup from being reclaimed.
>
> Slab objects, and first of all vfs cache, is shared between cgroups, which are
> using the same underlying fs, and what's even more important, it's shared
> between multiple generations of the same workload. So if something is running
> periodically every time in a new cgroup (like how systemd works), we do
> accumulate multiple dying cgroups.
>
> Strictly speaking pagecache isn't different here, but there is a key difference:
> we disable protection and apply some extra pressure on LRUs of dying cgroups,
> and these LRUs contain all charged pages.
> My experiments show that with the disabled kernel memory accounting the number
> of dying cgroups stabilizes at a relatively small number (~100, depends on
> memory pressure and cgroup creation rate), and with kernel memory accounting
> it grows pretty steadily up to several thousands.
>
> Memory cgroups are quite complex and big objects (mostly due to percpu stats),
> so it leads to noticeable memory losses. Memory occupied by dying cgroups
> is measured in hundreds of megabytes. I've even seen a host with more than 100Gb
> of memory wasted for dying cgroups. It leads to a degradation of performance
> with the uptime, and generally limits the usage of cgroups.
>
> My previous attempt [3] to fix the problem by applying extra pressure on slab
> shrinker lists caused a regressions with xfs and ext4, and has been reverted [4].
> The following attempts to find the right balance [5, 6] were not successful.
>
> So instead of trying to find a maybe non-existing balance, let's do reparent
> the accounted slabs to the parent cgroup on cgroup removal.
>
>
> # Implementation approach
>
> There is however a significant problem with reparenting of slab memory:
> there is no list of charged pages. Some of them are in shrinker lists,
> but not all. Introducing of a new list is really not an option.
>
> But fortunately there is a way forward: every slab page has a stable pointer
> to the corresponding kmem_cache. So the idea is to reparent kmem_caches
> instead of slab pages.
>
> It's actually simpler and cheaper, but requires some underlying changes:
> 1) Make kmem_caches to hold a single reference to the memory cgroup,
>    instead of a separate reference per every slab page.
> 2) Stop setting page->mem_cgroup pointer for memcg slab pages and use
>    page->kmem_cache->memcg indirection instead. It's used only on
>    slab page release, so it shouldn't be a big issue.
> 3) Introduce a refcounter for non-root slab caches. It's required to
>    be able to destroy kmem_caches when they become empty and release
>    the associated memory cgroup.
>
> There is a bonus: currently we do release empty kmem_caches on cgroup
> removal, however all other are waiting for the releasing of the memory cgroup.
> These refactorings allow kmem_caches to be released as soon as they
> become inactive and free.
>
> Some additional implementation details are provided in corresponding
> commit messages.
>
> # Results
>
> Below is the average number of dying cgroups on two groups of our production
> hosts. They do run some sort of web frontend workload, the memory pressure
> is moderate. As we can see, with the kernel memory reparenting the number
> stabilizes in 60s range; however with the original version it grows almost
> linearly and doesn't show any signs of plateauing. The difference in slab
> and percpu usage between patched and unpatched versions also grows linearly.
> In 7 days it exceeded 200Mb.
>
> day           0    1    2    3    4    5    6    7
> original     56  362  628  752 1070 1250 1490 1560
> patched      23   46   51   55   60   57   67   69
> mem diff(Mb) 22   74  123  152  164  182  214  241

No objection to the idea, but a question...

In patched kernel, does slabinfo (or similar) show the list reparented
slab caches?  A pile of zombie kmem_caches is certainly better than a
pile of zombie mem_cgroup.  But it still seems like it'll might cause
degradation - does cache_reap() walk an ever growing set of zombie
caches?

We've found it useful to add a slabinfo_full file which includes zombie
kmem_cache with their memcg_name.  This can help hunt down zombies.

> # History
>
> v4:
>   1) removed excessive memcg != parent check in memcg_deactivate_kmem_caches()
>   2) fixed rcu_read_lock() usage in memcg_charge_slab()
>   3) fixed synchronization around dying flag in kmemcg_queue_cache_shutdown()
>   4) refreshed test results data
>   5) reworked PageTail() checks in memcg_from_slab_page()
>   6) added some comments in multiple places
>
> v3:
>   1) reworked memcg kmem_cache search on allocation path
>   2) fixed /proc/kpagecgroup interface
>
> v2:
>   1) switched to percpu kmem_cache refcounter
>   2) a reference to kmem_cache is held during the allocation
>   3) slabs stats are fixed for !MEMCG case (and the refactoring
>      is separated into a standalone patch)
>   4) kmem_cache reparenting is performed from deactivatation context
>
> v1:
>   https://lkml.org/lkml/2019/4/17/1095
>
>
> # Links
>
> [1]: commit 68600f623d69 ("mm: don't miss the last page because of
> round-off error")
> [2]: commit 9b6f7e163cd0 ("mm: rework memcg kernel stack accounting")
> [3]: commit 172b06c32b94 ("mm: slowly shrink slabs with a relatively
> small number of objects")
> [4]: commit a9a238e83fbb ("Revert "mm: slowly shrink slabs
> with a relatively small number of objects")
> [5]: https://lkml.org/lkml/2019/1/28/1865
> [6]: https://marc.info/?l=linux-mm&m=155064763626437&w=2
>
>
> Roman Gushchin (7):
>   mm: postpone kmem_cache memcg pointer initialization to
>     memcg_link_cache()
>   mm: generalize postponed non-root kmem_cache deactivation
>   mm: introduce __memcg_kmem_uncharge_memcg()
>   mm: unify SLAB and SLUB page accounting
>   mm: rework non-root kmem_cache lifecycle management
>   mm: reparent slab memory on cgroup removal
>   mm: fix /proc/kpagecgroup interface for slab pages
>
>  include/linux/memcontrol.h |  10 +++
>  include/linux/slab.h       |  13 +--
>  mm/memcontrol.c            | 101 ++++++++++++++++-------
>  mm/slab.c                  |  25 ++----
>  mm/slab.h                  | 137 ++++++++++++++++++++++++-------
>  mm/slab_common.c           | 162 +++++++++++++++++++++----------------
>  mm/slub.c                  |  36 ++-------
>  7 files changed, 299 insertions(+), 185 deletions(-)
