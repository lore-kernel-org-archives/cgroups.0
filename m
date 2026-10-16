Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15897369208
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 07:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136377; cv=none; b=fB+7hE3WX7hwuZ8w2rznkF6D5aKHDd1xyas2XEDWXh3nobr/UA4P6PRkPPFOXeMKQX+w5fmL6JJG5ee6d6Ff5YZVEwRzSkDKb7De+VazBEs3RhLUvpzbBqO3ikgTnRT01+WqLi+kKq0sCgAaTw1dbR5tvURHh0mPIfJzljEkqD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136377; c=relaxed/simple;
	bh=6YVTjiJF+OeTm2+YCUwsxkxG2HWYadWFd9Pc3CWTYq8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=JBE9iVRqvgd2ZDdUi/Wz+YFHGgLWoHu71y4ocXSElT0Z0/COfU3zd2gSB5E5hf3ZYTh/eRKLarWAoA3fOjCmBFxKojK1W5X1n57rMW7ftB/YsjDx/4zsJAM3+dNlMganmMiLzkDKI7HcF6E3YaeYpzag/5/AlxJ1r9K7bLzeAeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zaqj6NRP; arc=none smtp.client-ip=91.218.175.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zaqj6NRP"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6YVTjiJF+OeTm2+YCUwsxkxG2HWYadWFd9Pc3CWTYq8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792136373; v=1; x=1792741173;
 b=Zaqj6NRPahbMwE2W/Dg0RHnTABrhQEH61rAUyPUfU58BjPb3zeNrASKWMf9gPh0XDk9u8gle
 SSs7tT1k9c3ZJS8aGHNYpi8kqUiXkLFwWh7nfLW6wJcoSuHFg+sphxIAHPWctUGLzvb8VlXhPZj
 4dGNpVAJ6PZ3zbZ23jsjlCn4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 139e1e22f2624819;
	Fri, 16 Oct 2026 07:39:32 +0000
X-Mizu-Trace-ID: 139e1e22f2624819
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
Date: Fri, 16 Oct 2026 15:39:10 +0800
Cc: linux-mm@kvack.org,
 "Liam R. Howlett" <liam@infradead.org>,
 SJ Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>,
 Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>,
 David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>,
 Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>,
 Chen Ridong <chenridong@xiaomi.com>,
 Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>,
 Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 damon@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <342E57E7-9B7F-4193-805E-D1EBB41299FF@linux.dev>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
To: kasong@tencent.com
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 16, 2026, at 02:15, Kairui Song via B4 Relay =
<devnull+kasong.tencent.com@kernel.org> wrote:
>=20
> From: Kairui Song <kasong@tencent.com>
>=20
> Add a helper that resolves a stable lruvec for a folio under RCU
> without taking the lruvec lock.  It takes a folio directly so the
> lruvec lookup happens inside the RCU read-side critical section,
> which a lruvec-based interface cannot guarantee.
>=20
> No functional change.
>=20
> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> include/linux/memcontrol.h | 39 =
+++++++++++++++++++++++++++++++++++++++
> 1 file changed, 39 insertions(+)
>=20
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 74110a324f9e..829ab776ab44 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1535,6 +1535,45 @@ static inline void lruvec_lock_irq(struct =
lruvec *lruvec)
> spin_lock_irq(&lruvec->lru_lock);
> }
>=20
> +/**
> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> + * @folio: the folio
> + *
> + * Computes @folio's lruvec and walks up to the nearest live ancestor
> + * if the folio's memcg is dying.  Paired with =
folio_lruvec_live_put().
> + * The result may be stale: RCU keeps it alive but does not pin =
@folio
> + * to it.  That is fine as the counters are fixed up on reparenting.
> + *
> + * Return: the live lruvec, with rcu_read_lock held.
> + */
> +static inline struct lruvec *folio_lruvec_live_get(struct folio =
*folio)
> +{
> +#ifdef CONFIG_MEMCG
> + 	struct lruvec *lruvec;
> + 	struct pglist_data *pgdat;
> + 	struct mem_cgroup *memcg;
> +
> + 	rcu_read_lock();
> + 	lruvec =3D folio_lruvec(folio);
> + 	pgdat =3D lruvec_pgdat(lruvec);
> + 	memcg =3D lruvec_memcg(lruvec);
> + 	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> + 		memcg =3D parent_mem_cgroup(memcg);
> + 		lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
> + 	}
> + 	return lruvec;

Hi Kairui,

Actually, we don't have any means to guarantee that the memcg
to which the returned lruvec belongs will not become dying
after the return, right?

> +#else
> + 	return folio_lruvec(folio);

Then, I'm wondering why folio_lruvec() doesn't apply to the
memcg scenario.

Internally, folio_lruvec() obtains the memcg through
obj_cgroup_memcg(). So when the memcg becomes dying, it should
be reparented to the parent memcg within a short time.

Likewise, folio_lruvec() may also return an lruvec whose memcg
may also be in a short-lived dying state.

Since the results of the two are similar, why not just use
folio_lruvec() directly? Or is there something I misunderstood?

Thanks,
Muchun


> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> + 	rcu_read_unlock();
> +#endif
> +}
> +
> static inline struct lruvec *lruvec_live_lock_irq(struct lruvec =
*lruvec)
> {
> #ifdef CONFIG_MEMCG
>=20
> --=20
> 2.56.0
>=20
>=20

