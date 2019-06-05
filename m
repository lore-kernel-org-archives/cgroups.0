From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC v2 3/5] workqueue, memcontrol: make memcg throttle workqueue workers
Date: Wed,  5 Jun 2019 09:36:48 -0400
Message-ID: <20190605133650.28545-4-daniel.m.jordan@oracle.com>
References: <20190605133650.28545-1-daniel.m.jordan@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=Ww3UO2Y64LsDIspP9nYZfcD+xc5topDBTlHYu02FoZk=;
 b=JTf9y2n/Sjoe4pCzMh/uy2QTChLH80qdYMT4tF5HvvdqnddEB6F4E7F4ln19olEOst+P
 s1d70dD4bMVQKxP4Wu+TyCMvlVbnlNw1Av/XCyGAad3Kwj35hUXdccR6qBwRPSim9lCU
 7Rb092NiSatD4WL50ijDmD/UXKm3bjtZxCByZFaqV88vG2iSAbuTpL79Hr6kx3DNUG60
 AllDwHwTDfclIdN9dy8zeJbbxLGmOLYPfZcfR/ES2Mtuqu9X1mGhxP5+Spi6RjmpSb8q
 nMtE1DTLPDzZD13aqefL2bhadYVaee21oqJeziL5s7NwKS9ai+fBjUFarxilJfvPWhIH gA== 
In-Reply-To: <20190605133650.28545-1-daniel.m.jordan@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, jiangshanlai@gmail.com, lizefan@huawei.com, tj@kernel.org
Cc: bsd@redhat.com, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, dave.hansen@intel.com, juri.lelli@redhat.com, mhocko@kernel.org, peterz@infradead.org, steven.sistare@oracle.com, tglx@linutronix.de, tom.hromatka@oracle.com, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Attaching a worker to a css_set isn't enough for all controllers to
throttle it.  In particular, the memory controller currently bypasses
accounting for kernel threads.

Support memcg accounting for cgroup-aware workqueue workers so that
they're appropriately throttled.

Another, probably better way to do this is to have kernel threads, or
even specifically cgroup-aware workqueue workers, call
memalloc_use_memcg and memalloc_unuse_memcg during cgroup migration
(memcg attach callback maybe).

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/workqueue.c          | 26 ++++++++++++++++++++++++++
 kernel/workqueue_internal.h |  5 +++++
 mm/memcontrol.c             | 26 ++++++++++++++++++++++++--
 3 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 89b90899bc09..c8cc69e296c0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -50,6 +50,8 @@
 #include <linux/sched/isolation.h>
 #include <linux/nmi.h>
 #include <linux/cgroup.h>
+#include <linux/memcontrol.h>
+#include <linux/sched/mm.h>
 
 #include "workqueue_internal.h"
 
@@ -1829,6 +1831,28 @@ static inline bool worker_in_child_cgroup(struct worker *worker)
 	return (worker->flags & WORKER_CGROUP) && cgroup_parent(worker->cgroup);
 }
 
+/* XXX Put this in the memory controller's attach callback. */
+#ifdef CONFIG_MEMCG
+static void worker_unuse_memcg(struct worker *worker)
+{
+	if (worker->task->active_memcg) {
+		struct mem_cgroup *memcg = worker->task->active_memcg;
+
+		memalloc_unuse_memcg();
+		css_put(&memcg->css);
+	}
+}
+
+static void worker_use_memcg(struct worker *worker)
+{
+	struct mem_cgroup *memcg;
+
+	worker_unuse_memcg(worker);
+	memcg = mem_cgroup_from_css(task_get_css(worker->task, memory_cgrp_id));
+	memalloc_use_memcg(memcg);
+}
+#endif /* CONFIG_MEMCG */
+
 static void attach_worker_to_dfl_root(struct worker *worker)
 {
 	int ret;
@@ -1841,6 +1865,7 @@ static void attach_worker_to_dfl_root(struct worker *worker)
 		rcu_read_lock();
 		worker->cgroup = task_dfl_cgroup(worker->task);
 		rcu_read_unlock();
+		worker_unuse_memcg(worker);
 	} else {
 		/*
 		 * TODO Modify the cgroup migration path to guarantee that a
@@ -1880,6 +1905,7 @@ static void attach_worker_to_cgroup(struct worker *worker,
 
 	if (cgroup_attach_kthread(cgroup) == 0) {
 		worker->cgroup = cgroup;
+		worker_use_memcg(worker);
 	} else {
 		/*
 		 * Attach failed, so attach to the default root so the
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 3ad5861258ca..f254b93edc2c 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -79,6 +79,11 @@ work_func_t wq_worker_last_func(struct task_struct *task);
 
 #ifdef CONFIG_CGROUPS
 
+#ifndef CONFIG_MEMCG
+static inline void worker_use_memcg(struct worker *worker) {}
+static inline void worker_unuse_memcg(struct worker *worker) {}
+#endif /* CONFIG_MEMCG */
+
 /*
  * A barrier work running in a cgroup-aware worker pool needs to specify a
  * cgroup.  For simplicity, WQ_BARRIER_CGROUP makes the worker stay in its
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 81a0d3914ec9..1a80931b124a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2513,9 +2513,31 @@ static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
 
 static inline bool memcg_kmem_bypass(void)
 {
-	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
+	if (in_interrupt())
 		return true;
-	return false;
+
+	if (unlikely(current->flags & PF_WQ_WORKER)) {
+		struct cgroup *parent;
+
+		/*
+		 * memcg should throttle cgroup-aware workers.  Infer the
+		 * worker is cgroup-aware by its presence in a non-root cgroup.
+		 *
+		 * This test won't detect a cgroup-aware worker attached to the
+		 * default root, but in that case memcg doesn't need to
+		 * throttle it anyway.
+		 *
+		 * XXX One alternative to this awkward block is adding a
+		 * cgroup-aware-worker bit to task_struct.
+		 */
+		rcu_read_lock();
+		parent = cgroup_parent(task_dfl_cgroup(current));
+		rcu_read_unlock();
+
+		return !parent;
+	}
+
+	return !current->mm || (current->flags & PF_KTHREAD);
 }
 
 /**
-- 
2.21.0

