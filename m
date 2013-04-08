From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/12] memcg: don't need to get a reference to the parent
Date: Mon, 8 Apr 2013 14:35:34 +0800
Message-ID: <51626536.3040901@huawei.com>
References: <5162648B.9070802@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5162648B.9070802-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

The cgroup core guarantees it's always safe to access the parent.

v2:
- added a comment in mem_cgroup_put() as suggested by Michal
- removed mem_cgroup_get(), otherwise gcc will warn that it's not used

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7fdd69d..9ca5a99 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -501,7 +501,6 @@ enum res_type {
  */
 static DEFINE_MUTEX(memcg_create_mutex);
 
-static void mem_cgroup_get(struct mem_cgroup *memcg);
 static void mem_cgroup_put(struct mem_cgroup *memcg);
 
 static inline
@@ -6125,19 +6124,10 @@ static void free_rcu(struct rcu_head *rcu_head)
 	schedule_work(&memcg->work_freeing);
 }
 
-static void mem_cgroup_get(struct mem_cgroup *memcg)
-{
-	atomic_inc(&memcg->refcnt);
-}
-
 static void __mem_cgroup_put(struct mem_cgroup *memcg, int count)
 {
-	if (atomic_sub_and_test(count, &memcg->refcnt)) {
-		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+	if (atomic_sub_and_test(count, &memcg->refcnt))
 		call_rcu(&memcg->rcu_freeing, free_rcu);
-		if (parent)
-			mem_cgroup_put(parent);
-	}
 }
 
 static void mem_cgroup_put(struct mem_cgroup *memcg)
@@ -6239,12 +6229,9 @@ mem_cgroup_css_online(struct cgroup *cont)
 		res_counter_init(&memcg->kmem, &parent->kmem);
 
 		/*
-		 * We increment refcnt of the parent to ensure that we can
-		 * safely access it on res_counter_charge/uncharge.
-		 * This refcnt will be decremented when freeing this
-		 * mem_cgroup(see mem_cgroup_put).
+		 * No need to take a reference to the parent because cgroup
+		 * core guarantees its existence.
 		 */
-		mem_cgroup_get(parent);
 	} else {
 		res_counter_init(&memcg->res, NULL);
 		res_counter_init(&memcg->memsw, NULL);
-- 
1.8.0.2
