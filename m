From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 6/8] memcg: get_mem_cgroup_from_mm()
Date: Tue, 11 Mar 2014 21:28:32 -0400
Message-ID: <1394587714-6966-7-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=uGozdbdxkKgVxxHeymC/nTVGdJAlV8t3nPXuhkkn4zI=;
	b=XNgf21uSwuhmPkkxX6TimM76DOs7MafXQOYlnWggX2dvpnJuUmZb6yS+clXTqgzP/Yc20EfnnjOJ9P18fF4z0VExK6Wa+lpEPpULsP7srHV4GIDps2+QZSjys2Aqm2YwZSuuz8XqSvayks1sFH8z8fp/h3NfnjdPfiQtrJgrq1s=;
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Instead of returning NULL from try_get_mem_cgroup_from_mm() when the
mm owner is exiting, just return root_mem_cgroup.  This makes sense
for all callsites and gets rid of some of them having to fallback
manually.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1780e66ec61e..cc7f3ca3ef34 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1071,7 +1071,7 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 	return mem_cgroup_from_css(task_css(p, mem_cgroup_subsys_id));
 }
 
-struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg = NULL;
 
@@ -1079,7 +1079,7 @@ struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 	do {
 		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 		if (unlikely(!memcg))
-			break;
+			memcg = root_mem_cgroup;
 	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
@@ -1475,7 +1475,7 @@ bool task_in_mem_cgroup(struct task_struct *task,
 
 	p = find_lock_task_mm(task);
 	if (p) {
-		curr = try_get_mem_cgroup_from_mm(p->mm);
+		curr = get_mem_cgroup_from_mm(p->mm);
 		task_unlock(p);
 	} else {
 		/*
@@ -1489,8 +1489,6 @@ bool task_in_mem_cgroup(struct task_struct *task,
 			css_get(&curr->css);
 		rcu_read_unlock();
 	}
-	if (!curr)
-		return false;
 	/*
 	 * We should check use_hierarchy of "memcg" not "curr". Because checking
 	 * use_hierarchy of "curr" here make this function true if hierarchy is
@@ -3649,15 +3647,7 @@ __memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
 	if (!current->mm || current->memcg_kmem_skip_account)
 		return true;
 
-	memcg = try_get_mem_cgroup_from_mm(current->mm);
-
-	/*
-	 * very rare case described in mem_cgroup_from_task. Unfortunately there
-	 * isn't much we can do without complicating this too much, and it would
-	 * be gfp-dependent anyway. Just let it go
-	 */
-	if (unlikely(!memcg))
-		return true;
+	memcg = get_mem_cgroup_from_mm(current->mm);
 
 	if (!memcg_can_account_kmem(memcg)) {
 		css_put(&memcg->css);
-- 
1.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
