From: brookxu <brookxu.cn@gmail.com>
Subject: [RFC PATCH 4/8] bfq: expire bfqq if a higher priority class is waiting
Date: Mon,  8 Mar 2021 20:00:17 +0800
Message-ID: <055c82a8f016a0e918e69ac6700a5839a7f4bfaf.1615203034.git.brookxu@tencent.com>
References: <cover.1615203034.git.brookxu@tencent.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=0CbPEsPvCKQnAIItYoZ2d4psiwcNd/zumwFN0bHqR4g=;
        b=sz52OpNr36wC18BhGHDtq9Xp1P5E9ydmLn+BqWMHO1Qxd/NHVo3XRvVC/pE9A5qnlO
         gNCrKRmsf0fharVMtDvq8h8euj1GgCdbrgOvbURbEnkq3rTP2VkdePbGdMhXuyujXx4m
         wr5UMx+9VQ2aTvDd9ic14NIBzzouODy8z3zdYjnB4zqMK206b9UyP3vCMmkLwgRZyLR1
         BS7VsbAbgM22tSzrasJfS/8tNuirrEkmG9FfCRKsIlCv6Z+p66zVC9Col1NjW64f+Koa
         h7UkpUExfLHuAwqMXvfvgZX11AW88RdCh142kN2LEytpvFJZ3vFxRa8T99vAsNyqqtYC
         6MBg==
In-Reply-To: <cover.1615203034.git.brookxu@tencent.com>
In-Reply-To: <cover.1615203034.git.brookxu@tencent.com>
References: <cover.1615203034.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

From: Chunguang Xu <brookxu@tencent.com>

Expire bfqq If a higher priority class is waiting to be served, we
can further guarantee the delay of the higher priority class.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 block/bfq-iosched.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index b639cdbb4192..223affaa7c92 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4677,7 +4677,10 @@ static struct request *bfq_dispatch_rq_from_bfqq(struct bfq_data *bfqd,
 						 struct bfq_queue *bfqq)
 {
 	struct request *rq = bfqq->next_rq;
+	struct bfq_sched_data *sd = bfqq->entity.sched_data;
+	struct bfq_service_tree *st = sd->service_tree;
 	unsigned long service_to_charge;
+	int idx;
 
 	service_to_charge = bfq_serv_to_charge(rq, bfqq);
 
@@ -4714,6 +4717,17 @@ static struct request *bfq_dispatch_rq_from_bfqq(struct bfq_data *bfqd,
 	if (!(bfq_tot_busy_queues(bfqd) > 1 && bfq_class_idle(bfqq)))
 		goto return_rq;
 
+	/*
+	 * Expire bfqq, if other queues belong to higher priority
+	 * class are waiting for service.
+	 */
+	for (idx = bfqq->ioprio_class - 2; idx >= 0; idx--) {
+		if (!RB_EMPTY_ROOT(&(st + idx)->active))
+			break;
+	}
+	if (idx < 0)
+		goto return_rq;
+
 	bfq_bfqq_expire(bfqd, bfqq, false, BFQQE_BUDGET_EXHAUSTED);
 
 return_rq:
-- 
2.30.0

