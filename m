From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 5/5] Revert "blk-cgroup: pin the gendisk in struct blkcg_gq"
Date: Tue, 14 Feb 2023 19:33:08 +0100
Message-ID: <20230214183308.1658775-6-hch@lst.de>
References: <20230214183308.1658775-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=aTpopcfEDXefND8njwDJgTxCfdO9jKFEwpwhqayI8UA=; b=Erds57+KCjbJ5Vg0whQpEPEtH/
        4J5NNkCx2dwd2QvqmrOfFRIAKbaIol7qmcyTUqbqE4nqLxLXBOF4tKR7VFrXOsKSLPgHTwRZdsbDJ
        ajLnBPZ39PrPKCkI25CzfEQeAXohf+vpRahQvaHf0l6HmE0skSMOeItwJAGOXDsXubIDM0PyGwe8o
        I2Lo7n13RUQVrZEhA07qQI/6WvsWywOlDiPdmmYLSkZE2X0jdwcYECF5Yiaqujsu7N2NTUQjE8wxS
        tZajFRmBtyXXrsjIAegshAHAzCdloYeXU5O7Y6ORFzBvYLnVExlvihs48/QZjmYeXmCf6a9n2LAdj
        fd9M3TOg==;
In-Reply-To: <20230214183308.1658775-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This reverts commit 84d7d462b16dd5f0bf7c7ca9254bf81db2c952a2.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/bfq-cgroup.c        |  6 +++---
 block/blk-cgroup-rwstat.c |  2 +-
 block/blk-cgroup.c        | 35 ++++++++++++++++++-----------------
 block/blk-cgroup.h        | 11 ++++++-----
 block/blk-iocost.c        |  2 +-
 block/blk-iolatency.c     |  4 ++--
 block/blk-throttle.c      |  4 ++--
 7 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 935a497b5dedb3..ea3638e06e04b4 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -405,7 +405,7 @@ static void bfqg_stats_xfer_dead(struct bfq_group *bfqg)
 
 	parent = bfqg_parent(bfqg);
 
-	lockdep_assert_held(&bfqg_to_blkg(bfqg)->disk->queue->queue_lock);
+	lockdep_assert_held(&bfqg_to_blkg(bfqg)->q->queue_lock);
 
 	if (unlikely(!parent))
 		return;
@@ -536,7 +536,7 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
 {
 	struct blkcg_gq *blkg = pd_to_blkg(pd);
 	struct bfq_group *bfqg = blkg_to_bfqg(blkg);
-	struct bfq_data *bfqd = blkg->disk->queue->elevator->elevator_data;
+	struct bfq_data *bfqd = blkg->q->elevator->elevator_data;
 	struct bfq_entity *entity = &bfqg->entity;
 	struct bfq_group_data *d = blkcg_to_bfqgd(blkg->blkcg);
 
@@ -1199,7 +1199,7 @@ static u64 bfqg_prfill_stat_recursive(struct seq_file *sf,
 	struct cgroup_subsys_state *pos_css;
 	u64 sum = 0;
 
-	lockdep_assert_held(&blkg->disk->queue->queue_lock);
+	lockdep_assert_held(&blkg->q->queue_lock);
 
 	rcu_read_lock();
 	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
diff --git a/block/blk-cgroup-rwstat.c b/block/blk-cgroup-rwstat.c
index b8b8c82e667a3b..3304e841df7ce9 100644
--- a/block/blk-cgroup-rwstat.c
+++ b/block/blk-cgroup-rwstat.c
@@ -107,7 +107,7 @@ void blkg_rwstat_recursive_sum(struct blkcg_gq *blkg, struct blkcg_policy *pol,
 	struct cgroup_subsys_state *pos_css;
 	unsigned int i;
 
-	lockdep_assert_held(&blkg->disk->queue->queue_lock);
+	lockdep_assert_held(&blkg->q->queue_lock);
 
 	memset(sum, 0, sizeof(*sum));
 	rcu_read_lock();
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1574566321245e..981ebe003b1c63 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -118,6 +118,7 @@ static void blkg_free_workfn(struct work_struct *work)
 {
 	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
 					     free_work);
+	struct request_queue *q = blkg->q;
 	int i;
 
 	/*
@@ -127,16 +128,16 @@ static void blkg_free_workfn(struct work_struct *work)
 	 * blkcg_mutex is used to synchronize blkg_free_workfn() and
 	 * blkcg_deactivate_policy().
 	 */
-	mutex_lock(&blkg->disk->queue->blkcg_mutex);
+	mutex_lock(&q->blkcg_mutex);
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 	if (blkg->parent)
 		blkg_put(blkg->parent);
 	list_del_init(&blkg->q_node);
-	mutex_unlock(&blkg->disk->queue->blkcg_mutex);
+	mutex_unlock(&q->blkcg_mutex);
 
-	put_disk(blkg->disk);
+	blk_put_queue(q);
 	free_percpu(blkg->iostat_cpu);
 	percpu_ref_exit(&blkg->refcnt);
 	kfree(blkg);
@@ -263,12 +264,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	blkg->iostat_cpu = alloc_percpu_gfp(struct blkg_iostat_set, gfp_mask);
 	if (!blkg->iostat_cpu)
 		goto out_exit_refcnt;
-
-	if (test_bit(GD_DEAD, &disk->state))
+	if (!blk_get_queue(disk->queue))
 		goto out_free_iostat;
-	get_device(disk_to_dev(disk));
-	blkg->disk = disk;
 
+	blkg->q = disk->queue;
 	INIT_LIST_HEAD(&blkg->q_node);
 	spin_lock_init(&blkg->async_bio_lock);
 	bio_list_init(&blkg->async_bios);
@@ -304,7 +303,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	while (--i >= 0)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
-	put_disk(blkg->disk);
+	blk_put_queue(disk->queue);
 out_free_iostat:
 	free_percpu(blkg->iostat_cpu);
 out_exit_refcnt:
@@ -476,7 +475,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	struct blkcg *blkcg = blkg->blkcg;
 	int i;
 
-	lockdep_assert_held(&blkg->disk->queue->queue_lock);
+	lockdep_assert_held(&blkg->q->queue_lock);
 	lockdep_assert_held(&blkcg->lock);
 
 	/*
@@ -500,7 +499,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 
 	blkg->online = false;
 
-	radix_tree_delete(&blkcg->blkg_tree, blkg->disk->queue->id);
+	radix_tree_delete(&blkcg->blkg_tree, blkg->q->id);
 	hlist_del_init_rcu(&blkg->blkcg_node);
 
 	/*
@@ -587,7 +586,9 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 
 const char *blkg_dev_name(struct blkcg_gq *blkg)
 {
-	return bdi_dev_name(blkg->disk->bdi);
+	if (!blkg->q->disk)
+		return NULL;
+	return bdi_dev_name(blkg->q->disk->bdi);
 }
 
 /**
@@ -619,10 +620,10 @@ void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
-		spin_lock_irq(&blkg->disk->queue->queue_lock);
-		if (blkcg_policy_enabled(blkg->disk->queue, pol))
+		spin_lock_irq(&blkg->q->queue_lock);
+		if (blkcg_policy_enabled(blkg->q, pol))
 			total += prfill(sf, blkg->pd[pol->plid], data);
-		spin_unlock_irq(&blkg->disk->queue->queue_lock);
+		spin_unlock_irq(&blkg->q->queue_lock);
 	}
 	rcu_read_unlock();
 
@@ -1046,9 +1047,9 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
-		spin_lock_irq(&blkg->disk->queue->queue_lock);
+		spin_lock_irq(&blkg->q->queue_lock);
 		blkcg_print_one_stat(blkg, sf);
-		spin_unlock_irq(&blkg->disk->queue->queue_lock);
+		spin_unlock_irq(&blkg->q->queue_lock);
 	}
 	rcu_read_unlock();
 	return 0;
@@ -1118,7 +1119,7 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
 	while (!hlist_empty(&blkcg->blkg_list)) {
 		struct blkcg_gq *blkg = hlist_entry(blkcg->blkg_list.first,
 						struct blkcg_gq, blkcg_node);
-		struct request_queue *q = blkg->disk->queue;
+		struct request_queue *q = blkg->q;
 
 		if (need_resched() || !spin_trylock(&q->queue_lock)) {
 			/*
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 3d9e42c519db86..9c5078755e5e19 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -53,7 +53,8 @@ struct blkg_iostat_set {
 
 /* association between a blk cgroup and a request queue */
 struct blkcg_gq {
-	struct gendisk			*disk;
+	/* Pointer to the associated request_queue */
+	struct request_queue		*q;
 	struct list_head		q_node;
 	struct hlist_node		blkcg_node;
 	struct blkcg			*blkcg;
@@ -253,11 +254,11 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 		return q->root_blkg;
 
 	blkg = rcu_dereference(blkcg->blkg_hint);
-	if (blkg && blkg->disk->queue == q)
+	if (blkg && blkg->q == q)
 		return blkg;
 
 	blkg = radix_tree_lookup(&blkcg->blkg_tree, q->id);
-	if (blkg && blkg->disk->queue != q)
+	if (blkg && blkg->q != q)
 		blkg = NULL;
 	return blkg;
 }
@@ -357,7 +358,7 @@ static inline void blkg_put(struct blkcg_gq *blkg)
 #define blkg_for_each_descendant_pre(d_blkg, pos_css, p_blkg)		\
 	css_for_each_descendant_pre((pos_css), &(p_blkg)->blkcg->css)	\
 		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
-					    (p_blkg)->disk->queue)))
+					    (p_blkg)->q)))
 
 /**
  * blkg_for_each_descendant_post - post-order walk of a blkg's descendants
@@ -372,7 +373,7 @@ static inline void blkg_put(struct blkcg_gq *blkg)
 #define blkg_for_each_descendant_post(d_blkg, pos_css, p_blkg)		\
 	css_for_each_descendant_post((pos_css), &(p_blkg)->blkcg->css)	\
 		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
-					    (p_blkg)->disk->queue)))
+					    (p_blkg)->q)))
 
 bool __blkcg_punt_bio_submit(struct bio *bio);
 
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 7a2dc9dc8e3ba0..ff534e9d92dca2 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2947,7 +2947,7 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 	struct blkcg_gq *blkg = pd_to_blkg(&iocg->pd);
-	struct ioc *ioc = q_to_ioc(blkg->disk->queue);
+	struct ioc *ioc = q_to_ioc(blkg->q);
 	struct ioc_now now;
 	struct blkcg_gq *tblkg;
 	unsigned long flags;
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index bc0d217f5c1723..0dc910568b3145 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -967,12 +967,12 @@ static void iolatency_pd_init(struct blkg_policy_data *pd)
 {
 	struct iolatency_grp *iolat = pd_to_lat(pd);
 	struct blkcg_gq *blkg = lat_to_blkg(iolat);
-	struct rq_qos *rqos = blkcg_rq_qos(blkg->disk->queue);
+	struct rq_qos *rqos = blkcg_rq_qos(blkg->q);
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	if (blk_queue_nonrot(blkg->disk->queue))
+	if (blk_queue_nonrot(blkg->q))
 		iolat->ssd = true;
 	else
 		iolat->ssd = false;
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 74bb1e753ea09d..47e9d8be68f300 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -387,7 +387,7 @@ static void throtl_pd_init(struct blkg_policy_data *pd)
 {
 	struct throtl_grp *tg = pd_to_tg(pd);
 	struct blkcg_gq *blkg = tg_to_blkg(tg);
-	struct throtl_data *td = blkg->disk->queue->td;
+	struct throtl_data *td = blkg->q->td;
 	struct throtl_service_queue *sq = &tg->service_queue;
 
 	/*
@@ -1174,7 +1174,7 @@ static void throtl_pending_timer_fn(struct timer_list *t)
 
 	/* throtl_data may be gone, so figure out request queue by blkg */
 	if (tg)
-		q = tg->pd.blkg->disk->queue;
+		q = tg->pd.blkg->q;
 	else
 		q = td->queue;
 
-- 
2.39.1

