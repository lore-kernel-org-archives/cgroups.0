From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] blkcg: pass @q and @blkcg into blkcg_pol_alloc_pd_fn()
Date: Wed, 10 Jul 2019 13:51:19 -0700
Message-ID: <20190710205128.1316483-2-tj@kernel.org>
References: <20190710205128.1316483-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1kGp2m3bMKTZuBvKVapVVACURbt75AkZ89ShYdU2gWU=;
        b=uId0l74koPJus9gxnB2KmVc9Yb7a0ZeDYWZUVR3OVuF+uBfffZW/Z0RRVa5rjGw8Yu
         Mg8Fj+rkk0m2h3LFRoNxCa4iMG1f1mqeMsGreQKz7jFr+Prqf3YaIoocMsAKRAlGtO0C
         TKXC5TKzPYljgz5bRq0mkz7bkpZ/s2mmMCyfDCkkFHsn9vFzVtAkX4OUbhHyW+xt89LD
         L8wgVOZHGzBXnhPYcUeO3kILztCTIXiWfjjyXE+x+w2oZmBz9+NIXq620imJ3m8GcvuH
         4b5ChNiKpKcjfW72nGKspgxv3Unck1XOYGa1pXDBahVhDJY2AyNHt9hVy7HqJ4S5zxNc
         mzng==
In-Reply-To: <20190710205128.1316483-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

Instead of @node, pass in @q and @blkcg so that the alloc function has
more context.  This doesn't cause any behavior change and will be used
by io.weight implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/bfq-cgroup.c         | 5 +++--
 block/blk-cgroup.c         | 6 +++---
 block/blk-iolatency.c      | 6 ++++--
 block/blk-throttle.c       | 6 ++++--
 include/linux/blk-cgroup.h | 3 ++-
 5 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 0f6cd688924f..e6fb537b4bfc 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -501,11 +501,12 @@ static void bfq_cpd_free(struct blkcg_policy_data *cpd)
 	kfree(cpd_to_bfqgd(cpd));
 }
 
-static struct blkg_policy_data *bfq_pd_alloc(gfp_t gfp, int node)
+static struct blkg_policy_data *bfq_pd_alloc(gfp_t gfp, struct request_queue *q,
+					     struct blkcg *blkcg)
 {
 	struct bfq_group *bfqg;
 
-	bfqg = kzalloc_node(sizeof(*bfqg), gfp, node);
+	bfqg = kzalloc_node(sizeof(*bfqg), gfp, q->node);
 	if (!bfqg)
 		return NULL;
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 24ed26957367..75f7f78b87b2 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -175,7 +175,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 			continue;
 
 		/* alloc per-policy data and attach it to blkg */
-		pd = pol->pd_alloc_fn(gfp_mask, q->node);
+		pd = pol->pd_alloc_fn(gfp_mask, q, blkcg);
 		if (!pd)
 			goto err_free;
 
@@ -1349,7 +1349,7 @@ int blkcg_activate_policy(struct request_queue *q,
 		blk_mq_freeze_queue(q);
 pd_prealloc:
 	if (!pd_prealloc) {
-		pd_prealloc = pol->pd_alloc_fn(GFP_KERNEL, q->node);
+		pd_prealloc = pol->pd_alloc_fn(GFP_KERNEL, q, &blkcg_root);
 		if (!pd_prealloc) {
 			ret = -ENOMEM;
 			goto out_bypass_end;
@@ -1365,7 +1365,7 @@ int blkcg_activate_policy(struct request_queue *q,
 		if (blkg->pd[pol->plid])
 			continue;
 
-		pd = pol->pd_alloc_fn(GFP_NOWAIT | __GFP_NOWARN, q->node);
+		pd = pol->pd_alloc_fn(GFP_NOWAIT | __GFP_NOWARN, q, &blkcg_root);
 		if (!pd)
 			swap(pd, pd_prealloc);
 		if (!pd) {
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index d973c38ee4fd..e613f89b37d3 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -931,11 +931,13 @@ static size_t iolatency_pd_stat(struct blkg_policy_data *pd, char *buf,
 }
 
 
-static struct blkg_policy_data *iolatency_pd_alloc(gfp_t gfp, int node)
+static struct blkg_policy_data *iolatency_pd_alloc(gfp_t gfp,
+						   struct request_queue *q,
+						   struct blkcg *blkcg)
 {
 	struct iolatency_grp *iolat;
 
-	iolat = kzalloc_node(sizeof(*iolat), gfp, node);
+	iolat = kzalloc_node(sizeof(*iolat), gfp, q->node);
 	if (!iolat)
 		return NULL;
 	iolat->stats = __alloc_percpu_gfp(sizeof(struct latency_stat),
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8ab6c8153223..0445c998c377 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -478,12 +478,14 @@ static void throtl_service_queue_init(struct throtl_service_queue *sq)
 	timer_setup(&sq->pending_timer, throtl_pending_timer_fn, 0);
 }
 
-static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
+static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp,
+						struct request_queue *q,
+						struct blkcg *blkcg)
 {
 	struct throtl_grp *tg;
 	int rw;
 
-	tg = kzalloc_node(sizeof(*tg), gfp, node);
+	tg = kzalloc_node(sizeof(*tg), gfp, q->node);
 	if (!tg)
 		return NULL;
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 689a58231288..930631cad5cf 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -149,7 +149,8 @@ typedef struct blkcg_policy_data *(blkcg_pol_alloc_cpd_fn)(gfp_t gfp);
 typedef void (blkcg_pol_init_cpd_fn)(struct blkcg_policy_data *cpd);
 typedef void (blkcg_pol_free_cpd_fn)(struct blkcg_policy_data *cpd);
 typedef void (blkcg_pol_bind_cpd_fn)(struct blkcg_policy_data *cpd);
-typedef struct blkg_policy_data *(blkcg_pol_alloc_pd_fn)(gfp_t gfp, int node);
+typedef struct blkg_policy_data *(blkcg_pol_alloc_pd_fn)(gfp_t gfp,
+				struct request_queue *q, struct blkcg *blkcg);
 typedef void (blkcg_pol_init_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_online_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_offline_pd_fn)(struct blkg_policy_data *pd);
-- 
2.17.1

