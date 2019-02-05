From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v6 3/5] cgroup/cpuset: make callback_lock raw
Date: Tue, 5 Feb 2019 10:18:20 +0100
Message-ID: <20190205091820.GE30905@localhost.localdomain>
References: <20190117084739.17078-1-juri.lelli@redhat.com>
 <20190117084739.17078-4-juri.lelli@redhat.com>
 <20190204120236.GC17550@hirez.programming.kicks-ass.net>
 <20190204120711.GA17582@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190204120711.GA17582@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 04/02/19 13:07, Peter Zijlstra wrote:
> On Mon, Feb 04, 2019 at 01:02:36PM +0100, Peter Zijlstra wrote:
> > On Thu, Jan 17, 2019 at 09:47:37AM +0100, Juri Lelli wrote:
> > > @@ -3233,11 +3233,11 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
> > >  {
> > >  	unsigned long flags;
> > >  
> > > -	spin_lock_irqsave(&callback_lock, flags);
> > > +	raw_spin_lock_irqsave(&callback_lock, flags);
> > >  	rcu_read_lock();
> > >  	guarantee_online_cpus(task_cs(tsk), pmask);
> > >  	rcu_read_unlock();
> > > -	spin_unlock_irqrestore(&callback_lock, flags);
> > > +	raw_spin_unlock_irqrestore(&callback_lock, flags);
> > >  }
> > >  
> > >  void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
> > > @@ -3285,11 +3285,11 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
> > >  	nodemask_t mask;
> > >  	unsigned long flags;
> > >  
> > > -	spin_lock_irqsave(&callback_lock, flags);
> > > +	raw_spin_lock_irqsave(&callback_lock, flags);
> > >  	rcu_read_lock();
> > >  	guarantee_online_mems(task_cs(tsk), &mask);
> > >  	rcu_read_unlock();
> > > -	spin_unlock_irqrestore(&callback_lock, flags);
> > > +	raw_spin_unlock_irqrestore(&callback_lock, flags);
> > >  
> > >  	return mask;
> > >  }
> > > @@ -3381,14 +3381,14 @@ bool __cpuset_node_allowed(int node, gfp_t gfp_mask)
> > >  		return true;
> > >  
> > >  	/* Not hardwall and node outside mems_allowed: scan up cpusets */
> > > -	spin_lock_irqsave(&callback_lock, flags);
> > > +	raw_spin_lock_irqsave(&callback_lock, flags);
> > >  
> > >  	rcu_read_lock();
> > >  	cs = nearest_hardwall_ancestor(task_cs(current));
> > >  	allowed = node_isset(node, cs->mems_allowed);
> > >  	rcu_read_unlock();
> > >  
> > > -	spin_unlock_irqrestore(&callback_lock, flags);
> > > +	raw_spin_unlock_irqrestore(&callback_lock, flags);
> > >  	return allowed;
> > >  }
> > 
> > These three appear to be a user-controlled O(n) (depth of cgroup tree).
> > Which is basically bad for raw_spinlock_t.
> > 
> > The Changelog should really have mentioned this; and ideally we'd
> > somehow avoid this.
> 
> N/m avoiding it; we have this all over the place, just mention it..

OK.
