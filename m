From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [HMM-CDM 3/5] mm/memcontrol: allow to uncharge page without
 using page->lru field
Date: Thu, 15 Jun 2017 13:31:28 +1000
Message-ID: <20170615133128.2fe2c33f@firefly.ozlabs.ibm.com>
References: <20170614201144.9306-1-jglisse@redhat.com>
        <20170614201144.9306-4-jglisse@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e0exmiue7cWbpT75TZAnVn+dFfHtOwqEvsfBxr0Ytgk=;
        b=TdrYsOJf3dIf73737vgTr7z97Bal9wZ94IozX/Ei+yx/9YO11givcW4aDMtuuXmM/W
         avadx3LRQxiMKKEQeLzyxqUE2lFpUtQVSBuP7y2G9xYzU3oxlj0F/MHS3s1Tjnbt2qbk
         rOqMavbQ/Lxaz6icP8CP08eK0fSmq823SWrM6hL+4LR7RrC7nxl8qQ2teqTtkm3uOv4h
         QNtJAymMYu3oSdwLjmeqrLuS6xxVFruhKuTMA+wkqztNxv51avcYJ+LIrr421dwdhn49
         a6vcT3F5jWwt8wk2q/U6jE/qNSmO0bASje0D5/xeUiaPLxmzpAqFsCP8RSi9OQA5F9vC
         AaKw==
In-Reply-To: <20170614201144.9306-4-jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 14 Jun 2017 16:11:42 -0400
J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> HMM pages (private or public device pages) are ZONE_DEVICE page and
> thus you can not use page->lru fields of those pages. This patch
> re-arrange the uncharge to allow single page to be uncharge without
> modifying the lru field of the struct page.
>=20
> There is no change to memcontrol logic, it is the same as it was
> before this patch.
>=20
> Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  mm/memcontrol.c | 168 +++++++++++++++++++++++++++++++-------------------=
------
>  1 file changed, 92 insertions(+), 76 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e3fe4d0..b93f5fe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5509,48 +5509,102 @@ void mem_cgroup_cancel_charge(struct page *page,=
 struct mem_cgroup *memcg,
>  	cancel_charge(memcg, nr_pages);
>  }
> =20
> -static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgo=
ut,
> -			   unsigned long nr_anon, unsigned long nr_file,
> -			   unsigned long nr_kmem, unsigned long nr_huge,
> -			   unsigned long nr_shmem, struct page *dummy_page)
> +struct uncharge_gather {
> +	struct mem_cgroup *memcg;
> +	unsigned long pgpgout;
> +	unsigned long nr_anon;
> +	unsigned long nr_file;
> +	unsigned long nr_kmem;
> +	unsigned long nr_huge;
> +	unsigned long nr_shmem;
> +	struct page *dummy_page;
> +};
> +
> +static inline void uncharge_gather_clear(struct uncharge_gather *ug)
>  {
> -	unsigned long nr_pages =3D nr_anon + nr_file + nr_kmem;
> +	memset(ug, 0, sizeof(*ug));
> +}
> +
> +static void uncharge_batch(const struct uncharge_gather *ug)
> +{

Can we pass page as an argument so that we can do check events on the page?

> +	unsigned long nr_pages =3D ug->nr_anon + ug->nr_file + ug->nr_kmem;
>  	unsigned long flags;
> =20
> -	if (!mem_cgroup_is_root(memcg)) {
> -		page_counter_uncharge(&memcg->memory, nr_pages);
> +	if (!mem_cgroup_is_root(ug->memcg)) {
> +		page_counter_uncharge(&ug->memcg->memory, nr_pages);
>  		if (do_memsw_account())
> -			page_counter_uncharge(&memcg->memsw, nr_pages);
> -		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && nr_kmem)
> -			page_counter_uncharge(&memcg->kmem, nr_kmem);
> -		memcg_oom_recover(memcg);
> +			page_counter_uncharge(&ug->memcg->memsw, nr_pages);
> +		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && ug->nr_kmem)
> +			page_counter_uncharge(&ug->memcg->kmem, ug->nr_kmem);
> +		memcg_oom_recover(ug->memcg);
>  	}
> =20
>  	local_irq_save(flags);
> -	__this_cpu_sub(memcg->stat->count[MEMCG_RSS], nr_anon);
> -	__this_cpu_sub(memcg->stat->count[MEMCG_CACHE], nr_file);
> -	__this_cpu_sub(memcg->stat->count[MEMCG_RSS_HUGE], nr_huge);
> -	__this_cpu_sub(memcg->stat->count[NR_SHMEM], nr_shmem);
> -	__this_cpu_add(memcg->stat->events[PGPGOUT], pgpgout);
> -	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
> -	memcg_check_events(memcg, dummy_page);
> +	__this_cpu_sub(ug->memcg->stat->count[MEMCG_RSS], ug->nr_anon);
> +	__this_cpu_sub(ug->memcg->stat->count[MEMCG_CACHE], ug->nr_file);
> +	__this_cpu_sub(ug->memcg->stat->count[MEMCG_RSS_HUGE], ug->nr_huge);
> +	__this_cpu_sub(ug->memcg->stat->count[NR_SHMEM], ug->nr_shmem);
> +	__this_cpu_add(ug->memcg->stat->events[PGPGOUT], ug->pgpgout);
> +	__this_cpu_add(ug->memcg->stat->nr_page_events, nr_pages);
> +	memcg_check_events(ug->memcg, ug->dummy_page);
>  	local_irq_restore(flags);
> =20
> -	if (!mem_cgroup_is_root(memcg))
> -		css_put_many(&memcg->css, nr_pages);
> +	if (!mem_cgroup_is_root(ug->memcg))
> +		css_put_many(&ug->memcg->css, nr_pages);
> +}
> +
> +static void uncharge_page(struct page *page, struct uncharge_gather *ug)
> +{
> +	VM_BUG_ON_PAGE(PageLRU(page), page);
> +	VM_BUG_ON_PAGE(!PageHWPoison(page) && page_count(page), page);
> +
> +	if (!page->mem_cgroup)
> +		return;
> +
> +	/*
> +	 * Nobody should be changing or seriously looking at
> +	 * page->mem_cgroup at this point, we have fully
> +	 * exclusive access to the page.
> +	 */
> +
> +	if (ug->memcg !=3D page->mem_cgroup) {
> +		if (ug->memcg) {
> +			uncharge_batch(ug);

What is ug->dummy_page set to at this point? ug->dummy_page is assigned bel=
ow

> +			uncharge_gather_clear(ug);
> +		}
> +		ug->memcg =3D page->mem_cgroup;
> +	}
> +
> +	if (!PageKmemcg(page)) {
> +		unsigned int nr_pages =3D 1;
> +
> +		if (PageTransHuge(page)) {
> +			nr_pages <<=3D compound_order(page);
> +			ug->nr_huge +=3D nr_pages;
> +		}
> +		if (PageAnon(page))
> +			ug->nr_anon +=3D nr_pages;
> +		else {
> +			ug->nr_file +=3D nr_pages;
> +			if (PageSwapBacked(page))
> +				ug->nr_shmem +=3D nr_pages;
> +		}
> +		ug->pgpgout++;
> +	} else {
> +		ug->nr_kmem +=3D 1 << compound_order(page);
> +		__ClearPageKmemcg(page);
> +	}
> +
> +	ug->dummy_page =3D page;
> +	page->mem_cgroup =3D NULL;
>  }
> =20
>  static void uncharge_list(struct list_head *page_list)
>  {
> -	struct mem_cgroup *memcg =3D NULL;
> -	unsigned long nr_shmem =3D 0;
> -	unsigned long nr_anon =3D 0;
> -	unsigned long nr_file =3D 0;
> -	unsigned long nr_huge =3D 0;
> -	unsigned long nr_kmem =3D 0;
> -	unsigned long pgpgout =3D 0;
> +	struct uncharge_gather ug;
>  	struct list_head *next;
> -	struct page *page;
> +
> +	uncharge_gather_clear(&ug);
> =20
>  	/*
>  	 * Note that the list can be a single page->lru; hence the
> @@ -5558,57 +5612,16 @@ static void uncharge_list(struct list_head *page_=
list)
>  	 */
>  	next =3D page_list->next;
>  	do {
> +		struct page *page;
> +

Nit pick

VM_WARN_ON(is_zone_device_page(page));

>  		page =3D list_entry(next, struct page, lru);
>  		next =3D page->lru.next;
> =20
> -		VM_BUG_ON_PAGE(PageLRU(page), page);
> -		VM_BUG_ON_PAGE(!PageHWPoison(page) && page_count(page), page);
> -
> -		if (!page->mem_cgroup)
> -			continue;
> -
> -		/*
> -		 * Nobody should be changing or seriously looking at
> -		 * page->mem_cgroup at this point, we have fully
> -		 * exclusive access to the page.
> -		 */
> -
> -		if (memcg !=3D page->mem_cgroup) {
> -			if (memcg) {
> -				uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
> -					       nr_kmem, nr_huge, nr_shmem, page);
> -				pgpgout =3D nr_anon =3D nr_file =3D nr_kmem =3D 0;
> -				nr_huge =3D nr_shmem =3D 0;
> -			}
> -			memcg =3D page->mem_cgroup;
> -		}
> -
> -		if (!PageKmemcg(page)) {
> -			unsigned int nr_pages =3D 1;
> -
> -			if (PageTransHuge(page)) {
> -				nr_pages <<=3D compound_order(page);
> -				nr_huge +=3D nr_pages;
> -			}
> -			if (PageAnon(page))
> -				nr_anon +=3D nr_pages;
> -			else {
> -				nr_file +=3D nr_pages;
> -				if (PageSwapBacked(page))
> -					nr_shmem +=3D nr_pages;
> -			}
> -			pgpgout++;
> -		} else {
> -			nr_kmem +=3D 1 << compound_order(page);
> -			__ClearPageKmemcg(page);
> -		}
> -
> -		page->mem_cgroup =3D NULL;
> +		uncharge_page(page, &ug);
>  	} while (next !=3D page_list);
> =20
> -	if (memcg)
> -		uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
> -			       nr_kmem, nr_huge, nr_shmem, page);
> +	if (ug.memcg)
> +		uncharge_batch(&ug);
>  }
> =20
>  /**
> @@ -5620,6 +5633,8 @@ static void uncharge_list(struct list_head *page_li=
st)
>   */
>  void mem_cgroup_uncharge(struct page *page)
>  {
> +	struct uncharge_gather ug;
> +
>  	if (mem_cgroup_disabled())
>  		return;
> =20
> @@ -5627,8 +5642,9 @@ void mem_cgroup_uncharge(struct page *page)
>  	if (!page->mem_cgroup)
>  		return;
> =20
> -	INIT_LIST_HEAD(&page->lru);
> -	uncharge_list(&page->lru);
> +	uncharge_gather_clear(&ug);
> +	uncharge_page(page, &ug);
> +	uncharge_batch(&ug);
>  }


Balbir Singh.
