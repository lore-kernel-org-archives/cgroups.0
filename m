Received: from mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875593E9584
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 10:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787741335; cv=none; b=QWyCJ/MZ2SJp+cDzeGmeyK6iQaYLxTy8Zkb25gK92M+5P+R2R7vK0gCNRx3+vRHzH6tIG0/dJbE3L765Gfmq3uxXs9HXFIhzdhhu7E84N2L7SZsWUqCb913xTvv0n3E0q/zztz8uvAJmTpcq/4P3dGHSLDOmiflxApJXYQWtLLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787741335; c=relaxed/simple;
	bh=OWFpLa2hlcedUTd6dCHWJ++O5mBHb6pDvO1c2wDCw8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PYaRoLWJEC11ZfRAxBzC9Pq1WAP1Bri1f/LZYo6fHWtNuqhrpRxVKloiz13JWV9QAyZuEt9BtyIgzjGaWZTZKDBbwZNacQHNNDEyGD/Vu6wb1WTr2Ek8i4upgKKu2jRme82BKsZPIBGaHbS/bRt04yQ1Sq9bctjnAggxb5xfHHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MXExMPQp; arc=none smtp.client-ip=91.218.175.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MXExMPQp"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OWFpLa2hlcedUTd6dCHWJ++O5mBHb6pDvO1c2wDCw8Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787741314; v=1; x=1788346114;
 b=MXExMPQpEcImL2tZdJVmRrI6eUh1yjzMDoZd06yP05X7mata90VLyUGMjzh+Yqnwq74Kwugz
 aMqLN+x91SWlUFW3P15r3IvVA8zPbP3wuF4/Cxs4BzoQEI2GfIhTgp4+FcSQYR1OKhoHp2ztLUE
 CHaRL+mZ89S2tDN9hsgA8epM=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id 19486a93eca802f7;
	Wed, 26 Aug 2026 10:48:24 +0000
X-Mizu-Trace-ID: 19486a93eca802f7
X-Migadu-Flow: FLOW_OUT
Message-ID: <49526857-62f4-45e3-9d8c-40d22586abdd@linux.dev>
Date: Wed, 26 Aug 2026 18:48:14 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Zi Yan <ziy@nvidia.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kairui,

On 8/26/26 1:53 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
> 
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
>   include/linux/mmzone.h    |  1 +
>   mm/folio.c                | 19 +++++++-----
>   mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
>   4 files changed, 114 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..edfaf2661812 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
>   	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>   }
>   
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_gen_from_flags(unsigned long flags)
> +{
> +	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);

It seems a bit weird to have this build warning inside this function,
but after I tried using static_assert() and failed, I think I understand
why you put it here.

Besides that, LGTM, so:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

