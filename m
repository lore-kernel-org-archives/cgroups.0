From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 7/8] memcg: do not replicate get_mem_cgroup_from_mm in __mem_cgroup_try_charge
Date: Tue, 11 Mar 2014 21:28:33 -0400
Message-ID: <1394587714-6966-8-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=Tirl0oSME1wafiyqnAH2xCAYHGsf/5SaYrg36aBAY+U=;
	b=Jdfvk91ZW8fp18++sKhzRzBExn6wxuWWPyG88zFk76k2BVWeqyeqmdy42LWBZiOz0V++5W1z7zhQpdWS4i8fV72ySdNWOIH3qUTwg+d6cI09eeQ02ECR88NfH4C3xIoMT0JEEtvxjgq/DhzaZR8H+ktIklp6/lmCTEWnjQ1ckPY=;
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

__mem_cgroup_try_charge duplicates get_mem_cgroup_from_mm for charges
which came without a memcg. The only reason seems to be a tiny
optimization when css_tryget is not called if the charge can be
consumed from the stock. Nevertheless css_tryget is very cheap since
it has been reworked to use per-cpu counting so this optimization
doesn't give us anything these days.

So let's drop the code duplication so that the code is more readable.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 50 ++++++--------------------------------------------
 1 file changed, 6 insertions(+), 44 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cc7f3ca3ef34..4f7192bfa5fa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2731,52 +2731,14 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
-		if (mem_cgroup_is_root(memcg))
-			goto done;
-		if (consume_stock(memcg, nr_pages))
-			goto done;
 		css_get(&memcg->css);
 	} else {
-		struct task_struct *p;
-
-		rcu_read_lock();
-		p = rcu_dereference(mm->owner);
-		/*
-		 * Because we don't have task_lock(), "p" can exit.
-		 * In that case, "memcg" can point to root or p can be NULL with
-		 * race with swapoff. Then, we have small risk of mis-accouning.
-		 * But such kind of mis-account by race always happens because
-		 * we don't have cgroup_mutex(). It's overkill and we allo that
-		 * small race, here.
-		 * (*) swapoff at el will charge against mm-struct not against
-		 * task-struct. So, mm->owner can be NULL.
-		 */
-		memcg = mem_cgroup_from_task(p);
-		if (!memcg)
-			memcg = root_mem_cgroup;
-		if (mem_cgroup_is_root(memcg)) {
-			rcu_read_unlock();
-			goto done;
-		}
-		if (consume_stock(memcg, nr_pages)) {
-			/*
-			 * It seems dagerous to access memcg without css_get().
-			 * But considering how consume_stok works, it's not
-			 * necessary. If consume_stock success, some charges
-			 * from this memcg are cached on this cpu. So, we
-			 * don't need to call css_get()/css_tryget() before
-			 * calling consume_stock().
-			 */
-			rcu_read_unlock();
-			goto done;
-		}
-		/* after here, we may be blocked. we need to get refcnt */
-		if (!css_tryget(&memcg->css)) {
-			rcu_read_unlock();
-			goto again;
-		}
-		rcu_read_unlock();
+		memcg = get_mem_cgroup_from_mm(mm);
 	}
+	if (mem_cgroup_is_root(memcg))
+		goto done;
+	if (consume_stock(memcg, nr_pages))
+		goto done;
 
 	do {
 		bool invoke_oom = oom && !nr_oom_retries;
@@ -2812,8 +2774,8 @@ again:
 
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
-	css_put(&memcg->css);
 done:
+	css_put(&memcg->css);
 	*ptr = memcg;
 	return 0;
 nomem:
-- 
1.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
