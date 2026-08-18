Received: from mta1.migadu.com (out-81.mta1.migadu.com [95.215.58.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902363AAF7F
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 03:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787023258; cv=none; b=dNqZwr8BixLpr87hvhgnK5OeLv66NljllE+5hX1fBcy4HNsimUERv8m0lpapeYwRPxUuLQdaiY9VqHjbl+I8leU/5LXv3E4pH9u7ReHkWONcwco1OnRxB3VYr7u9aj1W92xfEHplPmo0UuvtASBX80GvY276fqunO3LAMWXYSqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787023258; c=relaxed/simple;
	bh=on55ZWazHyqpPiNAdH4Wavq80fcxZiwVjhF0oygLLiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUzWNRsvTXbQCnSKTBjez4DdeRaRTVGGCJGVjJlisJwbB5YYZpVxu+pWRQHgm32iEJ4bMmg2fLjuPcBRnyLqnG6XZEfH7Ox9Z2DpMKRj6vJ0TqgRlwVopQRy9qUJMg0D9qnPjAkxeLiZNkB3z7v/E7or4nNnctdjlVUOD8M4o2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U6CE/Y+k; arc=none smtp.client-ip=95.215.58.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U6CE/Y+k"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=on55ZWazHyqpPiNAdH4Wavq80fcxZiwVjhF0oygLLiA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787023252; v=1; x=1787628052;
 b=U6CE/Y+kCX4sPAsQolZY/+3rwiw2FBQkHlU6uXUZJLghMHsnVZ0WZYe9lvWpdkXsS7Gl9OmN
 Caq9RakqNh8xx5nAqogjHsMK0FybdLyjFHf5/xF57tU3c8IDT9zDhmwt0/xlRBTtopFThKM/yvV
 TIn7jG1uYVztOgwQ1rnN1rVA=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 05ebf19c83237267;
	Tue, 18 Aug 2026 03:20:52 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 11:20:43 +0800
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
Subject: Re: [PATCH RFC 07/15] mm/mglru: move refault workingset activation
 into lru_gen_refault
Message-ID: <aoPPi1Y0a8umZuEX@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-7-4d8dad39dad6@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-7-4d8dad39dad6@tencent.com>

On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Move the folio_set_active() for refaulted workingset folios from
> folio_add_lru() into lru_gen_refault(), where the refault detection
> already happens.  No functional change: the ordering and logic are
> preserved in all cases, and no other paths reach the removed branch.

It doesn't explain or even mention why it doesn't matter to
discarding these two checkings.

!folio_test_unevictable(folio)
!(current->flags & PF_MEMALLOC)
> 
> This is a preparatory cleanup for MGLRU-FG.
> ---
>  mm/folio.c      | 6 +-----
>  mm/workingset.c | 9 ++++-----
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/folio.c b/mm/folio.c
> index f90b7f86dbe3..fab00cb02970 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -474,17 +474,13 @@ void folio_add_lru(struct folio *folio)
>  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>  
>  	/*
> -	 * For refaulted workingset folios, set PG_active so they
> -	 * can be added to active generations.
>  	 * For prefaulted file folios, folio_mark_accessed() sets
>  	 * PG_referenced so lru_gen_folio_seq() places them into
>  	 * the second oldest generation.
>  	 */
>  	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
>  	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
> -		if (folio_test_workingset(folio))
> -			folio_set_active(folio);
> -		else if (!folio_test_referenced(folio))
> +		if (!folio_test_referenced(folio) && !folio_test_workingset(folio))
>  			folio_mark_accessed(folio);
>  	}
>  
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 7ac2b88c80ae..5438e9390011 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -320,12 +320,11 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
>  	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
>  
>  	if (workingset) {
> -		/*
> -		 * see folio_add_lru(), where folio_set_active() is
> -		 * called for workingset folios
> -		 */
> -		if (lru_gen_in_fault())
> +		/* Send refaulted workingset folios to active generations. */
> +		if (lru_gen_in_fault()) {
> +			folio_set_active(folio);
>  			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
> +		}
>  		folio_set_workingset(folio);
>  		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
>  	} else
> 
> -- 
> 2.55.0
> 
> 
