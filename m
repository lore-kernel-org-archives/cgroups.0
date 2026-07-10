Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685C138F92D;
	Fri, 10 Jul 2026 07:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783668114; cv=none; b=lsgUaOEM98bpnpcNk/XottiQAXi0YR8pPKcW5UrTPQENPgJRwrQK66k9I8B2N/wThzpFu8Z+7FEk7DmdQRLu7oGNLqJVl3jir8LVDT8D8KelNBeOnosvuaS4KsQ9+LAyjZORzUfoHOgFrUnH9Z4LITDdj3Q1bTED1bP8o5hfE64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783668114; c=relaxed/simple;
	bh=GGdC5z0KSncv5qo868h8rhcsT2wyDfFF7Eay9xvSc4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xdd5ij8J+WPPQ2HJ2MWHwDJRdRJuJkaOJqJgjFDsbmlQJ2S74PEgEF0cIySmPWx8jIDjSw0cjAYmgWPB4pjHB15U8YrGKdpwr04rox5WZOuQ8A/7Mo8XIi7Lvc5MwWb9MyRNS+Z8j4jMhz8QIeUi9wxYjdZqnf6qNbr69Q8rxAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SPjPBuPV; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SPjPBuPV"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783668109; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=s0jsS6CvIf8h9YNVfslpOzzkSogUyLYNAlZCZLFhTUw=;
	b=SPjPBuPVDRcbDIXIZcofbJ0VZXytSaL6dSPueXfwFi0NCNJ8uKFMZpSLeBF8gUNwXvvWMFQTuUgortUQDvM6x5KV64D3tGLdYET1XpTDDQfJWq8rfLDLU741m9ioYh1iPi93Vd02pICdAfpv2P0Rh/9WAhRaJ1wcMVd4VWbItGg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X6n.faJ_1783668105;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6n.faJ_1783668105 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 15:21:47 +0800
Message-ID: <7ec7533f-e1dc-4236-99cc-6848d651976e@linux.alibaba.com>
Date: Fri, 10 Jul 2026 15:21:44 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 3/3] mm/vmscan: avoid pointless large folio splits
 without swap
To: Xueyuan Chen <xueyuan.chen21@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Barry Song <baohua@kernel.org>, Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>
References: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
 <20260709145124.764807-4-xueyuan.chen21@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260709145124.764807-4-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/9/26 10:51 PM, Xueyuan Chen wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> When swap is disabled, exhausted, or unavailable due to memcg swap
> limits, splitting a large anonymous folio cannot make swapout progress.
> The fallback only destroys the large folio and inflates split statistics.
> 
> Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
> the folio might allow swapout of smaller pieces. For other allocation
> failures, keep the existing activation path and avoid the split.
> 
> This preserves the split fallback for fragmented or partially available
> swap, while avoiding it when there is no backing space for any part of the
> folio.
> 
> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..40340a88f78e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1260,6 +1260,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   		 */
>   		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>   				!folio_test_swapcache(folio)) {
> +			int ret;
> +
>   			if (!(sc->gfp_mask & __GFP_IO))
>   				goto keep_locked;
>   			if (folio_maybe_dma_pinned(folio))
> @@ -1278,10 +1280,11 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   				    split_folio_to_list(folio, folio_list))
>   					goto activate_locked;
>   			}
> -			if (folio_alloc_swap(folio)) {
> +			ret = folio_alloc_swap(folio);
> +			if (ret) {
>   				int __maybe_unused order = folio_order(folio);
>   
> -				if (!folio_test_large(folio))
> +				if (!folio_test_large(folio) || ret != -E2BIG)
>   					goto activate_locked_split;

Like I said in v1 [1], please apply the same change to shmem swap as well.

[1] 
https://lore.kernel.org/all/6e89f868-ca7a-484f-aeea-5d8d029714f2@linux.alibaba.com/
