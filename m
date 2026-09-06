Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890F586329
	for <cgroups@vger.kernel.org>; Sun,  6 Sep 2026 05:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788671143; cv=none; b=CSSA68LctnMY20+FEk6c5aIf/lvO3habj/pt14gbjjD0vo31GwovC+c56ANQnv6OALkwpAULcF+1USqgQH+eO5TK01qJysf5tO0xjUuiB2VNpCEbR6Aunb+Q8NpR9eGgPrBteeVD+y1pmsLnvDxtoFoGKdXV/ovyQcr7+5Cncbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788671143; c=relaxed/simple;
	bh=90c8t894CaHOARptfQVdz1/jF1xpxhRk1kEXilNjskc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skAS5DoCx1GpDuCwzPZ+t2Hxw+jYhR0cHaAXEN/R/Mso3BHxRbigaVqV+jaosMtGO0pS3og3mhqqyxFkZLAtnB9RfJJ004g4Wssxw6bG4T9wFleCeU7N2jFyBWwp8Pux/OLEQn+29Q+U8x+rMQ6abmpsGhUF43Wr9oL21GeapRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YLdvTY+B; arc=none smtp.client-ip=91.218.175.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YLdvTY+B"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=90c8t894CaHOARptfQVdz1/jF1xpxhRk1kEXilNjskc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788671137; v=1; x=1789275937;
 b=YLdvTY+BdhyNetq/FhXe4EJRfKs9DSQjDHNoaWd8l9uLh9kMqYxUOh+IO1tnDOxXrJjw3EGC
 lZabqH3rKazj6pm80QQRLvsFcYlYbxPQGySi9bvJEJakjd8zPRAtLhmno2C0r73+txoiF5K7J+E
 iOK0VDADYSR4rly3oQfumg3c=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1352ad230425d981;
	Sun, 06 Sep 2026 05:05:36 +0000
X-Mizu-Trace-ID: 1352ad230425d981
X-Migadu-Flow: FLOW_OUT
Date: Sat, 5 Sep 2026 22:05:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, yosry@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/memcontrol: skip non-hierarchical memcg-wide stats
 when v1 is unavailable
Message-ID: <20260906050459.GA80665@shakeel.butt@linux.dev>
References: <20260903215616.1456239-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903215616.1456239-1-joannelkoong@gmail.com>

On Thu, Sep 03, 2026 at 02:56:16PM -0700, Joanne Koong wrote:
> memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
> and event alongside the hierarchical one. The only readers however are
> the legacy memory.stat and memory.numa_stat, and reparenting on offline.
> All of them live under CONFIG_MEMCG_V1, and their accessors
> (memcg_page_state_local() and memcg_events_local()) are already compiled
> out with it. This means on a CONFIG_MEMCG_V1=n kernel, memcg_vmstats's
> non-hierarchical arrays are written to on every rstat flush, despite
> their values never being read / accessed.
> 
> The same holds when the kernel does support v1 but the controller has
> been blocked from v1 hierarchies with the boot param
> cgroup_no_v1={memory,all}. A v1 mount is refused in that case, so the
> legacy memory.stat can never exist and the arrays are just as unread /
> unaccessed.
> 
> Compile out the non-hierarchical memcg-wide arrays if CONFIG_MEMCG_V1 is
> not set. If it is set but cgroup_no_v1= has blocked the controller, skip
> updates on the arrays.
> 
> This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
> read-modify-write of ac->local[i]. Nothing else accesses state_local or
> events_local, so those cachelines were getting pulled in solely for the
> writes and they are separate from the ones the loop is already walking.
> 
> On an 80-cpu x86_64 machine with 500 cgroups each running a workload that
> dirties anon, file, dirty/writeback, slab, kmem, mlock, and reclaim
> counters, timing mem_cgroup_css_rstat_flush() in-kernel in TSC ticks per
> flush showed roughly
> 
>                          before   after    delta
> memcg-wide aggregation   1231     1180     -4.1%
> overall flush function   2452     2397     -2.2%
> 
> These numbers are from taking the median of 70 samples, one per 20s
> window on each kernel. The 95% intervals observed on the two deltas are
> [-5.41%, -1.76%] and [-4.53%, -0.14%]. The values above include the
> timing overhead itself, so only the delta is meaningful here.
> 
> Counting the items that actually changed, a median of 1.5 of the 77
> memcg-wide items (57 state + 20 events) had a non-zero per-cpu delta at
> each flush, which means the benchmarks above are with one or two fewer
> cachelines pulled in per flush. The count is low because the benchmark
> reads memory.stat in a loop to keep the flush rate up. For cases where
> flushes are triggered only by the 2s periodic worker, more changes will
> have accumulated between flushes, so more cachelines are skipped and the
> per-flush saving should be larger.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
