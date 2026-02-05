Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A114331216
	for <cgroups@vger.kernel.org>; Thu,  5 Feb 2026 21:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327239; cv=none; b=me+9TIp9HxiT+j886EDjGOPv4HBxC8dvnGsGOTanzmERcBqyuNHJmCUZR5EID74ppcVs6hjiBYCxBbslvWtHH8n73hj7q9AIwUgLw1Y6hjN0RGfpxz8pZn8mni8uqwqNxmqq+0KhJLZPUdy6++MM6jWna0VzD0XxlmcXEqqA/wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327239; c=relaxed/simple;
	bh=QenuOkM5vCUH9qfZMONavaaNBnQ8vllRJg4GbuBpVbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=upH2mTkfjJl5UjESbeqxo9suRAG8owdlS4gfrkKFlAqHDNLU+A+DPccaToC6GHqZD+wsFD+twQ8kO3XJO08FbfBfft6EKIMVM/CXQlxNux7jPfwm15Z2LJdDA4iAe+LmfOfZ9k07RH9xNbH5q9PyheEowDSAwTPGu+ySXjI75Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KnjjFg3Z; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KnjjFg3Z"
Date: Thu, 5 Feb 2026 13:33:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770327236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+qpr3waIcmIzqz7i9F6KVzxWpJS3O2v0oEGwyPDl/Qc=;
	b=KnjjFg3ZoglQX/inTXLusN3966exuJUxp2WyryH2K3LXnD6N6OIeQHR3Qu5ALTGC0KkvfK
	LkUXJjI1jLCH0qdOoR1EXvIbk4bik6qKdIzt3l82icJgDAUj5Q4Aw3T6Gf9jrLlb/Gvm9Y
	5RA/xE3IcfAEvy1PHanFM9IFTKkBC7o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible pages
Message-ID: <aYUKpZ8nCB6MTQGY@linux.dev>
References: <20260205053013.25134-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205053013.25134-1-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 05, 2026 at 01:30:12PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> The global zswap_stored_incompressible_pages counter was added in commit
> dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
> to track how many pages are stored in raw (uncompressed) form in zswap.
> However, in containerized environments, knowing which cgroup is
> contributing incompressible pages is essential for effective resource
> management.
> 
> Add a new memcg stat 'zswpraw' to track incompressible pages per cgroup.
> This helps administrators and orchestrators to:
> 
> 1. Identify workloads that produce incompressible data (e.g., encrypted
>    data, already-compressed media, random data) and may not benefit from
>    zswap.
> 
> 2. Make informed decisions about workload placement - moving
>    incompressible workloads to nodes with larger swap backing devices
>    rather than relying on zswap.
> 
> 3. Debug zswap efficiency issues at the cgroup level without needing to
>    correlate global stats with individual cgroups.
> 
> While the compression ratio can be estimated from existing stats
> (zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
> "uniformly poor compression" and "a few completely incompressible pages
> mixed with highly compressible ones". The zswpraw stat provides direct
> visibility into the latter case.
> 
> Changes
> -------
> 
> 1. Add zswap_is_raw() helper (include/linux/zswap.h)
>    - Abstract the PAGE_SIZE comparison logic for identifying raw entries
>    - Keep the incompressible check in one place for maintainability
> 
> 2. Add MEMCG_ZSWAP_RAW stat definition (include/linux/memcontrol.h,
>    mm/memcontrol.c)
>    - Add MEMCG_ZSWAP_RAW to memcg_stat_item enum
>    - Register in memcg_stat_items[] and memory_stats[] arrays
>    - Export as "zswpraw" in memory.stat
> 
> 3. Update statistics accounting (mm/memcontrol.c, mm/zswap.c)
>    - Track MEMCG_ZSWAP_RAW in obj_cgroup_charge/uncharge_zswap()
>    - Use zswap_is_raw() helper in zswap.c for consistency
> 
> Test
> ----
> 
> I wrote a simple test program[1] that allocates memory and compresses it
> with zstd, so kernel zswap cannot compress further.
> 
>   $ cgcreate -g memory:test
>   $ cgexec -g memory:test ./test_zswpraw &
>   $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
>   zswpraw 0
>   zswpin 0
>   zswpout 0
>   zswpwb 0
> 
>   $ echo "100M" > /sys/fs/cgroup/test/memory.reclaim
>   $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
>   zswpraw 104800256
>   zswpin 0
>   zswpout 51222
>   zswpwb 0
> 
>   $ pkill test_zswpraw
>   $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
>   zswpraw 0
>   zswpin 1
>   zswpout 51222
>   zswpwb 0
> 
> [1] https://gist.github.com/mrpre/00432c6154250326994fbeaf62e0e6f1
> 
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Overall looks good but as Nhat suggested please update v2
documentation.


> ---
>  include/linux/memcontrol.h | 1 +
>  include/linux/zswap.h      | 9 +++++++++
>  mm/memcontrol.c            | 6 ++++++
>  mm/zswap.c                 | 6 +++---
>  4 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index b6c82c8f73e1..83d1328f81d1 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -39,6 +39,7 @@ enum memcg_stat_item {
>  	MEMCG_KMEM,
>  	MEMCG_ZSWAP_B,
>  	MEMCG_ZSWAPPED,
> +	MEMCG_ZSWAP_RAW,

Hmm I don't like the name though. How about INCOMPRESSIBLE or INCOMP for
short?

