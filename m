Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A38E4C10FB
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 06:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790057957; cv=none; b=mYhTj9rzeAI9u6HipxW4cjnfUb+Ph5XQ1po21JnD9IXO4lvTUKBUvl/I93yG0aEeFtuXy0sa5Te2vZ2BYiBrDv883yr+HTQiyQHRoxzUDLYhdV29vQ0BX5DtF2fohsfMjbz8/KlHDPCYMhKQroeSMnGuoc9iCA2wdFQj4EMmwF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790057957; c=relaxed/simple;
	bh=F1Scp7kU1gs61CCyWXz4iJsW5PoldpSJMclIFQiOv94=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=DK6FhNTvwvTfer9IX7YdA01JWzHs6Skf1IgboM1mlxelqxI8VUKUcsIUxM+D0GxNlKbAS1iwCwULaZ6RihU4RdS5g4ZEJ8Bcvst/SfN+mk8vc9cHOF7Vi8ej8V/iB3m/INuRDMV+zFq7yyYKRpDxD0CAsJ56wauYyuvrg/lEOxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XQ7D5pot; arc=none smtp.client-ip=91.218.175.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XQ7D5pot"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=F1Scp7kU1gs61CCyWXz4iJsW5PoldpSJMclIFQiOv94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790057951; v=1; x=1790662751;
 b=XQ7D5pot2eJ44qMEhkAbPGQoLtpqcygL3deow+x24a2APhcdc5A3KtJGawwYZ7MbhAfQn/fe
 w09n202O93npXBKYlgwwAGTSDCWx8KEXfsfGc7HhIo1Nfo9mUyL+qj2++rtWoD38XMnlW/6IdfL
 G3PrYxu2iKvgigDiyssz3EyY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 20087f601faff867;
	Tue, 22 Sep 2026 06:19:11 +0000
X-Mizu-Trace-ID: 20087f601faff867
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
Date: Tue, 22 Sep 2026 14:18:51 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 Chris Down <chris@chrisdown.name>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B710AD66-B826-4138-B1D4-2DB3E00FDC1D@linux.dev>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
 <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 21, 2026, at 17:12, Hongfu Li <hongfu.li@linux.dev> wrote:
>=20
> From: Hongfu Li <lihongfu@kylinos.cn>
>=20
> memory.numa_stat exposes per-node hugetlb counters from per-node =
lruvec
> stats. These stats are accounted against folio_nid(): incremented on
> the folio's node when handed to a user, decremented when the folio is
> returned to the pool.
>=20
> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
> to the new folio and drops the memcg data of the old one, so the free
> of the old folio right after the migration skips the memcg per-node
> lruvec decrement. The hugetlb count stays attributed to the old node
> for the rest of the life of the charge, while the target folio gets no
> increment on the new node; its later free decrements a counter that
> was never incremented.
>=20
> Migrate the per-node lruvec accounting alongside migration. Global
> memcg totals remain balanced because they track resource consumption,
> not node placement.
>=20
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
> mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
> 1 file changed, 31 insertions(+)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1460cba53588..9c96ebd5436f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5598,6 +5598,34 @@ void mem_cgroup_replace_folio(struct folio =
*old, struct folio *new)
> rcu_read_unlock();
> }
>=20
> +#ifdef CONFIG_HUGETLB_PAGE
> +static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,

Actually, we don't need this objcg parameter since we could get it from =
folio.
And I'd like to move this function to hugetlb.c.

> +     				struct folio *old, struct folio =
*new)
> +{
> + 	long nr_pages =3D folio_nr_pages(old);
> + 	struct mem_cgroup *memcg;
> + 	int old_nid =3D folio_nid(old);
> + 	int new_nid =3D folio_nid(new);
> +
> + 	if (old_nid =3D=3D new_nid)
> + 		return;
> +
> + 	rcu_read_lock();

Please use guard(rcu)() to simplify the code a little.

Thanks.

> + 	memcg =3D obj_cgroup_memcg(objcg);
> + 	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, =
NODE_DATA(old_nid)),
> +       		NR_HUGETLB, -nr_pages);
> + 	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, =
NODE_DATA(new_nid)),
> +       		NR_HUGETLB, nr_pages);
> + 	rcu_read_unlock();
> +}
> +#else /* CONFIG_HUGETLB_PAGE */
> +static inline void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
> +    					struct folio *old,
> +    					struct folio *new)
> +{
> +}
> +#endif /* CONFIG_HUGETLB_PAGE */
> +
> /**
>  * mem_cgroup_migrate - Transfer the memcg data from the old to the =
new folio.
>  * @old: Currently circulating folio.
> @@ -5635,6 +5663,9 @@ void mem_cgroup_migrate(struct folio *old, =
struct folio *new)
>=20
> 	new_objcg =3D get_migration_objcg(old, new);
>=20
> + 	if (folio_test_hugetlb(old))
> + 		move_hugetlb_lruvec_stat(new_objcg, old, new);
> +
> /*
> * @old was charged through a non-root objcg, so its charge is in the
> * page counters. If the re-derivation walked up to the root objcg -
>=20
> --=20
> 2.54.0
>=20

