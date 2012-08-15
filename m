From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
Date: Wed, 15 Aug 2012 15:09:52 +0200
Message-ID: <20120815130952.GI23985@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-7-git-send-email-glommer@parallels.com>
 <20120814172540.GD6905@dhcp22.suse.cz>
 <502B6F00.8040207@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <502B6F00.8040207-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Wed 15-08-12 13:42:24, Glauber Costa wrote:
[...]
> >> +
> >> +	ret = 0;
> >> +
> >> +	if (!memcg)
> >> +		return ret;
> >> +
> >> +	_memcg = memcg;
> >> +	ret = __mem_cgroup_try_charge(NULL, gfp, delta / PAGE_SIZE,
> >> +	    &_memcg, may_oom);
> > 
> > This is really dangerous because atomic allocation which seem to be
> > possible could result in deadlocks because of the reclaim. 
> 
> Can you elaborate on how this would happen?

Say you have an atomic allocation and we hit the limit so we get either
to reclaim which can sleep or to oom which can sleep as well (depending
on the oom_control).

> > Also, as I have mentioned in the other email in this thread. Why
> > should we reclaim just because of kernel allocation when we are not
> > reclaiming any of it because shrink_slab is ignored in the memcg
> > reclaim.
> 
> Don't get too distracted by the fact that shrink_slab is ignored. It is
> temporary, and while this being ignored now leads to suboptimal
> behavior, it will 1st, only affect its users, and 2nd, not be disastrous.

It's not just about shrink_slab it is also about triggering memcg-oom
which doesn't consider kmem accounted memory so the wrong tasks could
be killed. It is true that the impact is packed inside the group
(hierarchy) so you are right it won't be disastrous.
-- 
Michal Hocko
SUSE Labs
