Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342163D810D
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 19:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784835734; cv=none; b=c0PM9T3umyCOpQDUoQ5c9yb7k6F1S8c/23XkSjEyvdB/wHqiMDJFIIgw5VCkHUT1kjknr7S12YF7rWBGOGr9rcVLSYVi2r8WFOcE3JUslh8J13/2rWLQl69vITr/CGCAxTqq2Y6xivs0F1AqckcZgNJXpqvooEYV7aUV7evbi/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784835734; c=relaxed/simple;
	bh=GtD7Oj5CcoPkSzs2QFufqHCJi8oQqvyBjCE+T+F6aY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YSxZ2yz1uDs8jH8A6H7eAx9L6simw1elMGFrgPWlDeqNtge7frs22Svc5jrzAWsjHutSBYrqtO4We9vW26p8euQc4IKPGAr6UK7CUxmmWKcDoASbk6J4Z7c7+a408CBiUdbsuOcS8uSQ6KQi/7Qgpj3ZZRr0MdbBFVZQFb8045I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fud2iX/u; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fud2iX/u"
Date: Thu, 23 Jul 2026 12:41:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784835710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K2dpb7jWuPRitxlaV2YlTpHdd3fdOnLFqMv+siPkyhY=;
	b=fud2iX/uEPMDQW21ivxz6dX4hnscjMV6U/qz9xRug/rczHrbkmHEdPhtZNHjKahxBOSmXK
	q6lsUaz58aBOe16dDPNNciOejdH+KFujrmiHgJmCvK/fMEmgWdzErisoR9SK2x1+QhagH4
	ZrV9HmFTGzsQG6XJqEolEeFO0NEFScY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, chrisl@kernel.org, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, rientjes@google.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 1/2] mm/vmstat, mm/memcontrol: add _monotonic vmstat
 readers
Message-ID: <amJuV2zHAPYge56_@linux.dev>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-2-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720164207.450685-2-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 20, 2026 at 09:41:22AM -0700, Usama Arif wrote:
> lruvec_page_state(), node_page_state(), and global_node_page_state()
> all clamp negative reads to zero on CONFIG_SMP so that a transient
> per-CPU delta skew presents as zero pages rather than
> as a garbage unsigned value. This is the right behaviour for
> non-monotonic page-count readers.
> 
> It is however incorrect for callers that snapshot a monotonically-
> incremented event counter and compute a delta from two samples.
> Once the underlying signed long wraps past LONG_MAX, the clamped read
> drops to zero while the previously-recorded snapshot still holds the
> pre-wrap value; the unsigned subtraction then underflows into a
> ~2^31 spurious delta for 32-bit architecture and corrupts the
> caller's accumulator.
> 
> Add non-clamping siblings that return the underlying state value
> cast to unsigned long:
> 
>   global_node_page_state_monotonic()
>   node_page_state_monotonic()
>   lruvec_page_state_monotonic()
> 
> With both samples read via the _monotonic variant, unsigned modular
> subtraction stays correct across a signed-long wraparound as long
> as the true growth between two samples fits in unsigned long
> (< 2^32 on 32-bit, < 2^64 on 64-bit); the 32-bit bound is the
> practically-reachable one that motivates this helper.
> 
> The variants are only safe for monotonically-incremented counters.
> Non-monotonic page-count readers must keep using the existing
> clamped helpers so transient negative reads still present as zero.
> 
> This is a prerequisite for the following patch which
> replaces the producer-side anon_cost/file_cost accumulators with a
> read-side accumulator in prepare_scan_control() that samples
> monotonic per-LRU vmstat counters (PGROTATE_*, PGRECLAIM_PAGEOUT_*,
> WORKINGSET_RESTORE_*) via lruvec_page_state_monotonic() and folds
> the unsigned modular delta into a per-lruvec cost_accum[].
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
