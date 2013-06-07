From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Fri, 7 Jun 2013 09:37:54 +0200
Message-ID: <20130607073754.GA8117@dhcp22.suse.cz>
References: <20130605082023.GG7303@mtj.dyndns.org>
 <20130605143949.GQ15576@cmpxchg.org>
 <20130605172212.GA10693@mtj.dyndns.org>
 <20130605194552.GI15721@cmpxchg.org>
 <20130605200612.GH10693@mtj.dyndns.org>
 <20130605211704.GJ15721@cmpxchg.org>
 <20130605222021.GL10693@mtj.dyndns.org>
 <20130605222709.GM10693@mtj.dyndns.org>
 <20130606115031.GE7909@dhcp22.suse.cz>
 <20130607005242.GB16160@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130607005242.GB16160-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Thu 06-06-13 17:52:42, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jun 06, 2013 at 01:50:31PM +0200, Michal Hocko wrote:
> > > Also, do we need to hold a lock?  It doesn't have to be completely
> > > strict, so we might as well get away with something like,
> > > 
> > > 	for_each_cached_pos() {
> > > 		if (hint == me) {
> > > 			/* simple clearing implementation, we prolly wanna push it forward */
> > > 			cached = xchg(hint, NULL);
> > > 			if (cached)
> > > 				css_put(cached);
> > > 		}
> > > 	}
> > 
> > This would be racy:
> > mem_cgroup_iter
> >   rcu_read_lock
> >   __mem_cgroup_iter_next		cgroup_destroy_locked
> >     css_tryget(memcg)
> >   					  atomic_add(CSS_DEACT_BIAS)
> >     					  offline_css(memcg)
> > 					    xchg(memcg, NULL)
> >   mem_cgroup_iter_update
> >     iter->last_visited = memcg
> >   rcy_read_unlock
> > 
> > But if it was called from call_rcu the we should be safe AFAICS.
> 
> Oh yeah, it is racy.  That's what I meant by "not having to be
> completely strict".  The race window is small enough and it's not like
> we're messing up refcnt or may end up with use-after-free. 

But it would potentially pin (aka leak) the memcg for ever.

> Doing it from RCU would make the race go away but I'm not sure whether
> the extra RCU bouncing is worthwhile.  I don't know.  Maybe.
> 
> Thanks.
> 
> -- 
> tejun

-- 
Michal Hocko
SUSE Labs
