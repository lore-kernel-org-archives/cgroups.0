From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/5] mm/memcg: Reduce kmemcache memory accounting overhead
Date: Mon, 12 Apr 2021 18:54:58 -0400
Message-ID: <20210412225503.15119-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618268127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=TJxmmYkTPVvl2+ih4+GZ2DW2gMVPFn/WPrWSZF4KB64=;
        b=ZLg8mh9aXRGx2wmfNHXNEE+FTMdlwR9QdPj7agYx7iuOTjCKUNXGgj2pop/A2++zmRQtj5
        0cBGKGOp0AiraADSNTAVL972EYitZKcxjH+r59MG0KVE3fqK2htZ0yAojFZw+AWVolNAqL
        EwTcVY1ZG438Mf/jKu2vYs24qwe9a4w=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v2:
  - Fix bug found by test robot in patch 5.
  - Update cover letter and commit logs.

With the recent introduction of the new slab memory controller, we
eliminate the need for having separate kmemcaches for each memory
cgroup and reduce overall kernel memory usage. However, we also add
additional memory accounting overhead to each call of kmem_cache_alloc()
and kmem_cache_free().

For workloads that require a lot of kmemcache allocations and
de-allocations, they may experience performance regression as illustrated
in [1] and [2].

A simple kernel module that performs repeated loop of 100,000,000
kmem_cache_alloc() and kmem_cache_free() of a 64-byte object at module
init time is used for benchmarking. The test was run on a CascadeLake
server with turbo-boosting disable to reduce run-to-run variation.

With memory accounting disable, the run time was 2.848s. With memory
accounting enabled, the run times with the application of various
patches in the patchset were:

  Applied patches   Run time   Accounting overhead   Overhead %age
  ---------------   --------   -------------------   -------------
       None          10.800s         7.952s              100.0%
        1-2           9.140s         6.292s               79.1%
        1-3           7.641s         4.793s               60.3%
        1-5           6.801s         3.953s               49.7%

Note that this is the best case scenario where most updates happen only
to the percpu stocks. Real workloads will likely have a certain amount
of updates to the memcg charges and vmstats. So the performance benefit
will be less.

It was found that a big part of the memory accounting overhead
was caused by the local_irq_save()/local_irq_restore() sequences in
updating local stock charge bytes and vmstat array, at least in x86
systems. There are two such sequences in kmem_cache_alloc() and two
in kmem_cache_free(). This patchset tries to reduce the use of such
sequences as much as possible. In fact, it eliminates them in the common
case. Another part of this patchset to cache the vmstat data update in
the local stock as well which also helps.

[1] https://lore.kernel.org/linux-mm/20210408193948.vfktg3azh2wrt56t@gabell/T/#u
[2] https://lore.kernel.org/lkml/20210114025151.GA22932@xsang-OptiPlex-9020/

Waiman Long (5):
  mm/memcg: Pass both memcg and lruvec to mod_memcg_lruvec_state()
  mm/memcg: Introduce obj_cgroup_uncharge_mod_state()
  mm/memcg: Cache vmstat data in percpu memcg_stock_pcp
  mm/memcg: Separate out object stock data into its own struct
  mm/memcg: Optimize user context object stock access

 include/linux/memcontrol.h |  14 ++-
 mm/memcontrol.c            | 200 ++++++++++++++++++++++++++++++++-----
 mm/percpu.c                |   9 +-
 mm/slab.h                  |  32 +++---
 4 files changed, 197 insertions(+), 58 deletions(-)

-- 
2.18.1

