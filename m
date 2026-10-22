Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792709432;
	b=KoPh4aeL1QIF9EXDhs8RwCQVF9W9fSOzrbenY7+CdEEJUzlHK15kLU8Qvj6psp0TJzYv
	 WQvJug7P981g0WqGzST52CaQKTLPLRpViNzviBiffeBQN4dPqPjwBUQZZQyZvF4h98Bnj
	 HeMK945NBfQYQr2c7XJ3fvqSYBadpwl6ou0u1v6zKNml7Lo22A6GVeGV1cxGUzSsx0bKC
	 70JhDzxF4M0OYCeFJOK73G068MydDLJ9VwfqT3VlaWzMi60YcYZP1UXkqL3pF0247JtPh
	 Y80n7sXrWj3voRZXXhTi3eNVr1Edgd5E12gxtProKdfMmsWBe5WJANFEVwDYUDADCdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792709432;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=p8US3Njl6hx2/4kDUNZ/BNMckCrpYecKlAGjtmzYsKE=;
	b=hUWXBoHRrZe0b0u1Reqe5a48hKNqWoGQ1IVpyAd7E4o7yL2aHIC7ryMeDd4kMv1ZNSJf
	 EZAT96M+ka/vVXHui1BDO3NZE3TMkJvp2vhc/Xgq3ExrfvdT5dpmF9qDzOO1QN2dCp86t
	 ZH2qCiQOQiWYl2sAsWKbcVDfGRpNXcEDD5FBbpIBJaKGqGhDUF8O2OqOv+yWjJy9zPiYN
	 q8gtwWnj7tKx7H4ZRo0fPgjCqUwQ7THgeq45kiiFiqI86+LKSXVKa0tKRRTGn6NskhWhp
	 Hm1W8Y93999wxYoNWt8WozViysx+lZuDpINIZVuv6X57ADN0cEzwcT2xe3PCgdS8GJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gICNuPGD;
	arc=none smtp.remote-ip=95.215.58.8
Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E544606A31A
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 22:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E544606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gICNuPGD
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=z8N3xcKMxNTi1EWBslKB7dxo6vt+jRhpNiYdPAZnB1E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792709428; v=1; x=1793314228;
 b=gICNuPGDvueeF44RY5rIv2l9hF5zKz+KCTLb6vuE0E1M69p3c3zi5GEx05f6N4OepHg4ZaaZ
 CZ30RwxBX4cj4gjwC9Q+EtY5I3Mr/L0X04alkEpS0N4DsbULeGR1C39TSZlVLKOenRymIqhAeoC
 AIv5MouwP6ctDNGUnB2xIJxc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ea09b4d72e656f1e;
	Thu, 22 Oct 2026 22:50:27 +0000
X-Mizu-Trace-ID: ea09b4d72e656f1e
X-Migadu-Flow: FLOW_OUT
Date: Thu, 22 Oct 2026 15:50:22 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] memcg: reduce cacheline contention between lruvec
 stat updates and LRU lists
Message-ID: <atqSu4oxGogRaWSn@linux.dev>
References: <20261022223930.138779-1-joannelkoong@gmail.com>
 <20261022223930.138779-2-joannelkoong@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022223930.138779-2-joannelkoong@gmail.com>

On Thu, Oct 22, 2026 at 03:39:29PM -0700, Joanne Koong wrote:
> Every memcg lruvec (per-node) stat update reads the memcg and
> lruvec_stats_percpu pointers in the first 64 bytes of struct
> mem_cgroup_per_node. These updates are extremely frequent (eg these
> updates happen several times for every page that's faulted in, freed,
> dirtied, or written back).
> 
> The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
> on a different cacheline from the lruvec, but Intel CPUs do spatial
> prefetching [1] and fetch cachelines in 128-byte aligned pairs.
> Depending on where struct mem_cgroup_per_node lands in its slab, that
> cacheline can be paired with the cacheline holding the LRU list heads.
> 
> When this happens, every stat update also pulls in a copy of the LRU
> list heads cacheline, which is written to constantly by other CPUs under
> the lru_lock. The stat update has to fetch it from another CPU, which is
> unnecessary overhead since the stat update doesn't use the LRU list
> heads at all. But even worse, the lru_lock holder then has to invalidate
> those copies and wait for the acknowledgements to come back before it
> can do its next write, which makes the lru_lock critical section longer
> for everyone waiting on the lock.
> 
> This was found when analyzing the output of perf c2c for a benchmark
> where many threads fault in pages in one memcg. It showed the first 64
> bytes of mem_cgroup_per_node as the most contended cacheline (over a
> third of all HITMs and 5x more than the lru_lock cacheline) even though
> there are no writes to it. A quick experiment adding extra padding so
> that the cacheline no longer shared a pairing with the LRU list heads
> showed that this removed most of the contention, which confirmed the
> cause.
> 
> Fix this by moving the memcg_pn_cold group, which is only touched when
> the memcg is reparented or freed, right after memcg_pn_read_mostly, so
> that the read-mostly cacheline is paired with the cold cacheline
> instead of the LRU list heads.
> 
> Results from a multi-threaded fault/free benchmark in a single memcg,
> run on an Intel Skylake machine (80 threads, 2 NUMA nodes) with threads
> pinned to CPUs showed average pages faulted in (and freed) per second
> across all threads, over 7 freshly created memcgs per run:
> 
>                      before    after
>   shmem, 20 threads  4.74M     5.59M   (+18%)
>   shmem, 80 threads  7.94M     8.66M   (+9%)
>   anon,  20 threads  3.04M     3.08M   (+1%)
> 
> [1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf
> (bottom of page 62/800)
> 
> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/memcontrol.h | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 69e1bcc67c58..69ed283f7db9 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -95,6 +95,17 @@ struct mem_cgroup_per_node {
>  
>  	__cacheline_group_end_aligned(memcg_pn_read_mostly);
>  
> +	/* Touched only when the memcg is reparented or freed. */

Let's add a comment here why we placed this block here. Mainly about the spatial
prefetching intel CPUs do.

With that, you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

