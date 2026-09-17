Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DCB43499F
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 07:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789628486; cv=none; b=nuTRO/0Wz/IVVd2agwY5FadMAfsTZLv2jUaTS+Pscm7m1r4kbPUFrpOe3ELgZd1MXuJK0knPqjsLitQqLhkh1AGCc8Y2nEcztHlQ7FbS2fhGzrlAiewv/qoTsHfYjk8ZRch1CPff3omLsqraZEzLEy4bHoIV41FQDdOkjIZf4qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789628486; c=relaxed/simple;
	bh=63MuykeUWjsN3TmyvpFgVF6cEXQhM5BlFyJ5zW3KUp4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dsczgsURM6cJgp2OSvU5W8+I5IM3MMHH2/D+yG2/Bg2i21IjQdaAHONbWYR02TJk5FDqW8xclI9Doqb3GiCc8pDINOPpprU9zAsOMu1H5VltIOYb4mImPcS6yBPwgk/qwP/XcHSO6ToTim1+hZBpMv0yjo1evpO9EzSVL38fBUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Rkvl0Tt4; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Rkvl0Tt4"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-39b350c6920so431365a91.1
        for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 00:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789628483; x=1790233283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9DYHgRIJqpSed6YVO3OWCRp9w7bsaWXZECFIVVOSjzY=;
        b=Rkvl0Tt4wQDDNjQUpd4TzOnnJmsGbZROPmnIBMJfg2rLdH88g+3Vz5egFyEX4TiVZk
         oiG8RSvDcljGdjjlnUuzxLWqRX4LweGpznVMptvaldSmCPjqdTlsvTcJbPPDE4hn2Iom
         qkirZWn2zZ4Nm2FjXnqCE3rPVn1cHhfDniw3F0mW4mH4DIXXuTMrTsu4jmcNit54BoKr
         MfEZmn6dxEQJlsda0oI5QoJQIxHSPs21XOs/7VhzQHvfVhjPIt2niU+rsnNjx4v6e3FK
         p/wIVsF6cyLWOhZ2CwYQLtviGqu7E4vSQtWQKZHFL/vWSR0JgkqUYSXsNFwbvPLtMQ7W
         3oVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789628483; x=1790233283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9DYHgRIJqpSed6YVO3OWCRp9w7bsaWXZECFIVVOSjzY=;
        b=ZHv58aZlZREiFdSYpLz8NxvLKcbzqkqA5ygNbcEUy6WHHgNORIcv+dRnCk0zcTfnjh
         AIPJL/9uFqizyHxjKjQ1wW+2TR7k4u5+JmjT5S+FFRK5a39bCXNYI4BQgWpCLa1AN3Qc
         MVRjrOEs3ABV3c2O3CLssD54gJSTpU2TanLIqIOeki/o8FiRT6vyXchouFMVHs2l13Ye
         GzCzVVifyxcn/1vp+gJp+7NlZvmxvYUj5VQ9jMIxflGKwMe3k0D4NIazkk1iCW/0w7El
         yZno3Lyb7H8kLxK9Yfm62GN3GL7wcl/xkNQr8x0/eGrnG0oeTmf1cMshkvX1tNbgHlXw
         dE7w==
X-Forwarded-Encrypted: i=1; AKwUvBz4+soIw9fdQ23VjelrdmL/ptEFbSoMmyJWniqmVT5MaObP3J+eaERqnvXGpruFiqrAdeFSqIVD@vger.kernel.org
X-Gm-Message-State: AFuF++k5Pjw3H6MiWPdr4k0YKQneV0y9G5HSR59ly1rTbIli6C9CYyDI
	UWriI7ccpD6jcU/8Pmi6GZMQXOSrwvIJJFUTadYn0m8KkRucTZjNvBL/DeoUIgWudH8=
X-Gm-Gg: AYBFou3CRRO6UlEfXC5DdbOP8tFpRMf4ICp6PqoSL8gTYSJYb7UZXN8hZ8IMi42fJ9x
	hum0jpU8CGclijDDMS2ILUz/EZZqmgYu5eSGI9S8IfublquOSsEHXlbv0xteFW4p6iBuXxAHcvq
	KS3sKQMtURgFai98Aa3uSKGHL2CJUpFEymPTAJb3putZjyby/qqFlvkcWyvNu0aGePA5ydIFArZ
	kDljJww0fmF3HzSJ6+D2wYPfjc803eFYREq0tXsIYeVJdi3z5GXbgz4t/trJzGIWzI4cCcTc2K2
	G0gdesmXTtBooPzng7J4vWpoMqndbKlTRhHDGOwge++grGwuiLnW3DNL6lJ3+iNmpZZwHd2EcIL
	rdsmu2shfgP5HJFH+szFGJE32CQkowkzma1GW2Np6MZ6D9UjCmPbCt56t0IrfHunSH/VCfOGaO2
	vDFYKUd7TuezhgkQLVqjPoYS6F/wOxaBg+1SG5eGO4xuD0Xq+JpAKsKScDj1S4bzdTxspKEX/v9
	A==
X-Received: by 2002:a17:90a:10c1:b0:39e:1ec9:dc8d with SMTP id 98e67ed59e1d1-39e1ec9e479mr8576309a91.24.1789628482980;
        Thu, 17 Sep 2026 00:01:22 -0700 (PDT)
Received: from localhost ([106.38.226.67])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e362ea35asm3420728a91.16.2026.09.17.00.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 00:01:22 -0700 (PDT)
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
Subject: [PATCH v6 2/3] memcg,writeback: flush foreign bdev mappings separately from owner wbs
Date: Thu, 17 Sep 2026 15:01:18 +0800
Message-Id: <20260917070119.2648123-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260917065759.2643940-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
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

Record bdev device numbers separately and queue best-effort work on
memcg_bdev_frn_flusher to write only their mappings. Keep the existing
foreign-wb mechanism for non-bdev inodes.

Bdev foreign flushes can be triggered frequently. Use a dedicated
workqueue to avoid interfering with tasks on existing workqueues. If
allocation fails, retain the existing foreign-wb path.

Use fixed per-memcg slots, with a shared lock protecting device records
and in-flight state. Tracking is best effort: record only dev_t without
holding device or inode references. Skip closed devices or devices whose
open_mutex is busy. Device removal and device-number reuse may race with
lookup.

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 include/linux/memcontrol.h |  15 +++++
 mm/memcontrol.c            | 117 ++++++++++++++++++++++++++++++++++---
 2 files changed, 124 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..3cd90913773b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -176,6 +176,18 @@ struct memcg_cgwb_frn {
 	struct wb_completion done;	/* tracks in-flight foreign writebacks */
 };
 
+/*
+ * frn_lock protects dev and inflight.
+ * No extra memcg reference is taken: this work is embedded in the memcg,
+ * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
+ */
+struct bdev_frn_flush_ctx {
+	struct work_struct work;
+	dev_t dev;
+	bool inflight;
+	struct mem_cgroup *memcg;
+};
+
 /*
  * Bucket for arbitrarily byte-sized objects charged to a memory
  * cgroup. The bucket can be reparented in one piece when the cgroup
@@ -279,6 +291,9 @@ struct mem_cgroup {
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
+	struct bdev_frn_flush_ctx bdev_frn[MEMCG_CGWB_FRN_CNT];
+	/* Nests inside mapping->i_pages in the dirty tracking path. */
+	spinlock_t frn_lock;
 #endif
 
 #ifdef CONFIG_LRU_GEN_WALKS_MMU
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..55bd5d100caa 100644
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
@@ -3845,6 +3847,52 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	}
 }
 
+/*
+ * Bdev inodes are commonly shared by many memcgs. Flushing their owner wb
+ * can write unrelated file data, so record device numbers separately and
+ * flush only the bdev mappings. Tracking is best effort: record only dev_t
+ * without holding device or inode references, so it may race with device
+ * removal and re-addition.
+ */
+static void mem_cgroup_track_foreign_bdev(struct mem_cgroup *memcg, dev_t dev)
+{
+	struct bdev_frn_flush_ctx *ctx;
+	unsigned long flags;
+	int slot = -1;
+	int i;
+
+	/*
+	 * __folio_mark_dirty() takes mapping->i_pages with xa_lock_irqsave()
+	 * before reaching this helper. Use irqsave here as well so frn_lock's
+	 * IRQ protection does not depend on that outer locking.
+	 */
+	spin_lock_irqsave(&memcg->frn_lock, flags);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		if (memcg->bdev_frn[i].dev == dev)
+			goto out;
+	}
+
+	/*
+	 * Tracking is best effort, so losing hints when all slots are occupied
+	 * is expected.
+	 */
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		ctx = &memcg->bdev_frn[i];
+		if (ctx->inflight)
+			continue;
+		if (slot < 0)
+			slot = i;
+		if (!ctx->dev) {
+			slot = i;
+			break;
+		}
+	}
+	if (slot >= 0)
+		memcg->bdev_frn[slot].dev = dev;
+out:
+	spin_unlock_irqrestore(&memcg->frn_lock, flags);
+}
+
 /*
  * Foreign dirty flushing
  *
@@ -3875,17 +3923,17 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
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
+ * These wb records only remember IDs and don't hold any object references.
  * As being wrong occasionally doesn't matter, updates and accesses to the
  * records are lockless and racy.
  */
@@ -3898,9 +3946,17 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *bdev_inode = mapping ? mapping->host : NULL;
 
 	trace_track_foreign_dirty(folio, wb);
 
+	if (memcg_bdev_frn_wq && bdev_inode &&
+	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
+		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
+		return;
+	}
+
 	/*
 	 * Pick the slot to use.  If there is already a slot for @wb, keep
 	 * using it.  If not replace the oldest one which isn't being
@@ -3941,6 +3997,25 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	}
 }
 
+static void bdev_frn_flush_work(struct work_struct *work)
+{
+	struct bdev_frn_flush_ctx *ctx =
+		container_of(work, struct bdev_frn_flush_ctx, work);
+	unsigned long flags;
+
+	bdev_flush_by_dev(ctx->dev);
+
+	/*
+	 * The dirty tracking path takes frn_lock while holding mapping->i_pages.
+	 * Disable local IRQs here to avoid deadlocks with I/O completion
+	 * handlers that also take mapping->i_pages.
+	 */
+	spin_lock_irqsave(&ctx->memcg->frn_lock, flags);
+	ctx->inflight = false;
+	ctx->dev = 0;
+	spin_unlock_irqrestore(&ctx->memcg->frn_lock, flags);
+}
+
 /* issue foreign writeback flushes for recorded foreign dirtying events */
 void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
@@ -3949,6 +4024,18 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 	u64 now = jiffies_64;
 	int i;
 
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct bdev_frn_flush_ctx *ctx = &memcg->bdev_frn[i];
+		unsigned long flags;
+
+		spin_lock_irqsave(&memcg->frn_lock, flags);
+		if (!ctx->inflight && ctx->dev) {
+			ctx->inflight = true;
+			queue_work(memcg_bdev_frn_wq, &ctx->work);
+		}
+		spin_unlock_irqrestore(&memcg->frn_lock, flags);
+	}
+
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
 		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
 
@@ -4202,9 +4289,15 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
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
+		ctx->memcg = memcg;
+	}
+	spin_lock_init(&memcg->frn_lock);
 #endif
 	lru_gen_init_memcg(memcg);
 	return memcg;
@@ -4386,8 +4479,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
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
@@ -5703,6 +5798,12 @@ int __init mem_cgroup_init(void)
 	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
 	WARN_ON(!memcg_wq);
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
+					    WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	WARN_ON(!memcg_bdev_frn_wq);
+#endif
+
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_memcg_stock);
-- 
2.39.5

