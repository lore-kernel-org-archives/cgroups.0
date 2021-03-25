From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 10/14] bfq: optimize IO injection under better_fairness
Date: Thu, 25 Mar 2021 14:57:54 +0800
Message-ID: <d572933d913b4c38808446abe263b24bdac38098.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=DeBrNab0KU7KzKaG5m2cKOd/Gyr3Wt1IGcfHEMz36Qo=;
        b=Gp+SaexnPkH/P50XCFy/6XBBnQQBLSdHcmjcap9YMg+BTzmyVFYSrHpOXCz5QJyXWo
         2qa2TcycVdUxzmf/yiC84yw/4NTKRbSwNmv3ef9V9Cuvv5xtlnxi4NDUdDO6pTsEVI+P
         u3f6OVZRBLLYrGQczOMyCwXQOWjurtcr12+85iVo4J3XTlfCayowMKHno4y7iY7rH1xj
         SKBxVVQ3GZ9tkGRIL3FQAJQXo0W3u42eDVZKLpHyNbnDC6lrFxN/JXeuSjPthkJlK+Bo
         UHjgHAodVbbY7BEGztcTi5CYemjF1q+6uURfEFfgkvImU7Sb3m+lPNxq+ZxZKKa0q/S0
         0A9g==
In-Reply-To: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

In order to ensure better Qos of tasks of different groups
and different classes under better_fairness, we only allow
the queues of the same class in the same group can be
injected.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/bfq-iosched.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 51192bd..be5b1e3 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -1900,6 +1900,27 @@ static void bfq_reset_inject_limit(struct bfq_data *bfqd,
 	bfqq->decrease_time_jif = jiffies;
 }
 
+static bool bfq_bfqq_may_inject(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
+{
+	struct bfq_data *bfqd = bfqq->bfqd;
+	bool ret = true;
+
+	if (unlikely(bfqd->better_fairness)) {
+		/*
+		 * In addition to throughput, better_fairness also pays
+		 * attention to Qos. In the container scenario, in order
+		 * to ensure the Qos of each group we only allow tasks
+		 * of the same class in the same group to be injected.
+		 */
+		if (bfq_class(bfqq) != bfq_class(new_bfqq))
+			ret = false;
+
+		if (bfqq_group(bfqq) != bfqq_group(new_bfqq))
+			ret = false;
+	}
+	return ret;
+}
+
 static void bfq_update_io_intensity(struct bfq_queue *bfqq, u64 now_ns)
 {
 	u64 tot_io_time = now_ns - bfqq->io_start_time;
@@ -1985,7 +2006,8 @@ static void bfq_check_waker(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	    bfqd->last_completed_rq_bfqq == bfqq ||
 	    bfq_bfqq_has_short_ttime(bfqq) ||
 	    now_ns - bfqd->last_completion >= 4 * NSEC_PER_MSEC ||
-	    bfqd->last_completed_rq_bfqq == bfqq->waker_bfqq)
+	    bfqd->last_completed_rq_bfqq == bfqq->waker_bfqq ||
+	    !bfq_bfqq_may_inject(bfqq, bfqd->last_completed_rq_bfqq))
 		return;
 
 	if (bfqd->last_completed_rq_bfqq !=
@@ -4415,6 +4437,9 @@ static bool bfq_bfqq_must_idle(struct bfq_queue *bfqq)
 			else
 				limit = in_serv_bfqq->inject_limit;
 
+			if (!bfq_bfqq_may_inject(in_serv_bfqq, bfqq))
+				continue;
+
 			if (bfqd->rq_in_driver < limit) {
 				bfqd->rqs_injected = true;
 				return bfqq;
@@ -4590,6 +4615,7 @@ static struct bfq_queue *bfq_select_queue(struct bfq_data *bfqd)
 		 * happen to be served only after other queues.
 		 */
 		if (async_bfqq &&
+		    !(bfqd->better_fairness && !bfq_class_idx(&bfqq->entity)) &&
 		    icq_to_bic(async_bfqq->next_rq->elv.icq) == bfqq->bic &&
 		    bfq_serv_to_charge(async_bfqq->next_rq, async_bfqq) <=
 		    bfq_bfqq_budget_left(async_bfqq))
-- 
1.8.3.1

