Received: from mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C03E372662
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 21:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791666635; cv=none; b=Y2IrMd3L+zanF4GdpK8IxToHzHbSP9lPfFIoafTKgd//1dV9OFAsDD32o8KXjDp4MP5EtjMXY0LPQQAdprsmO8qWORuTq/iemOPL+746PIf73UoFBrLt99QpegbU8NVH/9zFJsnhegpXBdHZ2kgs05wInShea13F+8YkGfnNgco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791666635; c=relaxed/simple;
	bh=3hqX3BARmjWtAQ46OvzECobezGOVuBR47j+5rD5PZIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EA4N84yi4pGWCcAyAJEwX2Qi+20kqP6zaenoiPE4ZN3G93olVPc2+MZKOIrXLbi+BxIh49+W10aWHc8AysCc41RUoHQkSOh8pD1RqbdKh9rEG0wLuNPfC1SNg2Iwbl0OV/36gfucMW/uymzdAWpfbY0hYc3DuUuEAEE0UsrfViM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aH1NCR1d; arc=none smtp.client-ip=91.218.175.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aH1NCR1d"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3hqX3BARmjWtAQ46OvzECobezGOVuBR47j+5rD5PZIo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666631; v=1; x=1792271431;
 b=aH1NCR1dMaFgP7EOlDMiGX6daB+ScA4bILjgQ9I8YJfm87SX3DCWjztZEU35hF3slmfXfmS4
 f+RiiIHYwWPW9D42UA0uOKSiVhV92tB518YKTVkWLcgK92uzNXeumEAeEM6ziJIh68AiHUT/bsI
 8OGtWTAaTQfQlGizT66Dvvzc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4cd0ae48d6d3e480;
	Sat, 10 Oct 2026 21:10:31 +0000
X-Mizu-Trace-ID: 4cd0ae48d6d3e480
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH for-7.5 5/5] memcg: simplify high limit handling after a charge
Date: Sat, 10 Oct 2026 14:09:57 -0700
Message-ID: <20261010210957.1350874-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010210957.1350874-1-shakeel.butt@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Separate the hierarchy scan from high-limit enforcement. Find the first
cgroup over the applicable limit, then queue high_work or record the
task's overage after the scan. Worker contexts check only memory.high;
local charges also check memory.swap.high.

Read in_task() once and clarify the enforcement comments. Keep the
synchronous pending-overage check independent of the scan result so a
blocking charge still handles overage left by earlier charges.

No functional change intended.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 100 +++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 57 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d1e022e6572f..2a3742036b45 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2602,9 +2602,8 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 }
 
 /*
- * Reclaims memory over the high limit. Called directly from
- * try_charge() (context permitting), as well as from the userland
- * return path where reclaim is always able to block.
+ * Handle pending high overage during a blocking charge or on return
+ * to userspace.
  */
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
@@ -2704,78 +2703,65 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
+	struct mem_cgroup *iter;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
-	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
-		!current->mm || !mm_match_cgroup(current->mm, memcg);
+	bool task_context = in_task();
+	bool kthread = task_context && (current->flags & PF_KTHREAD);
+	bool use_high_work = !task_context || kthread || !current->mm ||
+		!mm_match_cgroup(current->mm, memcg);
 
 	/*
 	 * Reclaim can charge memory, for example when zswap stores a page.
 	 * Don't queue high_work from a reclaiming task, or the
 	 * high_work worker could keep queuing itself.
 	 */
-	if (in_task() && use_worker && (current->flags & PF_MEMALLOC))
+	if (task_context && use_high_work && (current->flags & PF_MEMALLOC))
 		return;
 
 	/*
-	 * If the hierarchy is above the normal consumption range, schedule
-	 * reclaim on returning to userland.  We can perform reclaim here
-	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
-	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
-	 * not recorded as it most likely matches current's and won't
-	 * change in the meantime.  As high limit is checked again before
-	 * reclaim, the cost of mismatch is negligible.
+	 * Check the charged cgroup and its parents. Local charges normally defer
+	 * reclaim until return to userspace so it can use GFP_KERNEL. Large
+	 * pending overages may be handled synchronously below. The handler looks
+	 * up current->mm and rechecks the limits.
 	 */
-	do {
+	for (iter = memcg; iter; iter = parent_mem_cgroup(iter)) {
 		bool mem_high, swap_high;
 
-		mem_high = page_counter_read(&memcg->memory) >
-			READ_ONCE(memcg->memory.high);
-		swap_high = page_counter_read(&memcg->swap) >
-			READ_ONCE(memcg->swap.high);
-
-		/*
-		 * Don't make an unrelated interrupted task handle this charge.
-		 * Kernel threads may be working for other tasks, so let a worker
-		 * reclaim instead.
-		 * Remote charges need reclaim from their charged hierarchy.
-		 */
-		if (use_worker) {
-			if (mem_high) {
-				if (allow_spinning)
-					schedule_work(&memcg->high_work);
-				else
-					irq_work_queue(&memcg->high_irq_work);
-				break;
-			}
-			continue;
-		}
-
-		if (mem_high || swap_high) {
-			/*
-			 * The allocating tasks in this cgroup will need to do
-			 * reclaim or be throttled to prevent further growth
-			 * of the memory or swap footprints.
-			 *
-			 * Target some best-effort fairness between the tasks,
-			 * and distribute reclaim work and delay penalties
-			 * based on how much each task is actually allocating.
-			 */
-			current->memcg_nr_pages_over_high += nr_pages;
-			set_notify_resume(current);
+		mem_high = page_counter_read(&iter->memory) >
+			READ_ONCE(iter->memory.high);
+		swap_high = !use_high_work &&
+			(page_counter_read(&iter->swap) > READ_ONCE(iter->swap.high));
+		if (mem_high || swap_high)
 			break;
-		}
-	} while ((memcg = parent_mem_cgroup(memcg)));
+	}
 
-	/* Interrupts, kernel threads, and remote chargers stop here. */
-	if (use_worker)
+	/*
+	 * Use a worker for interrupts, kernel threads, and tasks whose mm
+	 * does not match the charged hierarchy.
+	 */
+	if (use_high_work) {
+		if (!iter)
+			return;
+		if (allow_spinning)
+			schedule_work(&iter->high_work);
+		else
+			irq_work_queue(&iter->high_irq_work);
 		return;
+	}
+
+	if (iter) {
+		/*
+		 * Count the full batch so reclaim work and delay penalties scale
+		 * with the pages charged by this task.
+		 */
+		current->memcg_nr_pages_over_high += nr_pages;
+		set_notify_resume(current);
+	}
 
 	/*
-	 * Reclaim is set up above to be called from the userland
-	 * return path. But also attempt synchronous reclaim to avoid
-	 * excessive overrun while the task is still inside the
-	 * kernel. If this is successful, the return path will see it
-	 * when it rechecks the overage and simply bail out.
+	 * Earlier charges may have left high overage pending even if this charge
+	 * found no new overage. Handle it now if this charge can block, to limit
+	 * overrun while the task remains in the kernel.
 	 */
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
 	    !(current->flags & PF_MEMALLOC) &&
-- 
2.53.0-Meta

