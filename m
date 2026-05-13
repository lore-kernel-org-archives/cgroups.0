Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B763A8747
	for <cgroups@vger.kernel.org>; Wed, 13 May 2026 18:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778696828; cv=none; b=mmEf6fCNGVJr9YvjuOXGqBqCkmTuaAwbuiG4ZicsABbozcSMZ+nviMTReF6minNPPut+xxiuKBm3xmtKx5f5kVCkUYRKQChzf3e9FrIF+9xHPYx1cdjqAViWWraQ1HdOtmLb1pgMdYCW06CVWuddRsumJkz6jIzz1nhxTb2pSBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778696828; c=relaxed/simple;
	bh=jHu1YpBTeGBJy0b/KeruCwmCkpdBlbMQza/HAn01xIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1SwsDBd5ZrJFor4hWTQ4KNeOJ0jsYv8Y84qgjBZUWZcti1pdTaAsrB9jP85e5EwolnOfQPKi1lum7TEVU5sPnuzFm8E4J2qCuwM5ZnZyGYRjCZDpV6KxxPg+L6zBKQYzrPxvQWW2HLi9LEVryZnviqj7ZnsvoetuFDHmamvBN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 14 May 2026 03:27:04 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 14 May 2026 03:27:04 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH v3 12/12] mm, swap: merge zeromap into swap table
Message-ID: <agTCeEuMWJtYN9EF@yjaykim-PowerEdge-T330>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-12-2f23759a76bc@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421-swap-table-p4-v3-12-2f23759a76bc@tencent.com>

On Tue, Apr 21, 2026 at 02:16:56PM +0800, Kairui Song via B4 Relay wrote:

Nice! LGTM

Reviewed-by: Youngjun Park <youngjun.park@lge.com>

A few nitpicks follow. take them if you find them useful. :)

> +static inline void __swap_table_clear_zero(struct swap_cluster_info *ci,
> +					   unsigned int ci_off)
> +{
> +

trailing blank line. 

> +#if SWAP_TABLE_HAS_ZEROFLAG
> +	unsigned long swp_tb = __swap_table_get(ci, ci_off);
> +
> +	VM_WARN_ON(!swp_tb_is_countable(swp_tb));
> +	swp_tb &= ~SWP_TB_ZERO_FLAG;
> +	__swap_table_set(ci, ci_off, swp_tb);
> +#else
> +	lockdep_assert_held(&ci->lock);
> +	__clear_bit(ci_off, ci->zero_bitmap);
> +#endif
> +}
...
> +
>  	table = (struct swap_table *)rcu_access_pointer(ci->table);
>  	if (!table)
>  		return;
> @@ -470,6 +475,13 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>  	if (!ci->memcg_table)
>  		ret = -ENOMEM;
>  #endif
> +
> +#if !SWAP_TABLE_HAS_ZEROFLAG
> +	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> +	if (!ci->zero_bitmap)
> +		ret = -ENOMEM;
> +#endif
> +

memcg_table above uses `if (!ci->memcg_table)` before
kzalloc, but ci->zero_bitmap is assigned unconditionally.  Both
are NULL on entry today (swap_cluster_free_table nullifies them),
so either form works but the asymmetry reads oddly.  Either
drop the memcg guard (with an entry VM_WARN_ON asserting both
NULL by design), or mirror the guard here.

