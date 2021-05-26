From: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [RFC 5/7] mm: introduce memory allocation speed throttle
Date: Thu, 27 May 2021 00:18:02 +0800
Message-ID: <c2488d1e324f6b2a2cbfd32dd6f6f2423096fef8.1622043596.git.yuleixzhang@tencent.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tIlUJpv9owS7BaT6w3H8IfsbCFIbYiBLvFZ1cZUl/0o=;
        b=X0LAMmzw6u54bigaJR6dXXV+agl+onQ2Ryn0UVnDG3V4uD9cc5ZhY+xAsdJ9GBJ6OH
         KazZ6hBx3+KliIenVHQEDxMf7Z0tYRVp22rTakurBKfKakKvr4KpyEvtbBUmtdz1w5Gt
         9PYMBiVEwi2JP2ZWM8zImBkjyiXKD2sOkWnU2GgX+5zbTjhSF5T+JMqEjDNRfte6qmGy
         Tepyc7JG0aqw7rfpQmUkEGXP6B+xKXnrDc9LhUW7mryfJBFhWz9M/8tcE5exbqjDnGl6
         P0H1OT+o17AlSL0U3IZX03gnRvxt6nH8z3p5ggnuR+IEcO0fv+RoeAgfB944DhrHTqoT
         n4wQ==
In-Reply-To: <cover.1622043596.git.yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jiang Biao <benbjiang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

In the memory charge handling, check if the allocated memory
exceed the limitation in each slice period, then throttle
the executing for a while to lower the memory allocation speed
in memory cgroup to avoid triggering the direct reclaim frequently.

Signed-off-by: Jiang Biao <benbjiang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/memcontrol.h |   1 +
 mm/memcontrol.c            | 103 +++++++++++++++++++++++++++++++++++--
 2 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 230acdc635b5..b20820f7fdbf 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -238,6 +238,7 @@ struct mem_spd_ctl {
 	unsigned long prev_thl_jifs;
 	unsigned long prev_chg;
 	int has_lmt;
+	atomic_t updating;
 };
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 05bf4ba0da15..a1e33a9e6594 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1445,7 +1445,7 @@ static int mem_cgroup_mem_spd_lmt_write(struct cgroup_subsys_state *css,
 	memcg->msc.mem_spd_lmt = lmt;
 	memcg->msc.slice_lmt = lmt * MST_SLICE / HZ;
 
-	/* Sync with mst_has_lmt_init*/
+	/* Sync with mst_has_lmt_init and mem_cgroup_mst_overlmt_tree */
 	synchronize_rcu();
 
 	if (lmt) {
@@ -1458,23 +1458,109 @@ static int mem_cgroup_mem_spd_lmt_write(struct cgroup_subsys_state *css,
 
 /*
  * Update the memory speed throttle slice window.
- * Return 0 when we still in the previous slice window
- * Return 1 when we start a new slice window
+ * Return the prev charged page number before next slice
+ * refresh the total charge so that the overspeed exam logic
+ * can check if the quota is exceeded.
  */
 static int mem_cgroup_update_mst_slice(struct mem_cgroup *memcg)
 {
 	unsigned long total_charge;
 	struct mem_spd_ctl *msc = &memcg->msc;
+	unsigned long prev_chg = msc->prev_chg;
 
 	if (msc->prev_thl_jifs &&
 	    time_before(jiffies, (msc->prev_thl_jifs + MST_SLICE)))
-		return 0;
+		goto exit;
+
+	/* Bail out if other's updating */
+	if (atomic_cmpxchg(&msc->updating, 0, 1) != 0)
+		goto exit;
 
 	total_charge = atomic_long_read(&memcg->memory.total_chg);
 	msc->prev_chg = total_charge;
 	msc->prev_thl_jifs = jiffies;
+	atomic_set(&msc->updating, 0);
 
-	return 1;
+exit:
+	return prev_chg;
+}
+
+/*
+ * Check if the memory allocate speed is exceed the limits.
+ * Return 0 when it is within the limits.
+ * Return the value of actual time frame should be used for the
+ * allocation when it exceeds the limits.
+ */
+static int mem_cgroup_mst_overspd(struct mem_cgroup *memcg)
+{
+	struct mem_spd_ctl *msc = &memcg->msc;
+	unsigned long total_charge;
+	unsigned long usage, prev_chg;
+
+	prev_chg = mem_cgroup_update_mst_slice(memcg);
+
+	total_charge = atomic_long_read(&memcg->memory.total_chg);
+	usage = total_charge <= prev_chg ?
+		      0 : total_charge - prev_chg;
+
+	if (usage < msc->slice_lmt)
+		return 0;
+	else
+		return (usage * MST_SLICE) / msc->slice_lmt;
+}
+
+static int mem_cgroup_mst_overspd_tree(struct mem_cgroup *memcg)
+{
+	struct cgroup_subsys_state *css = &memcg->css;
+	struct mem_cgroup *iter = memcg;
+	int no_lmt = 1;
+	int ret = 0;
+
+	rcu_read_lock();
+	while (!mem_cgroup_is_root(iter)) {
+		if (iter->msc.mem_spd_lmt) {
+			no_lmt = 0;
+			ret = mem_cgroup_mst_overspd(iter);
+			if (ret) {
+				rcu_read_unlock();
+				return ret;
+			}
+		}
+		css = css->parent;
+		iter = mem_cgroup_from_css(css);
+	}
+
+	/* Mst has been disabled */
+	if (no_lmt)
+		mem_cgroup_mst_msc_reset(memcg);
+
+	rcu_read_unlock();
+	return ret;
+}
+
+static void mem_cgroup_mst_spd_throttle(struct mem_cgroup *memcg)
+{
+	struct mem_spd_ctl *msc = &memcg->msc;
+	long timeout;
+	int ret = 0;
+
+	if (!memcg->msc.has_lmt || in_interrupt() || in_atomic() ||
+		irqs_disabled() || oops_in_progress)
+		return;
+
+	ret = mem_cgroup_mst_overspd_tree(memcg);
+	if (!ret)
+		return;
+
+	/*
+	 * Throttle the allocation for amount of jiffies according to
+	 * the fraction between the actual memory usage and allowed
+	 * allocation speed
+	 */
+	timeout = ret - (jiffies - msc->prev_thl_jifs);
+
+	if (timeout > 0)
+		schedule_timeout_interruptible(timeout);
 }
 
 static unsigned long mem_cgroup_mst_get_mem_spd_max(struct mem_cgroup *memcg)
@@ -1501,6 +1587,10 @@ static void mem_cgroup_mst_show_mem_spd_max(struct mem_cgroup *memcg,
 		   mem_cgroup_mst_get_mem_spd_max(memcg));
 }
 #else /* CONFIG_MEM_SPEED_THROTTLE */
+static void mem_cgroup_mst_spd_throttle(struct mem_cgroup *memcg)
+{
+}
+
 static void mem_cgroup_mst_has_lmt_init(struct mem_cgroup *memcg)
 {
 }
@@ -2778,6 +2868,9 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return 0;
 
 done_restock:
+	/* Try to throttle allocation speed if needed */
+	mem_cgroup_mst_spd_throttle(memcg);
+
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
-- 
2.28.0

