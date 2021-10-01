From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm, memcg: Ensure valid memcg from objcg within a RCU
 critical section
Date: Fri, 1 Oct 2021 13:24:01 -0700
Message-ID: <CALvZod42VDSMy4E47snF-8yToSkt7no1h=KnYmQnH2dz2CDPLQ@mail.gmail.com>
References: <20211001190938.14050-1-longman@redhat.com> <20211001190938.14050-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WrYh61lOh+sxhsAAWd+QrLGaxeWWjn0UIN5WqeIFSDE=;
        b=CIdjNlyXFPPFBGpyYYj0DJwCz0IqLNKsi1GKRN6Upp9HWbEU9CjtboL96tj37LHbg6
         04qOPPQBhN0GrMgwsRABS91/Ds0j1+EBLQFi8dWQc880qQJXulAs6MfN89TKXKtCCr0P
         Sh84UDgjYPFJpIN1kiUOAXLBW5APRRFe5PspYZKdFcqqOL+QOk+yfDr9OzTHlG9HUc/x
         0TQ1zikI6RkxTDPqsyeyjcylOVDtET4Qd3WcHG08eTkizI7m4WWU57tk/xcxPnxbYToZ
         +2F38b4U13y/e2aBExzOVi/t8RpeoNqPHYG54th4nKn/4khpD3PmVcfmEQKHyL53r7+h
         p51A==
In-Reply-To: <20211001190938.14050-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Fri, Oct 1, 2021 at 12:10 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> To ensure that a to-be-offlined memcg fetched from objcg remains
> valid (has non-zero reference count) within a RCU critical section,
> a synchronize_rcu() call is inserted at the end of memcg_offline_kmem().
>
> With that change, we no longer need to use css_tryget()
> in get_mem_cgroup_from_objcg() as the final css_put() in
> css_killed_work_fn() would not have been called yet.
>
> The obj_cgroup_uncharge_pages() function is simplifed to perform
> the whole uncharge operation within a RCU critical section saving a
> css_get()/css_put() pair.
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8177f253a127..1dbb37d96e49 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2769,10 +2769,8 @@ static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
>         struct mem_cgroup *memcg;
>
>         rcu_read_lock();
> -retry:
>         memcg = obj_cgroup_memcg(objcg);
> -       if (unlikely(!css_tryget(&memcg->css)))
> -               goto retry;
> +       css_get(&memcg->css);
>         rcu_read_unlock();
>
>         return memcg;
> @@ -2947,13 +2945,14 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
>  {
>         struct mem_cgroup *memcg;
>
> -       memcg = get_mem_cgroup_from_objcg(objcg);
> +       rcu_read_lock();
> +       memcg = obj_cgroup_memcg(objcg);
>
>         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>                 page_counter_uncharge(&memcg->kmem, nr_pages);
>         refill_stock(memcg, nr_pages);
>
> -       css_put(&memcg->css);
> +       rcu_read_unlock();
>  }
>
>  /*
> @@ -3672,6 +3671,13 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
>         memcg_drain_all_list_lrus(kmemcg_id, parent);
>
>         memcg_free_cache_id(kmemcg_id);
> +
> +       /*
> +        * To ensure that a to-be-offlined memcg fetched from objcg remains
> +        * valid within a RCU critical section, we need to wait here until
> +        * the a grace period has elapsed.
> +        */
> +       synchronize_rcu();

This is called with cgroup_mutex held from css_offline path and
synchronize_rcu() can be very expensive on a busy system, so, this
will indirectly impact all the code paths which take cgroup_mutex.

>  }
>  #else
>  static int memcg_online_kmem(struct mem_cgroup *memcg)
> --
> 2.18.1
>
