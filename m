Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D973492E2F
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 12:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789992437; cv=none; b=rE7j192kQetR2nWZA+Bw3cCv3D4jDqblyyaV2WF4Gxh0THxui+xE1kr+bTMgA5fDk6tmCbjucLU/RZCSzgFeuqaZdOHUA2xfXS6h0jZlMUEzQbQjPzRCAXJxKKGQi3AyUwEvfu7zwmYmY7wC0b7+wfLJfzDYSwm7bHIzH41cRKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789992437; c=relaxed/simple;
	bh=5lTxrfdmFW5aX+i3b8jogW/Q6gC8kTXn0s8ZWRPEhqY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l/ptmm5Msh5cXWYV+rOc9PD4VVTz493drqkvy4dR61T19/leDV6IMVeSzBlKLRRuH7U0HL4ZCkxDBTw9fSMhP0ygmLf3JCEdVTxCtbBnrivBmWg7hUDi/UG2p6b2blG1bqaMYBWEhaZaDD2PMZmX3+SUVqXGPRvlGbas+pNsldk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=SOdXzPdE; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="SOdXzPdE"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb1a98fso2569156a91.1
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 05:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789992432; x=1790597232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tJc8Za2aPZMoiI3lBKhq481v++PjI0BiwI3io/gwLcM=;
        b=SOdXzPdE9IjwVgWejb30xb3nSQrULNUT83zN1WCdAldhBS/Gx24lb81F3xN4u7z81b
         s9qCWAPbeSgTFQXH2YvqXL6wY/NJUbqdgVzeOvRnKXwbU/CzCD7+s/vaw8qIuvsMEXuN
         W0SDHl3Fw2uA6Xyul9xFiAgidNFf6q4iMprkd2rLe2q6YsMMIdEdpkuFYgccJxEUNAo4
         aMrha1AV9La+Ufx1ZiTJtXwdJZzaxRYi2wOniUq4n3Yb8dGLI5bnXAzII8dhhNxFZIs0
         3HSpmezPyMlkSfnkZdTWBAuq6W0JaHcdzA2eljKci2La1ebW1MoChqwBpLw9GzpuTTi9
         r5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789992432; x=1790597232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tJc8Za2aPZMoiI3lBKhq481v++PjI0BiwI3io/gwLcM=;
        b=c3su1QOi2d6jL9h1gv7WIeZLrl5XeXyXv4I8+b1y/dolfzh9XUlcaP64VqjgNnDDzd
         Xjx7KwGRLn5nXkeG3Kmiiy5kRDCiAN5zBHQ7xo3O3fBEpwoU4TtxaUJbbvNn9US5ilod
         G5Qt7vdPIoAmW99u6bOG+TCz74Ai7BEKTkaMcl8fYahsJL6PX7xL4HzsvNHhjZx5qMXW
         hMIMkrJvDtERkp9/L6ku7iAuIcw/3xNNyPajT+BoyVbruSGSlONxtQGTna7ZLbkvAvdU
         erzaG3zppDcBkdbg+hDsHPN3zu4J5Mq88G3YYNHBQNS+AOQv7Ib/6BlRGtY1IZa2isjM
         qceQ==
X-Forwarded-Encrypted: i=1; AKwUvBz+ri3zIuyZ5P7OfO1Cmhme+aAtzgNj4JResSYoGATbaJPm/QUkJKHjF8pUSG+KdYxm++PIA9LP@vger.kernel.org
X-Gm-Message-State: AFuF++l2GDr5VS+Y+fRfiE9tQUWBIkT1bvMdv5WPUiAQs+1gMrlA6osD
	uT2Ugbuj4uyeW7yWVEARCrJ8upkdjfLfMv+oTqkzF0xAsQ/SHyjE7lZhVh2kY8dzS1o=
X-Gm-Gg: AYBFou2JO5rjZbp9AAfP4BQwYcuDpoQ/7mEV2I+JUxCD1LbUbr2hQo4FT+pK8KvZnq9
	150p0h+nEYcCfWjhP9DknJ0X/HyDF2Y0FEzUZxXVYsoKHftODYuK50a/WYpkg5r1tckCv4Cz55f
	IkyqMCoBw1eV1AMwvJ3r0AZdiFOPGGc3h0mDG4bl7yYdBzqFGy4B2546r/qES0QjA5hIZpCjQ5F
	ESzND7WA4wGKD0bvVYkh+77gF/f2YqHD+l0JzIy7YEZJ6QvNYlvs083X8CM4M/cDW4ReRol2kl0
	DTqbn5rhpQ6W0ImYl9xa7BwzVXB+D4yj6K35kP4BijqFParY6Cooy6+vQGvbi/xxMxfxXhxZeo5
	zC7SZenS1xoD++rF1msiscBPhE+QHJ7WO8rMvDsyrP0V2pjrFOQ0yUYSlBJsDV/XZZg2zP6n8Fu
	EbdGTdK04aOjXX2NpbxFT1AB7k2XDEQARVNkI9XTNZzdSLJZ3ZMN1uQ394ai43uaSWWmXX1UY1q
	A==
X-Received: by 2002:a17:90b:280c:b0:39e:6c6a:657c with SMTP id 98e67ed59e1d1-39e6c6a680emr10210435a91.63.1789992431963;
        Mon, 21 Sep 2026 05:07:11 -0700 (PDT)
Received: from localhost ([106.38.226.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cb3607csm14484008a91.16.2026.09.21.05.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:07:11 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH v7 2/3] memcg,writeback: flush foreign bdev mappings separately from owner wbs
Date: Mon, 21 Sep 2026 20:06:57 +0800
Message-Id: <20260921120658.1627992-3-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260921120658.1627992-1-sunjunchao@bytedance.com>
References: <20260921120658.1627992-1-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bdev inodes are routinely shared by multiple memcgs. Recording their
owner wb as foreign can flush unrelated file data when a source memcg
enters dirty throttling.

Record bdev device numbers separately and queue work on
memcg_bdev_frn_flusher to write only their mappings. Keep the existing
foreign-wb mechanism for non-bdev inodes.

Use fixed per-memcg slots. Tracking is best effort: record only dev_t
without holding device or inode references. Records are updated under
the mapping->i_pages lock with IRQs disabled, but dropping a bdev
reference can sleep. Also, since foreign flushes are triggered by dirty
throttling, a memcg that never throttles could retain an unused record
and pin the device object indefinitely. Recording only dev_t avoids
these lifetime constraints, but device removal and device-number reuse
may race with lookup. Such races are expected under the best-effort
semantics.

Bdev writeback submission can block for a long time on congested devices,
with up to four work items outstanding per memcg. Use a dedicated unbound
workqueue to give these flushes a separate max_active budget, so they do
not exhaust a shared workqueue's active slots and delay unrelated work.
If allocation fails, retain the existing foreign-wb path.

This primarily affects filesystems that keep metadata in the bdev page
cache, such as ext4 and other buffer_head users, rather than the usual
metadata writeback paths of XFS and Btrfs. The decision still does not
account for how much of the memcg's dirty memory belongs to the bdev.
Even a single dirty bitmap block can trigger writeback of the entire
bdev mapping when the memcg enters dirty throttling.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 include/linux/memcontrol.h |  12 ++++
 mm/memcontrol.c            | 117 +++++++++++++++++++++++++++++++++----
 2 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..30d0c5d0da14 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -176,6 +176,17 @@ struct memcg_cgwb_frn {
 	struct wb_completion done;	/* tracks in-flight foreign writebacks */
 };
 
+/*
+ * No extra memcg reference is taken: this work is embedded in the memcg,
+ * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
+ */
+struct bdev_frn_flush_ctx {
+	struct work_struct work;
+	dev_t dev;			/* for bdev inode, device hint */
+	u64 at;				/* last recorded dirtying time in jiffies */
+	atomic_t inflight;
+};
+
 /*
  * Bucket for arbitrarily byte-sized objects charged to a memory
  * cgroup. The bucket can be reparented in one piece when the cgroup
@@ -279,6 +290,7 @@ struct mem_cgroup {
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
+	struct bdev_frn_flush_ctx bdev_frn[MEMCG_CGWB_FRN_CNT];
 #endif
 
 #ifdef CONFIG_LRU_GEN_WALKS_MMU
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..494540cf6278 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -39,6 +39,7 @@
 #include <linux/smp.h>
 #include <linux/page-flags.h>
 #include <linux/backing-dev.h>
+#include <linux/blkdev.h>
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/limits.h>
@@ -104,6 +105,7 @@ static struct kmem_cache *memcg_pn_cachep;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
+static struct workqueue_struct *memcg_bdev_frn_wq __ro_after_init;
 #endif
 
 static inline bool task_is_dying(void)
@@ -3875,20 +3877,74 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
  * most recent foreign dirtying events and initiating remote flushes on
  * them when local writeback isn't enough to keep the memory clean enough.
  *
- * The following two functions implement such mechanism.  When a foreign
- * page - a page whose memcg and writeback ownerships don't match - is
- * dirtied, mem_cgroup_track_foreign_dirty() records the inode owning
- * bdi_writeback on the page owning memcg.  When balance_dirty_pages()
- * decides that the memcg needs to sleep due to high dirty ratio, it calls
+ * For non-bdev inodes, when a foreign page - a page whose memcg and
+ * writeback ownerships don't match - is dirtied,
+ * mem_cgroup_track_foreign_dirty() records the inode owning bdi_writeback
+ * on the page owning memcg. When balance_dirty_pages() decides that the
+ * memcg needs to sleep due to high dirty ratio, it calls
  * mem_cgroup_flush_foreign() which queues writeback on the recorded
  * foreign bdi_writebacks which haven't expired.  Both the numbers of
  * recorded bdi_writebacks and concurrent in-flight foreign writebacks are
  * limited to MEMCG_CGWB_FRN_CNT.
  *
- * The mechanism only remembers IDs and doesn't hold any object references.
- * As being wrong occasionally doesn't matter, updates and accesses to the
- * records are lockless and racy.
+ * Bdev inodes are commonly shared by many memcgs. Flushing their owner wb
+ * can write unrelated file data, so record device numbers separately and
+ * flush only the bdev mappings. Tracking is best effort: record only dev_t
+ * without holding device or inode references, so it may race with device
+ * removal and re-addition. A resulting flush of the wrong device is
+ * acceptable under these best-effort semantics.
+ *
+ * These wb/bdev_inodes records only remember IDs and don't hold any object
+ * references. As being wrong occasionally doesn't matter, updates and
+ * accesses to the records are lockless and racy.
  */
+
+static void mem_cgroup_track_foreign_bdev(struct mem_cgroup *memcg, dev_t dev)
+{
+	struct bdev_frn_flush_ctx *ctx;
+	int i;
+	int oldest = -1;
+	u64 now = get_jiffies_64();
+	u64 oldest_at = now;
+
+	/*
+	 * Pick the slot to use.  If there is already a slot for @dev, keep
+	 * using it.  If not replace the oldest one which isn't being
+	 * written out.
+	 */
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		ctx = &memcg->bdev_frn[i];
+		if (ctx->dev == dev)
+			break;
+		if (atomic_read(&ctx->inflight))
+			continue;
+		if (time_before64(ctx->at, oldest_at)) {
+			oldest = i;
+			oldest_at = ctx->at;
+		}
+	}
+
+	if (i < MEMCG_CGWB_FRN_CNT) {
+		/*
+		 * Re-using an existing one.  Update timestamp lazily to
+		 * avoid making the cacheline hot.  We want them to be
+		 * reasonably up-to-date and significantly shorter than
+		 * dirty_expire_interval as that's what expires the record.
+		 * Use the shorter of 1s and dirty_expire_interval / 8.
+		 */
+		unsigned long update_intv =
+			min_t(unsigned long, HZ,
+			      msecs_to_jiffies(dirty_expire_interval * 10) / 8);
+
+		if (time_before64(ctx->at, now - update_intv))
+			ctx->at = now;
+	} else if (oldest >= 0) {
+		/* replace the oldest free one */
+		memcg->bdev_frn[oldest].dev = dev;
+		memcg->bdev_frn[oldest].at = now;
+	}
+}
+
 void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 					     struct bdi_writeback *wb)
 {
@@ -3898,6 +3954,14 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *bdev_inode = mapping ? mapping->host : NULL;
+
+	if (memcg_bdev_frn_wq && bdev_inode &&
+	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
+		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
+		return;
+	}
 
 	trace_track_foreign_dirty(folio, wb);
 
@@ -3941,6 +4005,16 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	}
 }
 
+static void bdev_frn_flush_work(struct work_struct *work)
+{
+	struct bdev_frn_flush_ctx *ctx =
+		container_of(work, struct bdev_frn_flush_ctx, work);
+
+	bdev_flush_by_dev(ctx->dev);
+
+	atomic_set(&ctx->inflight, 0);
+}
+
 /* issue foreign writeback flushes for recorded foreign dirtying events */
 void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
@@ -3949,6 +4023,16 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 	u64 now = jiffies_64;
 	int i;
 
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct bdev_frn_flush_ctx *ctx = &memcg->bdev_frn[i];
+
+		if (memcg_bdev_frn_wq && time_after64(ctx->at, now - intv) &&
+		    atomic_cmpxchg(&ctx->inflight, 0, 1) == 0) {
+			ctx->at = 0;
+			queue_work(memcg_bdev_frn_wq, &ctx->work);
+		}
+	}
+
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
 		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
 
@@ -4202,9 +4286,14 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct bdev_frn_flush_ctx *ctx = &memcg->bdev_frn[i];
+
 		memcg->cgwb_frn[i].done =
 			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
+		INIT_WORK(&ctx->work, bdev_frn_flush_work);
+		atomic_set(&ctx->inflight, 0);
+	}
 #endif
 	lru_gen_init_memcg(memcg);
 	return memcg;
@@ -4386,8 +4475,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	int __maybe_unused i;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
 		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
+		flush_work(&memcg->bdev_frn[i].work);
+	}
 #endif
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
@@ -5703,6 +5794,12 @@ int __init mem_cgroup_init(void)
 	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
 	WARN_ON(!memcg_wq);
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
+					    WQ_UNBOUND, 0);
+	WARN_ON(!memcg_bdev_frn_wq);
+#endif
+
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_memcg_stock);
-- 
2.39.5

