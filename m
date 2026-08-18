Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7F836A350;
	Tue, 18 Aug 2026 09:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787044632; cv=none; b=aQJbB9ZLZ4rqoZZg/CRfEI7SgkGUcJGuKGeDLol0d8NEHFkVyBmZeMCfgYgNx1taL/ewn9ZWsHP+T7X6daPufhSYx3enHWDaFhN0kAilzXjo8nJb+yTDne6AvXa3avRC8qYhVLbnJrLnt69UvmuxQN7v5rUmu0BdGMFPfe75+c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787044632; c=relaxed/simple;
	bh=aMv+DE1EHZhlEokvsi/BNhUR7R7jYSbLz+asZcM7YN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwCFH5yAh90oEW31AcCNROr7aTr9Ny+1K+JlVVyrAmZZiIeIG3eA94WI6zroKI75dYpFfovM7Ld2pEwcxKn+hoo7ql8WpXJPO5gAIi5PckAd7MTTYac7Z+osgCKYnncVsH3C5YCwdU4uLf0jXzUyB36cTtbk3TShAi6dtcGSZbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mDXf7SJe; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mDXf7SJe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tF7YMh/p89wieg50jl8yz5w6+JR0I01dP/EgDEvrwuE=; b=mDXf7SJewioIPIncIcFGrW3ND/
	vQHXedDGTWV8dP56JqNLcxIhrxY7gizwk2rS+Qtd/AiNzDn01/GevtYL//feUfC+KaUZ6bX5gtCnJ
	0NvP3+bwTbqBcsaZhKlrYAmgKTSQfZt+11nMZRi72DEohTmwxl1OQN5D6GNNQOG4kEpuJzAd4t09X
	BfSMj7WyfqU/Lfz5ERqmkPanvjetqj87jTNRgVeqelzuN2lqSq10UCt3L7zb0CbXgXI64annKXNfY
	nPXkwV2ATMffX8QbsjrDI/AzMnT1hUa8/J4WbFlJTcTDSlCz+IHNMea4CJbfMDqI7IeUod2pE9kRp
	UiUHdMQw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wwFwB-00000001VJu-2G9e;
	Tue, 18 Aug 2026 09:16:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C110D300244; Tue, 18 Aug 2026 11:16:49 +0200 (CEST)
Date: Tue, 18 Aug 2026 11:16:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Szabina Korbai <szkorbai@linux.ibm.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>, mingo@kernel.org,
	longman@redhat.com, chenridong@huaweicloud.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, jstultz@google.com,
	qyousef@layalina.io, euan@linux.ibm.com, huschle@linux.ibm.com
Subject: Re: [PATCH v3 0/7] sched: Flatten the pick
Message-ID: <20260818091649.GC1247881@noisy.programming.kicks-ass.net>
References: <20260605105513.354837583@infradead.org>
 <fecf5eb215b4b86bec11ca47eb6b5b17f5e0fea5.camel@linux.ibm.com>
 <d690a668-7bb2-4cd1-a229-295e556d4f28@amd.com>
 <ef9f077a6faafc747b3e144400dd3f5ad10e8e0a.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef9f077a6faafc747b3e144400dd3f5ad10e8e0a.camel@linux.ibm.com>

On Tue, Aug 18, 2026 at 10:04:57AM +0100, Szabina Korbai wrote:
> On Mon, 2026-08-17 at 22:05 +0530, K Prateek Nayak wrote:
> > Hello Szabina,
> > 
> > On 8/17/2026 9:35 PM, Szabina Korbai wrote:
> > > Hello Peter,
> > > 
> > > We ran the same benchmarks (schbench, sysbench, hackbench) as
> > > Shubhang
> > > has on s390 on an LPAR running fedora 43 with 32 vCPUs.
> > > 
> > > We ran the benchmarks for each of the cgroup modes, and for the
> > > baseline, we chose the commit prior to the patches (f666241e6bd5 -
> > > sched/fair: Unify cfs_rq throttling via account_cfs_rq_runtime() ).
> > > 
> > > We have also tried running stress-ng in parallel with the
> > > benchmarks
> > > (set to generate 50% or 90% utilization for each vCPU).
> > > 
> > > Compared to simply running the benchmarks on their own, this has
> > > revealed some performance trade-offs that the move to a single
> > > runqueue
> > > can introduce.
> > 
> > Are you using tip:sched/core at commit 68e3748781 ("sched/fair: Fix
> > flat
> > hierarchy") for the flat_cg numbers or did you checkout at
> > 85570f10a4c6
> > ("sched/eevdf: Move to a single runqueue")?
> > 
> > There are a couple fixes for vruntime update and Vincent's
> > optimizations
> > for preemption bits which might make a difference to the overall
> > results.
> 
> 
> Hi Prateek,
> 
> thank you, that's a good call. I did checkout at "Move to a single
> runqueue". Let me try it with the fix included, see how the results are
> affected.

I've not yet managed to digest your various benchmark results, but also
double check that patch 6/7 from this series is not to 'blame' for the
some of the changes.

The 0day robot fingered that patch for at least one issue.

In that case the benchmark threads ended up 'heavier' than before, which
resulted in less preemptions. Probably ksoftirqd getting ran less and
causing a regression in network throughput for that thing.

I did suggest trying to change the slice of ksoftirqd down, such that it
might be ran more readily, but I'm not sure that ever got tried.
