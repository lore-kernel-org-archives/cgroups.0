From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] slab: make memcg slab destruction scalable
Date: Sat, 14 Jan 2017 00:54:40 -0500
Message-ID: <20170114055449.11044-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=gnVzrysm2ge4jh2bCqRLyZUWbFZ3eKhJARTDEKzSBOY=;
        b=KeLH4STULKEOrCDuGxjXl7mzvNMwyymWa0eYLn6Fjxx6yVPAo10PWSRriM7Kf8x3WN
         +kO6fzJeYGitguVWGrOhroS95yzeBOkCxC3QDdfTAtzdKnRPfmOG9g2MfLATwaoKVj/j
         O/r08pnISArsGNpeAX/tKO9C3tqSFfIhODfMVttrzWaU0DjKSApRn870+RrkgY1pumtX
         ycF/dgVNEaS95GU2IcEsabonzJbPLVrgsxMDYexWn7e1MSP12oefuW9bTmZtIIuyh++N
         Ej2l/ZREMqXSBn1uYzKE9HNTZRaxIlf7igyIeY4W5hDadQOK7lxBIRhkGEYqBYf5pT5T
         2fgA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: jsvana-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

With kmem cgroup support enabled, kmem_caches can be created and
destroyed frequently and a great number of near empty kmem_caches can
accumulate if there are a lot of transient cgroups and the system is
not under memory pressure.  When memory reclaim starts under such
conditions, it can lead to consecutive deactivation and destruction of
many kmem_caches, easily hundreds of thousands on moderately large
systems, exposing scalability issues in the current slab management
code.

I've seen machines which end up with hundred thousands of caches and
many millions of kernfs_nodes.  The current code is O(N^2) on the
total number of caches and has synchronous rcu_barrier() and
synchronize_sched() in cgroup offline / release path which is executed
while holding cgroup_mutex.  Combined, this leads to very expensive
and slow cache destruction operations which can easily keep running
for half a day.

This also messes up /proc/slabinfo along with other cache iterating
operations.  seq_file operates on 4k chunks and on each 4k boundary
tries to seek to the last position in the list.  With a huge number of
caches on the list, this becomes very slow and very prone to the list
content changing underneath it leading to a lot of missing and/or
duplicate entries.

This patchset addresses the scalability problem.

* Separate out root and memcg cache lists and add per-memcg list.
  Update each user to use the appropriate list.

* Replace rcu_barrier() and synchronize_rcu() with call_rcu() and
  call_rcu_sched().

* For dying empty slub caches, remove the sysfs files after
  deactivation so that we don't end up with millions of sysfs files
  without any useful information on them.

This patchset contains the following nine patches.

 0001-Revert-slub-move-synchronize_sched-out-of-slab_mutex.patch
 0002-slab-remove-synchronous-rcu_barrier-call-in-memcg-ca.patch
 0003-slab-simplify-shutdown_memcg_caches.patch
 0004-slab-reorganize-memcg_cache_params.patch
 0005-slab-link-memcg-kmem_caches-on-their-associated-memo.patch
 0006-slab-don-t-put-memcg-caches-on-slab_caches-list.patch
 0007-slab-introduce-__kmemcg_cache_deactivate.patch
 0008-slab-remove-synchronous-synchronize_sched-from-memcg.patch
 0009-slab-remove-slub-sysfs-interface-files-early-for-emp.patch

0001 reverts an existing optimization to prepare for the following
changes.  0002 replaces rcu_barrier() in release path with call_rcu().
0003-0006 separate out the lists.  0007-0008 replace
synchronize_sched() in slub destruction path with call_rcu_sched().
0009 removes sysfs files early for empty dying caches.

This patchset is on top of the current linus#master a121103c9228 and
also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-kmemcg-scalability

diffstat follows.  Thanks.

 include/linux/memcontrol.h |    1 
 include/linux/slab.h       |   39 ++++-
 include/linux/slab_def.h   |    5 
 include/linux/slub_def.h   |    9 -
 mm/memcontrol.c            |    7 -
 mm/slab.c                  |    7 +
 mm/slab.h                  |   21 ++-
 mm/slab_common.c           |  306 ++++++++++++++++++++++++---------------------
 mm/slub.c                  |   54 +++++++
 9 files changed, 283 insertions(+), 166 deletions(-)

--
tejun
