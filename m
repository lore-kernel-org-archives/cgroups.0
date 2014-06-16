From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 06/12] mm: memcontrol: simplify move precharge function
Date: Mon, 16 Jun 2014 15:54:26 -0400
Message-ID: <1402948472-8175-7-git-send-email-hannes@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=MnCgxo/nlfJsciu+lw6bvG3Al+vDmk6QgjEaI5EnYwo=;
	b=BATBUb1sQ5czRyL+linT8yFk/VzNpP1dfIZ2Uj+nl1QMRV5mjgVtBFxPCIvZ84waS4FftyQS7UncXOdf6Ds9BSj//EL9GC37vbyHuN/bG8Cgm3KAhrBsD5wyJ/OcBrCJf5CU3Nn8idGZqFjZXOunYjdqCmc94CHvcFZ1MgRsF+Q=;
In-Reply-To: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

The move precharge function does some baroque things: it tries raw
res_counter charging of the entire amount first, and then falls back
to a loop of one-by-one charges, with checks for pending signals and
cond_resched() batching.

Just use mem_cgroup_try_charge() without __GFP_WAIT for the first bulk
charge attempt.  In the one-by-one loop, remove the signal check (this
is already checked in try_charge), and simply call cond_resched()
after every charge - it's not that expensive.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 51 +++++++++++++++++----------------------------------
 1 file changed, 17 insertions(+), 34 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9c646b9b56f4..3d9df94896a7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6372,55 +6372,38 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 
 #ifdef CONFIG_MMU
 /* Handlers for move charge at task migration. */
-#define PRECHARGE_COUNT_AT_ONCE	256
 static int mem_cgroup_do_precharge(unsigned long count)
 {
-	int ret = 0;
-	int batch_count = PRECHARGE_COUNT_AT_ONCE;
-	struct mem_cgroup *memcg = mc.to;
+	int ret;
 
-	if (mem_cgroup_is_root(memcg)) {
+	if (mem_cgroup_is_root(mc.to)) {
 		mc.precharge += count;
 		/* we don't need css_get for root */
 		return ret;
 	}
-	/* try to charge at once */
-	if (count > 1) {
-		struct res_counter *dummy;
-		/*
-		 * "memcg" cannot be under rmdir() because we've already checked
-		 * by cgroup_lock_live_cgroup() that it is not removed and we
-		 * are still under the same cgroup_mutex. So we can postpone
-		 * css_get().
-		 */
-		if (res_counter_charge(&memcg->res, PAGE_SIZE * count, &dummy))
-			goto one_by_one;
-		if (do_swap_account && res_counter_charge(&memcg->memsw,
-						PAGE_SIZE * count, &dummy)) {
-			res_counter_uncharge(&memcg->res, PAGE_SIZE * count);
-			goto one_by_one;
-		}
+
+	/* Try a single bulk charge without reclaim first */
+	ret = mem_cgroup_try_charge(mc.to, GFP_KERNEL & ~__GFP_WAIT,
+				    count, false);
+	if (!ret) {
 		mc.precharge += count;
 		return ret;
 	}
-one_by_one:
-	/* fall back to one by one charge */
+
+	/* Try charges one by one with reclaim */
 	while (count--) {
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-		if (!batch_count--) {
-			batch_count = PRECHARGE_COUNT_AT_ONCE;
-			cond_resched();
-		}
-		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
+		ret = mem_cgroup_try_charge(mc.to, GFP_KERNEL, 1, false);
+		/*
+		 * In case of failure, any residual charges against
+		 * mc.to will be dropped by mem_cgroup_clear_mc()
+		 * later on.
+		 */
 		if (ret)
-			/* mem_cgroup_clear_mc() will do uncharge later */
 			return ret;
 		mc.precharge++;
+		cond_resched();
 	}
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.0.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
