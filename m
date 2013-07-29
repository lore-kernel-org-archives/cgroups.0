From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 6/6] mm: memcg: do not trap chargers with full callstack
 on OOM
Date: Mon, 29 Jul 2013 17:52:43 +0200
Message-ID: <20130729155243.GI4678@dhcp22.suse.cz>
References: <1374791138-15665-1-git-send-email-hannes@cmpxchg.org>
 <1374791138-15665-7-git-send-email-hannes@cmpxchg.org>
 <20130726144310.GH17761@dhcp22.suse.cz>
 <20130726212808.GD17975@cmpxchg.org>
 <20130729141250.GF4678@dhcp22.suse.cz>
 <20130729145529.GW715@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130729145529.GW715-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 29-07-13 10:55:29, Johannes Weiner wrote:
> On Mon, Jul 29, 2013 at 04:12:50PM +0200, Michal Hocko wrote:
> > On Fri 26-07-13 17:28:09, Johannes Weiner wrote:
> > > On Fri, Jul 26, 2013 at 04:43:10PM +0200, Michal Hocko wrote:
> > > > On Thu 25-07-13 18:25:38, Johannes Weiner wrote:
> > > > > @@ -2189,31 +2191,20 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
> > > > >  }
> > > > >  
> > > > >  /*
> > > > > - * try to call OOM killer. returns false if we should exit memory-reclaim loop.
> > > > > + * try to call OOM killer
> > > > >   */
> > > > > -static bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask,
> > > > > -				  int order)
> > > > > +static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
> > > > >  {
> > > > > -	struct oom_wait_info owait;
> > > > > -	bool locked, need_to_kill;
> > > > > +	bool locked, need_to_kill = true;
> > > > >  
> > > > > -	owait.memcg = memcg;
> > > > > -	owait.wait.flags = 0;
> > > > > -	owait.wait.func = memcg_oom_wake_function;
> > > > > -	owait.wait.private = current;
> > > > > -	INIT_LIST_HEAD(&owait.wait.task_list);
> > > > > -	need_to_kill = true;
> > > > > -	mem_cgroup_mark_under_oom(memcg);
> > > > 
> > > > You are marking memcg under_oom only for the sleepers. So if we have
> > > > no sleepers then the memcg will never report it is under oom which
> > > > is a behavior change. On the other hand who-ever relies on under_oom
> > > > under such conditions (it would basically mean a busy loop reading
> > > > memory.oom_control) would be racy anyway so it is questionable it
> > > > matters at all. At least now when we do not have any active notification
> > > > that under_oom has changed.
> > > > 
> > > > Anyway, this shouldn't be a part of this patch so if you want it because
> > > > it saves a pointless hierarchy traversal then make it a separate patch
> > > > with explanation why the new behavior is still OK.
> > > 
> > > This made me think again about how the locking and waking in there
> > > works and I found a bug in this patch.
> > > 
> > > Basically, we have an open-coded sleeping lock in there and it's all
> > > obfuscated by having way too much stuffed into the memcg_oom_lock
> > > section.
> > > 
> > > Removing all the clutter, it becomes clear that I can't remove that
> > > (undocumented) final wakeup at the end of the function.  As with any
> > > lock, a contender has to be woken up after unlock.  We can't rely on
> > > the lock holder's OOM kill to trigger uncharges and wakeups, because a
> > > contender for the OOM lock could show up after the OOM kill but before
> > > the lock is released.  If there weren't any more wakeups, the
> > > contender would sleep indefinitely.
> > 
> > I have checked that path again and I still do not see how wakeup_oom
> > helps here. What prevents us from the following race then?
> > 
> > spin_lock(&memcg_oom_lock)
> > locked = mem_cgroup_oom_lock(memcg) # true
> > spin_unlock(&memcg_oom_lock)
> 
>                                                 prepare_to_wait()

For some reason that one disappeared from my screen ;)

> > 						spin_lock(&memcg_oom_lock)
> > 						locked = mem_cgroup_oom_lock(memcg) # false
> > 						spin_unlock(&memcg_oom_lock)
> > 						<resched>
> > mem_cgroup_out_of_memory()
> > 			<uncharge & memcg_oom_recover>
> > spin_lock(&memcg_oom_lock)
> > mem_cgroup_oom_unlock(memcg)
> > memcg_wakeup_oom(memcg)
> > 						schedule()
> > spin_unlock(&memcg_oom_lock)
> > mem_cgroup_unmark_under_oom(memcg)

-- 
Michal Hocko
SUSE Labs
