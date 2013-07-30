From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 6/6] mm: memcg: do not trap chargers with full callstack
 on OOM
Date: Tue, 30 Jul 2013 16:56:02 +0200
Message-ID: <20130730145602.GI15847@dhcp22.suse.cz>
References: <1374791138-15665-1-git-send-email-hannes@cmpxchg.org>
 <1374791138-15665-7-git-send-email-hannes@cmpxchg.org>
 <20130726144310.GH17761@dhcp22.suse.cz>
 <20130726212808.GD17975@cmpxchg.org>
 <20130730140913.GC15847@dhcp22.suse.cz>
 <20130730143228.GD715@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130730143228.GD715-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 30-07-13 10:32:28, Johannes Weiner wrote:
> On Tue, Jul 30, 2013 at 04:09:13PM +0200, Michal Hocko wrote:
> > On Fri 26-07-13 17:28:09, Johannes Weiner wrote:
[...]
> > >  	} else {
> > >  		schedule();
> > > +		mem_cgroup_unmark_under_oom(memcg);
> > >  		finish_wait(&memcg_oom_waitq, &owait.wait);
> > >  	}
> > > -	spin_lock(&memcg_oom_lock);
> > > -	if (locked)
> > > -		mem_cgroup_oom_unlock(memcg);
> > > -	memcg_wakeup_oom(memcg);
> > > -	spin_unlock(&memcg_oom_lock);
> > >  
> > > -	mem_cgroup_unmark_under_oom(memcg);
> > > +	if (locked) {
> > > +		mem_cgroup_oom_unlock(memcg);
> > > +		/*
> > > +		 * There is no guarantee that a OOM-lock contender
> > > +		 * sees the wakeups triggered by the OOM kill
> > > +		 * uncharges.  Wake any sleepers explicitely.
> > > +		 */
> > > +		memcg_oom_recover(memcg);
> > 
> > This will be a noop because memcg is no longer under_oom (you wanted
> > memcg_wakeup_oom here I guess). Moreover, even the killed wouldn't wake
> > up anybody for the same reason.
> 
> Anybody entering this path will increase the under_oom counter.  The
> killer decreases it again, but everybody who is sleeping because they
> failed the trylock still hasn't unmarked the hierarchy (they call
> schedule() before unmark_under_oom()).  So we issue wakeups when there
> is somebody waiting for the lock.

True, sorry for the noise. Feel free to add

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
-- 
Michal Hocko
SUSE Labs
