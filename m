From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 02/10] blk-throttle: Fix that bps of child could exceed bps limited in parent
Date: Tue, 29 Nov 2022 11:01:39 +0800
Message-ID: <20221129030147.27400-3-shikemeng@huawei.com>
References: <20221129030147.27400-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221129030147.27400-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Consider situation as following (on the default hierarchy):
 HDD
  |
root (bps limit: 4k)
  |
child (bps limit :8k)
  |
fio bs=8k
Rate of fio is supposed to be 4k, but result is 8k. Reason is as
following:
Size of single IO from fio is larger than bytes allowed in one
throtl_slice in child, so IOs are always queued in child group first.
When queued IOs in child are dispatched to parent group, BIO_BPS_THROTTLED
is set and these IOs will not be limited by tg_within_bps_limit anymore.
Fix this by only set BIO_BPS_THROTTLED when the bio traversed the entire
tree.

There patch has no influence on situation which is not on the default
hierarchy as each group is a single root group without parent.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 59acfac87764..d516a37e82fb 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1067,7 +1067,6 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 	sq->nr_queued[rw]--;
 
 	throtl_charge_bio(tg, bio);
-	bio_set_flag(bio, BIO_BPS_THROTTLED);
 
 	/*
 	 * If our parent is another tg, we just need to transfer @bio to
@@ -1080,6 +1079,7 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 		throtl_add_bio_tg(bio, &tg->qnode_on_parent[rw], parent_tg);
 		start_parent_slice_with_credit(tg, parent_tg, rw);
 	} else {
+		bio_set_flag(bio, BIO_BPS_THROTTLED);
 		throtl_qnode_add_bio(bio, &tg->qnode_on_parent[rw],
 				     &parent_sq->queued[rw]);
 		BUG_ON(tg->td->nr_queued[rw] <= 0);
-- 
2.30.0

