From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Sat, 14 Jul 2018 11:02:44 +0200
Message-ID: <20180714090244.GC4920@worktop.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180713092153.GU2494@hirez.programming.kicks-ass.net>
 <20180713161756.GA21168@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DjX+vA0IobqjWniEWexVFNFhaNudjWnwNFHbmpTAbLY=; b=qX5TwQU+PVNWBKxA80Ffz56yc
        GZYlxBHBVHTxiiyMFbEJHKKEkuxW31ZTNyvkfD1HF9Cd7Ukct6YTCnVoMFymNZ+R9euH8mb2pT0PR
        rvZuraM50urQQtpxiRHr3cfkmgfBx73oISZHijxnuIFWDP7Fhc7eMZd7KwDpszO/vy7dynXux0ULR
        HhK3+5UoEzTVE+tj+ucFlYUeVm46CRIF+oi/TpXNwCaOcklovHKdvTCluWOB/mJqe+U94f3eWO8S9
        pxrwRWQX9mL+16zXaiGPoNTEpwNPVHo8gVCSUH0rC7SUTC71Q8fr2ovN6EMvOShtg+Iy4Md1E1Ijm
    
Content-Disposition: inline
In-Reply-To: <20180713161756.GA21168@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Jul 13, 2018 at 12:17:56PM -0400, Johannes Weiner wrote:
> On Fri, Jul 13, 2018 at 11:21:53AM +0200, Peter Zijlstra wrote:
> > On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> > > +static inline void psi_ttwu_dequeue(struct task_struct *p)
> > > +{
> > > +	if (psi_disabled)
> > > +		return;
> > > +	/*
> > > +	 * Is the task being migrated during a wakeup? Make sure to
> > > +	 * deregister its sleep-persistent psi states from the old
> > > +	 * queue, and let psi_enqueue() know it has to requeue.
> > > +	 */
> > > +	if (unlikely(p->in_iowait || (p->flags & PF_MEMSTALL))) {
> > > +		struct rq_flags rf;
> > > +		struct rq *rq;
> > > +		int clear = 0;
> > > +
> > > +		if (p->in_iowait)
> > > +			clear |= TSK_IOWAIT;
> > > +		if (p->flags & PF_MEMSTALL)
> > > +			clear |= TSK_MEMSTALL;
> > > +
> > > +		rq = __task_rq_lock(p, &rf);
> > > +		update_rq_clock(rq);
> > > +		psi_task_change(p, rq_clock(rq), clear, 0);
> > > +		p->sched_psi_wake_requeue = 1;
> > > +		__task_rq_unlock(rq, &rf);
> > > +	}
> > > +}
> > 
> > Still NAK, what happened to this here:

> That's my thought process, anyway. I'd be more than happy to make this
> more lightweight, but I don't see a way to do it without losing
> significant functional precision.

I think you're going to have to. We put a lot of effort into not taking
the old rq->lock on remote wakeups and got a significant performance
benefit from that.

You just utterly destroyed that for workloads with a high number of
iowait wakeups.
