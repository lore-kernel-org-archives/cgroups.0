From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] memcg: flatten task_struct->memcg_oom
Date: Sun, 13 Sep 2015 14:59:40 -0400
Message-ID: <20150913185940.GA25369@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=CWc5ebOZmw/jXUeHgNGbuBeiJTuWjnFfch1rXrKU08c=;
        b=fnZg81DvnfmS+m5kTt8OFaC9LO7Xr1Q/HLIlCaiaSPDtFatPooOnYYJ5MES4xQftHC
         O0NDQcqyKn1POecP9TOlJXC3/jX4JAut/urMUAh1LJeWYSm6LJY4ltMUhFvHMmZY2aBl
         mf4BMum4CyccawRGawg+gt1mMq6qVdV4rVRNojoE15DlQ8C+Y5nMVKRA9ZiZcz6GLjQv
         X7bTzi2eXzYBwqoU1woOEmz+OCYblr5tT0CTW0EDyVrYrrBog6XyYAxRmLzIX4H80X36
         AYgLkh78mgSDOHvVlDtJZ3c/3FsV6X9IeF6TYX7Lo59fyywUoPx6NqyugULCBx3sXFX5
         f/xA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

task_struct->memcg_oom is a sub-struct containing fields which are
used for async memcg oom handling.  Most task_struct fields aren't
packaged this way and it can lead to unnecessary alignment paddings.
This patch flattens it.

* task.memcg_oom.memcg          -> task.memcg_in_oom
* task.memcg_oom.gfp_mask	-> task.memcg_oom_gfp_mask
* task.memcg_oom.order          -> task.memcg_oom_order
* task.memcg_oom.may_oom        -> task.memcg_may_oom

In addition, task.memcg_may_oom is relocated to where other bitfields
are which reduces the size of task_struct.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
Hello,

Andrew, these are the two patches which got acked from the following
thread.

 http://lkml.kernel.org/g/20150828220158.GD11089-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org

Acks are added and the second patch's description is updated as
suggested by Michal and Vladimir.

Can you please put them in -mm?

Thanks!

 include/linux/memcontrol.h |   10 +++++-----
 include/linux/sched.h      |   13 ++++++-------
 mm/memcontrol.c            |   16 ++++++++--------
 3 files changed, 19 insertions(+), 20 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -407,19 +407,19 @@ void mem_cgroup_print_oom_info(struct me
 
 static inline void mem_cgroup_oom_enable(void)
 {
-	WARN_ON(current->memcg_oom.may_oom);
-	current->memcg_oom.may_oom = 1;
+	WARN_ON(current->memcg_may_oom);
+	current->memcg_may_oom = 1;
 }
 
 static inline void mem_cgroup_oom_disable(void)
 {
-	WARN_ON(!current->memcg_oom.may_oom);
-	current->memcg_oom.may_oom = 0;
+	WARN_ON(!current->memcg_may_oom);
+	current->memcg_may_oom = 0;
 }
 
 static inline bool task_in_memcg_oom(struct task_struct *p)
 {
-	return p->memcg_oom.memcg;
+	return p->memcg_in_oom;
 }
 
 bool mem_cgroup_oom_synchronize(bool wait);
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1451,7 +1451,9 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 	unsigned sched_migrated:1;
-
+#ifdef CONFIG_MEMCG
+	unsigned memcg_may_oom:1;
+#endif
 #ifdef CONFIG_MEMCG_KMEM
 	unsigned memcg_kmem_skip_account:1;
 #endif
@@ -1782,12 +1784,9 @@ struct task_struct {
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
 #ifdef CONFIG_MEMCG
-	struct memcg_oom_info {
-		struct mem_cgroup *memcg;
-		gfp_t gfp_mask;
-		int order;
-		unsigned int may_oom:1;
-	} memcg_oom;
+	struct mem_cgroup *memcg_in_oom;
+	gfp_t memcg_oom_gfp_mask;
+	int memcg_oom_order;
 #endif
 #ifdef CONFIG_UPROBES
 	struct uprobe_task *utask;
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1652,7 +1652,7 @@ static void memcg_oom_recover(struct mem
 
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	if (!current->memcg_oom.may_oom)
+	if (!current->memcg_may_oom)
 		return;
 	/*
 	 * We are in the middle of the charge context here, so we
@@ -1669,9 +1669,9 @@ static void mem_cgroup_oom(struct mem_cg
 	 * and when we know whether the fault was overall successful.
 	 */
 	css_get(&memcg->css);
-	current->memcg_oom.memcg = memcg;
-	current->memcg_oom.gfp_mask = mask;
-	current->memcg_oom.order = order;
+	current->memcg_in_oom = memcg;
+	current->memcg_oom_gfp_mask = mask;
+	current->memcg_oom_order = order;
 }
 
 /**
@@ -1693,7 +1693,7 @@ static void mem_cgroup_oom(struct mem_cg
  */
 bool mem_cgroup_oom_synchronize(bool handle)
 {
-	struct mem_cgroup *memcg = current->memcg_oom.memcg;
+	struct mem_cgroup *memcg = current->memcg_in_oom;
 	struct oom_wait_info owait;
 	bool locked;
 
@@ -1721,8 +1721,8 @@ bool mem_cgroup_oom_synchronize(bool han
 	if (locked && !memcg->oom_kill_disable) {
 		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
-		mem_cgroup_out_of_memory(memcg, current->memcg_oom.gfp_mask,
-					 current->memcg_oom.order);
+		mem_cgroup_out_of_memory(memcg, current->memcg_oom_gfp_mask,
+					 current->memcg_oom_order);
 	} else {
 		schedule();
 		mem_cgroup_unmark_under_oom(memcg);
@@ -1739,7 +1739,7 @@ bool mem_cgroup_oom_synchronize(bool han
 		memcg_oom_recover(memcg);
 	}
 cleanup:
-	current->memcg_oom.memcg = NULL;
+	current->memcg_in_oom = NULL;
 	css_put(&memcg->css);
 	return true;
 }
