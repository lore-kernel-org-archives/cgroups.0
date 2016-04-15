From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Fri, 15 Apr 2016 17:08:15 +0200
Message-ID: <20160415150815.GM32377@dhcp22.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415070601.GA32377@dhcp22.suse.cz>
 <20160415143815.GH12583@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160415143815.GH12583-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 15-04-16 10:38:15, Tejun Heo wrote:
> Hello, Michal.
> 
> On Fri, Apr 15, 2016 at 09:06:01AM +0200, Michal Hocko wrote:
> > Tejun was proposing to do the migration async (move the whole
> > mem_cgroup_move_charge into the work item). This would solve the problem
> > of course. I haven't checked whether this would be safe but it at least
> > sounds doable (albeit far from trivial). It would also be a user visible
> > change because the new memcg will not contain the moved charges after we
> > return to user space. I think this would be acceptable but if somebody
> 
> Not necessarily.  The only thing necessary is flushing the work item
> after releasing locks but before returning to user.
> cpuset_post_attach_flush() does exactly the same thing.

Ahh, ok, didn't know that __cgroup_procs_write is doing something
controller specific. Yes then we wouldn't need a generic callback if
another code like above would be acceptable.

> > really relies on the previous behavior I guess we can solve it with a
> > post_move cgroup callback which would be called from a lockless context.
> > 
> > Anyway, before we go that way, can we at least consider the possibility
> > of removing the kworker creation dependency on the global rwsem? AFAIU
> > this locking was added because of the pid controller. Do we even care
> > about something as volatile as kworkers in the pid controller?
> 
> It's not just pid controller and the global percpu locking has lower

where else would the locking matter? I have only checked the git history
to build my picture so I might be missing something of course.

> hotpath overhead.  We can try to exclude kworkers out of the locking
> but that can get really nasty and there are already attempts to add
> cgroup support to workqueue.  Will think more about it.  For now tho,
> do you think making charge moving async would be difficult?

Well it certainly is not that trivial because it relies on being
exclusive with global context. I will have to look closer of course but
I cannot guarantee I will get to it before I get back from LSF. We can
certainly discuss that at the conference. Johannes will be there as
well.

Thanks!
-- 
Michal Hocko
SUSE Labs
