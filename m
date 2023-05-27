From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: remove unused mem_cgroup_from_obj()
Date: Fri, 26 May 2023 20:55:22 -0700
Message-ID: <CAJD7tkZhUB9N6R-1mWAPGV=awEO0Y0cmi9OmGiVhjSfdFBCirQ@mail.gmail.com>
References: <20230527103126.398267-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685159759; x=1687751759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIU3ApG2t6G3Om8A3cojlnR0RAZfWHqg0wkrw6J9EhQ=;
        b=7anKzrx54MpIV/vXgrNEGJ+XZ3nR4S6+xWVOb3/Tt5YzVkbt7WPWY4f/AUP5W2UVr9
         K530DnGhnTIFcYiYmBbo+tPqqc0Ukj9QD1CkrX7XYrabbntH5JpVHcroD+SlRHKtx3Rc
         kY9L1c3K7NoOo4hOq0VERwTXnGOaLU2O0SqU/NyahwGPOOUbS5EUDCZArHOouWnL9tEg
         LeojmsUC/tR7MDeCs6MFcte8HBoOGbF4eHruYHv8bCvGelALDHxcGpq7H+s6hSYEOfkY
         E9QwDQeUZPLWNJY8DCUHU9Ztj6DnJmr57JCEklUa3J76GNHAbm8Up0Y+fc+yiJ39usxW
         MKHg==
In-Reply-To: <20230527103126.398267-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 26, 2023 at 7:40=E2=80=AFPM Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> w=
rote:
>
> The function mem_cgroup_from_obj() is not used anymore. Remove it and
> clean up relevant comments.
>
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/memcontrol.h |  6 ------
>  mm/memcontrol.c            | 31 -------------------------------
>  2 files changed, 37 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 00a88cf947e1..ce8c2355ed9f 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1813,7 +1813,6 @@ static inline int memcg_kmem_id(struct mem_cgroup *=
memcg)
>         return memcg ? memcg->kmemcg_id : -1;
>  }
>
> -struct mem_cgroup *mem_cgroup_from_obj(void *p);
>  struct mem_cgroup *mem_cgroup_from_slab_obj(void *p);
>
>  static inline void count_objcg_event(struct obj_cgroup *objcg,
> @@ -1876,11 +1875,6 @@ static inline int memcg_kmem_id(struct mem_cgroup =
*memcg)
>         return -1;
>  }
>
> -static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
> -{
> -       return NULL;
> -}
> -
>  static inline struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
>  {
>         return NULL;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6a3d4ce87b8a..532b29c9a0fe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2972,37 +2972,6 @@ struct mem_cgroup *mem_cgroup_from_obj_folio(struc=
t folio *folio, void *p)
>  /*
>   * Returns a pointer to the memory cgroup to which the kernel object is =
charged.
>   *
> - * A passed kernel object can be a slab object, vmalloc object or a gene=
ric
> - * kernel page, so different mechanisms for getting the memory cgroup po=
inter
> - * should be used.
> - *
> - * In certain cases (e.g. kernel stacks or large kmallocs with SLUB) the=
 caller
> - * can not know for sure how the kernel object is implemented.
> - * mem_cgroup_from_obj() can be safely used in such cases.
> - *
> - * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lo=
ck(),
> - * cgroup_mutex, etc.
> - */
> -struct mem_cgroup *mem_cgroup_from_obj(void *p)
> -{
> -       struct folio *folio;
> -
> -       if (mem_cgroup_disabled())
> -               return NULL;
> -
> -       if (unlikely(is_vmalloc_addr(p)))
> -               folio =3D page_folio(vmalloc_to_page(p));
> -       else
> -               folio =3D virt_to_folio(p);
> -
> -       return mem_cgroup_from_obj_folio(folio, p);
> -}
> -
> -/*
> - * Returns a pointer to the memory cgroup to which the kernel object is =
charged.
> - * Similar to mem_cgroup_from_obj(), but faster and not suitable for obj=
ects,
> - * allocated using vmalloc().

Perhaps keep the line about not being suitable for objects allocated
using vmalloc()? To be fair it's obvious from the function name, but I
am guessing whoever added it did for a reason.

I don't feel strongly either way, LGTM. I can't see any references in
Linus's tree or mm-unstable.

Reviewed-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


> - *
>   * A passed kernel object must be a slab object or a generic kernel page=
.
>   *
>   * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lo=
ck(),
> --
> 2.27.0
>
