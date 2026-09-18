Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3792D73B6
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 01:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789694810; cv=none; b=bwR3+y3eSPkVPPWLwpXd7Uikbsu3O/DoJqY/V8RWJvwXPHqQjZ9Ttt+U0mrOahF0FoIGoIrfojZ5MOtIRfqg3EpWVCMuD/cxU2+uOjuXwbwy37KkX1XbfolQMFX3UngiyVaJG7CajOZkNo5V7L127YdlBV1cuA9Gck2nbLfW7kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789694810; c=relaxed/simple;
	bh=oAXUSIcwbHVGGoUnEEnCx3HqkvSgoi10RnBttKf8Nkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YoGWcKSqDKkcIYVXOssSCxnlnvjBI3GrKtruInmMKS5ah66yaNPFR3cgahcaoluonrHjJ/dfsjwxzujaZwve93tSYa81IxBhPChnZ5f6N6cnNPFCeJSK0Yrc38qlZuPQd8JCawXDGLOwVR5pqD7SFAtW+6HK61o3Rx6K3OYj+iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SRrNqewI; arc=none smtp.client-ip=91.218.175.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SRrNqewI"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oAXUSIcwbHVGGoUnEEnCx3HqkvSgoi10RnBttKf8Nkg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789694805; v=1; x=1790299605;
 b=SRrNqewI8RhBjZBR4vaR8VRxBo9X/LEEgzboE/AAj3BCNArHUKFRcZ1yF0Swv9wfVu45uBIv
 4243GhDL3+2dAmNJ8iSxLB3WMc8XNJgo08zoO3I0lkfgbs1tNulXC55xm2wjsipoaNDHs8QCFda
 bel5//SMyN1dYIDMWdTWPISg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1a7595a3d0729dc5;
	Fri, 18 Sep 2026 01:26:45 +0000
X-Mizu-Trace-ID: 1a7595a3d0729dc5
X-Migadu-Flow: FLOW_OUT
Date: Thu, 17 Sep 2026 18:26:44 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, xlpang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, chris@chrisdown.name, kasong@tencent.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: memcg: don't hand out large folios above
 memory.high
Message-ID: <aqx5kcqRrbkuay4i@linux.dev>
References: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
 <20260915042546.279410-2-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915042546.279410-2-qinyuntan@linux.alibaba.com>

On Tue, Sep 15, 2026 at 12:25:46PM +0800, Qinyun Tan wrote:
> memory.high is enforced on return to userspace, and synchronously in

Over time I feel like this sync throttle for memory.high was a bad decision but
that is an orthogonal discussion.

> try_charge_memcg() for large overcharges, but only when the charge gfp
> allows blocking.  A populate loop - mlock(), MADV_POPULATE_*, any
> GUP-driven population - never returns to userspace, and large folios are
> charged with the THP allocation gfp, which does not allow blocking under
> the default defrag=madvise without MADV_HUGEPAGE, nor under defrag=defer.
> So neither runs: usage grows from memory.high straight up to memory.max
> with no reclaim and no penalty sleep.
> 
> mlock(200M) in a cgroup with memory.high=30M and memory.max=140M.  Of the
> 110M between high and max, the burst consumed:
> 
>   4K pages                       3M in 5s, then still throttled
>   THP, defrag=always             6M in 5s, then still throttled
>   THP, defrag=madvise          110M in 13ms, then OOM killed at 16ms
>   THP, defrag=madvise, patched   3M in 5s, then still throttled

I don't really like polluting non-memcg MM code with memcg internal details.
Let's first discuss the semantics we want here. Please tell why getting
oom-killed by kernel in the scenario you have described (mlock() larger than
memory.max) is wrong. How does throttling it will help? What can the external
observer (userspace oom-killer) do other than killing it? Or you are thinking
that the workload itself is observing itself and change the behavior (though
the big mlock one can't do anything).

What I am looking for is the real use-case you have for this case. Not
mlock()ing big chunk or creating a lot of unreclaimable memory and going over
memory.high. For example the reason I added the sync throttle in memory.high was
to implement a feature Google has in their internal kernel where a workload hits
its memory.max limit, kernel delays the kill for couple of seconds and during
that time, the node controller may decide to increase the limit based on the
memory situation of the memory. However even with sync throttle, we couldn't
reliably implement the alternative because applications there have thousands of
threads and there is threading library which keeps cloning more threads if it
observes threads getting throttled.

So, let's talk about some real use-case and then we can decide if throttling
makes sense here. If we decide to allow throttling in such cases, I would rather
do it in memcg code i.e. somehow inform memcg code that this is THP allocation
and can be throttled.
