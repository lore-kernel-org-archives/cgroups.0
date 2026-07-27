Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B19E424655
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 16:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785170007; cv=none; b=c4PDwM4RqUa5VC3IQjpWvp4R/lshuUPK5vCSsZ0kkCznLUoLPzjEI+1aOFS3nHZdvlGLxpQbh9pv45Zo+YAT2L/JAFs3HxAiifOgYWbWr3pFiXvMadMBfDzM5IzXLWCfKqDl4Y1KlJbd0veKvMdvBEscvEO25zVAv3NsH+SN9RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785170007; c=relaxed/simple;
	bh=8boHWbVQUJRFBogqC4sD7gcx1KMts7ioP/1zhtvOFSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=snVvpSP4H/wTGT4qtZoVkMxPfLthBsoP70Uy9cWuH04bhp+m57UTuD3o+fQRfxav4MgeZ0dOwuU1tSoIYnOlbnN5A9Dfc3jEQh9H74r8M7UHMOioHOAe2ccCsk/EQcawsdjirn43uaDp1+7p1gVlSYgkQo55w1x9wdLkRd2cAUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jESuRiPo; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jESuRiPo"
Date: Mon, 27 Jul 2026 09:33:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785170003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r7p+ZCLHsjU7FD5y18hGGBqxYxk6OAoh5PtbY3fZhP8=;
	b=jESuRiPoeVX6ZNM15A2AjxXrgXIRlQ4VOn4ctaxD104FNGt+l6AjMpGCxkwBBsxegyj6WI
	7gMcbjV7fXwcVJlsYA3khuDEyTcYGf7Qy12XYsOWLFi2goTz0wp7PoKQajOkyqxkHweLbm
	EuqTmYuVzACEx2Ew22SU6SUCuR8ejvI=
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
Subject: Re: [PATCH v5 2/3] mm/vmscan: add pgrotate_anon and pgrotate_file
 vmstat counters
Message-ID: <ameIMBqJPeF-Wi8J@linux.dev>
References: <20260727162550.2032-1-usama.arif@linux.dev>
 <20260727162550.2032-3-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727162550.2032-3-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 09:23:24AM -0700, Usama Arif wrote:
> Reclaim can spend substantial work on an LRU type without immediately
> reclaiming or demoting a corresponding amount of memory. Record this
> work in PGROTATE_ANON and PGROTATE_FILE.
> 
> For classic LRU reclaim:
> 
>   - Inactive-list reclaim adds nr_scanned - nr_reclaimed to the
>     corresponding anon/file counter when isolation succeeds.
>   - Active-list reclaim adds referenced executable file folios that
>     are retained on the active list to PGROTATE_FILE. Active anon
>     reclaim does not contribute this component.
> 
> For MGLRU, add the number of initially isolated pages that remain
> unreclaimed after both the initial and retry passes to the counter for
> the selected anon/file type.
> 
> These counters are distinct from the existing pgrotated vm event.
> pgrotated records an actual move to the inactive-list tail, primarily
> after reclaim-marked writeback completes or failed invalidation leaves
> a folio for accelerated reclaim. PGROTATE_ANON and PGROTATE_FILE
> measure reclaim cost and do not imply that a folio moved to an LRU tail.
> 
> A subsequent patch will consume these counters for anon/file scan
> balancing.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
