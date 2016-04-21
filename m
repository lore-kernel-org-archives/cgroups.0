From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-4.6-fixes] memcg: remove lru_add_drain_all()
 invocation from mem_cgroup_move_charge()
Date: Wed, 20 Apr 2016 23:27:05 -0400
Message-ID: <20160421032704.GA15585@dhcp22.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
 <20160417120747.GC21757@dhcp22.suse.cz>
 <20160420212922.GH4775@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160420212922.GH4775-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 20-04-16 17:29:22, Tejun Heo wrote:
> Hello, Michal.
> 
> On Sun, Apr 17, 2016 at 08:07:48AM -0400, Michal Hocko wrote:
[...]
> > I liked your proposal when mem_cgroup_move_charge would be called from a
> > context which doesn't hold the problematic rwsem much more. Would that
> > be too intrusive for the stable backport?
> 
> Yeah, I'm working on the fix but let's plug this one first as it seems
> really easy to trigger.  I got a couple off-list reports (in and
> outside fb) of this triggering.

Sure, I think we can use this for an immediate workaround. Nevertheless
we want to have a full fix and do not rely on this being the only
problem. I would eventually like to reintroduce the draining later when
we have a better fix because even though this is not a correctness
problem I think we should try hard to not leave anything behind.

That being said:
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
-- 
Michal Hocko
SUSE Labs
