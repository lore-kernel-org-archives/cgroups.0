Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393691;
	b=q5OCrUOOuRKVhKQ47qdl1WH1CEDm8gDKtKa2ve1i+/h4u+qV65ArSgoZg51/Ea1i2ldz
	 roA/JvQ3DTmHiFjMooZJJUcGxuoO3jyHHly9JEytxisQYE6VjzloVK6YGDZUBf+xFm/Uz
	 iFj8DHUA/hst20TS4CQCKngZno/WDK1Fn5rrcR3ITQJLIdQ8hN6oPxhJwmCX821zMXlx4
	 nWDtonjgOGOcJ/jQoLZWbYH9qCHQ3iYwktvOReJ6K8zX73+NLBzvR5b12O/MkzXy7Vv3e
	 McttozcdeSwHzpY/xGRwuv81/Z2QDrxCiCBdeDQI+RsjgdptFmk8D5NmwgLD2RTlNHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393691;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QjkNy7pHlfB3P9tWyxFaR8qT3ODyo1OuuBCXAHPu1yc=;
	b=yyEgDFSudxztriBhS9ajWSMvE2rYAFEI6xlyOrQIAjK5DjkISs7ICRrxYIJqnUFxyeZQ
	 LL4Hao4Od0cWL1YTZFeY8+fK9YJDDXI2mMCZxa5dVSNRQWQ/hZxsVskIFYhwvkdNj32KP
	 5mJnXxHoV8OUWb9j6LjXk6j6GqeXbnZgC+06XNTf1QqNV3k/xs6Mkk7/NBlWkHJWvfa8j
	 7d27M0V9/n0oGPvGKXgdLaMAJbSOoFcrAjwK+ifa+u5WP1ZGu6jOaJFVsAVFveEP1vDgz
	 0s0E/BL/U0cIWzlj48v4Qzi1F009wRLhICQEBn1yB4pt5jJgyAP11axz4NT/jdq1vpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AOktx0lr;
	arc=none smtp.remote-ip=95.215.58.153
Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EA4606A31C
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 20:54:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86EA4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AOktx0lr
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3BkmFCjzJBJtvnj6/69mPrvSFoGbhkTNbA1/fZOdMOM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393688; v=1; x=1793998488;
 b=AOktx0lrjEMar6tvlUKD0v+nU1xUxaXNnedHY8hMmXK/Hn5bgP8EgiAGXQR3XGrqbSi5iM5/
 F3K52gY6aLR5/3vlmU2H0EZqNSLT0QT7PANgh74OIViWn0liGowjTq74upTbq0GrH1AUNDHg68x
 NaopYG1E/4qc8/z1EnuYLdJI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 243d3ea72e8617f1;
	Fri, 30 Oct 2026 20:54:48 +0000
X-Mizu-Trace-ID: 243d3ea72e8617f1
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 5/5] memcg: simplify high limit handling after a charge
Date: Fri, 30 Oct 2026 13:54:16 -0700
Message-ID: <20261030205418.341214-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030205418.341214-1-shakeel.butt@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Separate the hierarchy scan from high-limit enforcement. Find the first
cgroup over the applicable limit, then queue high_work or record the
task's overage after the scan. Worker contexts check only memory.high;
local charges also check memory.swap.high.

Clarify the enforcement comments. Keep the synchronous pending-overage
check independent of the scan result so a blocking charge still handles
overage left by earlier charges.

No functional change intended.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c | 102 +++++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 57 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8d9c001b6ce..f3b69d4fa248 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2605,9 +2605,8 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
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
@@ -2701,76 +2700,65 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 
 /*
  * Called after @nr_pages were charged to @memcg. If @memcg or one of its
- * ancestors is over memory.high or memory.swap.high, start reclaim or slow
- * down the task.
+ * ancestors is over its high limit, either queue high_work to reclaim from
+ * that cgroup, or record the overage so the charging task reclaims later
+ * and sleeps if reclaim can't keep up. high_work only handles memory.high;
+ * memory.swap.high is only enforced on the charging task.
  */
 static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
+	struct mem_cgroup *iter;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
-	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
+	bool use_high_work = !in_task() || (current->flags & PF_KTHREAD) ||
 		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
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
+	 * up current->mm and rechecks the limits. If the task moved to another
+	 * cgroup in the meantime, the handler works on the new cgroup instead.
+	 * That is rare and costs little.
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
 	    gfpflags_allow_blocking(gfp_mask))
-- 
2.53.0-Meta

