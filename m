From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH 1/7 v2] temporal compile-fix in linux-next
Date: Fri, 27 Apr 2012 14:49:24 +0900
Message-ID: <4F9A3364.4090009@jp.fujitsu.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F9A327A.6050409-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Maybe Aneesh will post his own version. This is just for my work.

From eaf25c555ec809006220ef22ef152aa04c30c1af Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Thu, 26 Apr 2012 17:51:52 +0900
Subject: [PATCH 1/9] compile-fix

My version of compile fix for linux-next, discussed between Andrew and
Aneesh.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/hugetlb.h    |    4 ----
 include/linux/memcontrol.h |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 828b073..fc226be 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -343,8 +343,4 @@ static inline unsigned int pages_per_huge_page(struct hstate *h)
 #define hstate_index(h) 0
 #endif
 
-#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
-extern int hugetlb_force_memcg_empty(struct cgroup *cgroup);
-#endif
-
 #endif /* _LINUX_HUGETLB_H */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f173811..ca0914a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -450,9 +450,14 @@ extern int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 					  struct page *page);
 extern bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup);
 
+extern int hugetlb_force_memcg_empty(struct cgroup *cgroup);
+
 extern void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
 					struct page *newhpage);
 #else
+struct cgroup;
+struct mem_cgroup;
+
 static inline int
 mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
 						 struct mem_cgroup **ptr)
@@ -494,6 +499,16 @@ mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 	return 0;
 }
 
+static inline void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
+				struct page *newhpage)
+{
+	return;
+}
+
+static inline int hugetlb_force_memcg_empty(struct cgroup *cgroup)
+{
+	return 0;
+}
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif /* _LINUX_MEMCONTROL_H */
 
-- 
1.7.4.1

