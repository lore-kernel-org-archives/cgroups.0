Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9341E384CEF
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 09:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788083015; cv=none; b=tjRguA96d2qhZKUz8owcxyl5Dbu5UXBBZyDeWDABjavssi1uoy0+TXfZJgkqEDCp3CcDKACs3xWYeiECUGqNcbw0WMPIWA3JWudRV/co1uJ67m/4CvptPpxHHRCzvq7i11DXoDn3eTm12NS28BqK+78mK2L9IuDxAyOn9mfqzPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788083015; c=relaxed/simple;
	bh=WLzeZ4W+JrfRBuJ4IDHnEXj5Yo3WA5fDEH3jQpf5dZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IyyKVlKRxYjzy699HP8Jp6HMgEvY5Icmlr822aUL/uXInbqlIS5wbWzJiHmL9lgMIxVlY0YAL33Eyf9Yyzar5S0kBYuTlGmR+y9/cH35QswKcbT4+b4W+xO6O04yp398NY2R5e8ESsAQCUWkCG+IIhFm422iaBveDJ7RVI0wXeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ii8B1GFX; arc=none smtp.client-ip=95.215.58.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ii8B1GFX"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WLzeZ4W+JrfRBuJ4IDHnEXj5Yo3WA5fDEH3jQpf5dZg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788083009; v=1; x=1788687809;
 b=ii8B1GFXIP4C97TtjNGFHcTISARp+DTjIZA8SS0lxTod4xH+CLkW8kpFqAXKP6HUglSKjt7M
 o/h2fdjf13ZZv0k2zlzN6AyzDVd54LdjtCI7BDFETHvCsurlxq8kMkLFe51APXMuztPNqkE6HIu
 O+cW510HbcdvqGZTCxK1ttFQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b5dc266f82cf0c4a;
	Sun, 30 Aug 2026 09:43:19 +0000
X-Mizu-Trace-ID: b5dc266f82cf0c4a
X-Migadu-Flow: FLOW_OUT
Message-ID: <d469a60a-3aaf-43d3-955a-238042115a3e@linux.dev>
Date: Sun, 30 Aug 2026 17:43:06 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm/mglru: use explicit tier range in
 read_ctrl_pos()
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/26/2026 1:53 AM, Kairui Song via B4 Relay wrote:
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
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mmzone.h |  2 ++
>   mm/vmscan.c            | 18 ++++++++++--------
>   2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c9ecf370cd9f..9b27cf53bdbc 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -492,6 +492,8 @@ enum lruvec_flags {
>    * folio->flags, masked by LRU_REFS_MASK.
>    */
>   #define MAX_NR_TIERS		4U
> +#define LRU_TIER_MIN		0U
> +#define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
>   
>   #ifndef __GENERATING_BOUNDS_H
>   
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 52ef4c3705bd..cdc2e44875da 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3198,8 +3198,8 @@ struct ctrl_pos {
>   	int gain;
>   };
>   
> -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
> -			  struct ctrl_pos *pos)
> +static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> +			  int tier_max, int gain, struct ctrl_pos *pos)
>   {
>   	int i;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> @@ -3208,7 +3208,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
>   	pos->gain = gain;
>   	pos->refaulted = pos->total = 0;
>   
> -	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
> +	for (i = tier_min; i <= tier_max; i++) {
>   		pos->refaulted += lrugen->avg_refaulted[type][i] +
>   				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
>   		pos->total += lrugen->avg_total[type][i] +
> @@ -4809,9 +4809,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
>   	 * This value is chosen because any other tier would have at least twice
>   	 * as many refaults as the first tier.
>   	 */
> -	read_ctrl_pos(lruvec, type, 0, 2, &sp);
> -	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
> -		read_ctrl_pos(lruvec, type, tier, 3, &pv);
> +	read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
> +	for (tier = LRU_TIER_MIN + 1; tier <= LRU_TIER_MAX; tier++) {
> +		read_ctrl_pos(lruvec, type, tier, tier, 3, &pv);
>   		if (!positive_ctrl_err(&sp, &pv))
>   			break;
>   	}
> @@ -4832,8 +4832,10 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>   	 * Compare the sum of all tiers of anon with that of file to determine
>   	 * which type to scan.
>   	 */
> -	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
> -	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
> +	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
> +		      swappiness, &sp);
> +	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
> +		      MAX_SWAPPINESS - swappiness, &pv);
>   
>   	return positive_ctrl_err(&sp, &pv);
>   }
> 
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.
-- 
Best regards
Ridong

