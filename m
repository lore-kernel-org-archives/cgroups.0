From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] gfp: add __GFP_NOACCOUNT
Date: Wed, 6 May 2015 15:55:20 +0200
Message-ID: <20150506135520.GN14550@dhcp22.suse.cz>
References: <fdf631b3fa95567a830ea4f3e19d0b3b2fc99662.1430819044.git.vdavydov@parallels.com>
 <20150506115941.GH14550@dhcp22.suse.cz>
 <20150506122431.GA29387@esperanza>
 <20150506123541.GK14550@dhcp22.suse.cz>
 <20150506132510.GB29387@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150506132510.GB29387@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 06-05-15 16:25:10, Vladimir Davydov wrote:
> On Wed, May 06, 2015 at 02:35:41PM +0200, Michal Hocko wrote:
> > On Wed 06-05-15 15:24:31, Vladimir Davydov wrote:
[...]
> > > I don't think making this flag per-cache is an option either, but for
> > > another reason - it would not be possible to merge such a kmem cache
> > > with caches without this flag set. As a result, total memory pressure
> > > would increase, even for setups without kmem-active memory cgroups,
> > > which does not sound acceptable to me.
> > 
> > I am not sure I see the performance implications here because kmem
> > accounted memcgs would have their copy of the cache anyway, no?
> 
> It's orthogonal.
> 
> Suppose there are two *global* kmem caches, A and B, which would
> normally be merged, i.e. A=B. Then we find out that we don't want to
> account allocations from A to memcg while still accounting allocations
> from B. Obviously, cache A can no longer be merged with cache B so we
> have two different caches instead of the only merged one, even if there
> are *no* memory cgroups at all. That might result in increased memory
> consumption due to fragmentation.

Got your point. Thanks for the clarification!

> Although it is not really critical, especially counting that SLAB
> merging was introduced not long before, the idea that enabling an extra
> feature, such as memcg, without actually using it, may affect the global
> behavior does not sound good to me.

Agreed.

> > Anyway, I guess it would be good to document these reasons in the
> > changelog.
> >  
> > > > So I do not object to opt-out for kmemcg accounting but I really think
> > > > the name should be changed.
> > > 
> > > I named it __GFP_NOACCOUNT to match with __GFP_NOTRACK, which is a very
> > > specific flag too (kmemcheck),  nevertheless it has a rather generic
> > > name.
> > 
> > __GFP_NOTRACK is a bad name IMHO as well. One has to go and check the
> > comment to see this is kmemleak related.
> 
> I think it's a good practice to go to its definition and check comments
> when encountering an unknown symbol anyway. With ctags/cscope it's
> trivial :-)
> 
> > 
> > > Anyways, what else apart from memcg can account kmem so that we have to
> > > mention KMEMCG in the flag name explicitly?
> > 
> > NOACCOUNT doesn't imply kmem at all so it is not clear who is in charge
> > of the accounting.
> 
> IMO it is a benefit. If one day for some reason we want to bypass memcg
> accounting for some other type of allocation somewhere, we can simply
> reuse it.

But what if somebody, say a highlevel memory allocator in the kernel,
want's to (ab)use this flag for its internal purpose as well?

> > I do not insist on __GFP_NO_KMEMCG of course but it sounds quite
> > specific about its meaning and scope.
> 
> There is another argument against __GFP_NO_KMEMCG: it is not yet clear
> if kmem is going to be accounted separately in the unified cgroup
> hierarchy.

As I've said, I do not insist on *KMEMCG. __GFP_NO_MEMCG would be
generic enough to rule out MEMCG altogether as well. Be it kmem or user
memory.
-- 
Michal Hocko
SUSE Labs
