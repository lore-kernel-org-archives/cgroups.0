Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306774;
	b=pTfLDOedfUNIpg7x182tV3GZRkz4qju8lsE3199USjjGzTXcQRTQ1tEzBAC8xIyz0PWp
	 yYlSiPN74ZXManWuQjjZuyPudrOUHowNvxNs8uj4vzew2H9B/lw7tzE4i2iIxp8i1XhMC
	 Zfmc54JZM/iO8ShIPqv4HYL6ZbYJJJ2g1TA59CEZfVWUu15Ey+EGO6Ytc61NAzZRxOQnl
	 UuNATBs4RMvUCcf2AIqgzO0AfdR7wK6NMKtG+ej9UxDiihFl9U/y2FsnlyFDMiRhjSgMO
	 xUaSOHTy5ChYqyrrwBZlAlHvp/QOcdaAt+U0EMBFRyPsmQwLvT2NVX9iMlSmZLVXBGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306774;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=0F7s4yL/cXGpMLeK9k5AZGY9gNKQ/d4a6SNBf5cX2mQ=;
	b=tHfw3QRAEd+meY01YacFnRbXMkm/2ZpYSyxP7grIF7Nhmd/Zd4lhTi2jN295OJoFngcy
	 mytX7WWgpwN87VJGwuyS5wkmGSqLME7slhEoiUEDR8jclTlpShQsAWILuhvUa8XLRYCX1
	 XlGi4h2gB12zNlPE/khLFz3+KwIA0V1zJK7XpvgqUPD0m4S6vd2urewzjtkyTpiPUH+ca
	 R1OSAcEtnUMD2m+YMLlcs04t7CY39QdKTGfOReup/xlDOhVeOGJoCS0rxZd/+ULbIOaDz
	 XizfoZehd8m7rAVeo33nLymxt5Ev8vFzB/042SSko98hGEERibJhJR4nkixqa0rYyTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA07D606A32E;
	Tue, 10 Nov 2026 10:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA07D606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 11e4ace0dcf211f19a56ed5b684f684d-20261110
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:6fea8f8c-ad68-463f-a7e7-236af33beca4,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:6fea8f8c-ad68-463f-a7e7-236af33beca4,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:9b5fd0568f31d56a0bdff9192831e687,BulkI
	D:261110183250ZD0G7E49,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|153|
	850|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 11e4ace0dcf211f19a56ed5b684f684d-20261110
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1177678230; Tue, 10 Nov 2026 18:32:46 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com
Cc: yukuai@fygo.io,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Zhe Liu <liuzhe1@kylinos.cn>
Subject: [PATCH 2/3] blkcg: move cgroup v1 I/O statistics out of the throttle policy
Date: Tue, 10 Nov 2026 18:32:00 +0800
Message-Id: <20261110103201.762861-3-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110103201.762861-1-liuzhe1@kylinos.cn>
References: <20261110103201.762861-1-liuzhe1@kylinos.cn>
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

Cgroup v1 I/O statistics are currently stored in throtl_grp, making
their allocation and lifetime dependent on the throttle policy. With
lazy throttle initialization, these counters may not be available until
an I/O limit is configured.

Move the byte and I/O counters into an optional blkg-owned statistics
object, independent of throttle activation. Allocate the counters for
v1 and root blkgs to support late controller binding, while avoiding
unnecessary allocations for non-root v2 blkgs.

Move cgroup v1 statistics reporting, reset and offline propagation into
the blkcg core. Add recursive aggregation for the optional statistics
objects and preserve accumulated statistics when child blkgs are
destroyed. Keep the existing userspace interfaces unchanged.

Keep the accounting call site in blk_should_throtl(), routed through
the new blkcg_account_v1_bio(). Moving accounting before the throttle
activation check is handled in a separate patch.

Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
---
 block/blk-cgroup.c   | 188 ++++++++++++++++++++++++++++++++++++++++++-
 block/blk-cgroup.h   |  15 ++++
 block/blk-throttle.c |  78 ------------------
 block/blk-throttle.h |  13 +--
 4 files changed, 204 insertions(+), 90 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5b7a32293dc6..52093b06688a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -32,6 +32,7 @@
 #include <linux/part_stat.h>
 #include "blk.h"
 #include "blk-cgroup.h"
+#include "blk-cgroup-rwstat.h"
 #include "blk-ioprio.h"
 #include "blk-throttle.h"
 
@@ -66,6 +67,90 @@ static DEFINE_RAW_SPINLOCK(blkg_stat_lock);
 
 #define BLKG_DESTROY_BATCH_SIZE  64
 
+#ifdef CONFIG_BLK_DEV_THROTTLING
+struct blkg_v1_stats {
+	struct blkg_rwstat bytes;
+	struct blkg_rwstat ios;
+};
+
+static int blkg_v1_stats_init(struct blkcg_gq *blkg, struct blkcg *blkcg,
+			      gfp_t gfp)
+{
+	struct blkg_v1_stats *stats;
+	int ret;
+
+	/*
+	 * Keep stats for the root blkcg to support late v1 binding.
+	 * Non-root v2 blkgs do not need v1 statistics.
+	 */
+	if (blkcg != &blkcg_root && cgroup_on_dfl(blkcg->css.cgroup))
+		return 0;
+
+	stats = kzalloc_obj(*stats, gfp);
+	if (!stats)
+		return -ENOMEM;
+	ret = blkg_rwstat_init(&stats->bytes, gfp);
+	if (ret)
+		goto out_free;
+	ret = blkg_rwstat_init(&stats->ios, gfp);
+	if (ret)
+		goto out_exit_bytes;
+	blkg->v1_stats = stats;
+	return 0;
+
+out_exit_bytes:
+	blkg_rwstat_exit(&stats->bytes);
+out_free:
+	kfree(stats);
+	return ret;
+}
+
+static void blkg_v1_stats_exit(struct blkcg_gq *blkg)
+{
+	struct blkg_v1_stats *stats = blkg->v1_stats;
+
+	if (!stats)
+		return;
+	blkg_rwstat_exit(&stats->ios);
+	blkg_rwstat_exit(&stats->bytes);
+	kfree(stats);
+}
+
+static void blkg_v1_stats_reset(struct blkcg_gq *blkg)
+{
+	struct blkg_v1_stats *stats = blkg->v1_stats;
+
+	if (!stats)
+		return;
+	blkg_rwstat_reset(&stats->bytes);
+	blkg_rwstat_reset(&stats->ios);
+}
+
+static void blkg_v1_stats_offline(struct blkcg_gq *blkg)
+{
+	struct blkg_v1_stats *stats = blkg->v1_stats;
+	struct blkg_v1_stats *parent;
+
+	if (!stats || !blkg->parent)
+		return;
+
+	parent = blkg->parent->v1_stats;
+	blkg_rwstat_add_aux(&parent->bytes, &stats->bytes);
+	blkg_rwstat_add_aux(&parent->ios, &stats->ios);
+	blkg_v1_stats_reset(blkg);
+}
+#else
+static inline int blkg_v1_stats_init(struct blkcg_gq *blkg,
+				     struct blkcg *blkcg, gfp_t gfp)
+{
+	return 0;
+}
+
+static inline void blkg_v1_stats_exit(struct blkcg_gq *blkg) { }
+static inline void blkg_v1_stats_reset(struct blkcg_gq *blkg) { }
+static inline void blkg_v1_stats_offline(struct blkcg_gq *blkg) { }
+#endif
+
 /*
  * Lockless lists for tracking IO stats update
  *
@@ -150,6 +235,7 @@ static void blkg_free_workfn(struct work_struct *work)
 	 */
 	css_put(&blkg->blkcg->css);
 	blk_put_queue(q);
+	blkg_v1_stats_exit(blkg);
 	free_percpu(blkg->iostat_cpu);
 	percpu_ref_exit(&blkg->refcnt);
 	kfree(blkg);
@@ -329,8 +415,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	blkg->iostat_cpu = alloc_percpu_gfp(struct blkg_iostat_set, gfp_mask);
 	if (!blkg->iostat_cpu)
 		goto out_exit_refcnt;
-	if (!blk_get_queue(disk->queue))
+	if (blkg_v1_stats_init(blkg, blkcg, gfp_mask))
 		goto out_free_iostat;
+	if (!blk_get_queue(disk->queue))
+		goto out_exit_stats;
 	/* blkg holds a reference to blkcg */
 	if (!css_tryget_online(&blkcg->css))
 		goto out_put_queue;
@@ -377,6 +465,8 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	css_put(&blkcg->css);
 out_put_queue:
 	blk_put_queue(disk->queue);
+out_exit_stats:
+	blkg_v1_stats_exit(blkg);
 out_free_iostat:
 	free_percpu(blkg->iostat_cpu);
 out_exit_refcnt:
@@ -555,6 +645,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 		}
 	}
 
+	blkg_v1_stats_offline(blkg);
 	blkg->online = false;
 
 	radix_tree_delete(&blkcg->blkg_tree, blkg->q->id);
@@ -678,6 +769,7 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 	 */
 	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node) {
 		blkg_clear_stat(blkg);
+		blkg_v1_stats_reset(blkg);
 		for (i = 0; i < BLKCG_MAX_POLS; i++) {
 			struct blkcg_policy *pol = blkcg_policy[i];
 
@@ -1231,7 +1323,101 @@ static struct cftype blkcg_files[] = {
 	{ }	/* terminate */
 };
 
+#ifdef CONFIG_BLK_DEV_THROTTLING
+void __blkcg_account_v1_bio(struct bio *bio)
+{
+	struct blkg_v1_stats *stats = bio->bi_blkg->v1_stats;
+
+	if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
+		bio_set_flag(bio, BIO_CGROUP_ACCT);
+		blkg_rwstat_add(&stats->bytes, bio->bi_opf,
+				bio->bi_iter.bi_size);
+	}
+	blkg_rwstat_add(&stats->ios, bio->bi_opf, 1);
+}
+
+static void blkg_v1_stat_recursive_sum(struct blkcg_gq *blkg, int off,
+				       struct blkg_rwstat_sample *sum)
+{
+	struct cgroup_subsys_state *pos_css;
+	struct blkcg_gq *pos_blkg;
+	int i;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	memset(sum, 0, sizeof(*sum));
+	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
+		struct blkg_rwstat *rwstat;
+
+		/* Tolerate racing with blkg offlining. */
+		if (!data_race(pos_blkg->online) || !pos_blkg->v1_stats)
+			continue;
+		rwstat = (void *)pos_blkg->v1_stats + off;
+		for (i = 0; i < BLKG_RWSTAT_NR; i++)
+			sum->cnt[i] += blkg_rwstat_read_counter(rwstat, i);
+	}
+}
+
+static int blkcg_print_v1_stats(struct seq_file *sf, bool recursive)
+{
+	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
+	int off = seq_cft(sf)->private;
+	struct blkcg_gq *blkg;
+	u64 total = 0;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
+		struct gendisk *disk = READ_ONCE(blkg->q->disk);
+		struct blkg_rwstat_sample sum;
+
+		if (!blkg->v1_stats || !disk)
+			continue;
+
+		if (recursive)
+			blkg_v1_stat_recursive_sum(blkg, off, &sum);
+		else
+			blkg_rwstat_read((void *)blkg->v1_stats + off, &sum);
+		total += blkg_print_rwstat(sf, blkg, &sum);
+	}
+	rcu_read_unlock();
+
+	seq_printf(sf, "Total %llu\n", total);
+	return 0;
+}
+
+static int blkcg_print_v1_rwstat(struct seq_file *sf, void *v)
+{
+	return blkcg_print_v1_stats(sf, false);
+}
+
+static int blkcg_print_v1_rwstat_recursive(struct seq_file *sf, void *v)
+{
+	return blkcg_print_v1_stats(sf, true);
+}
+#endif
+
 static struct cftype blkcg_legacy_files[] = {
+#ifdef CONFIG_BLK_DEV_THROTTLING
+	{
+		.name = "throttle.io_service_bytes",
+		.private = offsetof(struct blkg_v1_stats, bytes),
+		.seq_show = blkcg_print_v1_rwstat,
+	},
+	{
+		.name = "throttle.io_service_bytes_recursive",
+		.private = offsetof(struct blkg_v1_stats, bytes),
+		.seq_show = blkcg_print_v1_rwstat_recursive,
+	},
+	{
+		.name = "throttle.io_serviced",
+		.private = offsetof(struct blkg_v1_stats, ios),
+		.seq_show = blkcg_print_v1_rwstat,
+	},
+	{
+		.name = "throttle.io_serviced_recursive",
+		.private = offsetof(struct blkg_v1_stats, ios),
+		.seq_show = blkcg_print_v1_rwstat_recursive,
+	},
+#endif
 	{
 		.name = "reset_stats",
 		.write_u64 = blkcg_reset_stats,
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1fd60cb4157c..bd528d52ab4c 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -23,6 +23,7 @@
 
 struct blkcg_gq;
 struct blkg_policy_data;
+struct blkg_v1_stats;
 
 
 /* percpu_counter batch for blkg_[rw]stats, per-cpu drift doesn't matter */
@@ -71,6 +72,9 @@ struct blkcg_gq {
 
 	struct blkg_iostat_set __percpu	*iostat_cpu;
 	struct blkg_iostat_set		iostat;
+#ifdef CONFIG_BLK_DEV_THROTTLING
+	struct blkg_v1_stats		*v1_stats;
+#endif
 
 	struct blkg_policy_data		*pd[BLKCG_MAX_POLS];
 #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
@@ -520,4 +524,15 @@ static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { r
 
 #endif	/* CONFIG_BLK_CGROUP */
 
+#ifdef CONFIG_BLK_DEV_THROTTLING
+void __blkcg_account_v1_bio(struct bio *bio);
+static inline void blkcg_account_v1_bio(struct bio *bio)
+{
+	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
+		__blkcg_account_v1_bio(bio);
+}
+#else
+static inline void blkcg_account_v1_bio(struct bio *bio) { }
+#endif
+
 #endif /* _BLK_CGROUP_PRIVATE_H */
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c5e26551956a..8f0632868780 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -268,12 +268,6 @@ static struct blkg_policy_data *throtl_pd_alloc(struct gendisk *disk,
 	if (!tg)
 		return NULL;
 
-	if (blkg_rwstat_init(&tg->stat_bytes, gfp))
-		goto err_free_tg;
-
-	if (blkg_rwstat_init(&tg->stat_ios, gfp))
-		goto err_exit_stat_bytes;
-
 	throtl_service_queue_init(&tg->service_queue);
 
 	for (rw = READ; rw <= WRITE; rw++) {
@@ -288,12 +282,6 @@ static struct blkg_policy_data *throtl_pd_alloc(struct gendisk *disk,
 	tg->iops[WRITE] = UINT_MAX;
 
 	return &tg->pd;
-
-err_exit_stat_bytes:
-	blkg_rwstat_exit(&tg->stat_bytes);
-err_free_tg:
-	kfree(tg);
-	return NULL;
 }
 
 static void throtl_pd_init(struct blkg_policy_data *pd)
@@ -359,8 +347,6 @@ static void tg_release(struct rcu_head *rcu)
 		container_of(rcu, struct blkg_policy_data, rcu_head);
 	struct throtl_grp *tg = pd_to_tg(pd);
 
-	blkg_rwstat_exit(&tg->stat_bytes);
-	blkg_rwstat_exit(&tg->stat_ios);
 	kfree(tg);
 }
 
@@ -1413,32 +1399,6 @@ static ssize_t tg_set_conf_uint(struct kernfs_open_file *of,
 	return tg_set_conf(of, buf, nbytes, off, false);
 }
 
-static int tg_print_rwstat(struct seq_file *sf, void *v)
-{
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
-			  blkg_prfill_rwstat, &blkcg_policy_throtl,
-			  seq_cft(sf)->private, true);
-	return 0;
-}
-
-static u64 tg_prfill_rwstat_recursive(struct seq_file *sf,
-				      struct blkg_policy_data *pd, int off)
-{
-	struct blkg_rwstat_sample sum;
-
-	blkg_rwstat_recursive_sum(pd_to_blkg(pd), &blkcg_policy_throtl, off,
-				  &sum);
-	return __blkg_prfill_rwstat(sf, pd, &sum);
-}
-
-static int tg_print_rwstat_recursive(struct seq_file *sf, void *v)
-{
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
-			  tg_prfill_rwstat_recursive, &blkcg_policy_throtl,
-			  seq_cft(sf)->private, true);
-	return 0;
-}
-
 static struct cftype throtl_legacy_files[] = {
 	{
 		.name = "throttle.read_bps_device",
@@ -1464,26 +1424,6 @@ static struct cftype throtl_legacy_files[] = {
 		.seq_show = tg_print_conf_uint,
 		.write = tg_set_conf_uint,
 	},
-	{
-		.name = "throttle.io_service_bytes",
-		.private = offsetof(struct throtl_grp, stat_bytes),
-		.seq_show = tg_print_rwstat,
-	},
-	{
-		.name = "throttle.io_service_bytes_recursive",
-		.private = offsetof(struct throtl_grp, stat_bytes),
-		.seq_show = tg_print_rwstat_recursive,
-	},
-	{
-		.name = "throttle.io_serviced",
-		.private = offsetof(struct throtl_grp, stat_ios),
-		.seq_show = tg_print_rwstat,
-	},
-	{
-		.name = "throttle.io_serviced_recursive",
-		.private = offsetof(struct throtl_grp, stat_ios),
-		.seq_show = tg_print_rwstat_recursive,
-	},
 	{ }	/* terminate */
 };
 
@@ -1672,25 +1612,8 @@ static void tg_flush_bios(struct throtl_grp *tg)
 static void throtl_pd_offline(struct blkg_policy_data *pd)
 {
 	struct throtl_grp *tg = pd_to_tg(pd);
-	struct throtl_grp *parent = blkg_to_tg(tg_to_blkg(tg)->parent);
 
 	tg_flush_bios(tg);
-
-	/* the recursive files of the ancestors go on counting what it did */
-	if (parent) {
-		blkg_rwstat_add_aux(&parent->stat_bytes, &tg->stat_bytes);
-		blkg_rwstat_add_aux(&parent->stat_ios, &tg->stat_ios);
-		blkg_rwstat_reset(&tg->stat_bytes);
-		blkg_rwstat_reset(&tg->stat_ios);
-	}
-}
-
-static void throtl_pd_reset_stats(struct blkg_policy_data *pd)
-{
-	struct throtl_grp *tg = pd_to_tg(pd);
-
-	blkg_rwstat_reset(&tg->stat_bytes);
-	blkg_rwstat_reset(&tg->stat_ios);
 }
 
 struct blkcg_policy blkcg_policy_throtl = {
@@ -1702,7 +1625,6 @@ struct blkcg_policy blkcg_policy_throtl = {
 	.pd_online_fn		= throtl_pd_online,
 	.pd_offline_fn		= throtl_pd_offline,
 	.pd_free_fn		= throtl_pd_free,
-	.pd_reset_stats_fn	= throtl_pd_reset_stats,
 };
 
 static void tg_cancel_writeback_bios(struct throtl_grp *tg,
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 1b5775771e07..02c08daf3dc3 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -2,7 +2,7 @@
 #ifndef BLK_THROTTLE_H
 #define BLK_THROTTLE_H
 
-#include "blk-cgroup-rwstat.h"
+#include "blk-cgroup.h"
 
 /*
  * To implement hierarchical throttling, throtl_grps form a tree and bios
@@ -124,8 +124,6 @@ struct throtl_grp {
 	unsigned long slice_start[2];
 	unsigned long slice_end[2];
 
-	struct blkg_rwstat stat_bytes;
-	struct blkg_rwstat stat_ios;
 };
 
 extern struct blkcg_policy blkcg_policy_throtl;
@@ -172,14 +170,7 @@ static inline bool blk_should_throtl(struct bio *bio)
 		return false;
 
 	tg = blkg_to_tg(bio->bi_blkg);
-	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
-		if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
-			bio_set_flag(bio, BIO_CGROUP_ACCT);
-			blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
-					bio->bi_iter.bi_size);
-		}
-		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
-	}
+	blkcg_account_v1_bio(bio);
 
 	/* iops limit is always counted */
 	if (tg->has_rules_iops[rw])
-- 
2.25.1

