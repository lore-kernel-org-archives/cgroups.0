From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v14 04/18] memcg: make for_each_mem_cgroup macros public
Date: Mon, 16 Dec 2013 16:16:53 +0400
Message-ID: <935807f1cf90abb10423e049346c49ef7b6bcc2f.1387193771.git.vdavydov@parallels.com>
References: <cover.1387193771.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1387193771.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

I am going to use these macros in next patches, so let's move them to
the header. These macros are very handy and they depend only on
mem_cgroup_iter(), which is already public, so I guess it's worth it.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/memcontrol.h |   15 +++++++++++++++
 mm/memcontrol.c            |   15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b3e7a66..e3efab2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -53,6 +53,21 @@ struct mem_cgroup_reclaim_cookie {
 	unsigned int generation;
 };
 
+/*
+ * Iteration constructs for visiting all cgroups (under a tree).  If
+ * loops are exited prematurely (break), mem_cgroup_iter_break() must
+ * be used for reference counting.
+ */
+#define for_each_mem_cgroup_tree(iter, root)		\
+	for (iter = mem_cgroup_iter(root, NULL, NULL);	\
+	     iter != NULL;				\
+	     iter = mem_cgroup_iter(root, iter, NULL))
+
+#define for_each_mem_cgroup(iter)			\
+	for (iter = mem_cgroup_iter(NULL, NULL, NULL);	\
+	     iter != NULL;				\
+	     iter = mem_cgroup_iter(NULL, iter, NULL))
+
 #ifdef CONFIG_MEMCG
 /*
  * All "charge" functions with gfp_mask should use GFP_KERNEL or
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8fdb239..b6ec029 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1261,21 +1261,6 @@ void mem_cgroup_iter_break(struct mem_cgroup *root,
 		css_put(&prev->css);
 }
 
-/*
- * Iteration constructs for visiting all cgroups (under a tree).  If
- * loops are exited prematurely (break), mem_cgroup_iter_break() must
- * be used for reference counting.
- */
-#define for_each_mem_cgroup_tree(iter, root)		\
-	for (iter = mem_cgroup_iter(root, NULL, NULL);	\
-	     iter != NULL;				\
-	     iter = mem_cgroup_iter(root, iter, NULL))
-
-#define for_each_mem_cgroup(iter)			\
-	for (iter = mem_cgroup_iter(NULL, NULL, NULL);	\
-	     iter != NULL;				\
-	     iter = mem_cgroup_iter(NULL, iter, NULL))
-
 void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 {
 	struct mem_cgroup *memcg;
-- 
1.7.10.4
