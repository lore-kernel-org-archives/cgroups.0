From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH RFC] block, bfq: switch 'bfqg->ref' to use atomic refcount apis
Date: Tue, 27 Dec 2022 11:15:41 +0800
Message-ID: <20221227031541.2595647-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

The updating of 'bfqg->ref' should be protected by 'bfqd->lock', however,
during code review, we found that bfq_pd_free() update 'bfqg->ref'
without holding the lock, which is problematic:

1) bfq_pd_free() triggered by removing cgroup is called asynchronously;
2) bfqq will grab bfqg reference, and exit bfqq will drop the reference,
which can concurrenty with 1).

Unfortunately, 'bfqd->lock' can't be held here because 'bfqd' might already
be freed in bfq_pd_free(). Fix the problem by using atomic refcount apis.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-cgroup.c  | 8 +++-----
 block/bfq-iosched.h | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 1b2829e99dad..aa9c4f02e3a3 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -316,14 +316,12 @@ struct bfq_group *bfqq_group(struct bfq_queue *bfqq)
 
 static void bfqg_get(struct bfq_group *bfqg)
 {
-	bfqg->ref++;
+	refcount_inc(&bfqg->ref);
 }
 
 static void bfqg_put(struct bfq_group *bfqg)
 {
-	bfqg->ref--;
-
-	if (bfqg->ref == 0)
+	if (refcount_dec_and_test(bfqg->ref))
 		kfree(bfqg);
 }
 
@@ -530,7 +528,7 @@ static struct blkg_policy_data *bfq_pd_alloc(gfp_t gfp, struct request_queue *q,
 	}
 
 	/* see comments in bfq_bic_update_cgroup for why refcounting */
-	bfqg_get(bfqg);
+	refcount_set(&bfqg->ref, 1);
 	return &bfqg->pd;
 }
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 41aa151ccc22..466e4865ace6 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -928,7 +928,7 @@ struct bfq_group {
 	char blkg_path[128];
 
 	/* reference counter (see comments in bfq_bic_update_cgroup) */
-	int ref;
+	refcount_t ref;
 	/* Is bfq_group still online? */
 	bool online;
 
-- 
2.31.1

