Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481EB3F825E
	for <cgroups@vger.kernel.org>; Fri, 26 Jun 2026 14:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782484377; cv=none; b=NpkoHe2YDLpBSh/jrOzppC/2AqR06CCE9LJnd8KOJKqZjbUbWGVMH9/eS325UvQRY+mJUNa8OAvRbCkTMaPS03uSEKKPB0axi/w9/RfmBlhrDQI+fAN2WPi2RIs2OtJSGeZY7ntrw1cIzMrc14jy98mX3x2M+W+34IHkhpdJYiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782484377; c=relaxed/simple;
	bh=8qPaCiD+kWhzMYu1v25kGwZJldUgbm2IxS4bv38Ze5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcvFTQ1o7fPmJDlst7SFYHJdv6Q0FIOZCaSnXGWHmRQy5i95FOuWWWLbafz1ypg851tD9kc7zgbk+MUZnv5OFARJ4eyU3wiut9B87Ypl7/vtchED8lHB4w7EQGLQhw7KJeoyVETLwSte+/9+sJ1l0swW5q1lV9dcvkIqXRr6CHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a31JYTtk; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a31JYTtk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782484372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1f7G+W7XdToQCcEEv+xhI/b4k9eRW05nVoQLm3eeNw=;
	b=a31JYTtkHqBYP9yQgIATJLIF5O8Bt+AGU5eBWio4HiGkQ+cWhMjdR+Z7sw8NkHZw6f+WCi
	a20/l8a4z1Yth6b1AP+Q2UbPym1OAFn9NaJQRG16c34M/0bXcekcPKPKqMyOlmlXhJKfks
	7Sx+8QTrExLatoHZHsVkKYjjyn9ZtIQ=
From: Usama Arif <usama.arif@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Usama Arif <usama.arif@linux.dev>,
	alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>
Subject: Re: [PATCH v2 9/9] mm: zswap: per-node kmem accounting for zswap/zsmalloc
Date: Fri, 26 Jun 2026 07:32:43 -0700
Message-ID: <20260626143244.3382853-1-usama.arif@linux.dev>
In-Reply-To: <20260626102358.1603618-10-alex@ghiti.fr>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 26 Jun 2026 12:20:58 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> Update zswap and zsmalloc to use per-node obj_cgroup for kmem
> accounting, attributing compressed page charges to the correct
> NUMA node.
> 
> But actually, this is incomplete because it does not correctly account
> for entries that straddle pages, those pages being possibly on 2 different
> nodes.
> 
> This will be correctly handled by Joshua in a different series [1].
> 
> Link: https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua.hahnjy@gmail.com/ [1]
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  include/linux/zsmalloc.h |  2 ++
>  mm/zsmalloc.c            | 11 +++++++++++
>  mm/zswap.c               | 19 ++++++++++++++++++-
>  3 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> index 478410c880b1..30427f3fe232 100644
> --- a/include/linux/zsmalloc.h
> +++ b/include/linux/zsmalloc.h
> @@ -50,6 +50,8 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
>  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>  		  void *handle_mem, size_t mem_len);
>  
> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle);
> +
>  extern const struct movable_operations zsmalloc_mops;
>  
>  #endif
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 83f5820c45f9..17f7403ebe77 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1380,6 +1380,17 @@ static void obj_free(int class_size, unsigned long obj)
>  	mod_zspage_inuse(zspage, -1);
>  }
>  
> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle)
> +{
> +	unsigned long obj;
> +	struct zpdesc *zpdesc;
> +
> +	obj = handle_to_obj(handle);
> +	obj_to_zpdesc(obj, &zpdesc);
> +	return page_to_nid(zpdesc_page(zpdesc));
> +}
> +EXPORT_SYMBOL(zs_handle_to_nid);

Does this need the same locking as the other handle-to-zspage paths?
zs_free() takes pool->lock before handle_to_obj() because zspage migration can
update or move the object behind the handle. This helper does the same decode
without the lock, so zswap's uncharge path can race migration and charge or
uncharge the wrong node, or observe transient zspage state.


> +
>  void zs_free(struct zs_pool *pool, unsigned long handle)
>  {
>  	struct zspage *zspage;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..466c6a3f4ef3 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1438,7 +1438,24 @@ static bool zswap_store_page(struct page *page,
>  	 */
>  	zswap_pool_get(pool);
>  	if (objcg) {
> -		obj_cgroup_get(objcg);
> +		struct obj_cgroup *nid_objcg;
> +		int nid = zs_handle_to_nid(pool->zs_pool, entry->handle);
> +
> +		/*
> +		 * obj_cgroup_nid() returns a borrowed RCU pointer (no
> +		 * reference), so the returned per-node objcg may be freed
> +		 * (kfree_rcu) before we use it. Pin it with a tryget inside a
> +		 * single rcu section; if it is already dying, fall back to the
> +		 * folio objcg (held by the caller) so the charge still lands on
> +		 * the right memcg, just without per-node attribution.
> +		 */
> +		rcu_read_lock();
> +		nid_objcg = obj_cgroup_nid(objcg, nid);
> +		if (nid_objcg && obj_cgroup_tryget(nid_objcg))
> +			objcg = nid_objcg;
> +		else
> +			obj_cgroup_get(objcg);
> +		rcu_read_unlock();
>  		obj_cgroup_charge_zswap(objcg, entry->length);
>  	}
>  	atomic_long_inc(&zswap_stored_pages);
> -- 
> 2.54.0
> 
> 
