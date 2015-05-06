From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] gfp: add __GFP_NOACCOUNT
Date: Wed, 6 May 2015 14:35:41 +0200
Message-ID: <20150506123541.GK14550@dhcp22.suse.cz>
References: <fdf631b3fa95567a830ea4f3e19d0b3b2fc99662.1430819044.git.vdavydov@parallels.com>
 <20150506115941.GH14550@dhcp22.suse.cz>
 <20150506122431.GA29387@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150506122431.GA29387@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 06-05-15 15:24:31, Vladimir Davydov wrote:
> On Wed, May 06, 2015 at 01:59:41PM +0200, Michal Hocko wrote:
> > On Tue 05-05-15 12:45:42, Vladimir Davydov wrote:
> > > Not all kmem allocations should be accounted to memcg. The following
> > > patch gives an example when accounting of a certain type of allocations
> > > to memcg can effectively result in a memory leak.
> > 
> > > This patch adds the __GFP_NOACCOUNT flag which if passed to kmalloc
> > > and friends will force the allocation to go through the root
> > > cgroup. It will be used by the next patch.
> > 
> > The name of the flag is way too generic. It is not clear that the
> > accounting is KMEMCG related. __GFP_NO_KMEMCG sounds better?
> > 
> > I was going to suggest doing per-cache rather than gfp flag and that
> > would actually work just fine for the kmemleak as it uses its own cache
> > already. But the ida_simple_get would be trickier because it doesn't use
> > any special cache and more over only one user seem to have a problem so
> > this doesn't sound like a good fit.
> 
> I don't think making this flag per-cache is an option either, but for
> another reason - it would not be possible to merge such a kmem cache
> with caches without this flag set. As a result, total memory pressure
> would increase, even for setups without kmem-active memory cgroups,
> which does not sound acceptable to me.

I am not sure I see the performance implications here because kmem
accounted memcgs would have their copy of the cache anyway, no?
Anyway, I guess it would be good to document these reasons in the
changelog.
 
> > So I do not object to opt-out for kmemcg accounting but I really think
> > the name should be changed.
> 
> I named it __GFP_NOACCOUNT to match with __GFP_NOTRACK, which is a very
> specific flag too (kmemcheck),  nevertheless it has a rather generic
> name.

__GFP_NOTRACK is a bad name IMHO as well. One has to go and check the
comment to see this is kmemleak related.

> Anyways, what else apart from memcg can account kmem so that we have to
> mention KMEMCG in the flag name explicitly?

NOACCOUNT doesn't imply kmem at all so it is not clear who is in charge
of the accounting. I do not insist on __GFP_NO_KMEMCG of course but
it sounds quite specific about its meaning and scope.
-- 
Michal Hocko
SUSE Labs
