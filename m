From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Wed, 9 May 2018 13:38:49 +0200
Message-ID: <20180509113849.GJ12235@hirez.programming.kicks-ass.net>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
 <20180509104618.GP12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SDadu1U/BcuAnzTexDW7zictMF42zgXBGclVmtyGo3U=; b=lrB5950y6Sf+Pl54yJQxKc9S6
        gQDQd7yamVu1YhghscdGzSsoQ8p/3VmopmVjYDd/sHanwiZysv/FnkSORUMBGcbRUItxTI4FypdVt
        5v6CxqrYyoguJwHqaDlSp/RH2n5jEG9FeMk7V8DEfKVB+AaGvAMcWs335MCGMf5TI0qb3KAO0smm/
        /4XwPiiWsNQlTlzG277ka70vzpiPNhs49I41M+FGSUTtw61alOuh0lOTkfLy9gk1XH1dfyyT8nJei
        veUmMBJy5xqYqI1enzbIxDjFIVPFniLZm5lW+KREN0K0WRjb6XQb8vkoawypS/pyeuWBu7XYFz1L1
    
Content-Disposition: inline
In-Reply-To: <20180509104618.GP12217@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Wed, May 09, 2018 at 12:46:18PM +0200, Peter Zijlstra wrote:
> On Mon, May 07, 2018 at 05:01:34PM -0400, Johannes Weiner wrote:
> 
> > @@ -2038,6 +2038,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> >  	cpu = select_task_rq(p, p->wake_cpu, SD_BALANCE_WAKE, wake_flags);
> >  	if (task_cpu(p) != cpu) {
> >  		wake_flags |= WF_MIGRATED;
> > +		psi_ttwu_dequeue(p);
> >  		set_task_cpu(p, cpu);
> >  	}
> >  
> 
> > +static inline void psi_ttwu_dequeue(struct task_struct *p)
> > +{
> > +	/*
> > +	 * Is the task being migrated during a wakeup? Make sure to
> > +	 * deregister its sleep-persistent psi states from the old
> > +	 * queue, and let psi_enqueue() know it has to requeue.
> > +	 */
> > +	if (unlikely(p->in_iowait || (p->flags & PF_MEMSTALL))) {
> > +		struct rq_flags rf;
> > +		struct rq *rq;
> > +		int clear = 0;
> > +
> > +		if (p->in_iowait)
> > +			clear |= TSK_IOWAIT;
> > +		if (p->flags & PF_MEMSTALL)
> > +			clear |= TSK_MEMSTALL;
> > +
> > +		rq = __task_rq_lock(p, &rf);
> > +		update_rq_clock(rq);
> > +		psi_task_change(p, rq_clock(rq), clear, 0);
> > +		p->sched_psi_wake_requeue = 1;
> > +		__task_rq_unlock(rq, &rf);
> > +	}
> > +}
> 
> Yeah, no... not happening.
> 
> We spend a lot of time to never touch the old rq->lock on wakeups. Mason
> was the one pushing for that, so he should very well know this.
> 
> The one cross-cpu atomic (iowait) is already a problem (the whole iowait
> accounting being useless makes it even worse), adding significant remote
> prodding is just really bad.

Also, since all you need is the global number, I don't think you
actually need any of this. See what we do for nr_uninterruptible.

In general I think you want to (re)read loadavg.c some more, and maybe
reuse a bit more of that.
