From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC] memory cgroup: my thoughts on memsw
Date: Wed, 17 Sep 2014 19:59:15 +0400
Message-ID: <20140917155915.GB5065@esperanza>
References: <20140904143055.GA20099@esperanza>
 <20140915191435.GA8950@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140915191435.GA8950-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Motohiro Kosaki <Motohiro.Kosaki-gkcJ3tX5bYHQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Emelianov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khorenko <khorenko-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, LKML-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML-cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Johannes,

On Mon, Sep 15, 2014 at 03:14:35PM -0400, Johannes Weiner wrote:
> > Finally, my understanding (may be crazy!) how the things should be
> > configured. Just like now, there should be mem_cgroup->res accounting
> > and limiting total user memory (cache+anon) usage for processes inside
> > cgroups. This is where there's nothing to do. However, mem_cgroup->memsw
> > should be reworked to account *only* memory that may be swapped out plus
> > memory that has been swapped out (i.e. swap usage).
> 
> But anon pages are not a resource, they are a swap space liability.
> Think of virtual memory vs. physical pages - the use of one does not
> necessarily result in the use of the other.  Without memory pressure,
> anonymous pages do not consume swap space.
> 
> What we *should* be accounting and limiting here is the actual finite
> resource: swap space.  Whenever we try to swap a page, its owner
> should be charged for the swap space - or the swapout be rejected.

I've been thinking quite a bit on the problem, and finally I believe
you're right: a separate swap limit would be better than anon+swap.

Provided we make the OOM-killer kill cgroups that exceed their soft
limit and can't be reclaimed, it will solve the problem with soft limits
I described above.

Besides, comparing to anon+swap, swap limit would be more efficient (we
only need to charge one res counter, not two) and understandable to
users (it's simple to setup a limit for both kinds of resources then,
because they never mix).

Finally, we could transfer user configuration from cgroup v1 to v2
easily: just setup swap.limit to be equal to memsw.limit-mem.limit; it
won't be exactly the same, but I bet nobody will notice any difference.

So, at least for now, I vote for moving from mem+swap to swap
accounting.

Thanks,
Vladimir
