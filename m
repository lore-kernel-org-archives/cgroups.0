From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Wed, 18 Jul 2018 18:06:23 -0400
Message-ID: <20180718220623.GE2838@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180717150142.GG2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wu822VWfbxTbIiJttkXqPEdGO8iaFFkoHKb0MR6LUhQ=;
        b=GJhavJ1CI0+lP0q3vonS3J1NpNHq1O0CDD50W8RtXWgK4ObbI+Qy65zeAny1IoopKz
         v2ufUHT03j4UlOJ0suI5T9mNRHmb9JggsFTdW3mwvtvmfBcYAY4j/eDflE6K1HkNnlcU
         uaIwZZ6AqIekkTX8a3jmHWli+PO64rvro6ZmvO6MhmKMvvuRInQuHEfV1cbZHUuvCcqX
         mgaSYVygsyr+VTBMJBBYg+SsxPDPb/Zv3xU41Q/fCuPtjgjtJdEStOQ+uhHE5jJcZ2p5
         DSS/VyrFd32GjrxEGrRJ2LHiAbNkKwU1fQVsiaBPjc98XodWakZjcIal0EzvPnwwooaS
         oo9A==
Content-Disposition: inline
In-Reply-To: <20180717150142.GG2494@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Jul 17, 2018 at 05:01:42PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> > +static bool psi_update_stats(struct psi_group *group)
> > +{
> > +	u64 some[NR_PSI_RESOURCES] = { 0, };
> > +	u64 full[NR_PSI_RESOURCES] = { 0, };
> > +	unsigned long nonidle_total = 0;
> > +	unsigned long missed_periods;
> > +	unsigned long expires;
> > +	int cpu;
> > +	int r;
> > +
> > +	mutex_lock(&group->stat_lock);
> > +
> > +	/*
> > +	 * Collect the per-cpu time buckets and average them into a
> > +	 * single time sample that is normalized to wallclock time.
> > +	 *
> > +	 * For averaging, each CPU is weighted by its non-idle time in
> > +	 * the sampling period. This eliminates artifacts from uneven
> > +	 * loading, or even entirely idle CPUs.
> > +	 *
> > +	 * We could pin the online CPUs here, but the noise introduced
> > +	 * by missing up to one sample period from CPUs that are going
> > +	 * away shouldn't matter in practice - just like the noise of
> > +	 * previously offlined CPUs returning with a non-zero sample.
> 
> But why!? cpuu_read_lock() is neither expensive nor complicated. So why
> try and avoid it?

Hm, I don't feel strongly about it either way. I'll add it.

> > +	/* total= */
> > +	for (r = 0; r < NR_PSI_RESOURCES; r++) {
> > +		do_div(some[r], max(nonidle_total, 1UL));
> > +		do_div(full[r], max(nonidle_total, 1UL));
> > +
> > +		group->some[r] += some[r];
> > +		group->full[r] += full[r];
> 
> 		group->some[r] = div64_ul(some[r], max(nonidle_total, 1UL));
> 		group->full[r] = div64_ul(full[r], max(nonidle_total, 1UL));
> 
> Is easier to read imo.

Sounds good to me, I'll change that.
