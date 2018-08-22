From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Wed, 22 Aug 2018 11:10:24 +0200
Message-ID: <20180822091024.GU24124@hirez.programming.kicks-ass.net>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
 <20180803172139.GE2494@hirez.programming.kicks-ass.net>
 <20180821201115.GB24538@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YbdDDn0LmMntOvsDynUtkB+mSIAFRIE4RGQzJvC3h5Q=; b=jSiz0SUqgjqtYAL67S8Lqar0i
        p0b7Y7CW10WpXS0NNVGlBubKM8EeCLv1Jaaou8dQCVTcElzguUN/Qs0+SlAHfcnF/mIHfVGmqsyLT
        s93/sZxhQwWIwqwVs7MNBaOsFZm5hyd6ROK5gaL2lOBo982Ww+U0YqRMmdSV9UarpPQfzV6XNWn6m
        0Nqq20kfiGNXzjtfK3hvjtA3dUXVqMMne8QJ4AijNqnL2KzK8YneUDZ8Yi9wiC2eZE6cOJYRs+rgo
        SMdhHO15+3XIi073bSguMNAihmCZ709twxhLzv26WYHo5bMKi3vPi+YOwbljVTFkyYzXRxRTHssL2
    
Content-Disposition: inline
In-Reply-To: <20180821201115.GB24538@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Aug 21, 2018 at 04:11:15PM -0400, Johannes Weiner wrote:
> On Fri, Aug 03, 2018 at 07:21:39PM +0200, Peter Zijlstra wrote:
> > On Wed, Aug 01, 2018 at 11:19:57AM -0400, Johannes Weiner wrote:
> > > +			time = READ_ONCE(groupc->times[s]);
> > > +			/*
> > > +			 * In addition to already concluded states, we
> > > +			 * also incorporate currently active states on
> > > +			 * the CPU, since states may last for many
> > > +			 * sampling periods.
> > > +			 *
> > > +			 * This way we keep our delta sampling buckets
> > > +			 * small (u32) and our reported pressure close
> > > +			 * to what's actually happening.
> > > +			 */
> > > +			if (test_state(groupc->tasks, cpu, s)) {
> > > +				/*
> > > +				 * We can race with a state change and
> > > +				 * need to make sure the state_start
> > > +				 * update is ordered against the
> > > +				 * updates to the live state and the
> > > +				 * time buckets (groupc->times).
> > > +				 *
> > > +				 * 1. If we observe task state that
> > > +				 * needs to be recorded, make sure we
> > > +				 * see state_start from when that
> > > +				 * state went into effect or we'll
> > > +				 * count time from the previous state.
> > > +				 *
> > > +				 * 2. If the time delta has already
> > > +				 * been added to the bucket, make sure
> > > +				 * we don't see it in state_start or
> > > +				 * we'll count it twice.
> > > +				 *
> > > +				 * If the time delta is out of
> > > +				 * state_start but not in the time
> > > +				 * bucket yet, we'll miss it entirely
> > > +				 * and handle it in the next period.
> > > +				 */
> > > +				smp_rmb();
> > > +				time += cpu_clock(cpu) - groupc->state_start;
> > > +			}
> > 
> > As is, groupc->state_start needs a READ_ONCE() above and a WRITE_ONCE()
> > below. But like stated earlier, doing an update in scheduler_tick() is
> > probably easier.
> 
> I've wrapped these in READ_ONCE/WRITE_ONCE.

I just realized, these are u64, so READ_ONCE/WRITE_ONCE will not work
correct on 32bit.
