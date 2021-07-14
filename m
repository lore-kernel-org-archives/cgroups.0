From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 2/6] workqueue: Decouple HK_FLAG_WQ and HK_FLAG_DOMAIN cpumask fetch
Date: Wed, 14 Jul 2021 15:54:16 +0200
Message-ID: <20210714135420.69624-3-frederic@kernel.org>
References: <20210714135420.69624-1-frederic@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626270873;
        bh=hwa9dZbwQb6e2uewfwoomlLnro+e6qpIwA8eeMY71nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdFGzMH5oquC8WgqwTxb2xAa21B/AY2Q2QiVRrxuA65Ag1vzw2uvXbsV+GSyv8cQn
         CA2SLYGD7WLt9fADtnbS9SMCMrqqszAmMHNQnR+df1QJ04Kb63Ox/+wzq34PP37FK8
         Mx5TloljxZAqEzPAYzp1xiE3EnVngQFm/AwdxcoRiGgNm46eeRr0xRg4dTcDIHml2b
         AsUwELbPxfL3hlKGXr4d/B/5nEsNOQfS5PrsiB/KUBsaf2GpsqxOLQGWD175OjdD4+
         fnLrOjLkcnAoRdNksf37PLxD8Ix+WhQsqi8/aNDVFv0QmOC2djU97Nio1FvNIq92H8
         ULW5vsPmB+T3Q==
In-Reply-To: <20210714135420.69624-1-frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

To prepare for supporting each feature of the housekeeping cpumask
toward cpuset, prepare for HK_FLAG_DOMAIN to move to its own cpumask.
This will allow to modify the set passed through "isolcpus=" kernel boot
parameter on runtime.

Signed-off-by: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>
---
 kernel/workqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 50142fc08902..d29c5b61a333 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5938,13 +5938,13 @@ static void __init wq_numa_init(void)
 void __init workqueue_init_early(void)
 {
 	int std_nice[NR_STD_WORKER_POOLS] = { 0, HIGHPRI_NICE_LEVEL };
-	int hk_flags = HK_FLAG_DOMAIN | HK_FLAG_WQ;
 	int i, cpu;
 
 	BUILD_BUG_ON(__alignof__(struct pool_workqueue) < __alignof__(long long));
 
 	BUG_ON(!alloc_cpumask_var(&wq_unbound_cpumask, GFP_KERNEL));
-	cpumask_copy(wq_unbound_cpumask, housekeeping_cpumask(hk_flags));
+	cpumask_copy(wq_unbound_cpumask, housekeeping_cpumask(HK_FLAG_WQ));
+	cpumask_and(wq_unbound_cpumask, wq_unbound_cpumask, housekeeping_cpumask(HK_FLAG_DOMAIN));
 
 	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
 
-- 
2.25.1

