From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH v3] mm: Make memory.emin the baseline for utilisation
 determination
Date: Tue, 29 Jan 2019 14:15:25 -0500
Message-ID: <20190129191525.GB10430@chrisdown.name>
References: <20190129182516.GA1834@chrisdown.name>
 <20190129190253.GA10430@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7Uuf0LVs+pzHcF3nyh4GxvEPQsOE1NPnxZxuLZkBYcE=;
        b=NWO1tpkadXDzKPLeqcckeYOXK0qRah25lv9XpFX4W/D0ZeK8WDrTZav72UjZSwm8Y5
         8E9j5aDJinxsGCjkPiV9bCrYzES7wIWNC6XZjNvE3ekV4DtiuqGhAvnXih2dEIUtbjBe
         5QquP/EkhMDDHWEeQGacIpCHyATrH6UAr06Rc=
Content-Disposition: inline
In-Reply-To: <20190129190253.GA10430@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Roman points out that when when we do the low reclaim pass, we scale the
reclaim pressure relative to position between 0 and the maximum
protection threshold.

However, if the maximum protection is based on memory.elow, and
memory.emin is above zero, this means we still may get binary behaviour
on second-pass low reclaim. This is because we scale starting at 0, not
starting at memory.emin, and since we don't scan at all below emin, we
end up with cliff behaviour.

This should be a fairly uncommon case since usually we don't go into the
second pass, but it makes sense to scale our low reclaim pressure
starting at emin.

You can test this by catting two large sparse files, one in a cgroup
with emin set to some moderate size compared to physical RAM, and
another cgroup without any emin. In both cgroups, set an elow larger
than 50% of physical RAM. The one with emin will have less page
scanning, as reclaim pressure is lower.

Signed-off-by: Chris Down <chris@chrisdown.name>
Suggested-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kernel-team@fb.com
---
 include/linux/memcontrol.h | 12 ++++++---
 mm/vmscan.c                | 55 +++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 26 deletions(-)

...well, I sent it with NULL for !CONFIG_MEMCG when I wanted 0. This is the 
fixed fix(tm) patch.

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 290cfbfd60cd..6f7e0e1b581d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -333,9 +333,11 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg)
+static inline void mem_cgroup_protection(struct mem_cgroup *memcg,
+					 unsigned long *min, unsigned long *low)
 {
-	return max(READ_ONCE(memcg->memory.emin), READ_ONCE(memcg->memory.elow));
+	*min = READ_ONCE(memcg->memory.emin);
+	*low = READ_ONCE(memcg->memory.elow);
 }
 
 enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
@@ -826,9 +828,11 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 {
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg)
+static inline void mem_cgroup_protection(struct mem_cgroup *memcg,
+					 unsigned long *min, unsigned long *low)
 {
-	return 0;
+	*min = 0;
+	*low = 0;
 }
 
 static inline enum mem_cgroup_protection mem_cgroup_protected(
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 549251818605..f7c4ab39d5d0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2447,12 +2447,12 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 		int file = is_file_lru(lru);
 		unsigned long lruvec_size;
 		unsigned long scan;
-		unsigned long protection;
+		unsigned long min, low;
 
 		lruvec_size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
-		protection = mem_cgroup_protection(memcg);
+		mem_cgroup_protection(memcg, &min, &low);
 
-		if (protection > 0) {
+		if (min || low) {
 			/*
 			 * Scale a cgroup's reclaim pressure by proportioning
 			 * its current usage to its memory.low or memory.min
@@ -2467,28 +2467,38 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 			 * set it too low, which is not ideal.
 			 */
 			unsigned long cgroup_size = mem_cgroup_size(memcg);
-			unsigned long baseline = 0;
 
 			/*
-			 * During the reclaim first pass, we only consider
-			 * cgroups in excess of their protection setting, but if
-			 * that doesn't produce free pages, we come back for a
-			 * second pass where we reclaim from all groups.
+			 * If there is any protection in place, we adjust scan
+			 * pressure in proportion to how much a group's current
+			 * usage exceeds that, in percent.
 			 *
-			 * To maintain fairness in both cases, the first pass
-			 * targets groups in proportion to their overage, and
-			 * the second pass targets groups in proportion to their
-			 * protection utilization.
-			 *
-			 * So on the first pass, a group whose size is 130% of
-			 * its protection will be targeted at 30% of its size.
-			 * On the second pass, a group whose size is at 40% of
-			 * its protection will be
-			 * targeted at 40% of its size.
+			 * There is one special case: in the first reclaim pass,
+			 * we skip over all groups that are within their low
+			 * protection. If that fails to reclaim enough pages to
+			 * satisfy the reclaim goal, we come back and override
+			 * the best-effort low protection. However, we still
+			 * ideally want to honor how well-behaved groups are in
+			 * that case instead of simply punishing them all
+			 * equally. As such, we reclaim them based on how much
+			 * of their best-effort protection they are using. Usage
+			 * below memory.min is excluded from consideration when
+			 * calculating utilisation, as it isn't ever
+			 * reclaimable, so it might as well not exist for our
+			 * purposes.
 			 */
-			if (!sc->memcg_low_reclaim)
-				baseline = lruvec_size;
-			scan = lruvec_size * cgroup_size / protection - baseline;
+			if (sc->memcg_low_reclaim && low > min) {
+				/*
+				 * Reclaim according to utilisation between min
+				 * and low
+				 */
+				scan = lruvec_size * (cgroup_size - min) /
+					(low - min);
+			} else {
+				/* Reclaim according to protection overage */
+				scan = lruvec_size * cgroup_size /
+					max(min, low) - lruvec_size;
+			}
 
 			/*
 			 * Don't allow the scan target to exceed the lruvec
@@ -2504,7 +2514,8 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 			 * some cases in the case of large overages.
 			 *
 			 * Also, minimally target SWAP_CLUSTER_MAX pages to keep
-			 * reclaim moving forwards.
+			 * reclaim moving forwards, avoiding decremeting
+			 * sc->priority further than desirable.
 			 */
 			scan = clamp(scan, SWAP_CLUSTER_MAX, lruvec_size);
 		} else {
-- 
2.20.1

