From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH v2] vmpressure: make sure memcg stays alive until all users
 are signaled
Date: Thu, 11 Jul 2013 11:33:00 +0200
Message-ID: <20130711093300.GE21667@dhcp22.suse.cz>
References: <20130710184254.GA16979@mtj.dyndns.org>
 <20130711083110.GC21667@dhcp22.suse.cz>
 <51DE701C.6010800@huawei.com>
 <20130711092542.GD21667@dhcp22.suse.cz>
 <51DE7AAF.6070004@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51DE7AAF.6070004-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

OK, here we go with v2. Thanks a lot for catching up issues Li!
I am also CCing other memcg guys and linux-mm.
---
From 0c2ae555132594fa3557ede99fc4bf5c22827253 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Thu, 11 Jul 2013 10:30:31 +0200
Subject: [PATCH] vmpressure: make sure memcg stays alive until all users are
 signaled

vmpressure is called synchronously from the reclaim where the
target_memcg is guaranteed to be alive but the eventfd is signaled from
the work queue context which might happen after memcg reference has been
released and so there is no guarantee it will be still alive if there
are not listeners registered on the eventfd.

This patch adds two helpers vmpressure_{un}pin_memcg which take and
release memcg css reference count which are used by vmmpressure and
vmpressure_work_fn to fix this issue.

We have to use these helpers rather than touching memcg->css directly
because mem_cgroup is not defined outside of memcontrol.o.

[lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org: no need to check for root_mem_cgroup explicitly]
[lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org: handle schedule_work returning false properly]
Reported-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 include/linux/vmpressure.h |  3 +++
 mm/memcontrol.c            | 20 ++++++++++++++++++++
 mm/vmpressure.c            | 16 ++++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index 76be077..d301c6a 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -38,6 +38,9 @@ extern int vmpressure_register_event(struct cgroup *cg, struct cftype *cft,
 				     const char *args);
 extern void vmpressure_unregister_event(struct cgroup *cg, struct cftype *cft,
 					struct eventfd_ctx *eventfd);
+
+extern void vmpressure_pin_memcg(struct vmpressure *vmpr);
+extern void vmpressure_unpin_memcg(struct vmpressure *vmpr);
 #else
 static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 			      unsigned long scanned, unsigned long reclaimed) {}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6e120e4..8329262 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6195,6 +6195,26 @@ struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 }
 EXPORT_SYMBOL(parent_mem_cgroup);
 
+static inline
+struct mem_cgroup *vmpressure_to_mem_cgroup(struct vmpressure *vmpr)
+{
+	return container_of(vmpr, struct mem_cgroup, vmpressure);
+}
+
+void vmpressure_pin_memcg(struct vmpressure *vmpr)
+{
+	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
+
+	css_get(&memcg->css);
+}
+
+void vmpressure_unpin_memcg(struct vmpressure *vmpr)
+{
+	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
+
+	css_put(&memcg->css);
+}
+
 static void __init mem_cgroup_soft_limit_tree_init(void)
 {
 	struct mem_cgroup_tree_per_node *rtpn;
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 736a601..3a955412 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -22,6 +22,7 @@
 #include <linux/swap.h>
 #include <linux/printk.h>
 #include <linux/vmpressure.h>
+#include <linux/memcontrol.h>
 
 /*
  * The window size (vmpressure_win) is the number of scanned pages before
@@ -178,7 +179,7 @@ static void vmpressure_work_fn(struct work_struct *work)
 	 * vmpr->reclaimed is in sync.
 	 */
 	if (!vmpr->scanned)
-		return;
+		goto out;
 
 	mutex_lock(&vmpr->sr_lock);
 	scanned = vmpr->scanned;
@@ -195,6 +196,13 @@ static void vmpressure_work_fn(struct work_struct *work)
 		 * hierarchy.
 		 */
 	} while ((vmpr = vmpressure_parent(vmpr)));
+out:
+	/*
+	 * Reference has been taken in vmpressure.
+	 * memcg which embeds this vmpr might go away after this call so
+	 * no further manipulation with vmprs or work item is safe
+	 */
+	vmpressure_unpin_memcg(vmpr);
 }
 
 /**
@@ -248,7 +256,11 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 
 	if (scanned < vmpressure_win || work_pending(&vmpr->work))
 		return;
-	schedule_work(&vmpr->work);
+
+	/* Reference will be released in vmpressure_work_fn */
+	vmpressure_pin_memcg(vmpr);
+	if (!schedule_work(&vmpr->work))
+		vmpressure_unpin_memcg(vmpr);
 }
 
 /**
-- 
1.8.3.2

-- 
Michal Hocko
SUSE Labs
