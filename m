From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Wed, 13 Apr 2016 21:23:14 +0200
Message-ID: <20160413192313.GA30260@dhcp22.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160413183309.GG3676-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed 13-04-16 14:33:09, Tejun Heo wrote:
> Hello, Petr.
> 
> (cc'ing Johannes)
> 
> On Wed, Apr 13, 2016 at 11:42:16AM +0200, Petr Mladek wrote:
> ...
> > By other words, "memcg_move_char/2860" flushes a work. But it cannot
> > get flushed because one worker is blocked and another one could not
> > get created. All these operations are blocked by the very same
> > "memcg_move_char/2860".
> > 
> > Note that also "systemd/1" is waiting for "cgroup_mutex" in
> > proc_cgroup_show(). But it seems that it is not in the main
> > cycle causing the deadlock.
> > 
> > I am able to reproduce this problem quite easily (within few minutes).
> > There are often even more tasks waiting for the cgroups-related locks
> > but they are not causing the deadlock.
> > 
> > 
> > The question is how to solve this problem. I see several possibilities:
> > 
> >   + avoid using workqueues in lru_add_drain_all()
> > 
> >   + make lru_add_drain_all() killable and restartable
> > 
> >   + do not block fork() when lru_add_drain_all() is running,
> >     e.g. using some lazy techniques like RCU, workqueues
> > 
> >   + at least do not block fork of workers; AFAIK, they have a limited
> >      cgroups usage anyway because they are marked with PF_NO_SETAFFINITY
> > 
> > 
> > I am willing to test any potential fix or even work on the fix.
> > But I do not have that big insight into the problem, so I would
> > need some pointers.
> 
> An easy solution would be to make lru_add_drain_all() use a
> WQ_MEM_RECLAIM workqueue.

I think we can live without lru_add_drain_all() in the migration path.
We are talking about 4 pagevecs so 56 pages. The charge migration is
racy anyway. What concerns me more is how all this is fragile. It sounds
just too easy to add a dependency on per-cpu sync work later and
reintroduce this issue which is quite hard to detect.

Cannot we come up with something more robust?  Or at least warn when we
try to use per-cpu workers with problematic locks held?

Thanks!
-- 
Michal Hocko
SUSE Labs
