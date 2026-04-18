Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA76382F01
	for <cgroups@vger.kernel.org>; Sat, 18 Apr 2026 14:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776521007; cv=none; b=rZt9XO39KsVO/U3qkKv9JWQpgzxxaunDygIg/eQNBGt+vJLg8rQUSzi0qeBzk/gaCS/te+p/mnSLfAfuqWGfTPpHgNJZQunZeVCKQamgoMpufiM5jnG+4YT2UEKh4l3ntLnTgZv3/66N0d0Z4rpdMq7m1DybL8cFHBDf8+hZMmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776521007; c=relaxed/simple;
	bh=P4zMOxcJIq64DsotD8stHNlEpFpwgp5wccgZpRFgPjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULdTb8IiSq1IPyl9LR5OE9RYzNN+pFJs2QFEOW7TvP4Z6ZeP/1M+2opZ31r41oDFkaqEde6ndu3pjJRMoWOKk7uaudxFb+Xx06gdxl7iNJ2c1gNQk3tod99cPHQldCo6sVIc577DKOg+v+kpaFw4v1pDlue3EvuYgpmyfb9G9L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 18 Apr 2026 23:03:22 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 18 Apr 2026 23:03:22 +0900
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
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v2 09/11] mm/memcg, swap: store cgroup id in cluster
 table directly
Message-ID: <aeOPKlF4qAdM2oMH@yjaykim-PowerEdge-T330>
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
 <20260417-swap-table-p4-v2-9-17f5d1015428@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417-swap-table-p4-v2-9-17f5d1015428@tencent.com>


> +		if (IS_ENABLED(CONFIG_MEMCG) && !memcg_table) {
> +			swap_table_free(table);
> +			return -ENOMEM;
> +		}

Hi Kairui,

Nit: 
(Just a readability nit. purely my preference, feel free to ignore.)
the checks around swap_memcg_table_alloc() reduce to two
equivalent forms of the same memcg success/failure question:

(!IS_ENABLED(CONFIG_MEMCG) || memcg_table)   /* success */
(IS_ENABLED(CONFIG_MEMCG) && !memcg_table)   /* failure */

A macro for the failure side would let the call sites read as plain
positive/negative:

#define SWAP_MEMCG_TABLE_ALLOC_FAILED(t) \
	(IS_ENABLED(CONFIG_MEMCG) && !(t))

SWAP_MEMCG_TABLE_ALLOC_FAILED(memcg_table)     /* failure */
!SWAP_MEMCG_TABLE_ALLOC_FAILED(memcg_table)    /* success */

Equivalently, the same macro can be expressed by splitting on
CONFIG_MEMCG.

#ifdef CONFIG_MEMCG
#define SWAP_MEMCG_TABLE_ALLOC_FAILED(t)  (!(t))
#else
#define SWAP_MEMCG_TABLE_ALLOC_FAILED(t)  (0)
#endif

What do you think?

Thanks,
Youngjun Park
