From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Tue, 21 Aug 2018 15:44:13 -0400
Message-ID: <20180821194413.GA24538@cmpxchg.org>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
 <20180803165641.GA2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y7sn1yrXnMivKB1tsHT35xpqQapDm2oCf8sWGyB+fzE=;
        b=sID9SnX2a7/YR0502EVfCCq+Sxl2ed4VFqtivAX9YclTEoBojimbnGqlm0pT4RnWtO
         Xcw9YyY746os1eX3XDkJ58U7s23CIa/74RJpfC754ewrJDsNAbt/Dwtib7MgnVrz4+OK
         6d78SbkkGuJ5jps0LBnjZj0YXRb41fkgvdH5EbgUtbZ494VbV9bNWVuUAobXXFx+G++s
         PuDsj6PVW7HeEHzFdOYfy0Yb/mzbCHiMo0kyrtb0qevMY6ZqeZ/mHjcgn7yqbTcoysV2
         hOs+uajbE8hhtSSVGngRef1j6LsFKoF1NySVq+pGldVtP69oYLJZPWwaQp+JITMn1ixF
         bX4w==
Content-Disposition: inline
In-Reply-To: <20180803165641.GA2476@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hi,

a quick update on that feedback before I send out v4:

On Fri, Aug 03, 2018 at 06:56:41PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 01, 2018 at 11:19:57AM -0400, Johannes Weiner wrote:
> > +static bool test_state(unsigned int *tasks, int cpu, enum psi_states state)
> > +{
> > +	switch (state) {
> > +	case PSI_IO_SOME:
> > +		return tasks[NR_IOWAIT];
> > +	case PSI_IO_FULL:
> > +		return tasks[NR_IOWAIT] && !tasks[NR_RUNNING];
> > +	case PSI_MEM_SOME:
> > +		return tasks[NR_MEMSTALL];
> > +	case PSI_MEM_FULL:
> > +		/*
> > +		 * Since we care about lost potential, things are
> > +		 * fully blocked on memory when there are no other
> > +		 * working tasks, but also when the CPU is actively
> > +		 * being used by a reclaimer and nothing productive
> > +		 * could run even if it were runnable.
> > +		 */
> > +		return tasks[NR_MEMSTALL] &&
> > +			(!tasks[NR_RUNNING] ||
> > +			 cpu_curr(cpu)->flags & PF_MEMSTALL);
> 
> I don't think you can do this, there is nothing that guarantees
> cpu_curr() still exists.

As discussed later in this thread, I've replaced this with time
sampling from inside scheduler_tick(): in the unlikely event that
rq->curr is PF_MEMSTALL, it'll record TICK_NSEC worth of MEM_FULL.

However:

> > +		for (s = PSI_NONIDLE; s >= 0; s--) {
> > +			u32 time, delta;
> > +
> > +			time = READ_ONCE(groupc->times[s]);
> > +			/*
> > +			 * In addition to already concluded states, we
> > +			 * also incorporate currently active states on
> > +			 * the CPU, since states may last for many
> > +			 * sampling periods.
> > +			 *
> > +			 * This way we keep our delta sampling buckets
> > +			 * small (u32) and our reported pressure close
> > +			 * to what's actually happening.
> > +			 */
> > +			if (test_state(groupc->tasks, cpu, s)) {
> > +				/*
> > +				 * We can race with a state change and
> > +				 * need to make sure the state_start
> > +				 * update is ordered against the
> > +				 * updates to the live state and the
> > +				 * time buckets (groupc->times).
> > +				 *
> > +				 * 1. If we observe task state that
> > +				 * needs to be recorded, make sure we
> > +				 * see state_start from when that
> > +				 * state went into effect or we'll
> > +				 * count time from the previous state.
> > +				 *
> > +				 * 2. If the time delta has already
> > +				 * been added to the bucket, make sure
> > +				 * we don't see it in state_start or
> > +				 * we'll count it twice.
> > +				 *
> > +				 * If the time delta is out of
> > +				 * state_start but not in the time
> > +				 * bucket yet, we'll miss it entirely
> > +				 * and handle it in the next period.
> > +				 */
> > +				smp_rmb();
> > +				time += cpu_clock(cpu) - groupc->state_start;
> > +			}
> 
> The alternative is adding an update to scheduler_tick(), that would
> ensure you're never more than nr_cpu_ids * TICK_NSEC behind.

I wasn't able to convert *all* states to tick updates like this.

The reason is that, while testing rq->curr for PF_MEMSTALL is cheap,
other tasks associated with the rq could be from any cgroup in the
system. That means we'd have to do for_each_cgroup() on every tick to
keep the groupc->times that closely uptodate, and that wouldn't scale.
We tend to have hundreds of them, some setups have thousands.

Since we don't need to be *that* current, I left the on-demand update
inside the aggregator for now. It's a bit trickier, but much cheaper.
