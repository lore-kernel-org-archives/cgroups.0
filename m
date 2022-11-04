From: Waiman Long <longman@redhat.com>
Subject: [PATCH v9 3/3] blk-cgroup: Flush stats at blkgs destruction path
Date: Fri,  4 Nov 2022 14:20:50 -0400
Message-ID: <20221104182050.342908-4-longman@redhat.com>
References: <20221104182050.342908-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667586063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjL1+H6RuB7jMr/6XEfK1aTzhYLFDKOwXB8sr3ps4w8=;
        b=bpOAy8VZaGLLKR3u7Y42mKoTA5coS8qvbeF0/m37WvMvibU396jq01xLnmmLR63FYjB45t
        Nd/dW5qiQIyyn/LVxomr7MjjuW1Q22m2SeSA7P83VLHOnIZ6dnRIEUTU9QaMvECDZgviXQ
        23bXm7ki5qsZ82b4ylo3QwGqtT3ULlA=
In-Reply-To: <20221104182050.342908-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>, Waiman Long <longman@redhat.com>

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

Signed-off-by: Waiman Long <longman@redhat.com>
---
 block/blk-cgroup.c     | 15 ++++++++++++++-
 include/linux/cgroup.h |  1 +
 kernel/cgroup/rstat.c  | 20 ++++++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3e03c0d13253..fa0a366e3476 100644
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
+			cgroup_rstat_css_flush(&blkcg->css, cpu);
+	}
+	css_put(&blkcg->css);
 }
 
 /**
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 528bd44b59e2..4a61cc5d1952 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -766,6 +766,7 @@ void cgroup_rstat_flush(struct cgroup *cgrp);
 void cgroup_rstat_flush_irqsafe(struct cgroup *cgrp);
 void cgroup_rstat_flush_hold(struct cgroup *cgrp);
 void cgroup_rstat_flush_release(void);
+void cgroup_rstat_css_flush(struct cgroup_subsys_state *css, int cpu);
 
 /*
  * Basic resource stats.
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 793ecff29038..28033190fb29 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -281,6 +281,26 @@ void cgroup_rstat_flush_release(void)
 	spin_unlock_irq(&cgroup_rstat_lock);
 }
 
+/**
+ * cgroup_rstat_css_flush - flush stats for the given css and cpu
+ * @css: target css to be flush
+ * @cpu: the cpu that holds the stats to be flush
+ *
+ * A lightweight rstat flush operation for a given css and cpu.
+ * Only the cpu_lock is being held for mutual exclusion, the cgroup_rstat_lock
+ * isn't used.
+ */
+void cgroup_rstat_css_flush(struct cgroup_subsys_state *css, int cpu)
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

