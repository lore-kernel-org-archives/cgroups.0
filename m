Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF22371D11;
	Thu,  1 Oct 2026 12:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790858419; cv=none; b=jbZEEa1Q6eYW+ZJdOYA+mZCVQob/TNPUQmPgfrVuAfucf/LzGAcLxhmbf2eqqV+K8mrY3JG/QYtEtCbq6+lYRqqKuewooZl2Wcj+f7ZgEjaarTIPDjlMcqm+/tdd1yvT6mC+ybbzeyNPFtbW1P78636c3gt+B6EKzZoItFr5H/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790858419; c=relaxed/simple;
	bh=gLqblHCn0+YwQDfFcGJsfXpbJ0y+P7fK7Am4ryV7fh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKBXd2//4i2019NyO28x/0p8mvrk7CVrIucbN6tksiHScpZD90unLeWYBl/lxdxCg2zDDDEqyz14IJdpGECEhUWzPIOkJtlKdPRGBVkFtSNeXRbJmNcgXZleGQAPD/gvvgNC1fWhFwQVrIVKdNkOTywbF0D6i5AaqWvnzjiMdsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vNaTELMc; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=pAZafPjW; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vNaTELMc";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="pAZafPjW"
Date: Thu, 1 Oct 2026 14:40:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1790858415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1IYPn7YfrvPH70i6iIWikqwHZmBwJ1LMaRivmCTeR70=;
	b=vNaTELMcGtZilr3kGDKfaocYqzlhPhhj4xUL8tc8l010QOAzqE1gfbhxJxRwY/CJQP2iNN
	dHH9FpmfCdOtt3+N3ScPLclEH64H0HxXM0XyxMXuAR4+tua64mSsXSPvBxry0xTcvdbkgm
	KPRAZxR5XGVY81qLZ13LeTCgnXQJ8G/pcZnnyr1fQKL3ADxyj2/P+q44R5p5vwJEURPdve
	lDaLdKElLZTBjIqC6N6SL4+K/9BV7zd5iVpAb4rYcJyYrsh5EVPwtridKE5DW3m8G1VJLC
	Umo9drwa6UmjTEY4g0S+6CJYedQIHJzFOepjcyObBpIb6WpgFvmNXH1pzeKY4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1790858415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1IYPn7YfrvPH70i6iIWikqwHZmBwJ1LMaRivmCTeR70=;
	b=pAZafPjW5uf+ns5DVLvxgNdHgjcPnL7GKMJPYR3Qva+5gI6njuOLuPRYsAYBNuVlPHuNQB
	PI483XSZ/izTLNCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
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
Message-ID: <20261001124013.UZsWvi4g@linutronix.de>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
 <20261001105909.GL4121339@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261001105909.GL4121339@noisy.programming.kicks-ass.net>

On 2026-10-01 12:59:09 [+0200], Peter Zijlstra wrote:
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

What currently kind of works is threaded NAPI. The interrupt wakes the
NAPI thread rather than adding NET_RX to the global flag softirq flags.

I was thinking about making the softirq flags per-thread rather than
per-CPU. This avoid the "catch up" of other raised but unrelated
softirqs.

For now a painless setup is to have "bulk queues" and "real-time" queues
and what gets where is configured via hardware filters.

> Furthermore, without ingress throttling, your RX back charge could
> completely deplete the actual cgroup time quota.
> 
> Anyway, if you get per queue RX processing threads, then you can move
> them into cgroups where so desired.

Sebastian
