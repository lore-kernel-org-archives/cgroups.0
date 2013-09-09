From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm, memcg: add a helper function to check may oom condition
Date: Mon, 9 Sep 2013 10:18:13 +0800
Message-ID: <522D2FE5.3080606@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Use helper function to check if we need to deal with oom condition.

Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/oom.h | 5 +++++
 mm/memcontrol.c     | 9 +--------
 mm/page_alloc.c     | 2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index da60007..d061c63 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -82,6 +82,11 @@ static inline void oom_killer_enable(void)
 	oom_killer_disabled = false;
 }

+static inline bool may_oom(gfp_t gfp_mask)
+{
+	return (gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY);
+}
+
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);

 /* sysctls */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b73988a..e07fcfa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2910,21 +2910,14 @@ static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
 	struct res_counter *fail_res;
 	struct mem_cgroup *_memcg;
 	int ret = 0;
-	bool may_oom;

 	ret = res_counter_charge(&memcg->kmem, size, &fail_res);
 	if (ret)
 		return ret;

-	/*
-	 * Conditions under which we can wait for the oom_killer. Those are
-	 * the same conditions tested by the core page allocator
-	 */
-	may_oom = (gfp & __GFP_FS) && !(gfp & __GFP_NORETRY);
-
 	_memcg = memcg;
 	ret = __mem_cgroup_try_charge(NULL, gfp, size >> PAGE_SHIFT,
-				      &_memcg, may_oom);
+				      &_memcg, may_oom(gfp));

 	if (ret == -EINTR)  {
 		/*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b7c612d..42af675 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2589,7 +2589,7 @@ rebalance:
 	 * running out of options and have to consider going OOM
 	 */
 	if (!did_some_progress) {
-		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
+		if (may_oom(gfp_mask)) {
 			if (oom_killer_disabled)
 				goto nopage;
 			/* Coredumps can quickly deplete all memory reserves */
-- 
1.8.3
