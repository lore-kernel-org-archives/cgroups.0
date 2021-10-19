From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v2] memcg, kmem: further deprecate kmem.limit_in_bytes
Date: Tue, 19 Oct 2021 13:51:55 +0800
Message-ID: <CAMZfGtUy5CQR4B1BFE+pEJfvzE2s0MDLJF2sC3cxkvZpahWKWg@mail.gmail.com>
References: <20211019053058.2873615-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hhQEzUyEKyXCEjjzkYdjEsFZ3KqkRdQuV0vIpz0DeEU=;
        b=8GjQYpKjvAO+JbTgbadd4Qpv0oYVQW5dLMGDgEVDqvaHL6WbpvpMzwRNiJHLxAVaXb
         lYxFY59tWmotTsbj3CGvxZ3s6AXrOyvXNkpsfaKIt7hwgO04SCFnoZuarqpRvGaQboj6
         JPtTFD42/O2UOmNCTM8mKs3MTdBpYxvbpiQETy5yMbRT7P3WJtw+nqWWz/RJCNB0tFSD
         8WehQP3Oc/7Pu2mSdAIGRWfKFpIRuRXdu2EklENy1Yhrs3+5Wu5cvZ4nsxZ7/5Rg+q6i
         m9NikMGLce+kWvRCBxXdYDBbe97Wm8ZaE7B2nce10OEn1VMblIWVJuVoTmPUa6F8HBL4
         nipw==
In-Reply-To: <20211019053058.2873615-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

On Tue, Oct 19, 2021 at 1:31 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> The deprecation process of kmem.limit_in_bytes started with the commit
> 0158115f702 ("memcg, kmem: deprecate kmem.limit_in_bytes") which also
> explains in detail the motivation behind the deprecation. To summarize,
> it is the unexpected behavior on hitting the kmem limit. This patch
> moves the deprecation process to the next stage by disallowing to set
> the kmem limit. In future we might just remove the kmem.limit_in_bytes
> file completely.
>
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> ---
> Changes since v1:
> - Replaced EINVAL with ENOTSUPP on setting kmem limits.
> - V1 was posted last year at [0].
>
> [0] https://lore.kernel.org/all/20201118175726.2453120-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
>
>  .../admin-guide/cgroup-v1/memory.rst          |  6 ++--
>  mm/memcontrol.c                               | 35 +++----------------
>  2 files changed, 6 insertions(+), 35 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
> index 41191b5fb69d..9be961521743 100644
> --- a/Documentation/admin-guide/cgroup-v1/memory.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memory.rst
> @@ -87,10 +87,8 @@ Brief summary of control files.
>   memory.oom_control                 set/show oom controls.
>   memory.numa_stat                   show the number of memory usage per numa
>                                      node
> - memory.kmem.limit_in_bytes          set/show hard limit for kernel memory
> -                                     This knob is deprecated and shouldn't be
> -                                     used. It is planned that this be removed in
> -                                     the foreseeable future.
> + memory.kmem.limit_in_bytes          This knob is deprecated and writing to
> +                                     it will return -ENOTSUPP.
>   memory.kmem.usage_in_bytes          show current kernel memory allocation
>   memory.kmem.failcnt                 show the number of kernel memory usage
>                                      hits limits

Since memory.kmem.limit_in_bytes can not be set, how about removing
those instructions as well?

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst
b/Documentation/admin-guide/cgroup-v1/memory.rst
index 41191b5fb69d..f710f36770fa 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -518,11 +518,6 @@ will be charged as a new owner of it.
   charged file caches. Some out-of-use page caches may keep charged until
   memory pressure happens. If you want to avoid that, force_empty
will be useful.
-   Also, note that when memory.kmem.limit_in_bytes is set the charges due to
-   kernel pages will still be seen. This is not considered a failure and the
-   write will still return success. In this case, it is expected that
-   memory.kmem.usage_in_bytes == memory.usage_in_bytes.
-
5.2 stat file
-------------

With this changes,

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8f1d9c028897..49a76049a885 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2999,7 +2999,6 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
>  static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
>                                    unsigned int nr_pages)
>  {
> -       struct page_counter *counter;
>         struct mem_cgroup *memcg;
>         int ret;
>
> @@ -3009,21 +3008,8 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
>         if (ret)
>                 goto out;
>
> -       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
> -           !page_counter_try_charge(&memcg->kmem, nr_pages, &counter)) {
> -
> -               /*
> -                * Enforce __GFP_NOFAIL allocation because callers are not
> -                * prepared to see failures and likely do not have any failure
> -                * handling code.
> -                */
> -               if (gfp & __GFP_NOFAIL) {
> -                       page_counter_charge(&memcg->kmem, nr_pages);
> -                       goto out;
> -               }
> -               cancel_charge(memcg, nr_pages);
> -               ret = -ENOMEM;
> -       }
> +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +               page_counter_charge(&memcg->kmem, nr_pages);
>  out:
>         css_put(&memcg->css);
>
> @@ -3715,17 +3701,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
>  }
>  #endif /* CONFIG_MEMCG_KMEM */
>
> -static int memcg_update_kmem_max(struct mem_cgroup *memcg,
> -                                unsigned long max)
> -{
> -       int ret;
> -
> -       mutex_lock(&memcg_max_mutex);
> -       ret = page_counter_set_max(&memcg->kmem, max);
> -       mutex_unlock(&memcg_max_mutex);
> -       return ret;
> -}
> -
>  static int memcg_update_tcp_max(struct mem_cgroup *memcg, unsigned long max)
>  {
>         int ret;
> @@ -3791,10 +3766,8 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
>                         ret = mem_cgroup_resize_max(memcg, nr_pages, true);
>                         break;
>                 case _KMEM:
> -                       pr_warn_once("kmem.limit_in_bytes is deprecated and will be removed. "
> -                                    "Please report your usecase to linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org if you "
> -                                    "depend on this functionality.\n");
> -                       ret = memcg_update_kmem_max(memcg, nr_pages);
> +                       /* kmem.limit_in_bytes is deprecated. */
> +                       ret = -ENOTSUPP;
>                         break;
>                 case _TCP:
>                         ret = memcg_update_tcp_max(memcg, nr_pages);
> --
> 2.33.0.1079.g6e70778dc9-goog
>
