Received: from mta0.migadu.com (out-244.mta0.migadu.com [91.218.175.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B8D21CC5C
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786982668; cv=none; b=NvsCy4r5x9EF1xtVRJC4tabnmK9d6sMgtbEoaShwzfc0vqQ8wb4r1eKXfDPMiDweMJDFhCDq67kEO6R9grmWFpGZSFpNA9TESC4TJW0ClP3v9+p9jWhfj48qyqy9CBBrRgCg2mP33B0bm2/TlZpYFlBFi+vM3kbGJFOa/Mi6jFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786982668; c=relaxed/simple;
	bh=SjbR/PgkZJDP5BslDAQ5jDOl6LqPclZDfgrCJIHFSoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZUAri6PKDlYiLeYjzYqt2MjdVRSLkLnwVj+izGCj7h+HbhnaMjWyGrmBKoP7iNGNuFoa648p5CgcEFldOM5hMBaw+BYt5erRcozfsqvlKyHtmXHAtEn97otbfgsJfMBjfk4VgcIhYADAl2xew8hdR5JTh+noXjh9H891S3humJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q6GDh+eB; arc=none smtp.client-ip=91.218.175.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q6GDh+eB"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SjbR/PgkZJDP5BslDAQ5jDOl6LqPclZDfgrCJIHFSoo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786982664; v=1; x=1787587464;
 b=q6GDh+eBCm+kWE8Uz+mzm0jcNG/ij3QPcfwPu9KuLFB7eDnHb2Ebs1CauCm2IpS1vEeeaseL
 OE48io6WE6RAtPfCRZI4sd3sA+CXcQDkEFH1I6qZGyvmK8PuJB+9bXuIjmvpuJNOmv7Q7UBburd
 bzs6+SyBOxk4kTDzUuDE3W6s=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:2a::)
	by smtp.migadu.com with ESMTPS id 68c5ea4acd3a7bb7;
	Mon, 17 Aug 2026 16:04:24 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 09:04:18 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, nphamcs@gmail.com, yosry@kernel.org, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in
 obj_cgroup_may_zswap()
Message-ID: <aoMvtKr6o8a6KpDf@linux.dev>
References: <20260817131843.45121-1-husong@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817131843.45121-1-husong@kylinos.cn>

On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> obj_cgroup_may_zswap() runs on every folio swapped out through
> zswap.  For each ancestor with a non-max zswap.max, it flushes the
> cgroup rstat hierarchy synchronously with force=true, which skips
> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
> with zswap.max configured, a container takes the global rstat lock
> on every swapped-out folio.

Any reason you are limiting zswap through zswap.max?

> 
> zswap_shrinker_count() had the same pattern and switched to
> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
> where the same flush on the shrinker side showed up at 2.88% of
> kernel cycles under osq_lock on a 96-core machine.
> 
> Measured on a KVM guest with a swap storm under a cgroup with
> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> before the patch and 198,968 times after, while
> __mem_cgroup_flush_stats() was entered 281,017 times before and
> 80,445 times after.  The removed 200,572 flushes match the store
> attempt count almost exactly; the remainder comes from other stats
> readers in the swap path.

This is a known issue. Using ratelimited interface also comes with a drawback
that the kernel may react on stale information and the consequences might be
unneeded oom-kills.

There was orthogonal discussion on moving zswap limit enforcement away from
rstat. Yosry, any updates on that?

> 
> The stats can now be up to one flusher cycle stale, so zswap.max
> admission can overshoot for one cycle in a storm; the overshoot is
> corrected as soon as the next flush lands and later stores see it,
> the same tradeoff the shrinker side made.
> 
> Fixes: f4840ccfca25 ("zswap: memcg accounting")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/memcontrol.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..7a8f689055c6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6000,8 +6000,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
>  			break;
>  		}
>  
> -		/* Force flush to get accurate stats for charging */
> -		__mem_cgroup_flush_stats(memcg, true);
> +		mem_cgroup_flush_stats_ratelimited(memcg);
>  		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
>  		if (pages < max)
>  			continue;
> -- 
> 2.43.0
> 
