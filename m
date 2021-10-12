From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v3] memcg: enable memory accounting in __alloc_pages_bulk
Date: Tue, 12 Oct 2021 08:19:37 -0700
Message-ID: <CALvZod69v-D-WtwEPNPRTUzt5us0oCOueH-ED-WjmTCfs5qVTA@mail.gmail.com>
References: <0baa2b26-a41b-acab-b75d-72ec241f5151@virtuozzo.com> <60df0efd-f458-a13c-7c89-749bdab21d1d@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fx9uh/yFwWPf1RvBOli1EjuO7bkG9IU/pBATiSWlqFg=;
        b=cYIERjdR5CU0zvc71v6OTruL+l9CA0jtutGtJNcw5rM9NzYLi+qEbTWlx7zJiFwVQu
         fEnrBA8rNpJVoW7q4RjuQO3im36raES3rst2dxsb5yzIEIEhaPuJxlmD1rtweHLiY47E
         KNm7Uw8pkCbNdQLqotnFg5fS0pjqPLvp/BR3eJgCT+vdxiXU34JNakFxh+rTQueP2V2M
         uQq+OwJmWZff2M2HTDJaxk9eE5zuukn9Ayx3iL8IjqrPquUOrvP9RLZKwJBmSQ5K98gY
         L2Vvi61nOZ6bNigRmyg48XKPolU1XsIKM7JtlIaiqMznD8pDtk3VxaflYz4MzIjWAiNX
         qGlg==
In-Reply-To: <60df0efd-f458-a13c-7c89-749bdab21d1d-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue, Oct 12, 2021 at 7:58 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> Enable memory accounting for bulk page allocator.
>
> Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
> v3: added comments,
>     removed call of post charge hook for nr_pages = 0
> v2: modified according to Shakeel Butt's remarks
> ---
>  include/linux/memcontrol.h | 11 +++++++++
>  mm/memcontrol.c            | 48 +++++++++++++++++++++++++++++++++++++-
>  mm/page_alloc.c            | 21 ++++++++++++++++-
>  3 files changed, 78 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 3096c9a0ee01..990acd70c846 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -810,6 +810,12 @@ static inline void obj_cgroup_put(struct obj_cgroup *objcg)
>         percpu_ref_put(&objcg->refcnt);
>  }
>
> +static inline void obj_cgroup_put_many(struct obj_cgroup *objcg,
> +                                      unsigned long nr)
> +{
> +       percpu_ref_put_many(&objcg->refcnt, nr);
> +}
> +
>  static inline void mem_cgroup_put(struct mem_cgroup *memcg)
>  {
>         if (memcg)
> @@ -1746,4 +1752,9 @@ static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
>
>  #endif /* CONFIG_MEMCG_KMEM */
>
> +bool memcg_bulk_pre_charge_hook(struct obj_cgroup **objcgp, gfp_t gfp,
> +                               unsigned int nr_pages);
> +void memcg_bulk_charge_hook(struct obj_cgroup *objcgp, struct page *page);
> +void memcg_bulk_post_charge_hook(struct obj_cgroup *objcg,
> +                                unsigned int nr_pages);
>  #endif /* _LINUX_MEMCONTROL_H */
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 87e41c3cac10..16fe3384c12c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3239,7 +3239,53 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
>         refill_obj_stock(objcg, size, true);
>  }
>
> -#endif /* CONFIG_MEMCG_KMEM */
> +bool memcg_bulk_pre_charge_hook(struct obj_cgroup **objcgp, gfp_t gfp,
> +                               unsigned int nr_pages)
> +{
> +       struct obj_cgroup *objcg = NULL;

No need to explicitly set it to NULL.

> +
> +       if (!memcg_kmem_enabled() || !(gfp & __GFP_ACCOUNT))
> +               return true;
> +
> +       objcg = get_obj_cgroup_from_current();
> +
> +       if (objcg && obj_cgroup_charge_pages(objcg, gfp, nr_pages)) {
> +               obj_cgroup_put(objcg);
> +               return false;
> +       }

get_obj_cgroup_from_current() can return NULL, so you would need to
return true early for that condition.

> +       obj_cgroup_get_many(objcg, nr_pages - 1);
> +       *objcgp = objcg;
> +       return true;
> +}
> +
> +void memcg_bulk_charge_hook(struct obj_cgroup *objcg, struct page *page)
> +{
> +       page->memcg_data = (unsigned long)objcg | MEMCG_DATA_KMEM;
> +}
> +
> +void memcg_bulk_post_charge_hook(struct obj_cgroup *objcg,
> +                                unsigned int nr_pages)
> +{
> +       obj_cgroup_uncharge_pages(objcg, nr_pages);
> +       obj_cgroup_put_many(objcg, nr_pages);
> +}

You can keep the following '#else' code block in the header file.

> +#else /* !CONFIG_MEMCG_KMEM */
> +bool memcg_bulk_pre_charge_hook(struct obj_cgroup **objcgp, gfp_t gfp,
> +                               unsigned int nr_pages)
> +{
> +       return true;
> +}
> +
> +void memcg_bulk_charge_hook(struct obj_cgroup *objcgp, struct page *page)
> +{
> +}
> +
> +void memcg_bulk_post_charge_hook(struct obj_cgroup *objcg,
> +                                unsigned int nr_pages)
> +{
> +}
> +#endif
> +
