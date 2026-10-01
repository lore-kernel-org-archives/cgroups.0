Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AE831E106;
	Thu,  1 Oct 2026 12:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790857149; cv=none; b=K4Wmrih2/SucxgTI4PYIekEHZkZQ3H415xB3WUVKw9Gz0Nd2W9Q/NAQ2/GY0DSpla+Ebz7+MG1p4JKXZ9JW0Nm6ICKv5fjOyGXutn1Z/JNQVF1D+RHCUzYze4FYK5yOBbpE/WgMxA2zx/NiP04TP+4yO637dcHUXf0UYsqPC4w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790857149; c=relaxed/simple;
	bh=L2x4F+RZepP9Ibzqqt/hat84vnlTSP8mV9e6KOzkB/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pkiOIvpNT+8nPPaxf8nwGfkL4700WysfCy0bIMR+UqgmqrR6TEY995iLIgLGxdFKQpxsWDK3WokIOIjzdIbHn6JtYFexkCx9VNTwuw33ZVEJMlWxo4WwiMoFqXf5Xu1nma3IMf9kopbfvvgnNwsq5jaXN1AT3f1aB+13EGc936k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OiPIkXFh; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OiPIkXFh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7xQHNY097cBtbkyro3E4qxSO+Gg+rAp0ETijwlM2SaY=; b=OiPIkXFhwRsB7f4czffZ0jIZlm
	MCegJdLQMkRCITcBPZnjFi+xdFJmNsNYnkZ9B4CHXl8n/ymjc5GGKywxn+HO8CUzgI4tyswsKvAqG
	IEyk1gdrEjJcyNNll0GXiOdPIz5+009/vS4jAKYGN/PZVHPDP/KfEHnFARdHdAzaotCRe7FHa03Ox
	w4x26e8bbZjFvBTInTMYBT4reQytBaZGcobnOqemIzcSVXJhMp+X6GhTYVW5Lmy/4lvxbBJyn/kM8
	JG5Hsrb89Bs24SboJ23d6HZHCLw5zeztahs1xSuG6b0YPmq/plhVBaGeh66+OVKS56EtawE8lKtqS
	bkU1HZPQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1xCFkK-00000004xMh-08zf;
	Thu, 01 Oct 2026 12:18:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1EE53300578; Thu, 01 Oct 2026 14:18:42 +0200 (CEST)
Date: Thu, 1 Oct 2026 14:18:42 +0200
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
Message-ID: <20261001121842.GJ4121620@noisy.programming.kicks-ass.net>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
 <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001105909.GL4121339@noisy.programming.kicks-ass.net>

On Thu, Oct 01, 2026 at 12:59:09PM +0200, Peter Zijlstra wrote:
> On Thu, Sep 24, 2026 at 10:28:10AM -1000, Tejun Heo wrote:
> > Hello, Shakeel.
> > 
> > On Thu, Sep 24, 2026 at 11:47:04AM -0700, Shakeel Butt wrote:
> > > This series lets a kernel thread say which cgroup it is working for.
> > > That cgroup then sees the CPU time in its cpu.stat and the stalls in
> > > its memory.pressure, and the CPU time comes out of its cpu.max quota.
> > > The first user is the memcg reclaim that runs from high_work.
> > 
> > This doesn't translate to net rx, which is another major source of
> > displaced CPU usage. Switching membership on each packet isn't going to
> > work there. Attribution can't happen that way. We'd much rather count
> > per-cgroup received packets and prorate the CPU consumption. If at all
> > possible, I think it'd be better to adopt an approach which can cover
> > both use cases.
> 
> Ideally RX would be split for each network queue, rather than lumped
> into the one giant softirq that nobody owns.
> 
> I know PREEMPT_RT has been wanting something like that for ages. Not all
> queues are created equal. Some might want RT priority while others
> should definitely not.
> 
> Furthermore, without ingress throttling, your RX back charge could
> completely deplete the actual cgroup time quota.
> 
> Anyway, if you get per queue RX processing threads, then you can move
> them into cgroups where so desired.

Gemini is trying to tell me this exists and is called Threaded NAPI.
