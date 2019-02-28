From: Chris Down <chris@chrisdown.name>
Subject: [PATCH] mm, memcg: Make scan aggression always exclude protection
Date: Thu, 28 Feb 2019 21:30:50 +0000
Message-ID: <20190228213050.GA28211@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=M5qRV30ip8IGNC83XxPf/9k/uWZjwDt12qJmaexTUOA=;
        b=UszRHdt+ZAsX06/EHTKapRQhXB+mYA+Xg8GhwFOSw+o/Xz0f5Q7zbRQXuZW3X/IjSJ
         vEUydqWKMAzfaihII8BrnY/ZeGFVj6StP3MhUoaSrBzsfa4cz9NHfoclp+IWG9cEOWMP
         dHiBKeMkSk/kTr7GB9aS0VLKO1UDLJ7gecLo8=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

This patch is an incremental improvement on the existing
memory.{low,min} relative reclaim work to base its scan pressure
calculations on how much protection is available compared to the current
usage, rather than how much the current usage is over some protection
threshold.

Previously the way that memory.low protection works is that if you are
50% over a certain baseline, you get 50% of your normal scan pressure.
This is certainly better than the previous cliff-edge behaviour, but it
can be improved even further by always considering memory under the
currently enforced protection threshold to be out of bounds. This means
that we can set relatively low memory.low thresholds for variable or
bursty workloads while still getting a reasonable level of protection,
whereas with the previous version we may still trivially hit the 100%
clamp. The previous 100% clamp is also somewhat arbitrary, whereas this
one is more concretely based on the currently enforced protection
threshold, which is likely easier to reason about.

There is also a subtle issue with the way that proportional reclaim
worked previously -- it promotes having no memory.low, since it makes
pressure higher during low reclaim. This happens because we base our
scan pressure modulation on how far memory.current is between memory.min
and memory.low, but if memory.low is unset, we only use the overage
method. In most cromulent configurations, this then means that we end up
with *more* pressure than with no memory.low at all when we're in low
reclaim, which is not really very usable or expected.

With this patch, memory.low and memory.min affect reclaim pressure in a
more understandable and composable way. For example, from a user
standpoint, "protected" memory now remains untouchable from a reclaim
aggression standpoint, and users can also have more confidence that
bursty workloads will still receive some amount of guaranteed
protection.

Signed-off-by: Chris Down <chris@chrisdown.name>
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
 include/linux/memcontrol.h | 25 ++++++++--------
 mm/vmscan.c                | 61 +++++++++++++-------------------------
 2 files changed, 32 insertions(+), 54 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 534267947664..2799008c1f88 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -333,17 +333,17 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *memcg,
-					 unsigned long *min, unsigned long *low)
+static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
+						  bool in_low_reclaim)
 {
-	if (mem_cgroup_disabled()) {
-		*min = 0;
-		*low = 0;
-		return;
-	}
+	if (mem_cgroup_disabled())
+		return 0;
+
+	if (in_low_reclaim)
+		return READ_ONCE(memcg->memory.emin);
 
-	*min = READ_ONCE(memcg->memory.emin);
-	*low = READ_ONCE(memcg->memory.elow);
+	return max(READ_ONCE(memcg->memory.emin),
+		   READ_ONCE(memcg->memory.elow));
 }
 
 enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
@@ -845,11 +845,10 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 {
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *memcg,
-					 unsigned long *min, unsigned long *low)
+static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
+						  bool in_low_reclaim)
 {
-	*min = 0;
-	*low = 0;
+	return 0;
 }
 
 static inline enum mem_cgroup_protection mem_cgroup_protected(
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ac4806f0f332..920a9c3ee792 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2414,12 +2414,13 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 		int file = is_file_lru(lru);
 		unsigned long lruvec_size;
 		unsigned long scan;
-		unsigned long min, low;
+		unsigned long protection;
 
 		lruvec_size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
-		mem_cgroup_protection(memcg, &min, &low);
+		protection = mem_cgroup_protection(memcg,
+						   sc->memcg_low_reclaim);
 
-		if (min || low) {
+		if (protection) {
 			/*
 			 * Scale a cgroup's reclaim pressure by proportioning
 			 * its current usage to its memory.low or memory.min
@@ -2432,13 +2433,10 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 			 * setting extremely liberal protection thresholds. It
 			 * also means we simply get no protection at all if we
 			 * set it too low, which is not ideal.
-			 */
-			unsigned long cgroup_size = mem_cgroup_size(memcg);
-
-			/*
-			 * If there is any protection in place, we adjust scan
-			 * pressure in proportion to how much a group's current
-			 * usage exceeds that, in percent.
+			 *
+			 * If there is any protection in place, we reduce scan
+			 * pressure by how much of the total memory used is
+			 * within protection thresholds.
 			 *
 			 * There is one special case: in the first reclaim pass,
 			 * we skip over all groups that are within their low
@@ -2448,43 +2446,24 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 			 * ideally want to honor how well-behaved groups are in
 			 * that case instead of simply punishing them all
 			 * equally. As such, we reclaim them based on how much
-			 * of their best-effort protection they are using. Usage
-			 * below memory.min is excluded from consideration when
-			 * calculating utilisation, as it isn't ever
-			 * reclaimable, so it might as well not exist for our
-			 * purposes.
+			 * memory they are using, reducing the scan pressure
+			 * again by how much of the total memory used is under
+			 * hard protection.
 			 */
-			if (sc->memcg_low_reclaim && low > min) {
-				/*
-				 * Reclaim according to utilisation between min
-				 * and low
-				 */
-				scan = lruvec_size * (cgroup_size - min) /
-					(low - min);
-			} else {
-				/* Reclaim according to protection overage */
-				scan = lruvec_size * cgroup_size /
-					max(min, low) - lruvec_size;
-			}
+			unsigned long cgroup_size = mem_cgroup_size(memcg);
+
+			/* Avoid TOCTOU with earlier protection check */
+			cgroup_size = max(cgroup_size, protection);
+
+			scan = lruvec_size - lruvec_size * protection /
+				cgroup_size;
 
 			/*
-			 * Don't allow the scan target to exceed the lruvec
-			 * size, which otherwise could happen if we have >200%
-			 * overage in the normal case, or >100% overage when
-			 * sc->memcg_low_reclaim is set.
-			 *
-			 * This is important because other cgroups without
-			 * memory.low have their scan target initially set to
-			 * their lruvec size, so allowing values >100% of the
-			 * lruvec size here could result in penalising cgroups
-			 * with memory.low set even *more* than their peers in
-			 * some cases in the case of large overages.
-			 *
-			 * Also, minimally target SWAP_CLUSTER_MAX pages to keep
+			 * Minimally target SWAP_CLUSTER_MAX pages to keep
 			 * reclaim moving forwards, avoiding decremeting
 			 * sc->priority further than desirable.
 			 */
-			scan = clamp(scan, SWAP_CLUSTER_MAX, lruvec_size);
+			scan = max(scan, SWAP_CLUSTER_MAX);
 		} else {
 			scan = lruvec_size;
 		}
-- 
2.21.0

