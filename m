From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH] block, bfq: switch 'bfqg->ref' to use atomic refcount apis
Date: Tue,  3 Jan 2023 16:47:55 +0800
Message-ID: <20230103084755.1256479-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

The updating of 'bfqg->ref' should be protected by 'bfqd->lock', however,
during code review, we found that bfq_pd_free() update 'bfqg->ref'
without holding the lock, which is problematic:

1) bfq_pd_free() triggered by removing cgroup is called asynchronously;
2) bfqq will grab bfqg reference, and exit bfqq will drop the reference,
which can concurrent with 1).

Unfortunately, 'bfqd->lock' can't be held here because 'bfqd' might already
be freed in bfq_pd_free(). Fix the problem by using atomic refcount apis.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
Changes from RFC:
 - refcount_dec_and_test(bfqg->ref) -> refcount_dec_and_test(&bfqg->ref)

 block/bfq-cgroup.c  | 8 +++-----
 block/bfq-iosched.h | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 1b2829e99dad..7d9b15f0dbd5 100644
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
+	if (refcount_dec_and_test(&bfqg->ref))
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

