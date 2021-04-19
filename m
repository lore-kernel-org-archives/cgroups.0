From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/5] mm/memcg: Reduce kmemcache memory accounting overhead
Date: Sun, 18 Apr 2021 20:00:27 -0400
Message-ID: <20210419000032.5432-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618790456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=yKxQATdGznhOXpI/AZM1Ukls2PIZ1+2c4XLkkNdNT6Q=;
        b=DvQGilwMpHgKY0Hn2ij8KN82HO2JMQmIjCfweIHUZFQyzdIbCBvzZ6X4sQMEijHrZze6NT
        V0+jxJ/pQX6In1WFJFmCc06G2C24l+t2a761xDWTti36zWHPk4vqgNuzLxOzsuny1Gku/M
        43RIY89Gj5ZmpPFLpdFSHsWEUJyubkM=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v4:
  - Drop v3 patch 1 as well as modification to mm/percpu.c as the percpu
    vmstat update isn't frequent enough to worth caching it.
  - Add a new patch 1 to move Move mod_objcg_state() to memcontrol.c instead.
  - Combine v3 patches 4 & 5 into a single patch (patch 3).
  - Add a new patch 4 to cache both reclaimable & unreclaimable vmstat updates.
  - Add a new patch 5 to improve refill_obj_stock() performance.

 v3:
  - Add missing "inline" qualifier to the alternate mod_obj_stock_state()
    in patch 3.
  - Remove redundant current_obj_stock() call in patch 5.

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
kmem_cache_alloc() and kmem_cache_free() of either a small 32-byte object
or a big 4k object at module init time is used for benchmarking. The
test was run on a CascadeLake server with turbo-boosting disable to
reduce run-to-run variation.

With memory accounting disable, the run time was 2.848s with small object
and 2.890s for the big object. With memory accounting enabled, the run
times with the application of various patches in the patchset were:

  Applied patches   Run time   Accounting overhead   %age 1   %age 2
  ---------------   --------   -------------------   ------   ------

  Small 32-byte object:
       None          10.570s         7.722s          100.0%   271.1%
        1-2           8.560s         5.712s           74.0%   200.6%
        1-3           6.592s         3.744s           48.5%   131.5%
        1-4           7.154s         4.306s           55.8%   151.2%
	1-5           7.192s         4.344s           56.3%   152.5%

  Large 4k object:
       None          20.612s        17.722s          100.0%   613.2%
        1-2          20.354s        17.464s           98.5%   604.3%
        1-3          19.395s        16.505s           93.1%   571.1%
        1-4          19.094s        16.204s           91.4%   560.7%
	1-5          13.576s        10.686s           60.3%   369.8%

  N.B. %age 1 = overhead/unpatched overhead
       %age 2 = overhead/accounting disable time

The small object test exercises mainly the object stock charging and
vmstat update code paths. The large object test also exercises the
refill_obj_stock() and  __memcg_kmem_charge()/__memcg_kmem_uncharge()
code paths.

The vmstat data stock caching helps in the small object test,
but not so much on the large object test. Similarly, eliminating
irq_disable/irq_enable helps in the small object test and less so in
the large object test. Caching both reclaimable and non-reclaimable
vmstat data actually regresses performance a bit in this particular
small object test.

The final patch to optimize refill_obj_stock() has negligible impact
on the small object test as this code path isn't being exercised. The
large object test, however, sees a pretty good performance improvement
with this patch.

[1] https://lore.kernel.org/linux-mm/20210408193948.vfktg3azh2wrt56t@gabell/T/#u
[2] https://lore.kernel.org/lkml/20210114025151.GA22932@xsang-OptiPlex-9020/

Waiman Long (5):
  mm/memcg: Move mod_objcg_state() to memcontrol.c
  mm/memcg: Cache vmstat data in percpu memcg_stock_pcp
  mm/memcg: Optimize user context object stock access
  mm/memcg: Save both reclaimable & unreclaimable bytes in object stock
  mm/memcg: Improve refill_obj_stock() performance

 mm/memcontrol.c | 199 +++++++++++++++++++++++++++++++++++++++++-------
 mm/slab.h       |  16 +---
 2 files changed, 175 insertions(+), 40 deletions(-)

-- 
2.18.1

