From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: optimize per-lruvec stats counter
 memory usage
Date: Tue, 8 Dec 2020 10:20:23 -0800
Message-ID: <CALvZod7Zt3v-g5gZYUST7_snXPoUijDzPkBT-Kf-ncxpE4W7ng@mail.gmail.com>
References: <20201208095132.79383-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KtsL6yyTsdRfL58pMrd/cVVqUWZ3Qpi4P1xbGQ497SA=;
        b=VfSb6i7CO6ruLDo2yDHAEhRj3tkB7pO3suizcEQKb0xPFlkwllIbDZyW7RhQ2aHIXL
         FqhSKoj+RwzE27HoBNjxdTU1dOo/wAQj7siOo+Y/ntWjoy6QLYQKBWOeNygpzbQteutN
         fZEnylSc/DaG6VqYLY/J9G8QyAnXOutvRYZc+CKHbPktW/vRLVM7V8LzwdHzH17j8FZy
         +xpZeE6qCWRnmjpkjPsgi3YvVLcG3w0mUm7KYzQJ7juXJWwfXBnPatgmtyNVQkUI0iTs
         ToO+3bSGVHkKXYjceu0ANnh30hjqfInU2RExCqJh4nSu3wGSyut5MmtTujBveXeXzIoj
         rh+Q==
In-Reply-To: <20201208095132.79383-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Dec 8, 2020 at 1:53 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> The vmstat threshold is 32 (MEMCG_CHARGE_BATCH), so the type of s32
> of lruvec_stat_cpu is enough. And introduce struct per_cpu_lruvec_stat
> to optimize memory usage.
>
> The size of struct lruvec_stat is 304 bytes on 64 bits system. As it
> is a per-cpu structure. So with this patch, we can save 304 / 2 * ncpu
> bytes per-memcg per-node where ncpu is the number of the possible CPU.
> If there are c memory cgroup (include dying cgroup) and n NUMA node in
> the system. Finally, we can save (152 * ncpu * c * n) bytes.
>
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Few nits below:

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
> Changes in v1 -> v2:
>  - Update the commit log to point out how many bytes that we can save.
>
>  include/linux/memcontrol.h |  6 +++++-
>  mm/memcontrol.c            | 10 +++++++++-
>  2 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 3febf64d1b80..290d6ec8535a 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -92,6 +92,10 @@ struct lruvec_stat {
>         long count[NR_VM_NODE_STAT_ITEMS];
>  };
>
> +struct per_cpu_lruvec_stat {

lruvec_stat is also per-cpu, so the name per_cpu_lruvec_stat does not
really tell why it is different from lruvec. Maybe name is
batched_lruvec_stat or something else.

> +       s32 count[NR_VM_NODE_STAT_ITEMS];
> +};
> +
>  /*
>   * Bitmap of shrinker::id corresponding to memcg-aware shrinkers,
>   * which have elements charged to this memcg.
> @@ -111,7 +115,7 @@ struct mem_cgroup_per_node {
>         struct lruvec_stat __percpu *lruvec_stat_local;

A comment for the above why it still needs to be lruvec_stat.

>
>         /* Subtree VM stats (batched updates) */
> -       struct lruvec_stat __percpu *lruvec_stat_cpu;
> +       struct per_cpu_lruvec_stat __percpu *lruvec_stat_cpu;
>         atomic_long_t           lruvec_stat[NR_VM_NODE_STAT_ITEMS];
>
>         unsigned long           lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index eec44918d373..da6dc6ca388d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5198,7 +5198,7 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
>                 return 1;
>         }
>
> -       pn->lruvec_stat_cpu = alloc_percpu_gfp(struct lruvec_stat,
> +       pn->lruvec_stat_cpu = alloc_percpu_gfp(struct per_cpu_lruvec_stat,
>                                                GFP_KERNEL_ACCOUNT);
>         if (!pn->lruvec_stat_cpu) {
>                 free_percpu(pn->lruvec_stat_local);
> @@ -7089,6 +7089,14 @@ static int __init mem_cgroup_init(void)
>  {
>         int cpu, node;
>
> +       /*
> +        * Currently s32 type (can refer to struct per_cpu_lruvec_stat) is
> +        * used for per-memcg-per-cpu caching of per-node statistics. In order
> +        * to work fine, we should make sure that the overfill threshold can't
> +        * exceed S32_MAX / PAGE_SIZE.
> +        */
> +       BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S32_MAX / PAGE_SIZE);
> +
>         cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
>                                   memcg_hotplug_cpu_dead);
>
> --
> 2.11.0
>
