From: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Fri, 19 Aug 2022 19:29:22 +0800
Message-ID: <1660908562-17409-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

It is observed in android system where per-app cgroup is demanded by freezer
subsys and part of groups require memory control. The hierarchy could be simplized
as bellowing where memory charged on group B abserved while we only want have
group E's memory be controlled and B's descendants compete freely for memory.
This should be the consequences of unified hierarchy.
Under this scenario, less efficient memory reclaim is observed when comparing
with no memory control. It is believed that multi LRU scanning introduces some
of the overhead. Furthermore, page thrashing is also heavier than global LRU
which could be the consequences of partial failure of WORKINGSET mechanism as
LRU is too short to protect the active pages.

A(subtree_control = memory) - B(subtree_control = NULL) - C()
							\ D()
			    - E(subtree_control = memory) - F()
							  \ G()

Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup/cgroup.c | 11 +++++++++++
 mm/memcontrol.c        |  5 ++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0d1ada8..747f0f4 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -136,6 +136,7 @@ extern void cgroup_post_fork(struct task_struct *p,
 
 int cgroup_parse_float(const char *input, unsigned dec_shift, s64 *v);
 
+struct cgroup *get_task_cgroup(struct task_struct *task);
 /*
  * Iteration helpers and macros.
  */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1779ccd..3f34c58 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1457,6 +1457,17 @@ struct cgroup *task_cgroup_from_root(struct task_struct *task,
 	return cset_cgroup_from_root(task_css_set(task), root);
 }
 
+struct cgroup *get_task_cgroup(struct task_struct *task)
+{
+	struct cgroup *src_cgrp;
+	/* find the source cgroup */
+	spin_lock_irq(&css_set_lock);
+	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
+	spin_unlock_irq(&css_set_lock);
+
+	return src_cgrp;
+}
+
 /*
  * A task must hold cgroup_mutex to modify cgroups.
  *
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index abec50f..c81012b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -930,6 +930,7 @@ static __always_inline struct mem_cgroup *active_memcg(void)
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg;
+	struct cgroup *cgrp;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -956,9 +957,11 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 	}
 
 	rcu_read_lock();
+	cgrp = get_task_cgroup(rcu_dereference(mm->owner));
 	do {
 		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-		if (unlikely(!memcg))
+		if (unlikely(!memcg)
+			|| !(cgroup_ss_mask(cgrp) & (1 << memory_cgrp_id)))
 			memcg = root_mem_cgroup;
 	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
-- 
1.9.1

