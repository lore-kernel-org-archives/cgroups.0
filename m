From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] [PATCH v4 5/5] mm/memcg: Improve refill_obj_stock() performance
Date: Mon, 19 Apr 2021 14:06:30 +0800
Message-ID: <CAMZfGtWX-Gik3i9_wmipuQZf0c-O-Yo_ejJYoN6-sf25vMLfog@mail.gmail.com>
References: <20210419000032.5432-1-longman@redhat.com> <20210419000032.5432-6-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I/pTwkQPxJMQ6l4p78nod3nlL4rUQvx1xoHYKzDAsFA=;
        b=f/9cvpFcKS+WzsdiHb4rmMOFg+au1XzMQsLcR+o+IU6et+sCJSDFqPkf4UWHQTocgK
         EwsvtFzxqSH3X4Rw50ZP+rgTvjC66EZQLWLPkHVdGH6twi1uaJs9Sa9RkH8ivcoPAdfO
         rGrgu0ShYa+/cLy3Yx0rm8RBR1BJ/8yTy4dt80OjVRULhRd+aU4lZFl99cPOoSj8iMbT
         GlNOqPSjOdoeEM4l20Eu3948/No0AM01fpPvlxHIQhsqezo4rF4IV6vHoywnqQVlgo5b
         OT8/q0ChJvd6Oi4rs0BuFiUdEnPrREzhu1Q+gp6bfmhc4osxeOkCDLM9lhHQHF8+OkAw
         b4mw==
In-Reply-To: <20210419000032.5432-6-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing

On Mon, Apr 19, 2021 at 8:01 AM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> There are two issues with the current refill_obj_stock() code. First of
> all, when nr_bytes reaches over PAGE_SIZE, it calls drain_obj_stock() to
> atomically flush out remaining bytes to obj_cgroup, clear cached_objcg
> and do a obj_cgroup_put(). It is likely that the same obj_cgroup will
> be used again which leads to another call to drain_obj_stock() and
> obj_cgroup_get() as well as atomically retrieve the available byte from
> obj_cgroup. That is costly. Instead, we should just uncharge the excess
> pages, reduce the stock bytes and be done with it. The drain_obj_stock()
> function should only be called when obj_cgroup changes.
>
> Secondly, when charging an object of size not less than a page in
> obj_cgroup_charge(), it is possible that the remaining bytes to be
> refilled to the stock will overflow a page and cause refill_obj_stock()
> to uncharge 1 page. To avoid the additional uncharge in this case,
> a new overfill flag is added to refill_obj_stock() which will be set
> when called from obj_cgroup_charge().
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a6dd18f6d8a8..d13961352eef 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3357,23 +3357,34 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>         return false;
>  }
>
> -static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
> +static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
> +                            bool overfill)
>  {
>         unsigned long flags;
>         struct obj_stock *stock = get_obj_stock(&flags);
> +       unsigned int nr_pages = 0;
>
>         if (stock->cached_objcg != objcg) { /* reset if necessary */
> -               drain_obj_stock(stock);
> +               if (stock->cached_objcg)
> +                       drain_obj_stock(stock);
>                 obj_cgroup_get(objcg);
>                 stock->cached_objcg = objcg;
>                 stock->nr_bytes = atomic_xchg(&objcg->nr_charged_bytes, 0);
>         }
>         stock->nr_bytes += nr_bytes;
>
> -       if (stock->nr_bytes > PAGE_SIZE)
> -               drain_obj_stock(stock);
> +       if (!overfill && (stock->nr_bytes > PAGE_SIZE)) {
> +               nr_pages = stock->nr_bytes >> PAGE_SHIFT;
> +               stock->nr_bytes &= (PAGE_SIZE - 1);
> +       }
>
>         put_obj_stock(flags);
> +
> +       if (nr_pages) {
> +               rcu_read_lock();
> +               __memcg_kmem_uncharge(obj_cgroup_memcg(objcg), nr_pages);
> +               rcu_read_unlock();
> +       }

It is not safe to call __memcg_kmem_uncharge() under rcu lock
and without holding a reference to memcg. More details can refer
to the following link.

https://lore.kernel.org/linux-mm/20210319163821.20704-2-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/

In the above patchset, we introduce obj_cgroup_uncharge_pages to
uncharge some pages from object cgroup. You can use this safe
API.

Thanks.

>  }
>
>  int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
> @@ -3410,7 +3421,7 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
>
>         ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
>         if (!ret && nr_bytes)
> -               refill_obj_stock(objcg, PAGE_SIZE - nr_bytes);
> +               refill_obj_stock(objcg, PAGE_SIZE - nr_bytes, true);
>
>         css_put(&memcg->css);
>         return ret;
> @@ -3418,7 +3429,7 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
>
>  void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
>  {
> -       refill_obj_stock(objcg, size);
> +       refill_obj_stock(objcg, size, false);
>  }
>
>  #endif /* CONFIG_MEMCG_KMEM */
> --
> 2.18.1
>
