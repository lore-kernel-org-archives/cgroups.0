Received: from mta1.migadu.com (out-145.mta1.migadu.com [95.215.58.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232004DA9CA
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 21:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790284266; cv=none; b=AS6XTY5Qi5ljdPM9e43PQSgnBprADIPE4oDCgK1MzskCKozmRkUGH4oSeFLSxZUQgxlUOzhSTXQCp98SwWAxT6/93x+AKkhpmA/G+N1wswRmj6qY19X6p1poke4IyBYhoF6LbLDATHdpdSJq4vOJNowrE1aHyiCfMVPFVYeESh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790284266; c=relaxed/simple;
	bh=geWEgMSYQDaXHL8PI+SwL20O2XP2TtLwPQS9ZQiVmS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESu2FwCKGW2b40bbs5w6MDVj8X0p9q/8qBHlBZqecO8LO6OeSykwJo0o6XCdv5Vj97anVnWOq+5rUtargBrlG2MFAvUMIrO7sr50s6lYNBhuZVG1hsIDe3OQoK3ckW+scqrRBdRqJqh8z/zT+PXcB4/EhCT3tjsja3zreX1ptbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Eeh4tDSK; arc=none smtp.client-ip=95.215.58.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Eeh4tDSK"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=geWEgMSYQDaXHL8PI+SwL20O2XP2TtLwPQS9ZQiVmS0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790284262; v=1; x=1790889062;
 b=Eeh4tDSK23G+TbvqhrDIDogpAxLZ6xsTOdlLHlKDetZUvHYMlAb3Ik1/Ut9G4V0OpLuS3y0m
 tmLn0/6MzpnzE+zUdW0zakrd9SIewOskKFysWTXFiUgIYljj4C4UMB51spUhO9DV8AYOc1SNMmb
 p165Nm7nJOoKWTlpRoaGar18=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id de8f8ffe1b04012f;
	Thu, 24 Sep 2026 21:11:01 +0000
X-Mizu-Trace-ID: de8f8ffe1b04012f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 14:11:00 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Peter Zijlstra <peterz@infradead.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Frederic Weisbecker <frederic@kernel.org>, Aaron Lu <ziqianlu@bytedance.com>, 
	Daniel Jordan <daniel.m.jordan@oracle.com>, Hao Lee <haolee.swjtu@gmail.com>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
Message-ID: <arWLq4p488JPhuZ1@linux.dev>
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

Very good point. I think we need to think for net rx for two scenarios. First,
the modern NICs with rx steering support and second, old NIC with shared queues.

On the modern NICs where the workloads get their own rx queues, I think the
proposed mechanism can help to do the accurate accounting (I have to extend this
to softirqs as it is limited to kthreads atm) very easily.

The challenge you mentioned is for the old NICs where we get to know the cgroup
assosiation of the rx packets very late (or deep) in the stack. Also CPU spent
on each packet is not necessarily uniform (due to out-of-order or drops or
checksum errors or window shrinking) but for simplicity we can assume uniform
CPU. Maybe the right place to charge for such scenario might be at application
receiving those packets into the memory. I feel like we might need a very
special way to account for this case (maybe through BPF or something). At
the moment to me it seems very hard to have a universal solution which helps
this case and the reclaim case I am targetted.

If you don't mind, I think having solution for modern NICs i.e. dedicated rx
queues, should suffice for now (unless you want the solution for old NICs as
well). Let me know what you think.

> 
> >  - The debt is capped at one period's quota, so one long piece of
> >    work cannot starve the cgroup for long. Time over the cap still
> >    shows up in cpu.stat. Writing cpu.max or cpu.max.burst clears the
> >    debt.
> 
> I don't like the debt capping. Having debt doesn't have to mean that
> the cgroup doesn't get any bandwidth at all. The cgroup just needs to
> be slowed down enough that the generation of new work is throttled and
> the whole thing doesn't go out of control. IO control already does
> this: when IO debt is accumulated, userspace is heavily throttled, but
> not completely stalled, until the whole cgroup's consumption comes
> under control. I don't see why the debts would need to be forgiven
> unconditionally. The cgroup can keep paying them while running at a
> minimal rate to avoid triggering stall failures, and if the situation
> doesn't resolve quickly, that will most likely trigger pressure based
> kills in any reasonable setup anyway.

Sounds good, I will remove this capping in the next version.

Thanks for taking a look.
