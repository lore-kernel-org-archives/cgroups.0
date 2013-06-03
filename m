From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch] mm, memcg: add oom killer delay
Date: Mon, 3 Jun 2013 12:51:20 -0400
Message-ID: <20130603165120.GH15576@cmpxchg.org>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
 <20130601061151.GC15576@cmpxchg.org>
 <20130603163012.GA23257@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130603163012.GA23257-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 03, 2013 at 06:31:34PM +0200, Michal Hocko wrote:
> On Sat 01-06-13 02:11:51, Johannes Weiner wrote:
> > @@ -2076,6 +2077,7 @@ static void memcg_wakeup_oom(struct mem_cgroup *memcg)
> >  {
> >  	/* for filtering, pass "memcg" as argument. */
> >  	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
> > +	atomic_inc(&memcg->oom_wakeups);
> >  }
> >  
> >  static void memcg_oom_recover(struct mem_cgroup *memcg)
> [...]
> > +	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
> > +	/* Only sleep if we didn't miss any wakeups since OOM */
> > +	if (atomic_read(&memcg->oom_wakeups) == current->memcg_oom.wakeups)
> > +		schedule();
> 
> On the way home it occured to me that the ordering might be wrong here.
> The wake up can be lost here.
> 					__wake_up(memcg_oom_waitq)
> 					<preempted>
> prepare_to_wait
> atomic_read(&memcg->oom_wakeups)
> 					atomic_inc(oom_wakeups)
> 
> I guess we want atomic_inc before __wake_up, right?

I think you are right, thanks for spotting this.  Will be fixed in
version 2.
