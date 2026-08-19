Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734863F822A;
	Wed, 19 Aug 2026 09:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787131549; cv=none; b=iBbGT9zNMZ1/aVVGU4A9HWhdImLp56Gj/7RaEgtKqQYneSPK+5zhxZ2m1ww3iZaI9zpTBmSbWG1mQxykCt9bLdfyNpJ5osq6LHufdRQAixFLXICXbq7rUVIX8Y8+lsWCeQ0/xNWzPzLnBFVE2RpJmeUI2s+NCpTIKVGV8QGIbIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787131549; c=relaxed/simple;
	bh=EbRQ2x/5Ng0ZG0ed9boH8GIirTWBzIzif7MmqDOeoC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nqOKLQQKT9dZSeMbKVLGBiDHZY4WaHgX4og6EstUEMIVvQeiS2NUMxgvxH6Ofi8/lQ9hKpUObK3nhuUEbMupeIGU9l8haLRmdAX6R+8962Jgs7igd3jpbvGrSielbnbkHn+HW3pUZn+efG2HI4cOVAlQDhKEvPkCEr+MNr4I4rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=r71dKfSH; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="r71dKfSH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787131537; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cfZIfo/SEd42BidWWjniFI4c8yolrhYimg9M2l4ITjM=;
	b=r71dKfSHr369KEn8VsZpOjxE8qxSzDj6GqFVGx8osmAF9CuMhM1naReBmJOpmsypfIeluPuN+2ojMXXsuq96eV/qPD5JjDe7pWzWlg/T+rvVbP8ud7l/MSUseYPlJF9D/jX22i6FfLOToOGjzVHDVT6f78iSTegJxg/BlXB1evM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X9G8Y5l_1787131534;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9G8Y5l_1787131534 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 17:25:35 +0800
Message-ID: <50e3710a-b63c-4460-b3a8-f9f98ad7e7ff@linux.alibaba.com>
Date: Wed, 19 Aug 2026 17:25:33 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] mm/mglru: use explicit tier range in read_ctrl_pos()
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> read_ctrl_pos() encodes the tier range in a single "tier" parameter
> via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> as the end. This is hard to follow, maintain, or extend. Tier values
> 0..3 select a single tier, while tier == MAX_NR_TIERS selects the
> full range.
> 
> Replace it with explicit (tier_min, tier_max) parameters using a
> closed [tier_min, tier_max] interval, and add LRU_TIER_MIN and
> LRU_TIER_MAX for the tier bounds. The call sites now become
> self-documenting:
> 
>    - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
>                      (tier, tier) for each subsequent tier
>    - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range
> 
> No functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Yes. More readable.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
