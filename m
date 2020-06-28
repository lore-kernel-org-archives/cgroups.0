From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Memcg stat for available memory
Date: Sun, 28 Jun 2020 15:15:25 -0700 (PDT)
Message-ID: <alpine.DEB.2.22.394.2006281445210.855265@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=bXlGWq9uTXnkYLRzPxcb6hpxU9VpPN38TAS14IL4DXU=;
        b=CPgaqyT1Jx9UOYLiIqMfnX7Tf8eNkL68Qr1/ndCHQChQEw0gyxZi+wZUzq6eBBEYRP
         pc+/CPbBhO3TLXbzOpeL6KkxlJO3CVKJeraSBqfF3sF+qpffnEgV02KXVmzBtv0OmsTp
         tycxMlzZy0EYrAHx7xZ6f6yuD9xnqYzgXjiAto3WSR/jC/tWPL6YMP+AkFYNzaBaUe2h
         iiaGn/d/zTOQrsHPipdPoico8WwIC7LCRefUt6cRYW2jYFVcUa/MCvQc7g+uFidtHVsz
         gRz566TTpsUYf7tNIoceau+1/KmB0K+YMCwhdT3EdozGhMZmhEgzCrwl1FuvPMJqmUpp
         m35w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi everybody,

I'd like to discuss the feasibility of a stat similar to 
si_mem_available() but at memcg scope which would specify how much memory 
can be charged without I/O.

The si_mem_available() stat is based on heuristics so this does not 
provide an exact quantity that is actually available at any given time, 
but can otherwise provide userspace with some guidance on the amount of 
reclaimable memory.  See the description in 
Documentation/filesystems/proc.rst and its implementation.

 [ Naturally, userspace would need to understand both the amount of memory 
   that is available for allocation and for charging, separately, on an 
   overcommitted system.  I assume this is trivial.  (Why don't we provide 
   MemAvailable in per-node meminfo?) ]

For such a stat at memcg scope, we can ignore totalreserves and 
watermarks.  We already have ~precise (modulo MEMCG_CHARGE_BATCH) data for 
both file pages and slab_reclaimable.

We can infer lazily free memory by doing

	file - (active_file + inactive_file)

(This is necessary because lazy free memory is anon but on the inactive 
 file lru and we can't infer lazy freeable memory through pglazyfree -
 pglazyfreed, they are event counters.)

We can also infer the number of underlying compound pages that are on 
deferred split queues but have yet to be split with active_anon - anon (or
is this a bug? :)

So it *seems* like userspace can make a si_mem_available()-like 
calculation ("avail") by doing

	free = memory.high - memory.current
	lazyfree = file - (active_file + inactive_file)
	deferred = active_anon - anon

	avail = free + lazyfree + deferred +
		(active_file + inactive_file + slab_reclaimable) / 2

For userspace interested in knowing how much memory it can charge without 
incurring I/O (and assuming it has knowledge of available memory on an 
overcommitted system), it seems like:

 (a) it can derive the above avail amount that is at least similar to
     MemAvailable,

 (b) it can assume that all reclaim is considered equal so anything more
     than memory.high - memory.current is disruptive enough that it's a
     better heuristic than the above, or

 (c) the kernel provide an "avail" stat in memory.stat based on the above 
     and can evolve as the kernel implementation changes (how lazy free 
     memory impacts anon vs file lru stats, how deferred split memory is 
     handled, any future extensions for "easily reclaimable memory") that 
     userspace can count on to the same degree it can count on 
     MemAvailable.

Any thoughts?
