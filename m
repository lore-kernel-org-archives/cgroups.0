Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07DC56C641;
	Thu, 15 Oct 2026 19:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792091498; cv=none; b=C6TdoWb7zWmfLbO8B0kjzdyJ8RGQHFcZT5xDh6L2wH8hdxuUrkEDhdMsmtCbL2tE+Rz8Nq+acUr4EGXSMSLCSNc5SA8dnYk7g/hq1h7/v6fnXZVJ2cFbehTXEpiXPTrM2uFOLQZT/C0fe9i5dhM40ZQLk/5av+a3Kq8RlYwQXIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792091498; c=relaxed/simple;
	bh=WfYnkLvsxFQ2Iy1AZblL4oivfqAitetwqf0jIRb78zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nx60Wqd2S2bwOHqe1EhEk8f7dMkb3BW6ZyjhXp6l1O1i0iVA473eZh8EXWgLB5dioTLnSeuf6LyMl1u7fj7DtJJ7WXNFaP28T5ivTrMrw+u8tmOSPCmlr4HVcd2I1ILwupXSYQbhKulogTdWBgSda0mSccBL9Id/8/FTDC3H4P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOi0wl0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOi0wl0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8A11F000C4;
	Thu, 15 Oct 2026 19:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792091483;
	bh=SAUwP8uv+umPvOo9Qj4Nscuwt4gS+Jp3uOlXS5VCJX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cOi0wl0wIMf7h6fRzBGzvmfNVak4QfBXmz5UnHGQQ//LoBbqmk8ISLwwLjlNRe5Zs
	 GA+DIVBtyk2epQQzkS5TNPlbIs+JwXJKrmqRcEsBJSWfZtwEwp6uOhULQfYLjtyqt4
	 5KFgSQL9Dhu9YzqkojCN/j3wcVZQRzcNzEZZCuKeaA4OZVyM6vtQtE5Sek2XP1xDQo
	 mkYJ0zv8NUdXBgNONVQzRTD6VJVLkWBPUdxhdnHztVjO68F4vBJaRJUizOkps3jn4S
	 0PY3ZMjpwDIuyI2Bc9jmPKHvakp8HRDb918uC+aEDjli9MTrM19VmYHLO5mSfkiozk
	 53TZ4XwXpuMYg==
Date: Thu, 15 Oct 2026 20:11:21 +0100
From: Harry Yoo <harry@kernel.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
Message-ID: <atEkfmRFgXJCbJuK@thinkstation>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>

On Fri, Oct 16, 2026 at 02:15:52AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Add a helper that resolves a stable lruvec for a folio under RCU
> without taking the lruvec lock.  It takes a folio directly so the
> lruvec lookup happens inside the RCU read-side critical section,
> which a lruvec-based interface cannot guarantee.
> 
> No functional change.
> 
> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

This new helper is doing the the same thing as what
get_non_dying_memcg_start/end() do.

>  include/linux/memcontrol.h | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 74110a324f9e..829ab776ab44 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1535,6 +1535,45 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
>  	spin_lock_irq(&lruvec->lru_lock);
>  }
>  
> +/**
> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> + * @folio: the folio
> + *
> + * Computes @folio's lruvec and walks up to the nearest live ancestor
> + * if the folio's memcg is dying.  Paired with folio_lruvec_live_put().
> + * The result may be stale: RCU keeps it alive but does not pin @folio
> + * to it.  That is fine as the counters are fixed up on reparenting.
> + *
> + * Return: the live lruvec, with rcu_read_lock held.
> + */
> +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
> +{
> +#ifdef CONFIG_MEMCG
> +	struct lruvec *lruvec;
> +	struct pglist_data *pgdat;
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	lruvec = folio_lruvec(folio);
> +	pgdat = lruvec_pgdat(lruvec);
> +	memcg = lruvec_memcg(lruvec);
> +	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> +		memcg = parent_mem_cgroup(memcg);
> +		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +	}
> +	return lruvec;
> +#else
> +	return folio_lruvec(folio);
> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_unlock();
> +#endif
> +}
> +
>  static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
>  {
>  #ifdef CONFIG_MEMCG
> 
> -- 
> 2.56.0

-- 
Cheers,
Harry / Hyeonggon
