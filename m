Received: from mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A23330D40D
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 21:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791666622; cv=none; b=pd2OXgLtXqG5z/f01W7ROSgnfRYqASGZasqRmVe14McKi2D0wOM+D1HrI9qYmrZJPm40wP6w906QVoTkeOVZAN66VgrRDk3R4fdfr33LhKjcUwz9CaWxT6Cl50W7wqyPW2jUt8q68/8SA5OewcgnQPBCBcT8rSzI8kj0abuGMMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791666622; c=relaxed/simple;
	bh=r8kUhAXeGuwNlZMbjSzZrDN+BN6E2U2Ur6MAZTc0RbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFy/uhQWnvZ8tbX1P+4IigGOwC7Or+yCWWFzFbgfqSDcm6yt/fTRYcXr1tCsev5h6J4+QG0Z7Z2tIjaYuuSVLoPrMszI/JJzN8pvPx4Yiybzl1olskiumrS4kYQeSIHTKoNqc4kucZITWixPM/OsciivCJaY+5mpPuKLuTW53sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LcN7HbZo; arc=none smtp.client-ip=95.215.58.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LcN7HbZo"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=r8kUhAXeGuwNlZMbjSzZrDN+BN6E2U2Ur6MAZTc0RbA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666618; v=1; x=1792271418;
 b=LcN7HbZote/F9ryzygmmmtViTn4SBQYReaBYFT22YCE7qw6Na7TlEwPlyM6rqM9VvZVj6elY
 P9E0MLRrGOFcDnj1JlAWl7BJIKNSK9DrOPGvtaW65OxDRXnKImE1Oj2gye5OI7pWuA61b6zbRwn
 SUG7hHVKpVll4WbveyRoqDLI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5ce34010455c6035;
	Sat, 10 Oct 2026 21:10:15 +0000
X-Mizu-Trace-ID: 5ce34010455c6035
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
Subject: [PATCH for-7.5 1/5] memcg: move memory.high enforcement out of try_charge_memcg()
Date: Sat, 10 Oct 2026 14:09:53 -0700
Message-ID: <20261010210957.1350874-2-shakeel.butt@linux.dev>
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

try_charge_memcg() does a lot. It charges the page counters, reclaims
when a limit is hit, may call the OOM killer, and at the end it checks
and enforces memory.high. Move the memory.high part into a new function,
memcg_enforce_high(), so that try_charge_memcg() is shorter and the
memory.high code is easier to read and change.

The code and its comments move as they are. The only difference is that
the new function gets allow_spinning from gfp_mask itself.

No functional change.
---
 mm/memcontrol.c | 125 ++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 56 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..20c5dfe1a894 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2696,6 +2696,74 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	css_put(&memcg->css);
 }
 
+/*
+ * Called after @nr_pages were charged to @memcg. If @memcg or one of its
+ * ancestors is over memory.high or memory.swap.high, start reclaim or slow
+ * down the task.
+ */
+static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
+			       gfp_t gfp_mask)
+{
+	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+
+	/*
+	 * If the hierarchy is above the normal consumption range, schedule
+	 * reclaim on returning to userland.  We can perform reclaim here
+	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
+	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
+	 * not recorded as it most likely matches current's and won't
+	 * change in the meantime.  As high limit is checked again before
+	 * reclaim, the cost of mismatch is negligible.
+	 */
+	do {
+		bool mem_high, swap_high;
+
+		mem_high = page_counter_read(&memcg->memory) >
+			READ_ONCE(memcg->memory.high);
+		swap_high = page_counter_read(&memcg->swap) >
+			READ_ONCE(memcg->swap.high);
+
+		/* Don't bother a random interrupted task */
+		if (!in_task()) {
+			if (mem_high) {
+				if (allow_spinning)
+					schedule_work(&memcg->high_work);
+				else
+					irq_work_queue(&memcg->high_irq_work);
+				break;
+			}
+			continue;
+		}
+
+		if (mem_high || swap_high) {
+			/*
+			 * The allocating tasks in this cgroup will need to do
+			 * reclaim or be throttled to prevent further growth
+			 * of the memory or swap footprints.
+			 *
+			 * Target some best-effort fairness between the tasks,
+			 * and distribute reclaim work and delay penalties
+			 * based on how much each task is actually allocating.
+			 */
+			current->memcg_nr_pages_over_high += nr_pages;
+			set_notify_resume(current);
+			break;
+		}
+	} while ((memcg = parent_mem_cgroup(memcg)));
+
+	/*
+	 * Reclaim is set up above to be called from the userland
+	 * return path. But also attempt synchronous reclaim to avoid
+	 * excessive overrun while the task is still inside the
+	 * kernel. If this is successful, the return path will see it
+	 * when it rechecks the overage and simply bail out.
+	 */
+	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
+	    !(current->flags & PF_MEMALLOC) &&
+	    gfpflags_allow_blocking(gfp_mask))
+		__mem_cgroup_handle_over_high(gfp_mask);
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
@@ -2853,62 +2921,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
-	/*
-	 * If the hierarchy is above the normal consumption range, schedule
-	 * reclaim on returning to userland.  We can perform reclaim here
-	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
-	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
-	 * not recorded as it most likely matches current's and won't
-	 * change in the meantime.  As high limit is checked again before
-	 * reclaim, the cost of mismatch is negligible.
-	 */
-	do {
-		bool mem_high, swap_high;
-
-		mem_high = page_counter_read(&memcg->memory) >
-			READ_ONCE(memcg->memory.high);
-		swap_high = page_counter_read(&memcg->swap) >
-			READ_ONCE(memcg->swap.high);
-
-		/* Don't bother a random interrupted task */
-		if (!in_task()) {
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
-			current->memcg_nr_pages_over_high += batch;
-			set_notify_resume(current);
-			break;
-		}
-	} while ((memcg = parent_mem_cgroup(memcg)));
-
-	/*
-	 * Reclaim is set up above to be called from the userland
-	 * return path. But also attempt synchronous reclaim to avoid
-	 * excessive overrun while the task is still inside the
-	 * kernel. If this is successful, the return path will see it
-	 * when it rechecks the overage and simply bail out.
-	 */
-	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    !(current->flags & PF_MEMALLOC) &&
-	    gfpflags_allow_blocking(gfp_mask))
-		__mem_cgroup_handle_over_high(gfp_mask);
+	memcg_enforce_high(memcg, batch, gfp_mask);
 	return ret;
 }
 
-- 
2.53.0-Meta

