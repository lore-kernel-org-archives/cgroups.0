From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] memcg: fold mem_cgroup_stolen
Date: Wed, 7 May 2014 16:27:10 +0800
Message-ID: <5369EE5E.50202@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rt-users <linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

It is only used in __mem_cgroup_begin_update_page_stat(), the
name is confusing and 2 routines for one thing also confuse people,
so fold this function seems more clear.

Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4f97662..5804d71 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1568,23 +1568,12 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
 }

 /*
- * 2 routines for checking "mem" is under move_account() or not.
+ * A routine for checking "mem" is under move_account() or not.
  *
- * mem_cgroup_stolen() -  checking whether a cgroup is mc.from or not. This
- *			  is used for avoiding races in accounting.  If true,
- *			  pc->mem_cgroup may be overwritten.
- *
- * mem_cgroup_under_move() - checking a cgroup is mc.from or mc.to or
- *			  under hierarchy of moving cgroups. This is for
- *			  waiting at hith-memory prressure caused by "move".
+ * Checking a cgroup is mc.from or mc.to or under hierarchy of
+ * moving cgroups. This is for waiting at hith-memory pressure
+ * caused by "move".
  */
-
-static bool mem_cgroup_stolen(struct mem_cgroup *memcg)
-{
-	VM_BUG_ON(!rcu_read_lock_held());
-	return atomic_read(&memcg->moving_account) > 0;
-}
-
 static bool mem_cgroup_under_move(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *from;
@@ -1627,7 +1616,6 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
  * Take this lock when
  * - a code tries to modify page's memcg while it's USED.
  * - a code tries to modify page state accounting in a memcg.
- * see mem_cgroup_stolen(), too.
  */
 static void move_lock_mem_cgroup(struct mem_cgroup *memcg,
 				  unsigned long *flags)
@@ -2301,9 +2289,10 @@ again:
 	 * If this memory cgroup is not under account moving, we don't
 	 * need to take move_lock_mem_cgroup(). Because we already hold
 	 * rcu_read_lock(), any calls to move_account will be delayed until
-	 * rcu_read_unlock() if mem_cgroup_stolen() == true.
+	 * rcu_read_unlock().
 	 */
-	if (!mem_cgroup_stolen(memcg))
+	VM_BUG_ON(!rcu_read_lock_held());
+	if (atomic_read(&memcg->moving_account) <= 0)
 		return;

 	move_lock_mem_cgroup(memcg, flags);
-- 
1.8.3
