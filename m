From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 7/7] block: make blkcg_punt_bio_submit optional
Date: Mon, 27 Mar 2023 09:49:53 +0900
Message-ID: <20230327004954.728797-8-hch@lst.de>
References: <20230327004954.728797-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TPw9qrw+C0d4LOLpjPe9aVmo+/5e3HxItkaDq8wloFA=; b=4vrmrwRpsZO8U0EKNDKDMw5zwh
        fi5ZJAzbcBpFqwrFAB7R7lp2nm5oBSbzX4GHd6gZqDz/l/2niTJkc+XSaWj3aUZDH1vMu83I9jR65
        h6cOAokyHsmXa+5SICeJV3lpGKwf/DzlOZU7y6z3SNXiz929Q51mpkg6cRy4KSGW2uudozCFNi9m2
        5q7f+YRCE4wQdMJaO12lnR+qWpnoU2CS5ds4J21WkhczLbiO0l3/ZqPkOQ0Wvx7+zLvvck7pYoq8k
        6PdwWaVi+mpOL6j02yB8VvDS3n+wwV7LKS74C/Q2bJjHLE/MnGRGHQ2aWT3Qhx063QZyV5TYJO9k9
        U9/IkFqw==;
In-Reply-To: <20230327004954.728797-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Guard all the code to punt bios to a per-cgroup submission helper by a
new CONFIG_BLK_CGROUP_PUNT_BIO symbol that is selected by btrfs.
This way non-btrfs kernel builds don't need to have this code.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/Kconfig      |  3 ++
 block/blk-cgroup.c | 77 +++++++++++++++++++++++++---------------------
 block/blk-cgroup.h |  3 +-
 fs/btrfs/Kconfig   |  1 +
 4 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 941b2dca70db73..69ccf7457ae110 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -41,6 +41,9 @@ config BLK_RQ_ALLOC_TIME
 config BLK_CGROUP_RWSTAT
 	bool
 
+config BLK_CGROUP_PUNT_BIO
+	bool
+
 config BLK_DEV_BSG_COMMON
 	tristate
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c524ecab440b8f..18c922579719b5 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -56,7 +56,6 @@ static struct blkcg_policy *blkcg_policy[BLKCG_MAX_POLS];
 static LIST_HEAD(all_blkcgs);		/* protected by blkcg_pol_mutex */
 
 bool blkcg_debug_stats = false;
-static struct workqueue_struct *blkcg_punt_bio_wq;
 
 #define BLKG_DESTROY_BATCH_SIZE  64
 
@@ -166,7 +165,9 @@ static void __blkg_release(struct rcu_head *rcu)
 {
 	struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq, rcu_head);
 
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
 	WARN_ON(!bio_list_empty(&blkg->async_bios));
+#endif
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
@@ -188,6 +189,9 @@ static void blkg_release(struct percpu_ref *ref)
 	call_rcu(&blkg->rcu_head, __blkg_release);
 }
 
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+static struct workqueue_struct *blkcg_punt_bio_wq;
+
 static void blkg_async_bio_workfn(struct work_struct *work)
 {
 	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
@@ -214,6 +218,40 @@ static void blkg_async_bio_workfn(struct work_struct *work)
 		blk_finish_plug(&plug);
 }
 
+/*
+ * When a shared kthread issues a bio for a cgroup, doing so synchronously can
+ * lead to priority inversions as the kthread can be trapped waiting for that
+ * cgroup.  Use this helper instead of submit_bio to punt the actual issuing to
+ * a dedicated per-blkcg work item to avoid such priority inversions.
+ */
+void blkcg_punt_bio_submit(struct bio *bio)
+{
+	struct blkcg_gq *blkg = bio->bi_blkg;
+
+	if (blkg->parent) {
+		spin_lock(&blkg->async_bio_lock);
+		bio_list_add(&blkg->async_bios, bio);
+		spin_unlock(&blkg->async_bio_lock);
+		queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
+	} else {
+		/* never bounce for the root cgroup */
+		submit_bio(bio);
+	}
+}
+EXPORT_SYMBOL_GPL(blkcg_punt_bio_submit);
+
+static int __init blkcg_punt_bio_init(void)
+{
+	blkcg_punt_bio_wq = alloc_workqueue("blkcg_punt_bio",
+					    WQ_MEM_RECLAIM | WQ_FREEZABLE |
+					    WQ_UNBOUND | WQ_SYSFS, 0);
+	if (!blkcg_punt_bio_wq)
+		return -ENOMEM;
+	return 0;
+}
+subsys_initcall(blkcg_punt_bio_init);
+#endif /* CONFIG_BLK_CGROUP_PUNT_BIO */
+
 /**
  * bio_blkcg_css - return the blkcg CSS associated with a bio
  * @bio: target bio
@@ -269,10 +307,12 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 
 	blkg->q = disk->queue;
 	INIT_LIST_HEAD(&blkg->q_node);
+	blkg->blkcg = blkcg;
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
 	spin_lock_init(&blkg->async_bio_lock);
 	bio_list_init(&blkg->async_bios);
 	INIT_WORK(&blkg->async_bio_work, blkg_async_bio_workfn);
-	blkg->blkcg = blkcg;
+#endif
 
 	u64_stats_init(&blkg->iostat.sync);
 	for_each_possible_cpu(cpu) {
@@ -1688,28 +1728,6 @@ void blkcg_policy_unregister(struct blkcg_policy *pol)
 }
 EXPORT_SYMBOL_GPL(blkcg_policy_unregister);
 
-/*
- * When a shared kthread issues a bio for a cgroup, doing so synchronously can
- * lead to priority inversions as the kthread can be trapped waiting for that
- * cgroup.  Use this helper instead of submit_bio to punt the actual issuing to
- * a dedicated per-blkcg work item to avoid such priority inversions.
- */
-void blkcg_punt_bio_submit(struct bio *bio)
-{
-	struct blkcg_gq *blkg = bio->bi_blkg;
-
-	if (blkg->parent) {
-		spin_lock(&blkg->async_bio_lock);
-		bio_list_add(&blkg->async_bios, bio);
-		spin_unlock(&blkg->async_bio_lock);
-		queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
-	} else {
-		/* never bounce for the root cgroup */
-		submit_bio(bio);
-	}
-}
-EXPORT_SYMBOL_GPL(blkcg_punt_bio_submit);
-
 /*
  * Scale the accumulated delay based on how long it has been since we updated
  * the delay.  We only call this when we are adding delay, in case it's been a
@@ -2088,16 +2106,5 @@ bool blk_cgroup_congested(void)
 	return ret;
 }
 
-static int __init blkcg_init(void)
-{
-	blkcg_punt_bio_wq = alloc_workqueue("blkcg_punt_bio",
-					    WQ_MEM_RECLAIM | WQ_FREEZABLE |
-					    WQ_UNBOUND | WQ_SYSFS, 0);
-	if (!blkcg_punt_bio_wq)
-		return -ENOMEM;
-	return 0;
-}
-subsys_initcall(blkcg_init);
-
 module_param(blkcg_debug_stats, bool, 0644);
 MODULE_PARM_DESC(blkcg_debug_stats, "True if you want debug stats, false if not");
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 64758ab9f1f134..e98d2c1be35415 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -72,9 +72,10 @@ struct blkcg_gq {
 	struct blkg_iostat_set		iostat;
 
 	struct blkg_policy_data		*pd[BLKCG_MAX_POLS];
-
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
 	spinlock_t			async_bio_lock;
 	struct bio_list			async_bios;
+#endif
 	union {
 		struct work_struct	async_bio_work;
 		struct work_struct	free_work;
diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 37b6bab90c835e..66fa9ab2c04629 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -2,6 +2,7 @@
 
 config BTRFS_FS
 	tristate "Btrfs filesystem support"
+	select BLK_CGROUP_PUNT_BIO
 	select CRYPTO
 	select CRYPTO_CRC32C
 	select LIBCRC32C
-- 
2.39.2

