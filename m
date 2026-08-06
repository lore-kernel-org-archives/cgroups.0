Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F883AD530;
	Thu,  6 Aug 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041499; cv=none; b=FAx42Dr7OteZusVe8g/Bwn2g7o5Jiz2EgfmkdBmz+29pjBe+PxjDlhO8k+p4LS8PoZd0rF2GqGkiu3tTwYiEvn6Y02gfcha/KGQuiEQwhUw8VaRkrXo46HDEpEKRW0mmk5Oy7i/3wgZcKFmf0oVy93XCAbj2kkpjb5hnW/R6UOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041499; c=relaxed/simple;
	bh=3STlD0WPXYKSL4esrs0oWJNHpZYXmpUe5bZ411q890s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmb5eh5Ztx+/c5U4lh2hSTO+ec4vTQBfeqrE4yYioS6OpT3jP7PPsc+zaQC2+KCjoT+GnNcQc0IxT8eYNBZasZz+84YsIasvoQru3jeWLtG84+fLaGqCo06tSEk008m3VSuTJY+cpoW4lvtNn4GznwOonhv5rQE+BcG0xTrXHR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ATKLBYRo; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ATKLBYRo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786041491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzWVKAlXgbLri8mDj6PSzWVwpKabqcrOs8M8q+EKsLU=;
	b=ATKLBYRoOu39nF9WPvvoqLVrnPqiSI49EFWPD8uLJDDQqBaJlTJtVUVu3+FgVyJGU/62E8
	lmVIfA/rZf8rpWGOgDQfI9vMHcyc19wZUC/otVcDd5NI7mTcS8m1xmKp04LyYunBN9BFay
	k9Pb/9MJrF9dIVwc2pfpDSFOl6qV888=
From: Usama Arif <usama.arif@linux.dev>
To: axboe@kernel.dk,
	cgroups@vger.kernel.org,
	josef@toxicpanda.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tj@kernel.org
Cc: shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 3/3] block: skip blkcg walk in blk_cgroup_congested() when nothing throttled
Date: Thu,  6 Aug 2026 11:37:20 -0700
Message-ID: <20260806183742.946953-4-usama.arif@linux.dev>
In-Reply-To: <20260806183742.946953-1-usama.arif@linux.dev>
References: <20260806183742.946953-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

blk_cgroup_congested() walks the current task's blkcg ancestor chain on
every readahead decision and, once swap is in use, on every anonymous and
shmem folio allocation.  The answer is almost always "no", but finding that
out costs two loads per level on two cold cache lines, plus an out-of-line
kthread_blkcg() and an RCU read-side pair.  On a fleet profile of hosts
running containers with 5-10 level hierarchies it costs about as much as
all of mutex_lock(), 99.4% of it under __folio_throttle_swaprate().

Gate the walk on a global count of blkcgs with a non-zero
congestion_count.  The counter only moves on the 0 <-> 1 transitions of
each blkcg's congestion_count, so the extra atomic stays in the throttle
arm/disarm paths and never appears in steady state. When something is
throttled the counter is non-zero and the walk runs as before.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 block/blk-cgroup.c         | 15 ++++++++++++++-
 block/blk-cgroup.h         | 25 +++++++++++++++++++++----
 include/linux/blk-cgroup.h | 23 ++++++++++++++++++++++-
 3 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 354637f3b158c..ff25e7da29373 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -53,6 +53,9 @@ EXPORT_SYMBOL_GPL(blkcg_root);
 struct cgroup_subsys_state * const blkcg_root_css = &blkcg_root.css;
 EXPORT_SYMBOL_GPL(blkcg_root_css);
 
+/* number of blkcgs with a non-zero congestion_count */
+atomic_t blkcg_congested_blkcgs __read_mostly = ATOMIC_INIT(0);
+
 static struct blkcg_policy *blkcg_policy[BLKCG_MAX_POLS];
 
 static LIST_HEAD(all_blkcgs);		/* protected by blkcg_pol_mutex */
@@ -1350,6 +1353,16 @@ static void blkcg_css_free(struct cgroup_subsys_state *css)
 	struct blkcg *blkcg = css_to_blkcg(css);
 	int i;
 
+	/*
+	 * Every blkg holds a reference on this css and drops any delay it
+	 * still has from pd_free_fn(), so this is expected to be zero.  Should
+	 * a policy ever leave one behind, drop it here rather than let it pin
+	 * blkcg_congested_blkcgs and disable the fast path for the rest of the
+	 * boot.  Nothing can race with us at this point.
+	 */
+	if (atomic_xchg(&blkcg->congestion_count, 0) > 0)
+		atomic_dec(&blkcg_congested_blkcgs);
+
 	mutex_lock(&blkcg_pol_mutex);
 
 	list_del(&blkcg->all_blkcgs_node);
@@ -2228,7 +2241,7 @@ void blk_cgroup_bio_start(struct bio *bio)
 	put_cpu();
 }
 
-bool blk_cgroup_congested(void)
+bool __blk_cgroup_congested(void)
 {
 	struct blkcg *blkcg;
 	bool ret = false;
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 615390f751aa2..09e47a4a07f48 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -375,12 +375,29 @@ static inline void blkg_put(struct blkcg_gq *blkg)
 		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
 					    (p_blkg)->q)))
 
+/*
+ * blkcg_congested_blkcgs gates the hierarchy walk in blk_cgroup_congested().
+ * These two helpers keep it in step with each blkcg's congestion_count in
+ * normal operation; blkcg_css_free() drops a residual count as a backstop.
+ */
+static inline void blkcg_inc_congestion_count(struct blkcg *blkcg)
+{
+	if (atomic_inc_return(&blkcg->congestion_count) == 1)
+		atomic_inc(&blkcg_congested_blkcgs);
+}
+
+static inline void blkcg_dec_congestion_count(struct blkcg *blkcg)
+{
+	if (atomic_dec_return(&blkcg->congestion_count) == 0)
+		atomic_dec(&blkcg_congested_blkcgs);
+}
+
 static inline void blkcg_use_delay(struct blkcg_gq *blkg)
 {
 	if (WARN_ON_ONCE(atomic_read(&blkg->use_delay) < 0))
 		return;
 	if (atomic_add_return(1, &blkg->use_delay) == 1)
-		atomic_inc(&blkg->blkcg->congestion_count);
+		blkcg_inc_congestion_count(blkg->blkcg);
 }
 
 static inline int blkcg_unuse_delay(struct blkcg_gq *blkg)
@@ -405,7 +422,7 @@ static inline int blkcg_unuse_delay(struct blkcg_gq *blkg)
 	if (old == 0)
 		return 0;
 	if (old == 1)
-		atomic_dec(&blkg->blkcg->congestion_count);
+		blkcg_dec_congestion_count(blkg->blkcg);
 	return 1;
 }
 
@@ -424,7 +441,7 @@ static inline void blkcg_set_delay(struct blkcg_gq *blkg, u64 delay)
 
 	/* We only want 1 person setting the congestion count for this blkg. */
 	if (!old && atomic_try_cmpxchg(&blkg->use_delay, &old, -1))
-		atomic_inc(&blkg->blkcg->congestion_count);
+		blkcg_inc_congestion_count(blkg->blkcg);
 
 	atomic64_set(&blkg->delay_nsec, delay);
 }
@@ -441,7 +458,7 @@ static inline void blkcg_clear_delay(struct blkcg_gq *blkg)
 
 	/* We only want 1 person clearing the congestion count for this blkg. */
 	if (old && atomic_try_cmpxchg(&blkg->use_delay, &old, 0))
-		atomic_dec(&blkg->blkcg->congestion_count);
+		blkcg_dec_congestion_count(blkg->blkcg);
 }
 
 /**
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index dd5841a42c331..1dbb08a436b51 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -14,6 +14,8 @@
  * 	              Nauman Rafique <nauman@google.com>
  */
 
+#include <linux/atomic.h>
+#include <linux/compiler.h>
 #include <linux/types.h>
 
 struct bio;
@@ -24,10 +26,29 @@ struct gendisk;
 
 #ifdef CONFIG_BLK_CGROUP
 extern struct cgroup_subsys_state * const blkcg_root_css;
+extern atomic_t blkcg_congested_blkcgs;
 
 void blkcg_schedule_throttle(struct gendisk *disk, bool use_memdelay);
 void blkcg_maybe_throttle_current(void);
-bool blk_cgroup_congested(void);
+bool __blk_cgroup_congested(void);
+
+/**
+ * blk_cgroup_congested - is the current task in a throttled blkcg?
+ *
+ * Called from mm hot paths where the answer is almost always false, so keep
+ * that case to a load and a branch and only walk the hierarchy out of line
+ * when something in the system really is throttled.
+ *
+ * Return: %true if the current task's blkcg or any of its ancestors is
+ * throttled, %false otherwise.
+ */
+static inline bool blk_cgroup_congested(void)
+{
+	if (likely(!atomic_read(&blkcg_congested_blkcgs)))
+		return false;
+	return __blk_cgroup_congested();
+}
+
 void blkcg_pin_online(struct cgroup_subsys_state *blkcg_css);
 void blkcg_unpin_online(struct cgroup_subsys_state *blkcg_css);
 struct list_head *blkcg_get_cgwb_list(struct cgroup_subsys_state *css);
-- 
2.53.0-Meta

