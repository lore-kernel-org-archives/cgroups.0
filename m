Received: from mta0.migadu.com (out-133.mta0.migadu.com [91.218.175.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC32503BC7
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789750014; cv=none; b=uqJA2GQLT4Ja/jFipneAN8X55/aVoXxPposZ7Xlp4MML6mZ/kw/qMT8MjmvDRQVzdLwJRdW3uY6a6FPMefpgDgc6S4HXXBzcSKxrr4kPBACo9o4y18RPEakw8J77Ngdeb43QyjiI+kK5amY55NXinf85E62EjobQJhUUMN2rmGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789750014; c=relaxed/simple;
	bh=IcMPsgHLbsL3gesbrTlWcc/a4iLPhjEjxGMLJtdWezE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GhkESGsX0FxWUOP1U7kXi7/CQd3ImLF7aRGRsnw2jcOz1wSzlSN4DcvUZzozGhgI8tqwNIp2H2Dqdz3UmDtY3ajX62053YzJLUhNhCENWbDwa9SJptrf9luy7pMVLFmXgRNE4CY7K4tylM9m4MYBFpDm8r1DlSvK/daV2kVMqYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DU5Hd2PF; arc=none smtp.client-ip=91.218.175.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DU5Hd2PF"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IcMPsgHLbsL3gesbrTlWcc/a4iLPhjEjxGMLJtdWezE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789750009; v=1; x=1790354809;
 b=DU5Hd2PFEEgYgI4Zxlvb2jgNoeyVj8Eqo0mwELcjvuqpm+Fq+24fpAiK7eCIMcZRDFXa1oKB
 1bwelFiYlOinmryvmNfJ1iv8Y+z92BiV6paJFLmYBkza3xM1MjcOlEYIazjvKBRxOzrXfklbDUB
 ACII3CxPEJp4IAerPrYY0U7Y=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2886f110b7b1646b;
	Fri, 18 Sep 2026 16:46:48 +0000
X-Mizu-Trace-ID: 2886f110b7b1646b
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 09:46:47 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: bingfangguo@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Bingfang Guo <bfguo@icloud.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] memcg: keep swap charging under RCU protection
Message-ID: <aq1qj7Owhuk2BQsv@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>

On Fri, Sep 18, 2026 at 05:18:40PM +0800, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
> 
> This is a preparatory work for unbinding memcgid from memcg. No
> functional change.
> 
> The swap charging path currently drops its RCU read lock after acquiring
> a private ID reference. This is safe because the ID reference pins the
> memcg's CSS.
> 
> Moving private ID references to objcgs will remove that lifetime
> guarantee. Keep the RCU read lock held while accessing the memcg for
> counter charging, statistics and failure handling. (This matches what
> __memcg1_swapout() already does.).
> 
> Save the private ID before dropping the RCU read lock, and use the saved
> value when recording the swap entry. The swap cluster locking remains
> outside the RCU read-side critical section.
> 
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>  mm/memcontrol.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 791e536efaebe..72522ec827c9a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5954,6 +5954,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>  	struct page_counter *counter;
>  	struct mem_cgroup *memcg;
>  	struct obj_cgroup *objcg;
> +	unsigned short private_id;
>  
>  	if (do_memsw_account())
>  		return 0;
> @@ -5973,20 +5974,21 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>  

If there is one more spin of this patch, I think scoped_guard(rcu) would be more
readable here, so please use that here.

>  	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
>  	/* memcg is pined by memcg ID. */
> -	rcu_read_unlock();
> +	private_id = mem_cgroup_private_id(memcg);
>  
>  	if (!mem_cgroup_is_root(memcg) &&
>  	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
>  		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>  		mem_cgroup_private_id_put(memcg, nr_pages);
> +		rcu_read_unlock();
>  		return -ENOMEM;
>  	}
>  	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> +	rcu_read_unlock();
>  
>  	ci = swap_cluster_get_and_lock(folio);
> -	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> -			  mem_cgroup_private_id(memcg));
> +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, private_id);
>  	swap_cluster_unlock(ci);
>  
>  	return 0;
> 
> -- 
> 2.43.7
> 
> 
