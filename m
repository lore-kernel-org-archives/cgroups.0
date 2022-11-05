From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v10 3/3] blk-cgroup: Flush stats at blkgs destruction path
Date: Fri,  4 Nov 2022 20:59:02 -0400
Message-ID: <20221105005902.407297-4-longman@redhat.com>
References: <20221105005902.407297-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667609966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TbSqpBbgk+NOPaOLl9NnIjbIwkdm/eU7seDomB5Bqqc=;
        b=hC3W5xrv1hzpboUte+r7ZCXiko2DbKz7tJAvWpY9f/TfmOnVFZzEJSkf4oNCDkY7Joafye
        /jT7nhodOprYfpsJLHdGgF3baXQNdZlx7KpiRenq6iRDawfJuSmyxVCW/Kh5Xg5NMGSR0B
        v6GS31NKvzdB8te+F88ba9iNF2yyQTg=
In-Reply-To: <20221105005902.407297-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

As noted by Michal, the blkg_iostat_set's in the lockless list
hold reference to blkg's to protect against their removal. Those
blkg's hold reference to blkcg. When a cgroup is being destroyed,
cgroup_rstat_flush() is only called at css_release_work_fn() which is
called when the blkcg reference count reaches 0. This circular dependency
will prevent blkcg from being freed until some other events cause
cgroup_rstat_flush() to be called to flush out the pending blkcg stats.

To prevent this delayed blkcg removal, add a new cgroup_rstat_css_flush()
function to flush stats for a given css and cpu and call it at the blkgs
destruction path, blkcg_destroy_blkgs(), whenever there are still some
pending stats to be flushed. This will ensure that blkcg reference
count can reach 0 ASAP.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c     | 15 ++++++++++++++-
 include/linux/cgroup.h |  1 +
 kernel/cgroup/rstat.c  | 20 ++++++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3e03c0d13253..57941d2a8ba3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1084,10 +1084,12 @@ struct list_head *blkcg_get_cgwb_list(struct cgroup_subsys_state *css)
  */
 static void blkcg_destroy_blkgs(struct blkcg *blkcg)
 {
+	int cpu;
+
 	might_sleep();
 
+	css_get(&blkcg->css);
 	spin_lock_irq(&blkcg->lock);
-
 	while (!hlist_empty(&blkcg->blkg_list)) {
 		struct blkcg_gq *blkg = hlist_entry(blkcg->blkg_list.first,
 						struct blkcg_gq, blkcg_node);
@@ -1110,6 +1112,17 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
 	}
 
 	spin_unlock_irq(&blkcg->lock);
+
+	/*
+	 * Flush all the non-empty percpu lockless lists.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
+
+		if (!llist_empty(lhead))
+			cgroup_rstat_css_cpu_flush(&blkcg->css, cpu);
+	}
+	css_put(&blkcg->css);
 }
 
 /**
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 528bd44b59e2..6c4e66b3fa84 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -766,6 +766,7 @@ void cgroup_rstat_flush(struct cgroup *cgrp);
 void cgroup_rstat_flush_irqsafe(struct cgroup *cgrp);
 void cgroup_rstat_flush_hold(struct cgroup *cgrp);
 void cgroup_rstat_flush_release(void);
+void cgroup_rstat_css_cpu_flush(struct cgroup_subsys_state *css, int cpu);
 
 /*
  * Basic resource stats.
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 793ecff29038..910e633869b0 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -281,6 +281,26 @@ void cgroup_rstat_flush_release(void)
 	spin_unlock_irq(&cgroup_rstat_lock);
 }
 
+/**
+ * cgroup_rstat_css_cpu_flush - flush stats for the given css and cpu
+ * @css: target css to be flush
+ * @cpu: the cpu that holds the stats to be flush
+ *
+ * A lightweight rstat flush operation for a given css and cpu.
+ * Only the cpu_lock is being held for mutual exclusion, the cgroup_rstat_lock
+ * isn't used.
+ */
+void cgroup_rstat_css_cpu_flush(struct cgroup_subsys_state *css, int cpu)
+{
+	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
+
+	raw_spin_lock_irq(cpu_lock);
+	rcu_read_lock();
+	css->ss->css_rstat_flush(css, cpu);
+	rcu_read_unlock();
+	raw_spin_unlock_irq(cpu_lock);
+}
+
 int cgroup_rstat_init(struct cgroup *cgrp)
 {
 	int cpu;
-- 
2.31.1

