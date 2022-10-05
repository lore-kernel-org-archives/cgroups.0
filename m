From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC] memcg rstat flushing optimization
Date: Tue, 4 Oct 2022 18:17:40 -0700
Message-ID: <CAJD7tkZQ+L5N7FmuBAXcg_2Lgyky7m=fkkBaUChr7ufVMHss=A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date;
        bh=wKEtZiXDz87n8b96HSwoP0cLh0C7jyCCww9QlL2G0QQ=;
        b=dQCLd9ZJb+EU+6pDOHcUcK51l9MyM2MRIxnvcivW7rzZ5K/tAQ2zNSu642hI3JM2tm
         oFje2cbkO1YyMErawMODJhBrkUVw6tG/bK8qdxXgZ7SmhzKzvLiVErxtfAuW1Jc4lWgf
         lY+3hMTG7uq1GJagqorBTId8QPuvQzyIo1781rgDMoGMklyq/NJLZ5N8tjHwF09fR+iv
         XVx8J/+8UXCN68Av4/LqigIqaeo5xgrXWfDeXXkJ30BY0j2R2EU9m+ZF0h2hrMxw0BDk
         hYnxwiZcA3Ff5WWqFl+hhLdf3IBJBIDEWjf6iE2nPNHgPKboiGl5uwL7mOm6nqkjZbRa
         lRUw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hey everyone,

Sorry for the long email :)

We have recently ran into a hard lockup on a machine with hundreds of
CPUs and thousands of memcgs during an rstat flush. There have also
been some discussions during LPC between myself, Michal Koutn=C3=BD, and
Shakeel about memcg rstat flushing optimization. This email is a
follow up on that, discussing possible ideas to optimize memcg rstat
flushing.

Currently, mem_cgroup_flush_stats() is the main interface to flush
memcg stats. It has some internal optimizations that can skip a flush
if there hasn't been significant updates in general. It always flushes
the entire memcg hierarchy, and always invokes flushing using
cgroup_rstat_flush_irqsafe(), which has interrupts disabled and does
not sleep. As you can imagine, with a sufficiently large number of
memcgs and cpus, a call to mem_cgroup_flush_stats() might be slow, or
in an extreme case like the one we ran into, cause a hard lockup
(despite periodically flushing every 4 seconds).

(a) A first step might be to introduce a non _irqsafe version of
mem_cgroup_flush_stats(), and only call the _irqsafe version in places
where we can't sleep. This will exclude some contexts from possibly
introducing a lockup, like the stats reading context and the periodic
flushing context.

(b) We can also stop flushing the entire memcg hierarchy in hopes that
flushing might happen incrementally over subtrees, but this was
introduced to reduce lock contention when there are multiple contexts
trying to flush memcgs stats concurrently, where only one of them will
flush and all the others return immediately (although there is some
inaccuracy here as we didn't actually wait for the flush to complete).
This will re-introduce the lock contention. Maybe we can mitigate this
in rstat code by having hierarchical locks instead of a global lock,
although I can imagine this can quickly get too complicated.

(c) One other thing we can do (similar to the recent blkcg patch
series [1]) is keep track of which stats have been updated. We
currently flush MEMCG_NR_STATS + MEMCG_NR_EVENTS (thanks to Shakeel) +
nodes * NR_VM_NODE_STAT_ITEMS. I didn't make the exact calculation but
I suspect this easily goes over a 100. Keeping track of updated stats
might be in the form of a percpu bitmask. It will introduce some
overhead to the update side and flush sides, but it can help us skip a
lot of up-to-date stats and cache misses. In a few sample machines I
have found that every (memcg, cpu) pair had less than 5 stats on
average that are actually updated.

(d) Instead of optimizing rstat flushing in general, we can just
mitigate the cases that can actually cause a lockup. After we do (a)
and separate call sites that actually need to disable interrupts, we
can introduce a new selective flush callback (e.g.
cgroup_rstat_flush_opts()). This callback can flush only the stats we
care about (bitmask?) and leave the rstat tree untouched (only
traverse the tree, don't pop the nodes). It might be less than optimal
in cases where the stats we choose to flush are the only ones that are
updated, and the cgroup just remains on the rstat tree for no reason.
However, it effectively addresses the cases that can cause a lockup by
only flushing a small subset of the stats.

(e) If we do both (c) and (d), we can go one step further. We can make
cgroup_rstat_flush_opts() return a boolean to indicate whether this
cgroup is completely flushed (what we asked to flush is all what was
updated). If true, we can remove the cgroup from the rstat tree.
However, to do this we will need to have separate rstat trees for each
subsystem or to keep track of which subsystems have updates for a
cgroup (so that if cgroup_rstat_flush_opts() returns true we know if
we can remove the cgroup from the tree or not).

Of course nothing is free. Most of the solutions above will either
introduce overhead somewhere, complexity, or both. We also don't have
a de facto benchmark that will tell us for sure if a change made
things generally better or not, as it will vastly differ depending on
the setup, the workloads, etc. Nothing will make everything better for
all use cases. This is just me kicking off a discussion to see what we
can/should do :)

[1] https://lore.kernel.org/lkml/20221004151748.293388-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org=
/
