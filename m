From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] gfp: add __GFP_NOACCOUNT
Date: Wed, 6 May 2015 15:46:20 +0200
Message-ID: <20150506134620.GM14550@dhcp22.suse.cz>
References: <fdf631b3fa95567a830ea4f3e19d0b3b2fc99662.1430819044.git.vdavydov@parallels.com>
 <20150506115941.GH14550@dhcp22.suse.cz>
 <20150506131622.GA4629@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150506131622.GA4629-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 06-05-15 09:16:22, Johannes Weiner wrote:
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
> > accounting is KMEMCG related.
> 
> The memory controller is the (primary) component that accounts
> physical memory allocations in the kernel, so I don't see how this
> would be ambiguous in any way.

What if a high-level allocator wants to do some accounting as well?
E.g. slab allocator accounts {un}reclaimable pages. It is a different
thing because the accounting is per-cache rather than gfp based but I
just wanted to point out that accounting is rather a wide term.

> > __GFP_NO_KMEMCG sounds better?
> 
> I think that's much worse.  I would prefer communicating the desired
> behavior directly instead of having to derive it from a subsystem
> name.
> (And KMEMCG should not even be a term, it's all just the memory
> controller, i.e. memcg.)

I do not mind __GFP_NO_MEMCG either.

-- 
Michal Hocko
SUSE Labs
