Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD838443E39
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 10:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787134586; cv=none; b=TS9AOy66qtmW7/krkU8CBsG4Qcnj4Jgw2ZgyIKmC0Z/qt/gI+nmtDjHCzEOupGGAod+UjkkWGgI/01DWqlkqWDkxzyrNlKXcs2w6qNxzSmmkLGi+nPhI0Ppy5T5kV6PgM+wBHJO9x0XrD2kkVG5u2U680DdITdJjsWeah0f6E1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787134586; c=relaxed/simple;
	bh=lrdTAluOUYWs62O0PpRF6nh/ALgtREIgbj5lfiADRdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RunvHkpq5LS5Nkq3xsidwcrQN+jFk2KTSYJ//RXDDnwbEIe+PNK+ZPowBX2ItPVEOdcYZfNlrLLESqPZK7uBV/krt8mu6+0LLy36AanS+KVTGfK8lXNc1SkmiGXaY6xpDnKHrZnJVtsLgbzVBGZMjNUhVzoMgkZaMSvjeQgtjMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HerHLKK5; arc=none smtp.client-ip=95.215.58.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HerHLKK5"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lrdTAluOUYWs62O0PpRF6nh/ALgtREIgbj5lfiADRdg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787134581; v=1; x=1787739381;
 b=HerHLKK5iA7jemF1t+gQ978L4Z6+gpvBPttI933WycTGV7uSciIYX4Iguw7qtWWuJOy/K6J2
 ZGE/Us7iRZjIX5CMzKVygkdn5mFDUBvYGE8AvC97sAuj0VzWTss9FuZm/bOeO/m9+upUaHau3TC
 Zi+I5n85Jw0OVzN2QNaB2i8Y=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 572f4396708aeda8;
	Wed, 19 Aug 2026 10:16:21 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 19 Aug 2026 18:16:13 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 5/7] mm/mglru: use explicit tier range in read_ctrl_pos()
Message-ID: <aoWCbV6J7xsiZrTw@MiWiFi-R3L-srv>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>

On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
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
>   - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
>                     (tier, tier) for each subsequent tier
>   - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range
> 
> No functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mmzone.h |  2 ++
>  mm/vmscan.c            | 18 ++++++++++--------
>  2 files changed, 12 insertions(+), 8 deletions(-)

To be honest, I like the old version better. The complexity is
encapsulated inside the function, and tier_idx can reflect if it's
operating on a specific tier or the whole tier. Anyway, this is also
good:

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 32d9354a754f..d0b5c6217d25 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -492,6 +492,8 @@ enum lruvec_flags {
>   * folio->flags, masked by LRU_REFS_MASK.
>   */
>  #define MAX_NR_TIERS		4U
> +#define LRU_TIER_MIN		0U
> +#define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
>  
>  #ifndef __GENERATING_BOUNDS_H
>  
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a819be6b7ae9..a613bb8d7271 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3198,8 +3198,8 @@ struct ctrl_pos {
>  	int gain;
>  };
>  
> -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
> -			  struct ctrl_pos *pos)
> +static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> +			  int tier_max, int gain, struct ctrl_pos *pos)
>  {
>  	int i;
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> @@ -3208,7 +3208,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
>  	pos->gain = gain;
>  	pos->refaulted = pos->total = 0;
>  
> -	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
> +	for (i = tier_min; i <= tier_max; i++) {
>  		pos->refaulted += lrugen->avg_refaulted[type][i] +
>  				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
>  		pos->total += lrugen->avg_total[type][i] +
> @@ -4804,9 +4804,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
>  	 * This value is chosen because any other tier would have at least twice
>  	 * as many refaults as the first tier.
>  	 */
> -	read_ctrl_pos(lruvec, type, 0, 2, &sp);
> -	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
> -		read_ctrl_pos(lruvec, type, tier, 3, &pv);
> +	read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
> +	for (tier = LRU_TIER_MIN + 1; tier <= LRU_TIER_MAX; tier++) {
> +		read_ctrl_pos(lruvec, type, tier, tier, 3, &pv);
>  		if (!positive_ctrl_err(&sp, &pv))
>  			break;
>  	}
> @@ -4827,8 +4827,10 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>  	 * Compare the sum of all tiers of anon with that of file to determine
>  	 * which type to scan.
>  	 */
> -	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
> -	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
> +	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
> +		      swappiness, &sp);
> +	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
> +		      MAX_SWAPPINESS - swappiness, &pv);
>  
>  	return positive_ctrl_err(&sp, &pv);
>  }
> 
> -- 
> 2.55.0
> 
> 
