From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC] memory cgroup: weak points of kmem accounting design
Date: Sun, 21 Sep 2014 19:30:10 +0400
Message-ID: <20140921153010.GB32416@esperanza>
References: <20140915104437.GA11886@esperanza>
 <CABCjUKCkgoG07djfLEpqo0sBwgKts0iMepwNsh_RdNVTVtYH3A@mail.gmail.com>
 <20140916083124.GA32139@esperanza>
 <xr93r3z9ctje.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <xr93r3z9ctje.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Motohiro Kosaki <Motohiro.Kosaki-gkcJ3tX5bYHQFUHtdCDX3A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Emelianov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khorenko <khorenko-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, LKML-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML-cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Greg,

On Wed, Sep 17, 2014 at 09:04:00PM -0700, Greg Thelen wrote:
> I've found per memcg per cache type stats useful in answering "why is my
> container oom?"  While these are kernel allocations, it is common for
> user space operations to cause these allocations (e.g. lots of open file
> descriptors).  So I don't specifically need per memcg slabinfo formatted
> data, but at the least a per memcg per cache type active object count
> would be very useful.  Thus I imagine each memcg would have an array of
> slab cache types each with per-cpu active object counters.  Per-cpu is
> used to avoid trashing those counters between cpus as objects are
> allocated and freed.

Hmm, that sounds sane. One more argument for the current design.

> As you say only memcg shrinkable cache types would need list heads.  I
> assume these per memcg shrinkable object list heads would be per cache
> type per cpu list heads for cache performance.  Allocation of a dentry
> today uses the normal slab management structures.  In this proposal I
> suspect the dentry would be dual indexed: once in the global slab/slub
> dentry lru and once in the per memcg dentry list.  If true, this might
> be a hot path regression allocation speed regression.
> 
> Do you have a shrinker design in mind?  I suspect this new design would
> involve a per memcg dcache shrinker which grabs a big per-memcg dcache
> lock while walking the dentry list.  The classic per superblock
> shrinkers would not used for memcg shrinking.

To be honest, I hadn't elaborated that in my mind when I sent this
e-mail, but now I realize that it doesn't look as if there's an easy way
to implement shrinkers in such a setup efficiently. I thought we could
keep each dentry/inode simultaneously in two list, global and memcg.
However, apart from resulting in memory wastes this, as you pointed out,
would result in a regression in operating on the lrus, which is
unacceptable.

That said, I admit my idea sounds crazy. I think sticking to Glauber's
design and trying to make it work is the best we can do now.

Thanks,
Vladimir
