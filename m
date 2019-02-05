From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v6 4/5] sched/core: Prevent race condition between cpuset
 and __sched_setscheduler()
Date: Tue, 5 Feb 2019 12:49:11 +0100
Message-ID: <20190205114911.GH30905@localhost.localdomain>
References: <20190117084739.17078-1-juri.lelli@redhat.com>
 <20190117084739.17078-5-juri.lelli@redhat.com>
 <20190204121029.GD17550@hirez.programming.kicks-ass.net>
 <20190205095143.GG30905@localhost.localdomain>
 <20190205112049.GO17528@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190205112049.GO17528@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 05/02/19 12:20, Peter Zijlstra wrote:
> On Tue, Feb 05, 2019 at 10:51:43AM +0100, Juri Lelli wrote:
> > On 04/02/19 13:10, Peter Zijlstra wrote:
> > > On Thu, Jan 17, 2019 at 09:47:38AM +0100, Juri Lelli wrote:
> > > > No synchronisation mechanism exists between the cpuset subsystem and calls
> > > > to function __sched_setscheduler(). As such, it is possible that new root
> > > > domains are created on the cpuset side while a deadline acceptance test
> > > > is carried out in __sched_setscheduler(), leading to a potential oversell
> > > > of CPU bandwidth.
> > > > 
> > > > Grab callback_lock from core scheduler, so to prevent situations such as
> > > > the one described above from happening.
> > > 
> > > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > > index f5263383170e..d928a42b8852 100644
> > > > --- a/kernel/sched/core.c
> > > > +++ b/kernel/sched/core.c
> > > > @@ -4224,6 +4224,13 @@ static int __sched_setscheduler(struct task_struct *p,
> > > >  	rq = task_rq_lock(p, &rf);
> > > >  	update_rq_clock(rq);
> > > >  
> > > > +	/*
> > > > +	 * Make sure we don't race with the cpuset subsystem where root
> > > > +	 * domains can be rebuilt or modified while operations like DL
> > > > +	 * admission checks are carried out.
> > > > +	 */
> > > > +	cpuset_read_only_lock();
> > > > +
> > > >  	/*
> > > >  	 * Changing the policy of the stop threads its a very bad idea:
> > > >  	 */
> > > > @@ -4285,6 +4292,7 @@ static int __sched_setscheduler(struct task_struct *p,
> > > >  	/* Re-check policy now with rq lock held: */
> > > >  	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
> > > >  		policy = oldpolicy = -1;
> > > > +		cpuset_read_only_unlock();
> > > >  		task_rq_unlock(rq, p, &rf);
> > > >  		goto recheck;
> > > >  	}
> > > > @@ -4342,6 +4350,7 @@ static int __sched_setscheduler(struct task_struct *p,
> > > >  
> > > >  	/* Avoid rq from going away on us: */
> > > >  	preempt_disable();
> > > > +	cpuset_read_only_unlock();
> > > >  	task_rq_unlock(rq, p, &rf);
> > > >  
> > > >  	if (pi)
> > > > @@ -4354,6 +4363,7 @@ static int __sched_setscheduler(struct task_struct *p,
> > > >  	return 0;
> > > >  
> > > >  unlock:
> > > > +	cpuset_read_only_unlock();
> > > >  	task_rq_unlock(rq, p, &rf);
> > > >  	return retval;
> > > >  }
> > > 
> > > Why take callback_lock inside rq->lock and not the other way around?
> > > AFAICT there is no pre-existing order so we can pick one here.
> > 
> > I dediced to go for this order because if we do the other way around
> > grabbing callback_lock should have to also disable irqs, no? And I
> > didn't want to modify task_rq_lock; or at least this approach seemed
> > less intrusive code-wide.
> 
> Ah, but this way around we add the wait-time of callback_lock to
> rq_lock, which seems undesirable because rq_lock is a far hotter lock in
> general, right?

Eh, indeed. OK, I'll work on it.
