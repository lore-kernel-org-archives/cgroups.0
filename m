Received: from mx9.didiglobal.com (mx9.didiglobal.com [111.202.70.124])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 8983531E834;
	Mon, 19 Oct 2026 12:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.70.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792414677; cv=none; b=YlmS6HeNpbkoAdYKTkC9tzwbW4g8EeAn4Ul+4/yPU379uSjo+K21o24CWQHRsH77MubfHNUiAlyA8Y655RaC1wojZAmVNGGfYiG1zlBaUvLl9df0qEqtjmEdpGTsZ9FWWeeq8v7m5L3mFdTHJrdI6MGWZ3xumLSTw5GKKhP4Tgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792414677; c=relaxed/simple;
	bh=vKkhKtWA42yW9wVIH4p0xY2IRuKPFD0Ta4pyKg3uZrA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type; b=HtCpThuguWMlUHItgar9aR07uroNq7Ebe5eShH4RDSBpOpsVfxLtNlGzc8L/8taDQp4LSspa3BceGfnQrm1XTYRIvf/skShy/Uc89/UMX+9yEyPYtW206CFzl6+nqf7MhvoIQ/9uqe2+dWGfEzaOQ6Y9raxoiyKpQ4bzk75IGM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=didiglobal.com; spf=pass smtp.mailfrom=didiglobal.com; dkim=pass (1024-bit key) header.d=didiglobal.com header.i=@didiglobal.com header.b=R0yWymz3; arc=none smtp.client-ip=111.202.70.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=didiglobal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=didiglobal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=didiglobal.com header.i=@didiglobal.com header.b="R0yWymz3"
Received: from mail.didiglobal.com (unknown [10.79.65.19])
	by mx9.didiglobal.com (MailData Gateway V2.8.8) with ESMTPS id D31F8198006EF0;
	Mon, 19 Oct 2026 20:54:37 +0800 (CST)
Received: from BJ01-ACTMBX-05.didichuxing.com (10.79.64.32) by
 BJ02-ACTMBX-01.didichuxing.com (10.79.65.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 19 Oct 2026 20:54:37 +0800
Received: from ml-justfortest.ys (10.79.64.102) by
 BJ01-ACTMBX-05.didichuxing.com (10.79.64.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Mon, 19 Oct 2026 20:54:37 +0800
X-MD-Sfrom: daikunhai@didiglobal.com
X-MD-SrcIP: 10.79.65.19
From: Kunhai Dai <daikunhai@didiglobal.com>
To: <tj@kernel.org>
CC: <axboe@kernel.dk>, <josef@toxicpanda.com>, <yukuai@fygo.io>,
	<cui.tao@linux.dev>, <cgroups@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<mathieu.desnoyers@efficios.com>, <linux-trace-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] blk-iocost: publish hweights as one atomic value
Date: Mon, 19 Oct 2026 08:54:12 -0400
Message-ID: <20261019125412.3123895-3-daikunhai@didiglobal.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20261019125412.3123895-1-daikunhai@didiglobal.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJ03-PUBMBX-01.didichuxing.com (10.79.71.11) To
 BJ01-ACTMBX-05.didichuxing.com (10.79.64.32)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=didiglobal.com;
	s=2026; t=1792414479;
	bh=k7SYnfoZ8zZ0ZaqK41YGRYACz77+86eneeUF36eLz1s=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=R0yWymz3JPtGnLWQ+8aINOESs3r09vmOByYn1JshPYC6KsSoXg+nDGRYTTHn6+m37
	 ZXI35VFpWd5SApSKrO0xQZuEBhMXsyRz2cKU1E5pSmScyxaMZhkdz4bC3mww9l5oGG
	 FWSdllbPTLfN7emEk/1jal8/3dXsesBjrBdrYCJM=

current_hweight() publishes the cache generation and both weights with
separate stores.  Refreshers running on different CPUs can interleave
their stores and leave a new generation paired with weights from an older
calculation.  The compiler can also reorder the generation store before
the weight stores, so a reader that sees the new generation can accept
stale weights.

A stale weight is not only a reporting artifact.  It feeds the cost
calculation and the donation logic, where an inconsistent combination can
lead to a zero divisor in transfer_surpluses().

In addition, the slow path rereads iocg->hweight_active/inuse after
publishing them, so the value it returns can be the one written by another
refresher instead of the locally computed one.

Pack the generation and both weights into a single atomic64_t and publish
them with one atomic write.  Readers take one atomic snapshot and return
the local values.  Weights are in [1, WEIGHT_ONE]; storing each minus one
preserves the full range in 16 bits and leaves 32 bits for the generation.

The two weight fields remain as the donation workspace used under
ioc->lock.  Tracepoints decode the packed cache without refreshing it and
iocost_monitor.py is updated accordingly.

Developed with assistance from Claude Code (Anthropic): the assistant
drafted the packed representation, the helpers and the tracepoint/monitor
changes, and ran the checks listed below.  The author reviewed the result
and remains responsible for it.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Kunhai Dai <daikunhai@didiglobal.com>
---
Validated against next-20261016 (2efb7a11f1aa):
- git apply --check on a clean tree and a W=1 build of block/blk-iocost.o;
- strict checkpatch (the only warning is the unknown Fixes id, because the
  validation tree is a shallow clone without that history);
- encode/decode round-trip for all 65536 active values, with inuse sampled
  plus both boundaries, and five generation values including the high bits
  (6225920 round-trips).  This is not an exhaustive cross product of all
  (generation, active, inuse) combinations;
- VM A/B on the same 32-vCPU VM and workload against next-20261016: the
  unpatched kernel panicked (invalid donation weights followed by a divide
  error at transfer_surpluses+0x43e) with a kprobe widening the publication
  window, while this series completed a full workload round with ~26k
  widened publication windows (~4.9k of them overtaken by a concurrent
  publisher) and no warning or panic.
---
 block/blk-iocost.c             | 109 +++++++++++++++++++++++++++------
 include/trace/events/iocost.h  |   7 ++-
 tools/cgroup/iocost_monitor.py |   7 ++-
 3 files changed, 99 insertions(+), 24 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 7b8af094a..67fd5a4ea 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -173,6 +173,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/time64.h>
@@ -472,8 +473,8 @@ struct ioc_gq {
 	 *
 	 * When an idle cgroup becomes active its `active` goes from 0 to
 	 * `weight`.  `inuse` is the surplus adjusted active weight.
-	 * `active` and `inuse` are used to calculate `hweight_active` and
-	 * `hweight_inuse`.
+	 * `active` and `inuse` determine the hierarchical weights cached in
+	 * `hweight_cache`.
 	 *
 	 * `last_inuse` remembers `inuse` while an iocg is idle to persist
 	 * surplus adjustments.
@@ -520,7 +521,9 @@ struct ioc_gq {
 	u64				child_active_sum;
 	u64				child_inuse_sum;
 	u64				child_adjusted_sum;
-	int				hweight_gen;
+	/* Generation in bits 63:32; active - 1 and inuse - 1 in 31:16/15:0. */
+	atomic64_t			hweight_cache;
+	/* Donation workspace, protected by ioc->lock. */
 	u32				hweight_active;
 	u32				hweight_inuse;
 	u32				hweight_donating;
@@ -727,6 +730,54 @@ static void iocg_commit_bio(struct ioc_gq *iocg, struct bio *bio,
 	put_cpu_ptr(gcs);
 }
 
+/*
+ * The hierarchical weights are in [1, WEIGHT_ONE] and the generation is a
+ * 32-bit counter.  Pack generation and both weights into one 64-bit value so
+ * that a reader or a refresher always observes a complete snapshot:
+ *
+ *   bits 63:32  generation
+ *   bits 31:16  hweight_active - 1
+ *   bits 15:0   hweight_inuse - 1
+ */
+#define HWEIGHT_GEN_MASK	GENMASK_ULL(63, 32)
+#define HWEIGHT_ACTIVE_MASK	GENMASK_ULL(31, 16)
+#define HWEIGHT_INUSE_MASK	GENMASK_ULL(15, 0)
+
+static inline u64 hweight_cache_pack(u32 gen, u32 active, u32 inuse)
+{
+	return FIELD_PREP(HWEIGHT_GEN_MASK, gen) |
+	       FIELD_PREP(HWEIGHT_ACTIVE_MASK, active - 1) |
+	       FIELD_PREP(HWEIGHT_INUSE_MASK, inuse - 1);
+}
+
+static inline void hweight_cache_unpack(u64 cache, u32 *genp, u32 *activep,
+					u32 *inusep)
+{
+	if (genp)
+		*genp = FIELD_GET(HWEIGHT_GEN_MASK, cache);
+	if (activep)
+		*activep = FIELD_GET(HWEIGHT_ACTIVE_MASK, cache) + 1;
+	if (inusep)
+		*inusep = FIELD_GET(HWEIGHT_INUSE_MASK, cache) + 1;
+}
+
+/* Decode the published weights without refreshing the cache. */
+static inline void iocg_hweight_cache(struct ioc_gq *iocg, u32 *activep,
+				      u32 *inusep)
+{
+	hweight_cache_unpack(atomic64_read(&iocg->hweight_cache), NULL,
+			     activep, inusep);
+}
+
+/* Decode the cached inuse weight; only used by tracepoints. */
+static inline u32 iocg_hweight_cache_inuse(struct ioc_gq *iocg)
+{
+	u32 inuse;
+
+	iocg_hweight_cache(iocg, NULL, &inuse);
+	return inuse;
+}
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/iocost.h>
 
@@ -1154,12 +1205,15 @@ static void current_hweight(struct ioc_gq *iocg, u32 *hw_activep, u32 *hw_inusep
 {
 	struct ioc *ioc = iocg->ioc;
 	int lvl;
-	u32 hwa, hwi;
-	int ioc_gen;
+	u32 hwa, hwi, ioc_gen, cache_gen;
+	u64 cache;
+
+	ioc_gen = (u32)atomic_read(&ioc->hweight_gen);
 
-	/* hot path - if uptodate, use cached */
-	ioc_gen = atomic_read(&ioc->hweight_gen);
-	if (ioc_gen == iocg->hweight_gen)
+	/* hot path - if uptodate, use the cached snapshot */
+	cache = atomic64_read(&iocg->hweight_cache);
+	hweight_cache_unpack(cache, &cache_gen, &hwa, &hwi);
+	if (cache_gen == ioc_gen)
 		goto out;
 
 	/*
@@ -1194,14 +1248,20 @@ static void current_hweight(struct ioc_gq *iocg, u32 *hw_activep, u32 *hw_inusep
 		hwi = div64_u64((u64)hwi * inuse, inuse_sum);
 	}
 
-	iocg->hweight_active = max_t(u32, hwa, 1);
-	iocg->hweight_inuse = max_t(u32, hwi, 1);
-	iocg->hweight_gen = ioc_gen;
+	hwa = max_t(u32, hwa, 1);
+	hwi = max_t(u32, hwi, 1);
+	/*
+	 * Publish the generation and both weights as one atomic snapshot.
+	 * A concurrent refresher may overwrite this with its own snapshot,
+	 * but the generation travels with the weights so the next reader
+	 * detects the mismatch and refreshes again.
+	 */
+	atomic64_set(&iocg->hweight_cache, hweight_cache_pack(ioc_gen, hwa, hwi));
 out:
 	if (hw_activep)
-		*hw_activep = iocg->hweight_active;
+		*hw_activep = hwa;
 	if (hw_inusep)
-		*hw_inusep = iocg->hweight_inuse;
+		*hw_inusep = hwi;
 }
 
 /*
@@ -1249,7 +1309,8 @@ static bool iocg_activate(struct ioc_gq *iocg, struct ioc_now *now)
 {
 	struct ioc *ioc = iocg->ioc;
 	u64 __maybe_unused last_period, cur_period;
-	u64 vtime, vtarget;
+	u64 vtime, vtarget, cache;
+	u32 active, inuse;
 	int i;
 
 	/*
@@ -1299,11 +1360,16 @@ static bool iocg_activate(struct ioc_gq *iocg, struct ioc_now *now)
 	vtime = vtarget;
 
 	/*
-	 * Activate, propagate weight and start period timer if not
-	 * running.  Reset hweight_gen to avoid accidental match from
-	 * wrapping.
+	 * Activate, propagate weight and start period timer if not running.
+	 * Invalidate the cached generation to avoid an accidental match from
+	 * wrapping.  Keep the last published weights so that the activation
+	 * tracepoint can report them; the next current_hweight() recomputes.
 	 */
-	iocg->hweight_gen = atomic_read(&ioc->hweight_gen) - 1;
+	cache = atomic64_read(&iocg->hweight_cache);
+	hweight_cache_unpack(cache, NULL, &active, &inuse);
+	atomic64_set(&iocg->hweight_cache,
+		     hweight_cache_pack((u32)(atomic_read(&ioc->hweight_gen) - 1),
+					active, inuse));
 	list_add(&iocg->active_list, &ioc->active_iocgs);
 
 	propagate_weights(iocg, iocg->weight,
@@ -2049,7 +2115,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 
 		TRACE_IOCG_PATH(inuse_transfer, iocg, now,
 				iocg->inuse, inuse,
-				iocg->hweight_inuse,
+				iocg_hweight_cache_inuse(iocg),
 				iocg->hweight_after_donation);
 
 		__propagate_weights(iocg, iocg->active, inuse, true, now);
@@ -2362,7 +2428,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 				 */
 				TRACE_IOCG_PATH(inuse_shortage, iocg, &now,
 						iocg->inuse, iocg->active,
-						iocg->hweight_inuse, new_hwi);
+						old_hwi, new_hwi);
 
 				__propagate_weights(iocg, iocg->active,
 						    iocg->active, true, &now);
@@ -3034,6 +3100,9 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	INIT_LIST_HEAD(&iocg->active_list);
 	INIT_LIST_HEAD(&iocg->walk_list);
 	INIT_LIST_HEAD(&iocg->surplus_list);
+	atomic64_set(&iocg->hweight_cache,
+		     hweight_cache_pack((u32)(atomic_read(&ioc->hweight_gen) - 1),
+					WEIGHT_ONE, WEIGHT_ONE));
 	iocg->hweight_active = WEIGHT_ONE;
 	iocg->hweight_inuse = WEIGHT_ONE;
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index e772b1bc6..eb711343c 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -34,6 +34,9 @@ DECLARE_EVENT_CLASS(iocost_iocg_state,
 	),
 
 	TP_fast_assign(
+		u32 hwa, hwi;
+
+		iocg_hweight_cache(iocg, &hwa, &hwi);
 		__assign_str(devname);
 		__assign_str(cgroup);
 		__entry->now = now->now;
@@ -44,8 +47,8 @@ DECLARE_EVENT_CLASS(iocost_iocg_state,
 		__entry->vtime = vtime;
 		__entry->weight = iocg->weight;
 		__entry->inuse = iocg->inuse;
-		__entry->hweight_active = iocg->hweight_active;
-		__entry->hweight_inuse = iocg->hweight_inuse;
+		__entry->hweight_active = hwa;
+		__entry->hweight_inuse = hwi;
 	),
 
 	TP_printk("[%s:%s] now=%llu:%llu vrate=%llu "
diff --git a/tools/cgroup/iocost_monitor.py b/tools/cgroup/iocost_monitor.py
index bdd78ba27..8a4f844c9 100644
--- a/tools/cgroup/iocost_monitor.py
+++ b/tools/cgroup/iocost_monitor.py
@@ -149,8 +149,11 @@ class IocgStat:
         self.weight = iocg.weight.value_() / WEIGHT_ONE
         self.active = iocg.active.value_() / WEIGHT_ONE
         self.inuse = iocg.inuse.value_() / WEIGHT_ONE
-        self.hwa_pct = iocg.hweight_active.value_() * 100 / WEIGHT_ONE
-        self.hwi_pct = iocg.hweight_inuse.value_() * 100 / WEIGHT_ONE
+        hweight_cache = iocg.hweight_cache.counter.value_()
+        hwa = ((hweight_cache >> 16) & (WEIGHT_ONE - 1)) + 1
+        hwi = (hweight_cache & (WEIGHT_ONE - 1)) + 1
+        self.hwa_pct = hwa * 100 / WEIGHT_ONE
+        self.hwi_pct = hwi * 100 / WEIGHT_ONE
         self.address = iocg.value_()
 
         vdone = iocg.done_vtime.counter.value_()
-- 
2.27.0

