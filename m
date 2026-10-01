Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B9C4052A9;
	Thu,  1 Oct 2026 10:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852373; cv=none; b=ME4OU926/abbA/RRUQysqAjOAp7VuuYTuEQCrPNtQMbR2RcZkLtXvSkwX3zQG+vcR97BSeMjqb1+axBqYGMa1tRQEDcwxINV2D0Bj0JhXcv9bDLcUiBaAet98g62D6LHfKtboIN86Dshn9K8l/ICa3pff2RXZJrQkah+bO8snkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852373; c=relaxed/simple;
	bh=P2mPmdSeN7M/92lKbHc68p8T0hLOu0rZMNpkrr+Q7S8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+TuZH63WJEWulYv8TyEPyfMO52YboAKb8OEW4wPGvPhfhx2hnjUUhe/Z99/eionTomHcNG/V7g5SfyFNeAZ3vQ7lKhrfz3QU8bj4ZfQ4x/4k1KcPWTqasdDCT9EqkKz6pXBlCAtCdiP9aODUSVaJZzPmnAq80W+W51R9PRIyw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LCl1OI8l; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LCl1OI8l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MXA2KDE32vmEL8dBfumYlL+dA+/j3dJ1ohxuDqggpGk=; b=LCl1OI8lRvcv+outLHBWL9A2bo
	DG5ITJUiFjfuw/CEH5vbNjtI/P+BGLUvwXGLDA3jC0T340gY/Wk7k1gpkQvW1Z70RfVbhOYmCo3xw
	AQrPBZuoPECelcO87vpNBk1zQqZk4sUCEzOkgiymVqQuPddoPjUy5oK3h0Qme/AB7rJNngceuc7hq
	SpH7CHPQ+yTaxLRhMOeVVPTVIV3l0euLPDh5NhuMo38PzhWMuEE+tFR7wdSAxCvYvgzjUDCfjyRZJ
	2Vfd5RXX1oJ8sfOXd6TivgxG21zO1fScJ0vlE+bpH4aP4s6m55zck+Q/N8LB/P1cBonRI090dOtPd
	BxfbrTrw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xCEVK-00000006r8z-1WSi;
	Thu, 01 Oct 2026 10:59:10 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E81DA3001FD; Thu, 01 Oct 2026 12:59:09 +0200 (CEST)
Date: Thu, 1 Oct 2026 12:59:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>, kernel-team@meta.com,
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
Message-ID: <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <befc0a9b9998db0292c9998c639a3a9f@kernel.org>

On Thu, Sep 24, 2026 at 10:28:10AM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
> On Thu, Sep 24, 2026 at 11:47:04AM -0700, Shakeel Butt wrote:
> > This series lets a kernel thread say which cgroup it is working for.
> > That cgroup then sees the CPU time in its cpu.stat and the stalls in
> > its memory.pressure, and the CPU time comes out of its cpu.max quota.
> > The first user is the memcg reclaim that runs from high_work.
> 
> This doesn't translate to net rx, which is another major source of
> displaced CPU usage. Switching membership on each packet isn't going to
> work there. Attribution can't happen that way. We'd much rather count
> per-cgroup received packets and prorate the CPU consumption. If at all
> possible, I think it'd be better to adopt an approach which can cover
> both use cases.

Ideally RX would be split for each network queue, rather than lumped
into the one giant softirq that nobody owns.

I know PREEMPT_RT has been wanting something like that for ages. Not all
queues are created equal. Some might want RT priority while others
should definitely not.

Furthermore, without ingress throttling, your RX back charge could
completely deplete the actual cgroup time quota.

Anyway, if you get per queue RX processing threads, then you can move
them into cgroups where so desired.
