From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v10 11/16] vmscan: take at least one pass with shrinkers
Date: Sun,  7 Jul 2013 11:56:51 -0400
Message-ID: <1373212616-11713-12-git-send-email-glommer@openvz.org>
References: <1373212616-11713-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=n060NApHm1EmBvMeDNvtYZoNBNy++UiOkqivBri40SU=;
        b=QLzDDEhWVQJFVLVi4KpRKdA7oZSY235dz/4yPwSwx96RGcBfBZMg5vIrfPY7amhDUs
         gOIBhk4e1hLRvGLMr12LcEuVVZodnPI4Ovq5eez1C/MoiSf4PTHcxZ0ZHUt8DGhj1VSA
         KZdRwdSWxsoYTJYrR0kVYZIx0oDUjGmcdPOXLaSQsBCnrwJIsP2V9jHNhJiC65sipiIa
         Zp/EBZfM49zI0u8oUhAvqNMY12hv0va2EQE143GJCWQiSE7ynoj3K1kFrqkqnR1Z+aWg
         Zx2Ub0E1JVEPJSnR7MIxsF1+0G+DrDayISR6xtJZdhuP+xan9VbqDwt+8U2GiBT/XYxQ
         T1LQ==
In-Reply-To: <1373212616-11713-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mhocko-Y4LbUc7mvzI@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

In very low free kernel memory situations, it may be the case that we
have less objects to free than our initial batch size. If this is the
case, it is better to shrink those, and open space for the new workload
then to keep them and fail the new allocations.

In particular, we are concerned with the direct reclaim case for memcg.
Although this same technique can be applied to other situations just as well,
we will start conservative and apply it for that case, which is the one
that matters the most.

[ v6: only do it per memcg ]
[ v5: differentiate no-scan case, don't do this for kswapd ]

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
CC: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
 mm/vmscan.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f1ff892..7b8ea36 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -291,20 +291,33 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 				nr_pages_scanned, lru_pages,
 				max_pass, delta, total_scan);
 
-	while (total_scan >= batch_size) {
+	do {
 		unsigned long ret;
+		unsigned long nr_to_scan = min(batch_size, total_scan);
+		struct mem_cgroup *memcg = shrinkctl->target_mem_cgroup;
+
+		/*
+		 * Differentiate between "few objects" and "no objects"
+		 * as returned by the count step.
+		 */
+		if (!total_scan)
+			break;
+
+		if ((total_scan < batch_size) &&
+		   !(memcg && memcg_kmem_is_active(memcg)))
+			break;
 
-		shrinkctl->nr_to_scan = batch_size;
+		shrinkctl->nr_to_scan = nr_to_scan;
 		ret = shrinker->scan_objects(shrinker, shrinkctl);
 		if (ret == SHRINK_STOP)
 			break;
 		freed += ret;
 
-		count_vm_events(SLABS_SCANNED, batch_size);
-		total_scan -= batch_size;
+		count_vm_events(SLABS_SCANNED, nr_to_scan);
+		total_scan -= nr_to_scan;
 
 		cond_resched();
-	}
+	} while (total_scan >= batch_size);
 
 	/*
 	 * move the unused scan count back into the shrinker in a
-- 
1.8.2.1
