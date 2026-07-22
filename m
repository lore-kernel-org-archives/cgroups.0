Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D95C355F49
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 14:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784731147; cv=none; b=TuzWh0su71GtOgjaM1iv/aS7nYeqHTbp64nI91JQ9zUw9d+3fq7+vKXDlRdiqiRKxkmskFhoLZzLiHTlgf4eLNEo/uaFY1SqpaJBSUTTUxJiEi7KDXVujUD+43tPevUi1+CPnQA1//4Y+YtZH34xJCzugN/CKwI6Zm982ycv0r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784731147; c=relaxed/simple;
	bh=8aOgLn46DVa4Y157P1gYH41efpVpSrdx03UoQnyu+q0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WmprTOUkrphFxydite9WYUpiWW7CDTDAPuusSl7zZRAYt+Z50Su7YQJPEOMF5l/qofCWqA+rLnIYphsJjJ58FeGQYUzk5R/ehV4F4F8y3P9OodvnfXTB4CElZ5TzJ/tTsKCL4D4fhJkNE3M7Fxu+hnQUgbDsRDP3DJct0QP6x1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mlBhTxfR; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mlBhTxfR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784731145; x=1816267145;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=8aOgLn46DVa4Y157P1gYH41efpVpSrdx03UoQnyu+q0=;
  b=mlBhTxfRSy26AIG7Xg/bPzn4wBgpPPt4hVeyVF1Eu9J38ouNHj1u108V
   k94ci7Q6V8xB1l4YbkREEENtEtPFO0efpAlMzgVHbPcBlfBsIWUvDIVkB
   HL7nCgxjAGFNk2ePjCtPpzPwMMyiupUQUTEAUX9DdEpTZWZAU1/fig5c0
   x35JNtiXQDHeW19ElC2E16zr5DJd+FdJUqbd50hyzHyDwMrbhHpszS3cR
   SDWDhDgUsOP3t1p4yKJXqteLU7bwP3JgGcakydKOpSi2I/KlrE9RqP8Ge
   M5ui7/1S19mW4mm5coVuxDwmo0TxUYTFe+6bhNIG9BZvzT6v8Szue+lyc
   w==;
X-CSE-ConnectionGUID: k3c2yfcCSOm4xyKCMOZYLA==
X-CSE-MsgGUID: YuU5iz+BQW2q+HCwFWi4CA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="89044779"
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="89044779"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 07:39:05 -0700
X-CSE-ConnectionGUID: fvKJnEMoTQKw1v7dYrSong==
X-CSE-MsgGUID: +QNYQxmoS9iVVBJY7611+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="258781172"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.245.180]) ([10.245.245.180])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 07:39:01 -0700
Message-ID: <7fdc1aa1d8c605a642a9b283ca60ec062842f139.camel@linux.intel.com>
Subject: Re: [PATCH 01/10] memcg: add support for GPU page counters. (v5)
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org, 
	tj@kernel.org, christian.koenig@amd.com, Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt	 <shakeel.butt@linux.dev>, Muchun
 Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>,
 simona@ffwll.ch, 	intel-xe@lists.freedesktop.org
Date: Wed, 22 Jul 2026 16:38:58 +0200
In-Reply-To: <20260706052330.1110909-2-airlied@gmail.com>
References: <20260706052330.1110909-1-airlied@gmail.com>
	 <20260706052330.1110909-2-airlied@gmail.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-07-06 at 15:22 +1000, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
>=20
> This introduces 2 new statistics and 3 new memcontrol APIs for
> dealing
> with GPU system memory allocations.
>=20
> The stats corresponds to the same stats in the global vmstat,
> for number of active GPU pages, and number of pages in pools that
> can be reclaimed.
>=20
> The first API charges a order of pages to a objcg, and sets
> the objcg on the pages like kmem does, and updates the active/reclaim
> statistic.
>=20
> The second API uncharges a page from the obj cgroup it is currently
> charged
> to.
>=20
> The third API allows moving a page to/from reclaim and between obj
> cgroups.
> When pages are added to the pool lru, this just updates accounting.
> When pages are being removed from a pool lru, they can be taken from
> the parent objcg so this allows them to be uncharged from there and
> transferred
> to a new child objcg.
>=20
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
> v2: use memcg_node_stat_items
> v3: fix null ptr dereference in uncharge
> v4: AI review: fix parameter names, fix problem with reclaim moving
> doing wrong thing
> v5: fix the build with CONFIG_MEMCG=3Dn
> ---
> =C2=A0Documentation/admin-guide/cgroup-v2.rst |=C2=A0=C2=A0 6 ++
> =C2=A0include/linux/memcontrol.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 34 ++++++++
> =C2=A0mm/memcontrol.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 104
> ++++++++++++++++++++++++
> =C2=A03 files changed, 144 insertions(+)

Looks like there are a couple of sashiko issues remaining for this
patch:

https://sashiko.dev/#/message/20260706052330.1110909-2-airlied%40gmail.com

>=20
> diff --git a/Documentation/admin-guide/cgroup-v2.rst
> b/Documentation/admin-guide/cgroup-v2.rst
> index 993446ab66d0..aa4f503770c5 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1573,6 +1573,12 @@ The following nested keys are defined.
> =C2=A0	=C2=A0 vmalloc (npn)
> =C2=A0		Amount of memory used for vmap backed memory.
> =C2=A0
> +	=C2=A0 gpu_active (npn)
> +		Amount of system memory used for GPU devices.
> +
> +	=C2=A0 gpu_reclaim (npn)
> +		Amount of system memory cached for GPU devices.
> +
> =C2=A0	=C2=A0 shmem
> =C2=A0		Amount of cached filesystem data that is swap-
> backed,
> =C2=A0		such as tmpfs, shm segments, shared anonymous
> mmap()s
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e1f46a0016fc..9d057f58c9d0 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1583,6 +1583,7 @@ static inline void
> mem_cgroup_flush_foreign(struct bdi_writeback *wb)
> =C2=A0#endif	/* CONFIG_CGROUP_WRITEBACK */
> =C2=A0
> =C2=A0struct sock;
> +

Unrelated


> =C2=A0#ifdef CONFIG_MEMCG
> =C2=A0extern struct static_key_false memcg_sockets_enabled_key;
> =C2=A0#define mem_cgroup_sockets_enabled
> static_branch_unlikely(&memcg_sockets_enabled_key)
> @@ -1629,6 +1630,17 @@ static inline u64
> mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
> =C2=A0}
> =C2=A0#endif
> =C2=A0
> +bool mem_cgroup_charge_gpu_page(struct obj_cgroup *objcg, struct
> page *page,
> +			=C2=A0=C2=A0 unsigned int order,
> +			=C2=A0=C2=A0 gfp_t gfp_mask, bool reclaim);
> +void mem_cgroup_uncharge_gpu_page(struct page *page,
> +				=C2=A0 unsigned int order,
> +				=C2=A0 bool reclaim);
> +bool mem_cgroup_move_gpu_page_reclaim(struct obj_cgroup *objcg,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int order,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool to_reclaim);
> +
> =C2=A0int alloc_shrinker_info(struct mem_cgroup *memcg);
> =C2=A0void free_shrinker_info(struct mem_cgroup *memcg);
> =C2=A0void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int
> shrinker_id);
> @@ -1665,6 +1677,28 @@ static inline void
> mem_cgroup_sk_uncharge(const struct sock *sk,
> =C2=A0{
> =C2=A0}
> =C2=A0
> +static inline bool mem_cgroup_charge_gpu_page(struct obj_cgroup
> *objcg,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int order,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gfp_t gfp_mask, bool
> reclaim)
> +{
> +	return true;
> +}
> +
> +static inline void mem_cgroup_uncharge_gpu_page(struct page *page,
> +						unsigned int order,
> +						bool reclaim)
> +{
> +}
> +
> +static inline bool mem_cgroup_move_gpu_page_reclaim(struct
> obj_cgroup *objcg,
> +						=C2=A0=C2=A0=C2=A0 struct page
> *page,
> +						=C2=A0=C2=A0=C2=A0 unsigned int
> order,
> +						=C2=A0=C2=A0=C2=A0 bool to_reclaim)
> +{
> +	return true;
> +}
> +
> =C2=A0static inline void set_shrinker_bit(struct mem_cgroup *memcg,
> =C2=A0				=C2=A0=C2=A0=C2=A0 int nid, int shrinker_id)
> =C2=A0{
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..4c682b91cbbe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -423,6 +423,8 @@ static const unsigned int memcg_node_stat_items[]
> =3D {
> =C2=A0#ifdef CONFIG_HUGETLB_PAGE
> =C2=A0	NR_HUGETLB,
> =C2=A0#endif
> +	NR_GPU_ACTIVE,
> +	NR_GPU_RECLAIM,
> =C2=A0};
> =C2=A0
> =C2=A0static const unsigned int memcg_stat_items[] =3D {
> @@ -1553,6 +1555,8 @@ static const struct memory_stat memory_stats[]
> =3D {
> =C2=A0	{
> "percpu",			MEMCG_PERCPU_B			},
> =C2=A0	{
> "sock",			MEMCG_SOCK			},
> =C2=A0	{
> "vmalloc",			NR_VMALLOC			},
> +	{
> "gpu_active",			NR_GPU_ACTIVE			},
> +	{
> "gpu_reclaim",		NR_GPU_RECLAIM	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },
> =C2=A0	{
> "shmem",			NR_SHMEM			},
> =C2=A0#ifdef CONFIG_ZSWAP
> =C2=A0	{
> "zswap",			MEMCG_ZSWAP_B			},
> @@ -5508,6 +5512,106 @@ void mem_cgroup_flush_workqueue(void)
> =C2=A0	flush_workqueue(memcg_wq);
> =C2=A0}
> =C2=A0
> +/**
> + * mem_cgroup_charge_gpu_page - charge a page to GPU memory tracking
Nit: Patch guidelines call for ()

> + * @objcg: objcg to charge, NULL charges root memcg
> + * @page: page to charge
> + * @order: page allocation order
> + * @gfp_mask: gfp mode
> + * @reclaim: charge the reclaim counter instead of the active one.

Return:

>=20
> + *
> + * Charge the order sized @page to the objcg. Returns %true if the
> charge fit within
> + * @objcg's configured limit, %false if it doesn't.
> + */
> +bool mem_cgroup_charge_gpu_page(struct obj_cgroup *objcg, struct
> page *page,
> +				unsigned int order, gfp_t gfp_mask,
> bool reclaim)
> +{
> +	unsigned int nr_pages =3D 1 << order;
> +	struct mem_cgroup *memcg =3D NULL;
> +	struct lruvec *lruvec;
> +	int ret;
> +
> +	if (objcg) {
> +		memcg =3D get_mem_cgroup_from_objcg(objcg);
> +
> +		ret =3D try_charge_memcg(memcg, gfp_mask, nr_pages);
> +		if (ret) {
> +			mem_cgroup_put(memcg);
> +			return false;
> +		}
> +
> +		obj_cgroup_get(objcg);
> +		page_set_objcg(page, objcg);
> +	}
> +
> +	lruvec =3D mem_cgroup_lruvec(memcg, page_pgdat(page));
> +	mod_lruvec_state(lruvec, reclaim ? NR_GPU_RECLAIM :
> NR_GPU_ACTIVE, nr_pages);
> +
> +	mem_cgroup_put(memcg);
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(mem_cgroup_charge_gpu_page);
> +
> +/**
> + * mem_cgroup_uncharge_gpu_page - uncharge a page from GPU memory
> tracking
> + * @page: page to uncharge
> + * @order: order of the page allocation
> + * @reclaim: uncharge the reclaim counter instead of the active.
> + */
> +void mem_cgroup_uncharge_gpu_page(struct page *page,
> +				=C2=A0 unsigned int order, bool reclaim)
> +{
> +	struct obj_cgroup *objcg =3D page_objcg(page);
> +	struct mem_cgroup *memcg;
> +	struct lruvec *lruvec;
> +	int nr_pages =3D 1 << order;
> +
> +	memcg =3D objcg ? get_mem_cgroup_from_objcg(objcg) : NULL;
> +
> +	lruvec =3D mem_cgroup_lruvec(memcg, page_pgdat(page));
> +	mod_lruvec_state(lruvec, reclaim ? NR_GPU_RECLAIM :
> NR_GPU_ACTIVE, -nr_pages);
> +
> +	if (memcg && !mem_cgroup_is_root(memcg))
> +		refill_stock(memcg, nr_pages);
> +	page->memcg_data =3D 0;
> +	obj_cgroup_put(objcg);
> +	mem_cgroup_put(memcg);
> +}
> +EXPORT_SYMBOL_GPL(mem_cgroup_uncharge_gpu_page);
> +
> +/**
> + * mem_cgroup_move_gpu_reclaim - move pages from gpu to gpu reclaim
> and back
> + * @new_objcg: objcg to move page to, NULL if just stats update.
> + * @nr_pages: number of pages to move
> + * @to_reclaim: true moves pages into reclaim, false moves them back

Return:

> + */
> +bool mem_cgroup_move_gpu_page_reclaim(struct obj_cgroup *new_objcg,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int order,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool to_reclaim)
> +{
> +	struct obj_cgroup *objcg =3D page_objcg(page);
> +
> +	if (!objcg || !new_objcg || objcg =3D=3D new_objcg) {
> +		struct mem_cgroup *memcg =3D objcg ?
> get_mem_cgroup_from_objcg(objcg) : NULL;
> +		struct lruvec *lruvec;
> +		unsigned long flags;
> +		int nr_pages =3D 1 << order;
> +
> +		lruvec =3D mem_cgroup_lruvec(memcg, page_pgdat(page));
> +		local_irq_save(flags);
> +		mod_lruvec_state(lruvec, to_reclaim ? NR_GPU_RECLAIM
> : NR_GPU_ACTIVE, nr_pages);
> +		mod_lruvec_state(lruvec, to_reclaim ? NR_GPU_ACTIVE
> : NR_GPU_RECLAIM, -nr_pages);
> +		local_irq_restore(flags);
> +		mem_cgroup_put(memcg);
> +		return true;
> +	} else {
> +		mem_cgroup_uncharge_gpu_page(page, order, true);
> +		return mem_cgroup_charge_gpu_page(new_objcg, page,
> order, 0, false);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(mem_cgroup_move_gpu_page_reclaim);
> +
> =C2=A0static int __init cgroup_memory(char *s)
> =C2=A0{
> =C2=A0	char *token;
