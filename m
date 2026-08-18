Received: from mta1.migadu.com (out-126.mta1.migadu.com [95.215.58.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD9E149C7B
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 02:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.126
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787021541; cv=none; b=CAEmoC6UT6F/NkaIeOjoc/3SKm/PPgWuZLagvi/f4Y08b4/C1xwUcc5JPTwSxwSr09OaqdiUOKiNtVrITGi6O7NUGzELNvRIhbr4b2NawnzFFCjihjDs4v5/n+GNnuRtq6HWxv6wZLb/Mriy8BRnoHY9XRjtDIkBHhwCTDr68g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787021541; c=relaxed/simple;
	bh=+tjcYmM4+1lY/ufxesPT9Adlqs9FR04NAEFsPbm6s8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4b15E7dOwOpuu4raj6Dp21iYceCBEbjKn38+Ilf4F56dP/j6LEJDq1plI9OAIPcdhbC3kP22g4w65oEVmXy/scjrDNjGTcrsggfVpxwGu+agQcNJWwMV17JKSoiM1cTtXrA0VOikXsdqDwrWTyZoJiEHT45ZU/+mtAVZ9xWlwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SpY6/shO; arc=none smtp.client-ip=95.215.58.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SpY6/shO"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+tjcYmM4+1lY/ufxesPT9Adlqs9FR04NAEFsPbm6s8c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787021536; v=1; x=1787626336;
 b=SpY6/shOZ3utvqYsXQXYPFvHPOv51bEh6uJjaMySYjay6u1j3+cknzXzsrfUlK0/x6Q0DSa9
 9oYN+U75Mi8SLfb8gwmt7wzcMC6UJrT9cJXVP2e6JPatAoSTZ2MjkBeWuKTouvo+xhnCwp4IYAH
 ItZnps/mpdDhpqu4/H6ItHkA=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 9923006abc1b77f9;
	Tue, 18 Aug 2026 02:52:06 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 10:52:02 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 06/15] mm/mglru: use explicit tier range in
 read_ctrl_pos()
Message-ID: <aoPI0hlFe1uOPeFO@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com>

On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> read_ctrl_pos() encodes the tier range in a single "tier" parameter
> via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> as the end.  This is hard to follow or maintain or extend. Tier
> values 0..3 select a single tier, while tier == MAX_NR_TIERS selects
> the full range.
> 
> Replace it with explicit (tier_min, tier_max) parameters using a
> half-open [tier_min, tier_max) interval, which is the conventional C
> idiom.  The call sites become self-documenting:
> 
>   - get_tier_idx:   (0, 1) for tier 0, (tier, tier+1) for each tier
>   - get_type_to_scan: (0, MAX_NR_TIERS) for the full range

I agree with the complexity, while I am starting to like the original
style once I understand it. Maybe add sentences to explain it?

Anyway, leave this to other reviewers.

> 
> No functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c2ea92c2b69e..a359d5a1ff41 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3192,8 +3192,8 @@ struct ctrl_pos {
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
> @@ -3202,7 +3202,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
>  	pos->gain = gain;
>  	pos->refaulted = pos->total = 0;
>  
> -	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
> +	for (i = tier_min; i < tier_max; i++) {
>  		pos->refaulted += lrugen->avg_refaulted[type][i] +
>  				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
>  		pos->total += lrugen->avg_total[type][i] +
> @@ -4805,9 +4805,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
>  	 * This value is chosen because any other tier would have at least twice
>  	 * as many refaults as the first tier.
>  	 */
> -	read_ctrl_pos(lruvec, type, 0, 2, &sp);
> +	read_ctrl_pos(lruvec, type, 0, 1, 2, &sp);
>  	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
> -		read_ctrl_pos(lruvec, type, tier, 3, &pv);
> +		read_ctrl_pos(lruvec, type, tier, tier + 1, 3, &pv);
>  		if (!positive_ctrl_err(&sp, &pv))
>  			break;
>  	}
> @@ -4828,8 +4828,8 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>  	 * Compare the sum of all tiers of anon with that of file to determine
>  	 * which type to scan.
>  	 */
> -	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
> -	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
> +	read_ctrl_pos(lruvec, LRU_GEN_ANON, 0, MAX_NR_TIERS, swappiness, &sp);
> +	read_ctrl_pos(lruvec, LRU_GEN_FILE, 0, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
>  
>  	return positive_ctrl_err(&sp, &pv);
>  }
> 
> -- 
> 2.55.0
> 
> 
