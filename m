From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: optimize stats flushing for latency and
 accuracy
Date: Wed, 13 Sep 2023 11:37:58 -0400
Message-ID: <20230913153758.GB45543@cmpxchg.org>
References: <20230913073846.1528938-1-yosryahmed@google.com>
 <20230913073846.1528938-4-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1694619479; x=1695224279; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pes0x2FgCzst9zO4by3a7HiJnngRgun+ysnigDkdDBI=;
        b=Dww1p0ZTB4p0ePOsIhtIQmpWQmle9nu5zjD3KSf6t25lF2zPY78d+Lsk2iWhMaP+OJ
         qFY51+2MvP+EgzNCbdgySWK3za4hGBBNNpYv1ro637wk2CoDdHcFdTMUcqYQdkTzsjpe
         yV6imxRMH3sl/++viDPVUeIJ/vCevbLMdSjjsZMcj8XSI/rpg9BYepAkyrs3Pd3rJpzQ
         9Kv5yRYXsUOkeYIg2h7fyjSfKXlCQXOcuWhr4eWZsPuTQVT4k+SVLEhFNkv+wTEbUvHy
         MR9o+A8r12n0KQSEDWbFyMQCDg9ZyBlO33KnSfi5pa9xemzhG5bGd1yoVbDqRWcdH7Vi
         6oNg==
Content-Disposition: inline
In-Reply-To: <20230913073846.1528938-4-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 13, 2023 at 07:38:46AM +0000, Yosry Ahmed wrote:
> Stats flushing for memcg currently follows the following rules:
> - Always flush the entire memcg hierarchy (i.e. flush the root).
> - Only one flusher is allowed at a time. If someone else tries to flush
>   concurrently, they skip and return immediately.
> - A periodic flusher flushes all the stats every 2 seconds.
>=20
> The reason this approach is followed is because all flushes are
> serialized by a global rstat spinlock. On the memcg side, flushing is
> invoked from userspace reads as well as in-kernel flushers (e.g.
> reclaim, refault, etc). This approach aims to avoid serializing all
> flushers on the global lock, which can cause a significant performance
> hit under high concurrency.
>=20
> This approach has the following problems:
> - Occasionally a userspace read of the stats of a non-root cgroup will
>   be too expensive as it has to flush the entire hierarchy [1].
> - Sometimes the stats accuracy are compromised if there is an ongoing
>   flush, and we skip and return before the subtree of interest is
>   actually flushed. This is more visible when reading stats from
>   userspace, but can also affect in-kernel flushers.
>=20
> This patch aims to solve both problems by reworking how flushing
> currently works as follows:
> - Without contention, there is no need to flush the entire tree. In this
>   case, only flush the subtree of interest. This avoids the latency of a
>   full root flush if unnecessary.
> - With contention, fallback to a coalesced (aka unified) flush of the
>   entire hierarchy, a root flush. In this case, instead of returning
>   immediately if a root flush is ongoing, wait for it to finish
>   *without* attempting to acquire the lock or flush. This is done using
>   a completion. Compared to competing directly on the underlying lock,
>   this approach makes concurrent flushing a synchronization point
>   instead of a serialization point. Once  a root flush finishes, *all*
>   waiters can wake up and continue at once.
> - Finally, with very high contention, bound the number of waiters to the
>   number of online cpus. This keeps the flush latency bounded at the tail
>   (very high concurrency). We fallback to sacrificing stats freshness only
>   in such cases in favor of performance.
>=20
> This was tested in two ways on a machine with 384 cpus:
> - A synthetic test with 5000 concurrent workers doing allocations and
>   reclaim, as well as 1000 readers for memory.stat (variation of [2]).
>   No significant regressions were noticed in the total runtime.
>   Note that if concurrent flushers compete directly on the spinlock
>   instead of waiting for a completion, this test shows 2x-3x slowdowns.
>   Even though subsequent flushers would have nothing to flush, just the
>   serialization and lock contention is a major problem. Using a
>   completion for synchronization instead seems to overcome this problem.
>=20
> - A synthetic stress test for concurrently reading memcg stats provided
>   by Wei Xu.
>   With 10k threads reading the stats every 100ms:
>   - 98.8% of reads take <100us
>   - 1.09% of reads take 100us to 1ms.
>   - 0.11% of reads take 1ms to 10ms.
>   - Almost no reads take more than 10ms.
>   With 10k threads reading the stats every 10ms:
>   - 82.3% of reads take <100us.
>   - 4.2% of reads take 100us to 1ms.
>   - 4.7% of reads take 1ms to 10ms.
>   - 8.8% of reads take 10ms to 100ms.
>   - Almost no reads take more than 100ms.
>=20
> [1] https://lore.kernel.org/lkml/CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO=
9ME4-dsgfoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
> [2] https://lore.kernel.org/lkml/CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZ=
cz6POYTV-4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
> [3] https://lore.kernel.org/lkml/CAAPL-u9D2b=3DiF5Lf_cRnKxUfkiEe0AMDTu6yh=
rUAzX0b6a6rDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
>=20
> [weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org: suggested the fallback =
logic and bounding the
> number of waiters]
>=20
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gman=
e.org>

>  	/*
> +	 * Opportunistically try to only flush the requested subtree. Otherwise
> +	 * fallback to a coalesced flush below.
>  	 */
> -	if (atomic_read(&stats_flush_ongoing) ||
> -	    atomic_xchg(&stats_flush_ongoing, 1))
> +	if (!mem_cgroup_is_root(memcg) && mutex_trylock(&subtree_flush_mutex)) {
> +		cgroup_rstat_flush(memcg->css.cgroup);
> +		mutex_unlock(&subtree_flush_mutex);
>  		return;
> +	}
> =20
> -	WRITE_ONCE(flush_last_time, jiffies_64);
> -
> -	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
> +	/* A coalesced root flush is in order. Are we the designated flusher? */
> +	spin_lock(&root_flusher_lock);

I can't say I'm crazy about this.

Let's say you have a fairly sprawling and active cgroup tree with lots
of updates in lots of groups in the system.

Add a periodic memory.stat reader to one of the subgroups, and that
reader will do very fast, localized aggregation.

Now add a periodic memory.stat reader to some other subgroup. They
might still both do very fast, localized aggregation. Or they might
collide; and now - despite having nothing in common, and sharing no
data besides the rstat lock - will have to flush the entire massive
tree. The rate at which this happens is purely dependent on timing of
what should be independent actors. This is really not great for the
p50 vs p99 gap.

I think this whole thing is getting away from us.

When we first switched to rstat, every reader would take the global
rstat lock and then flush its local subtree of interest.

This was changed in the following commit:

commit fd25a9e0e23b995fd0ba5e2f00a1099452cbc3cf
Author: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date:   Fri Nov 5 13:37:34 2021 -0700

    memcg: unify memcg stat flushing
   =20
    The memcg stats can be flushed in multiple context and potentially in
    parallel too.  For example multiple parallel user space readers for
    memcg stats will contend on the rstat locks with each other.  There is
    no need for that.  We just need one flusher and everyone else can
    benefit.
   =20
    In addition after aa48e47e3906 ("memcg: infrastructure to flush memcg
    stats") the kernel periodically flush the memcg stats from the root, so,
    the other flushers will potentially have much less work to do.
   =20
    Link: https://lkml.kernel.org/r/20211001190040.48086-2-shakeelb-hpIqsD4=
AKlfQT0dZR+AlfA@public.gmane.org
    Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gma=
ne.org>
    Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.o=
rg>
    Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
    Cc: "Michal Koutn=FD" <mkoutny-IBi9RG/b67k@public.gmane.org>
    Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@pub=
lic.gmane.org>
    Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+=
b@public.gmane.org>

The idea was that we can avoid lock contention if somebody is already
doing the flushing. However, you're now bringing global serialization.
Clearly that idea didn't work out. What would be an obstacle to go
back to the original way of doing it?

With one reader, this will work the same as in your proposal.

With two readers, just like in your proposal, flushing must be
serialized against the root level. But at least the two flushes only
aggregate the local data they actually care about - not the entire
tree data that doesn't even have readers! This is much better for lock
contention and performance.

One concern is the thresholding code. The cost of flushing on every
read is too high: even when there is no flush work, checking for it is
kind of expensive due to the locks and the for_each_possible_cpu().

Could we do something like the following?

	mem_cgroup_flush(memcg)
	{
		mutex_lock(&memcg_flush_mutex);
		if (atomic_read(&memcg->stat_delta) > THRESHOLD)
			cgroup_rstat_flush(memcg);
		mutex_unlock(&memcg_flush_mutex);
	}

	mem_cgroup_css_rstat_flush(css, cpu)
	{
		...
		/*
		 * Reset here instead of mem_cgroup_flush()
		 * so that each flushed subgroup is reset
		 * recursively. A recent parent flush will
		 * allow a child flush to skip.
		 */
		atomic_set(&mem_cgroup_from_css(css)->stat_delta, 0);
	}

	memcg_rstat_updated(memcg, val)
	{
		atomic_add(&memcg->stat_delta, val);
	}
