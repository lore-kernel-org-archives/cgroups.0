From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: [PATCH 2/2] mm, memcg: Throttle allocators based on ancestral
 memory.high
Date: Thu, 12 Mar 2020 18:03:04 +0000
Message-ID: <8cd132f84bd7e16cdb8fde3378cdbf05ba00d387.1584036142.git.chris@chrisdown.name>
References: <80780887060514967d414b3cd91f9a316a16ab98.1584036142.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=db1bUIPese8tjEPtKXx5DKELzL2SGDYpGP6uaK+iPYk=;
        b=tmWupmQn6aBGlxS345WRGAZeHC8WXMQPju9i7p6QnNUOSx21Xp5MO9v9Bmms9+plRJ
         aJHMDf/lddi7gNlBlJeMQXSy5Wu0fY67UMHLwg5PDMHqLMs3SJUAGd11Z4nrIo5kdDkN
         sNB9XXE0s93VkX6/77RkeFloCCdRWi7p6Kq7s=
Content-Disposition: inline
In-Reply-To: <80780887060514967d414b3cd91f9a316a16ab98.1584036142.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Prior to this commit, we only directly check the affected cgroup's
memory.high against its usage. However, it's possible that we are being
reclaimed as a result of hitting an ancestor memory.high and should be
penalised based on that, instead.

This patch changes memory.high overage throttling to use the largest
overage in its ancestors when considering how many penalty jiffies to
charge. This makes sure that we penalise poorly behaving cgroups in the
same way regardless of at what level of the hierarchy memory.high was
breached.

Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Reported-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-team-b10kYP2dOMg@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.4.x
---
 mm/memcontrol.c | 93 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 35 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a70206e516fe..46d649241a21 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2297,28 +2297,41 @@ static void high_work_func(struct work_struct *work)
  #define MEMCG_DELAY_SCALING_SHIFT 14
 
 /*
- * Scheduled by try_charge() to be executed from the userland return path
- * and reclaims memory over the high limit.
+ * Get the number of jiffies that we should penalise a mischievous cgroup which
+ * is exceeding its memory.high by checking both it and its ancestors.
  */
-void mem_cgroup_handle_over_high(void)
+static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
+					  unsigned int nr_pages)
 {
-	unsigned long usage, high, clamped_high;
-	unsigned long pflags;
-	unsigned long penalty_jiffies, overage;
-	unsigned int nr_pages = current->memcg_nr_pages_over_high;
-	struct mem_cgroup *memcg;
+	unsigned long penalty_jiffies;
+	u64 max_overage = 0;
 
-	if (likely(!nr_pages))
-		return;
+	do {
+		unsigned long usage, high;
+		u64 overage;
 
-	memcg = get_mem_cgroup_from_mm(current->mm);
-	reclaim_high(memcg, nr_pages, GFP_KERNEL);
-	current->memcg_nr_pages_over_high = 0;
+		usage = page_counter_read(&memcg->memory);
+		high = READ_ONCE(memcg->high);
+
+		/*
+		 * Prevent division by 0 in overage calculation by acting as if
+		 * it was a threshold of 1 page
+		 */
+		high = max(high, 1UL);
+
+		overage = usage - high;
+		overage <<= MEMCG_DELAY_PRECISION_SHIFT;
+		overage = div64_u64(overage, high);
+
+		if (overage > max_overage)
+			max_overage = overage;
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		 !mem_cgroup_is_root(memcg));
+
+	if (!max_overage)
+		return 0;
 
 	/*
-	 * memory.high is breached and reclaim is unable to keep up. Throttle
-	 * allocators proactively to slow down excessive growth.
-	 *
 	 * We use overage compared to memory.high to calculate the number of
 	 * jiffies to sleep (penalty_jiffies). Ideally this value should be
 	 * fairly lenient on small overages, and increasingly harsh when the
@@ -2326,24 +2339,9 @@ void mem_cgroup_handle_over_high(void)
 	 * its crazy behaviour, so we exponentially increase the delay based on
 	 * overage amount.
 	 */
-
-	usage = page_counter_read(&memcg->memory);
-	high = READ_ONCE(memcg->high);
-
-	if (usage <= high)
-		goto out;
-
-	/*
-	 * Prevent division by 0 in overage calculation by acting as if it was a
-	 * threshold of 1 page
-	 */
-	clamped_high = max(high, 1UL);
-
-	overage = div64_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
-			  clamped_high);
-
-	penalty_jiffies = ((u64)overage * overage * HZ)
-		>> (MEMCG_DELAY_PRECISION_SHIFT + MEMCG_DELAY_SCALING_SHIFT);
+	penalty_jiffies = max_overage * max_overage * HZ;
+	penalty_jiffies >>= MEMCG_DELAY_PRECISION_SHIFT;
+	penalty_jiffies >>= MEMCG_DELAY_SCALING_SHIFT;
 
 	/*
 	 * Factor in the task's own contribution to the overage, such that four
@@ -2360,7 +2358,32 @@ void mem_cgroup_handle_over_high(void)
 	 * application moving forwards and also permit diagnostics, albeit
 	 * extremely slowly.
 	 */
-	penalty_jiffies = min(penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
+	return min(penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
+}
+
+/*
+ * Scheduled by try_charge() to be executed from the userland return path
+ * and reclaims memory over the high limit.
+ */
+void mem_cgroup_handle_over_high(void)
+{
+	unsigned long penalty_jiffies;
+	unsigned long pflags;
+	unsigned int nr_pages = current->memcg_nr_pages_over_high;
+	struct mem_cgroup *memcg;
+
+	if (likely(!nr_pages))
+		return;
+
+	memcg = get_mem_cgroup_from_mm(current->mm);
+	reclaim_high(memcg, nr_pages, GFP_KERNEL);
+	current->memcg_nr_pages_over_high = 0;
+
+	/*
+	 * memory.high is breached and reclaim is unable to keep up. Throttle
+	 * allocators proactively to slow down excessive growth.
+	 */
+	penalty_jiffies = calculate_high_delay(memcg, nr_pages);
 
 	/*
 	 * Don't sleep if the amount of jiffies this memcg owes us is so low
-- 
2.25.1

