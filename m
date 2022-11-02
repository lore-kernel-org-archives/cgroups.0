From: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/3] Avoid scheduling cache draining to isolated cpus
Date: Tue,  1 Nov 2022 23:02:40 -0300
Message-ID: <20221102020243.522358-1-leobras@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667354621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gev6P7R24DpRq36R8wXz2kmWLBFI3J+84j/AqTpnyIw=;
        b=MMgpzDsEu7IISUbhnfHtQ9SBuF/cRzwGanUp6m2TEWuJ+XPWlY9Z0rRsmFXl4mZgBRUivA
        fAb/DJvqkqq9Eai6Xheaf/jY0CPytmLW7VBPCmUjGH0vs4KHTVP/pL/QBkZMRCBWux777b
        AbCm2rOoUPJKLeiErRIasf8FJ9DDnAI=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mt>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Patch #1 expands housekeepíng_any_cpu() so we can find housekeeping cpus
closer (NUMA) to any desired CPU, instead of only the current CPU.

### Performance argument that motivated the change:
There could be an argument of why would that be needed, since the current
CPU is probably acessing the current cacheline, and so having a CPU closer
to the current one is always the best choice since the cache invalidation
will take less time. OTOH, there could be cases like this which uses
perCPU variables, and we can have up to 3 different CPUs touching the
cacheline:

C1 - Isolated CPU: The perCPU data 'belongs' to this one
C2 - Scheduling CPU: Schedule some work to be done elsewhere, current cpu
C3 - Housekeeping CPU: This one will do the work

Most of the times the cacheline is touched, it should be by C1. Some times
a C2 will schedule work to run on C3, since C1 is isolated.

If C1 and C2 are in different NUMA nodes, we could have C3 either in
C2 NUMA node (housekeeping_any_cpu()) or in C1 NUMA node 
(housekeeping_any_cpu_from(C1). 

If C3 is in C2 NUMA node, there will be a faster invalidation when C3
tries to get cacheline exclusivity, and then a slower invalidation when
this happens in C1, when it's working in its data.

If C3 is in C1 NUMA node, there will be a slower invalidation when C3
tries to get cacheline exclusivity, and then a faster invalidation when
this happens in C1.

The thing is: it should be better to wait less when doing kernel work
on an isolated CPU, even at the cost of some housekeeping CPU waiting
a few more cycles.
###

Patch #2 changes the locking strategy of memcg_stock_pcp->stock_lock from
local_lock to spinlocks, so it can be later used to do remote percpu
cache draining on patch #3. Most performance concerns should be pointed
in the commit log.

Patch #3 implements the remote per-CPU cache drain, making use of both 
patches #2 and #3. Performance-wise, in non-isolated scenarios, it should
introduce an extra function call and a single test to check if the CPU is
isolated. 

On scenarios with isolation enabled on boot, it will also introduce an
extra test to check in the cpumask if the CPU is isolated. If it is,
there will also be an extra read of the cpumask to look for a
housekeeping CPU.

Please, provide any feedback on that!
Thanks a lot for reading!

Leonardo Bras (3):
  sched/isolation: Add housekeepíng_any_cpu_from()
  mm/memcontrol: Change stock_lock type from local_lock_t to spinlock_t
  mm/memcontrol: Add drain_remote_stock(), avoid drain_stock on isolated
    cpus

 include/linux/sched/isolation.h | 11 +++--
 kernel/sched/isolation.c        |  8 ++--
 mm/memcontrol.c                 | 83 ++++++++++++++++++++++-----------
 3 files changed, 69 insertions(+), 33 deletions(-)

-- 
2.38.1

