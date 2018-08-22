From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Wed, 22 Aug 2018 13:28:25 -0400
Message-ID: <20180822172825.GA1317@cmpxchg.org>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
 <20180803172139.GE2494@hirez.programming.kicks-ass.net>
 <20180821201115.GB24538@cmpxchg.org>
 <20180822091024.GU24124@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0fqYneS8rObbjrQtaVaioH+NNLEqKGl0wY/oATv9iXk=;
        b=zMr/NBJzORtE1COVfHArW9FY3wL+CbxviCU//4jeV194L2ftzIk+l+qA2p5rCW/Gdq
         11Os04dc43eIa0tEDp9oFg/y+Wo6lsqcyG4FDCxC5aH71q59ijQPQkeRNbm5dOOD4Io7
         aWhzN6IkM0yvn6C9AJt+0Ft65+pOMvYJgILrqhaQdPx/Poj1xuuq+m4nlfUIvU64XBk8
         rhTxgyiwJtR6Ysoo97y7QX/aRjhHlatDrZ9GerLkrAhB6GJ7AYO9XTeNWSn+W3jwU7Av
         kWrqQi83dDWfU304d8y4A3MFqjsMOh9Z4SyIb4YEjffsNprKHUp1LKX930wyl26XGNsK
         wgPg==
Content-Disposition: inline
In-Reply-To: <20180822091024.GU24124@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Aug 22, 2018 at 11:10:24AM +0200, Peter Zijlstra wrote:
> On Tue, Aug 21, 2018 at 04:11:15PM -0400, Johannes Weiner wrote:
> > On Fri, Aug 03, 2018 at 07:21:39PM +0200, Peter Zijlstra wrote:
> > > On Wed, Aug 01, 2018 at 11:19:57AM -0400, Johannes Weiner wrote:
> > > > +			time = READ_ONCE(groupc->times[s]);
> > > > +			/*
> > > > +			 * In addition to already concluded states, we
> > > > +			 * also incorporate currently active states on
> > > > +			 * the CPU, since states may last for many
> > > > +			 * sampling periods.
> > > > +			 *
> > > > +			 * This way we keep our delta sampling buckets
> > > > +			 * small (u32) and our reported pressure close
> > > > +			 * to what's actually happening.
> > > > +			 */
> > > > +			if (test_state(groupc->tasks, cpu, s)) {
> > > > +				/*
> > > > +				 * We can race with a state change and
> > > > +				 * need to make sure the state_start
> > > > +				 * update is ordered against the
> > > > +				 * updates to the live state and the
> > > > +				 * time buckets (groupc->times).
> > > > +				 *
> > > > +				 * 1. If we observe task state that
> > > > +				 * needs to be recorded, make sure we
> > > > +				 * see state_start from when that
> > > > +				 * state went into effect or we'll
> > > > +				 * count time from the previous state.
> > > > +				 *
> > > > +				 * 2. If the time delta has already
> > > > +				 * been added to the bucket, make sure
> > > > +				 * we don't see it in state_start or
> > > > +				 * we'll count it twice.
> > > > +				 *
> > > > +				 * If the time delta is out of
> > > > +				 * state_start but not in the time
> > > > +				 * bucket yet, we'll miss it entirely
> > > > +				 * and handle it in the next period.
> > > > +				 */
> > > > +				smp_rmb();
> > > > +				time += cpu_clock(cpu) - groupc->state_start;
> > > > +			}
> > > 
> > > As is, groupc->state_start needs a READ_ONCE() above and a WRITE_ONCE()
> > > below. But like stated earlier, doing an update in scheduler_tick() is
> > > probably easier.
> > 
> > I've wrapped these in READ_ONCE/WRITE_ONCE.
> 
> I just realized, these are u64, so READ_ONCE/WRITE_ONCE will not work
> correct on 32bit.

Ah, right.

Actually, that race described in the comment above - "If the time
delta is out of state_start but not in the time bucket yet, we'll miss
it entirely and handle it in the next period" - can cause bogus time
samples if state persists for more than 2s. Because if we observed a
live state and included it in our private copy of the time bucket
(times_prev), missing the delta in transit to the time bucket in the
next aggregation results in times_prev being ahead of 'time', which
causes the delta to underflow into a bogusly large sample.

Memory barriers alone cannot guarantee full coherency here (neither
seeing the delta twice, nor missing it entirely) so I'm switching this
over to seqcount to make sure the aggregator sees something sensible.

And then I don't need the READ_ONCE/WRITE_ONCE.
