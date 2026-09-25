Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC0C396585
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 06:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790318697; cv=none; b=EZua2pMXn/SEVJSRwcumw1ehAZ931RH8PKrLvDv0HQv8t9j6+qh4OQqwtMw2D7Qs+U80tFCqvxM8vvqUdiVKWnYhRuFflBycNlb5oSUqiMNiGwHJogaok31LYryaDdqhfAPK8vWqXXWO8aq60sl41c53U/my4xW785bhjoXcm9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790318697; c=relaxed/simple;
	bh=/7ZR1MhRm9vyDmr0dTz+pg7JkHvtf1XgOFK4Tg5rDNE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FH0PfNDz4Flt9y9aWgXc9mT1K9Un1iB0gu/6WwCSxMfb9Ed14YlVQoANsM/jz+86c5MjR/0pcwaZk8b2HMoFSY+GljYLc+/VxazGi+OeBVJbcRBpoKjnrBSD/tGbXdoHukSx/pv7QBu3KGd4zN17EGwhNaSsMVuKR1x+VW09AGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=VV3yjLbE; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="VV3yjLbE"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd5cf03so425266a91.1
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 23:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790318695; x=1790923495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W028e/7qHpdafGaaElswgV9Bz8E8q5pXxlsv2HaAUwg=;
        b=VV3yjLbECIKiNAhWsWP/ZpS1QN3GNU6rrNOS4+BIgCvse5Nh4VuEAwDEmuADpnix/W
         oiOoNcMUhWIENAyAjcFr9I1NZmCh4n+JrXiIJvztGdkN3jiOk1PXKezygvrc/ssf1DvP
         Sz11Q+/M9jnVMoVqxs6hpB4iQL7gAZynHnhTtxwVmtsfSp7qwNQI9C6J6D3ECAACzLyp
         7rwy16Wpdi7UG4bfq/51LXKIffl69RdD1yDnJHtsoa0m4Tv8Yna0hyWjC8iClq8aNjdN
         kwXpzDPveUN+fqmKPkYND2YS3DcN6nFjv7vlXk9WzoW9jZKVv4D7x0jBaqCJYkSLKsE9
         cY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790318695; x=1790923495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W028e/7qHpdafGaaElswgV9Bz8E8q5pXxlsv2HaAUwg=;
        b=erok3qTTAs6Df4SBk7O74oXUky5lekiR73+OqLIDpK17542qT5C72WLWQLgy6rJmPN
         wFT3mFPxtMoeDUX8CrrsbzgGvEPp/6tCjueu+z2b0tlK2OHnpD8p+cQahcjKAm9XNxuf
         Zw3su5Bf7l0eu3KijK+XWWWw9T5lBRte/zKN2yZwMpaFpdY1ZymDTQZdxGhft3oC/Ls7
         z4J44/uQGSgAQO1lMwbS8Ca6sLdhMUBMdkEo92rALvzrFSwBJwgoISUhDk9Wi4F5AM8O
         AHOACQjs1p3At4LoIh8DEq+PcOSJUQnPYIcEtyO6xpCCC4Ysg8/KVJImu6A1Wwu+8qup
         NAng==
X-Forwarded-Encrypted: i=1; AKwUvByyrHRVgethP2gqA7DLFYZIcxbu87CvIjFyP+BkASQWNTI8NplyiBxDa6slmQV7YNjIh5pdR6SF@vger.kernel.org
X-Gm-Message-State: AFuF++kTatvX1w7j9Fgd0S0914b1Sfm5LLUYxGuHDdULAmkrzdxpHQic
	vEmDHTSmzuGQ8+TodCczSHGBFJS3ukB8EJ7LePL/ei+fKoYSOE/JNb2YiQg9mfwj3BM=
X-Gm-Gg: AYBFou13FYfObbB6hzDHGydnCsfLBZKcNAiwMHGqeJXKe5e17ZL/uKRlu0avbGFAcVA
	pohPItXdKvVwqOER+RVRGMJtJG9dhE6WrgcJ8VocmMN+JusJnqwcL9HklXZuWbtag2SAToIFT0c
	7K5wZY8gjRhLUdkXbl0jgwXX62keh1hLPr1/myOpOO2A9fS98K4hxGu2mfbLyKzGrY3k/n0jZK1
	AQECmfZcRiyP2BsPwZHGyPLqdXaA715z7NraCT/g1+rbQdqGCx4df4fpigSjsDKTgMwsPuKsLj5
	1ZCJg3xBn2OrIkUTlOeYTSN2ygIajnvb2Xr8U/gzSkbFIy+TI2aMXtocpidZ8txHzO23vBoFECh
	JP+N0umGviUB3LySJnkYhXOJsndYUACyDPVTt6Tkx1LWQMdQqZMcR5rY/jxLL+mPn7sY7m/dIjr
	OaaHIDWzzBpLu5LV4A0wYyXonADRREnE3dORIs06tEnnQnTEK9ZrIT0mfRG1fCT6lIFRyzMAN5u
	6Y=
X-Received: by 2002:a17:90b:4b83:b0:398:990e:1587 with SMTP id 98e67ed59e1d1-3a0986ed065mr4476822a91.9.1790318694779;
        Thu, 24 Sep 2026 23:44:54 -0700 (PDT)
Received: from localhost ([106.38.226.129])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9355e49sm2598699a91.4.2026.09.24.23.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 23:44:54 -0700 (PDT)
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
Subject: [PATCH v9 2/3] memcg,writeback: flush foreign bdev mappings separately from owner wbs
Date: Fri, 25 Sep 2026 14:44:43 +0800
Message-Id: <20260925064444.3944820-3-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260925064444.3944820-1-sunjunchao@bytedance.com>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
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

Use fixed per-memcg slots. Tracking uses oldest-first replacement and
expiry after dirty_expire_interval. Further dirtying during an ongoing
flush can trigger another flush after it finishes.

Tracking is best effort: record only dev_t without holding device or
inode references. Records are updated under the mapping->i_pages lock
with IRQs disabled, but dropping a bdev reference can sleep. Also, since
foreign flushes are triggered by dirty throttling, a memcg that never
throttles could retain an unused record and pin the device object
indefinitely. Recording only dev_t avoids these lifetime constraints,
but device removal and device-number reuse may race with lookup. Such
races are expected under the best-effort semantics.

Bdev writeback submission can block for a long time on congested devices,
with up to four work items outstanding per memcg. Use a dedicated unbound
workqueue to give these flushes a separate max_active budget, so they do
not exhaust a shared workqueue's active slots and delay unrelated work.
If the workqueue cannot be allocated at boot, bdev inodes continue to use
the existing foreign-wb path.

This primarily affects filesystems that keep metadata in the bdev page
cache, such as ext4 and other buffer_head users, rather than the usual
metadata writeback paths of XFS and Btrfs. This also covers buffered writes
to raw block devices. The decision still does not account for how much of
the memcg's dirty memory belongs to the bdev. Even a single dirty bitmap
block can trigger writeback of the entire bdev mapping when the memcg
enters dirty throttling.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 include/linux/memcontrol.h |  12 ++++
 mm/memcontrol.c            | 126 ++++++++++++++++++++++++++++++++++---
 2 files changed, 129 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..f13aa529fa15 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -176,6 +176,17 @@ struct memcg_cgwb_frn {
 	struct wb_completion done;	/* tracks in-flight foreign writebacks */
 };
 
+/*
+ * No extra memcg reference is taken: this work is embedded in the memcg,
+ * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
+ */
+struct memcg_bdev_frn {
+	struct work_struct work;
+	dev_t dev;			/* dev_t of the foreign bdev inode */
+	u64 at;				/* last recorded dirtying time in jiffies */
+	atomic_t inflight;		/* slot replacement or queued/running flush */
+};
+
 /*
  * Bucket for arbitrarily byte-sized objects charged to a memory
  * cgroup. The bucket can be reparented in one piece when the cgroup
@@ -279,6 +290,7 @@ struct mem_cgroup {
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
+	struct memcg_bdev_frn bdev_frn[MEMCG_CGWB_FRN_CNT];
 #endif
 
 #ifdef CONFIG_LRU_GEN_WALKS_MMU
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..74677078f9b4 100644
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
@@ -3875,20 +3877,81 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
  * most recent foreign dirtying events and initiating remote flushes on
  * them when local writeback isn't enough to keep the memory clean enough.
  *
- * The following two functions implement such mechanism.  When a foreign
- * page - a page whose memcg and writeback ownerships don't match - is
- * dirtied, mem_cgroup_track_foreign_dirty() records the inode owning
- * bdi_writeback on the page owning memcg.  When balance_dirty_pages()
+ * When a foreign page - a page whose memcg and writeback ownerships don't
+ * match - is dirtied, mem_cgroup_track_foreign_dirty() records the inode
+ * owning bdi_writeback on the page owning memcg. When balance_dirty_pages()
  * decides that the memcg needs to sleep due to high dirty ratio, it calls
  * mem_cgroup_flush_foreign() which queues writeback on the recorded
  * foreign bdi_writebacks which haven't expired.  Both the numbers of
  * recorded bdi_writebacks and concurrent in-flight foreign writebacks are
  * limited to MEMCG_CGWB_FRN_CNT.
  *
- * The mechanism only remembers IDs and doesn't hold any object references.
- * As being wrong occasionally doesn't matter, updates and accesses to the
- * records are lockless and racy.
+ * Bdev inodes are commonly shared by many memcgs. Flushing their owner wb
+ * can write unrelated file data, so each memcg tracks foreign bdevs
+ * separately in MEMCG_CGWB_FRN_CNT slots keyed by dev_t. These records
+ * use the same expiry policy, but trigger writeback of only the bdev
+ * mappings.
+ *
+ * Both kinds of records only remember IDs and don't hold any object
+ * references. As being wrong occasionally doesn't matter, updates and
+ * accesses to the records are lockless and racy.
  */
+
+static void mem_cgroup_track_foreign_bdev(struct mem_cgroup *memcg, dev_t dev)
+{
+	struct memcg_bdev_frn *frn;
+	int i;
+	int oldest;
+	u64 now = get_jiffies_64();
+	u64 oldest_at;
+
+retry:
+	oldest = -1;
+	oldest_at = now;
+
+	/*
+	 * Pick the slot to use.  If there is already a slot for @dev, keep
+	 * using it.  If not replace the oldest one which isn't being
+	 * written out.
+	 */
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		frn = &memcg->bdev_frn[i];
+		if (frn->dev == dev)
+			break;
+		if (atomic_read(&frn->inflight))
+			continue;
+		if (time_before64(frn->at, oldest_at)) {
+			oldest = i;
+			oldest_at = frn->at;
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
+		if (time_before64(frn->at, now - update_intv))
+			frn->at = now;
+	} else if (oldest >= 0) {
+		frn = &memcg->bdev_frn[oldest];
+		/* Reserve the slot: it may have become busy after the inflight check. */
+		if (atomic_cmpxchg(&frn->inflight, 0, 1) != 0)
+			goto retry;
+
+		frn->dev = dev;
+		frn->at = now;
+		atomic_set_release(&frn->inflight, 0);
+	}
+}
+
 void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 					     struct bdi_writeback *wb)
 {
@@ -3898,6 +3961,14 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *inode = mapping->host;
+
+	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {
+		trace_track_foreign_dirty(folio, wb);
+		mem_cgroup_track_foreign_bdev(memcg, inode->i_rdev);
+		return;
+	}
 
 	trace_track_foreign_dirty(folio, wb);
 
@@ -3941,6 +4012,16 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	}
 }
 
+static void bdev_frn_flush_work(struct work_struct *work)
+{
+	struct memcg_bdev_frn *frn =
+		container_of(work, struct memcg_bdev_frn, work);
+
+	bdev_flush_by_dev(frn->dev);
+
+	atomic_set(&frn->inflight, 0);
+}
+
 /* issue foreign writeback flushes for recorded foreign dirtying events */
 void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
@@ -3949,6 +4030,21 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 	u64 now = jiffies_64;
 	int i;
 
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct memcg_bdev_frn *frn = &memcg->bdev_frn[i];
+
+		/* Keep the workqueue availability check explicit. */
+		if (memcg_bdev_frn_wq && time_after64(frn->at, now - intv) &&
+		    atomic_cmpxchg(&frn->inflight, 0, 1) == 0) {
+			/*
+			 * Clear now so dirtying during writeback can refresh
+			 * the timestamp for a later flush.
+			 */
+			frn->at = 0;
+			queue_work(memcg_bdev_frn_wq, &frn->work);
+		}
+	}
+
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
 		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
 
@@ -4202,9 +4298,13 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct memcg_bdev_frn *frn = &memcg->bdev_frn[i];
+
 		memcg->cgwb_frn[i].done =
 			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
+		INIT_WORK(&frn->work, bdev_frn_flush_work);
+	}
 #endif
 	lru_gen_init_memcg(memcg);
 	return memcg;
@@ -4386,8 +4486,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
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
@@ -5703,6 +5805,12 @@ int __init mem_cgroup_init(void)
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

