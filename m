From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: fix hanging shrinker management on long
 do_shrink_slab
Date: Fri, 6 Dec 2019 13:09:53 +1100
Message-ID: <20191206020953.GS2695@dread.disaster.area>
References: <20191129214541.3110-1-ptikhomirov@virtuozzo.com>
 <4e2d959a-0b0e-30aa-59b4-8e37728e9793@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4e2d959a-0b0e-30aa-59b4-8e37728e9793@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, "J. Bruce Fields" <bfields@fieldses.org>

[please cc me on future shrinker infrastructure modifications]

On Mon, Dec 02, 2019 at 07:36:03PM +0300, Andrey Ryabinin wrote:
> 
> On 11/30/19 12:45 AM, Pavel Tikhomirov wrote:
> > We have a problem that shrinker_rwsem can be held for a long time for
> > read in shrink_slab, at the same time any process which is trying to
> > manage shrinkers hangs.
> > 
> > The shrinker_rwsem is taken in shrink_slab while traversing shrinker_list.
> > It tries to shrink something on nfs (hard) but nfs server is dead at
> > these moment already and rpc will never succeed. Generally any shrinker
> > can take significant time to do_shrink_slab, so it's a bad idea to hold
> > the list lock here.

registering/unregistering a shrinker is not a performance critical
task. If a shrinker is blocking for a long time, then we need to
work to fix the shrinker implementation because blocking is a much
bigger problem than just register/unregister.

> > The idea of the patch is to inc a refcount to the chosen shrinker so it
> > won't disappear and release shrinker_rwsem while we are in
> > do_shrink_slab, after that we will reacquire shrinker_rwsem, dec
> > the refcount and continue the traversal.

This is going to cause a *lot* of traffic on the shrinker rwsem.
It's already a pretty hot lock on large machines under memory
pressure (think thousands of tasks all doing direct reclaim across
hundreds of CPUs), and so changing them to cycle the rwsem on every
shrinker that will only make this worse. Esepcially when we consider
that there may be hundreds to thousands of registered shrinker
instances on large machines.

As an example of how frequent cycling of a global lock in shrinker
instances causes issues, we used to take references to superblock
shrinker count invocations to guarantee existence. This was found to
be a scalability limitation when lots of near-empty superblocks were
present in a system (see commit d23da150a37c ("fs/superblock: avoid
locking counting inodes and dentries before reclaiming them")).

This alleviated the problem for a while, but soon we had problems
with just taking a reference to the superblock in the callbacks that
did actual work. Hence we changed it to just take a per-superblock
rwsem to get rid of the global sb_lock spinlock in this path. See
commit eb6ef3df4faa ("trylock_super(): replacement for
grab_super_passive()". Now we don't have a scalability problem.

IOWs, we already know that cycling a global rwsem on every
individual shrinker invocation is going to cause noticable
scalability problems. Hence I don't think that this sort of "cycle
the global rwsem faster to reduce [un]register latency" solution is
going to fly because of the runtime performance regressions it will
introduce....

> I don't think this patch solves the problem, it only fixes one minor symptom of it.
> The actual problem here the reclaim hang in the nfs.

The nfs client is waiting on the NFS server to respond. It may
actually be that the server has hung, not the client...

> It means that any process, including kswapd, may go into nfs inode reclaim and stuck there.

*nod*

> I think this should be handled on nfs/vfs level by making  inode eviction during reclaim more asynchronous.

That's what we are trying to do with similar blocking based issues
in XFS inode reclaim. It's not simple, though, because these days
memory reclaim is like a bowl full of spaghetti covered with a
delicious sauce of non-obvious heuristics and broken
functionality....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
