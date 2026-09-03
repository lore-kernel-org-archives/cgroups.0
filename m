Received: from mta1.migadu.com (out-86.mta1.migadu.com [95.215.58.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E368F4E80A7
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788457885; cv=none; b=RwxJ/mihMORc4dG+xj6dwOOdRL1xaBiQjzrGjumyprGa+6xlqwopGwStWZIPS/e5osgUnDbIyhfIr2iU/m03QVQCD39C9n8Vd0X1a2s4Y9C3YZgCR9rr9YgH9b56A9zmzAUOcm3OKHKCmlhSk4MOUNLPzg7SAfh9tqBsa7QbhL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788457885; c=relaxed/simple;
	bh=Q76IA5wKfZVmQPtYRc+wwddVBWZgCaJsAP54HPFaqac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGDHE2k7hG3eVyWDpIqcVJuBg7ib82y7MaH+UyiNUGY49tBNXAH2+LC4rJIaRSpBvLvnL85O6UA0SNGjf3NP/+Gtg8jEmJhVuJTpAtPUE/dcNCh43nIQnYBrjcSdu68Kc9L6H1i6t0dbPQFTyfxmnM42gJTedAvkpdakMMORvD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hfl5XIDn; arc=none smtp.client-ip=95.215.58.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hfl5XIDn"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Q76IA5wKfZVmQPtYRc+wwddVBWZgCaJsAP54HPFaqac=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788457880; v=1; x=1789062680;
 b=hfl5XIDnO9tqeCkLXliayjUADfQtrvWt+83kmm0nyf4e00RNGgf3K32YLqyoQogjzXAFFQu+
 JHwRmJcCD6Pf+TgWFgtbVtsQZBGSS0iD3j9Ksec+5FfESEe8cJWY7i8u13ap22RXw3QDbH+etlW
 pZPM/5v2krwPlJ1G4VB56bpE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c3d49bd8c8bbf0fa;
	Thu, 03 Sep 2026 17:51:20 +0000
X-Mizu-Trace-ID: c3d49bd8c8bbf0fa
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:51:18 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: workingset: use lruvec_page_state_local() to
 count lru pages
Message-ID: <apmzXFZfMGas9RWe@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
 <e16dc5e411c1c5d95c4c4db6ffc789756362b867.1788169145.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e16dc5e411c1c5d95c4c4db6ffc789756362b867.1788169145.git.zhuhui@kylinos.cn>

On Mon, Aug 31, 2026 at 05:46:09PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
> which only the classic LRU paths maintain.  MGLRU accounts its pages
> through __update_lru_size(), which skips that array, so with MGLRU on the
> four evictable LRU lists are always seen as empty.  The shadow node budget
> (pages >> 3) then collapses to slab plus unevictable pages, and the
> workingset shadow shrinker reclaims eviction tokens almost as fast as they
> are created, losing thrashing protection.
> 
> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
> race this re-exposes on cgroup v2 is closed by the follow-up patch that
> redirects dying-memcg stat updates for all hierarchies.
> 
> Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Make this patch at the end (or after 2nd) of the series as it is only correct
after the 2nd patch of the series.

> ---
>  mm/workingset.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/workingset.c b/mm/workingset.c
> index f351798e723a..85a4e14e95d5 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -693,10 +693,9 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
>  
>  		mem_cgroup_flush_stats_ratelimited(sc->memcg);
>  		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
> -
>  		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
> -			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
> -
> +			pages += lruvec_page_state_local(lruvec,
> +							 NR_LRU_BASE + i);
>  		pages += lruvec_page_state_local(
>  			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
>  		pages += lruvec_page_state_local(
> -- 
> 2.53.0
> 
