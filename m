Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FF348CD4A
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 08:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789461261; cv=none; b=XudybsnfqCyDXeAZAQTz3fXL/GKdvEnM/mtal2kZpG+pTk6pvMFIyNiF9saGGTVLteV1W5RvUTF68NbBexfzfq7In7FIftqCPPnOyhxRJFmZmzBEdKJIZlScxq6M+fzXBWLHtmTNUWKnZI4XeSELyjiQynuyDAfEgCgho6g/8Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789461261; c=relaxed/simple;
	bh=CKMbPuM6Yb1atG/NuM5NdV1aKcM8/wnznVYdm3QdpRk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tPOvWX96XZ77bkDRi8zcsjpzB4vxYbPFbqNs24loj8qyQcxfNUO+LqqToAc3UXbZPpoNE7V0YtbxnWiqfVVjT54++unop9QDewbn1JpcrGQTUIofNKBN9hH6F12VVltb/CMsCh0V1/E7aBORqlqRIqdtKbTAXfkFJtjZWhHi9vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=fR8ihgPN; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="fR8ihgPN"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b35611so1680560b3a.0
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 01:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789461259; x=1790066059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=18B+mnf3gIsI3ZPyV0XbtWA76VI7+e4SAQ+2YXTfHcE=;
        b=fR8ihgPNDWcWsp7UhPMagiGYRK/3vjZrRPDOpC4nNctlFQJGu8aQeBxZM2wAyhzoNV
         et97KWWJ3ZlPQ3iXeyKsOr5CTH8cBan5bshsNzkamUfTnJ0gdYhP+f7QdWSV/KB/pp8w
         3ibFGqcnqqMC/Bp4tThKkmaV7ERvy/c/9WKEZeoGiGpFUcyHnSwv7sPYnerN65d3zOpf
         M1w1eVnTKSEQgK7PQyPfz0SG1XgGWxpFYu3vUzEKQJM5rgfDvwynsL5q0we1J8MgRdpx
         06xkrecJxtVhF4MAgQ7scur7bdoi/2aNaMHTXYx8EBZ1VBC1/OBwufwJv+2iyK8keCJE
         cE7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461259; x=1790066059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=18B+mnf3gIsI3ZPyV0XbtWA76VI7+e4SAQ+2YXTfHcE=;
        b=YwzCpvMm/t/9w7ub9PhP41whPrh/TUrz9qt2U6skhzx9orhNgv2MQ0p8jEGHpqpbPK
         1ayjxnvujGLOLWhf6P+ZOMAJevlmfXzSW/ejqLD27V4gMntTqIz/a9MESbQJIpt6y+wU
         vqPBENzw5N55NEZu+92sH/H5QlQMpqXfYtswtZBP9ooHgtW5qQCiNSyCv5d4NuUOwXYs
         4sFRFWmJo6KMQOSqUmiQbdB2zabOCUBrS+b2sQHgKmsrCThIwHiBzFI0DE8WgNGIVWVH
         bbX6MMJ7LFDNGXK/QmMMNV+CfjUavS2glKw1sdpPmkKxzUez+oTAnlHK27DxeV5zFyLX
         Gqsw==
X-Forwarded-Encrypted: i=1; AKwUvBwrpc7wXFx8jpfAl/6cAHP6oSr1SgkcsuC0ax5Hui6pPuTRVGyAU3mn1raVPGGoehFBhuejkY95@vger.kernel.org
X-Gm-Message-State: AFuF++nAvM7xXhz1g9h4DWlARx/KnHBEUfFfY//LjWl69vlRFsoMIKye
	nkFOMqS7ElfkzQ8dl6Df5qjsqZCpmuKY8K+7wTIxTmZrIsW1V2RW3n9tKI16Ch6NXXUmKpAFgD6
	zHKxYWMg=
X-Gm-Gg: AYBFou2vupamW177WKxjLtV/o9sZDX8gzfdyRoCNGz9erF37mVYPxlxwE5NVQIG3A8I
	Q1JdnE2JY8CYgDpYA3dHIZkePEghKgp2URvPUg9Nm1rnExcJnCorBQVEFM/V+8ZhXoXKG4Z7qET
	QQMX6/lfl0p1AqFGpwGtF4bcc7CB/he2uxlnxSpC6aTj4UiBxaY5N/sAdFcyDST/GSXigvEpQ92
	x1z3OZtxVEEj034XNM9X8CL3pwW+EcHuE/y2PFJ6/AycHam+ON/LqcvROevSiROAeFfYhKbOLX1
	8e4TqyORnbUOqYhGhABhsMeFdsnh6MaOKLbzcXRZdx3QgB+QfYxpwDu6tJ0ia1TF4kzEFw9Hedl
	H/GuY0VW2j9lJtK4IfoWxq6Uc3uldH+HrG/XDmKa+SjCusWhycNjmpFp/Ah+WKnOiMqTjJ7G1w4
	5OIajrl7Tro+dODMMw8Odk0rtdNXg/0Z/reYuY8sl9mFZH+cwIFPsBkG/jXcf45LVZ8mHGR0i+H
	Ts=
X-Received: by 2002:a05:6a00:1950:b0:82f:38df:681c with SMTP id d2e1a72fcca58-86f82f524c7mr12906512b3a.6.1789461258753;
        Tue, 15 Sep 2026 01:34:18 -0700 (PDT)
Received: from localhost ([106.38.226.183])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29dc09d4sm5702332b3a.47.2026.09.15.01.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:34:18 -0700 (PDT)
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
Subject: [PATCH v5 2/3] memcg,writeback: flush foreign bdev mappings separately from owner wbs
Date: Tue, 15 Sep 2026 16:34:05 +0800
Message-Id: <20260915083406.3471036-3-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915083406.3471036-1-sunjunchao@bytedance.com>
References: <20260915083406.3471036-1-sunjunchao@bytedance.com>
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
 include/linux/memcontrol.h |  15 ++++++
 mm/memcontrol.c            | 106 ++++++++++++++++++++++++++++++++++---
 2 files changed, 113 insertions(+), 8 deletions(-)

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
index 1271d390b617..61ebe4ab744f 100644
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
@@ -3845,6 +3847,41 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
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
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		ctx = &memcg->bdev_frn[i];
+		if (ctx->inflight)
+			continue;
+		ctx->dev = dev;
+		break;
+	}
+out:
+	spin_unlock_irqrestore(&memcg->frn_lock, flags);
+}
+
 /*
  * Foreign dirty flushing
  *
@@ -3875,17 +3912,17 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
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
@@ -3898,9 +3935,17 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
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
@@ -3941,6 +3986,25 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
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
@@ -3949,6 +4013,18 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
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
 
@@ -4202,9 +4278,15 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
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
@@ -4386,8 +4468,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
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
@@ -5703,6 +5787,12 @@ int __init mem_cgroup_init(void)
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

