From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Thu, 10 May 2018 10:24:42 -0400
Message-ID: <20180510142442.GG19348@cmpxchg.org>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
 <20180509102100.GN12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VX6n6xNfzLtisMenr8eEvDlnrRFHvzpXhjbw0g+8Rpo=; b=VcTK3cfk8yOGUGI3zEw6tfCdPv
        eOTcAmhbjWgzJqrYadSjp8ej4N3H2xDUQuyaVbZimlh9I9kBhjSr+BNSiu6TH1mBqAlotZfTuIDmH
        sbjG3pCQJ4TkQMTU6qXDZ+Hnq7GjKAeOxR0HORYFaep3KhP+YYAEDrpx8YRVqBI0JHe8=;
Content-Disposition: inline
In-Reply-To: <20180509102100.GN12217@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Wed, May 09, 2018 at 12:21:00PM +0200, Peter Zijlstra wrote:
> On Mon, May 07, 2018 at 05:01:34PM -0400, Johannes Weiner wrote:
> > +	local_irq_disable();
> > +	rq = this_rq();
> > +	raw_spin_lock(&rq->lock);
> > +	rq_pin_lock(rq, &rf);
> 
> Given that churn in sched.h, you seen rq_lock() and friends.
> 
> Either write this like:
> 
> 	local_irq_disable();
> 	rq = this_rq();
> 	rq_lock(rq, &rf);
> 
> Or instroduce "rq = this_rq_lock_irq()", which we could also use in
> do_sched_yield().

Sounds good, I'll add that.

> > +	update_rq_clock(rq);
> > +
> > +	current->flags |= PF_MEMSTALL;
> > +	psi_task_change(current, rq_clock(rq), 0, TSK_MEMSTALL);
> > +
> > +	rq_unpin_lock(rq, &rf);
> > +	raw_spin_unlock(&rq->lock);
> > +	local_irq_enable();
> 
> That's called rq_unlock_irq().

I'll use that. This code was first written against a kernel that
didn't have 8a8c69c32778 ("sched/core: Add rq->lock wrappers.") yet ;)
