From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v3 05/14] bfq: limit the IO depth of CLASS_IDLE to 1
Date: Thu, 25 Mar 2021 14:57:49 +0800
Message-ID: <43daae87ff5fd6ed66e7859b8bc17818f309b9ff.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=OJnLYiytqXxdA84x+UwnW3WTrmnnWDql1WAM6O4M83E=;
        b=VV5eQDSz57WBHVe/d36HjTfftb+WCgACha+j2Z14/yKHkQdeMmmDgUXNvw8zKfpN8L
         rhIAuG9VmUUYszENYO3A/nB67emVOE9ZcL3fxI2Z7u6GM6F7fINCFMNxn3+KEApsP1V6
         Vm1x5Ts7BsBTyvyT4+GlOtinMu/OnwzoP0E6RiHsYF+FluUdRN7Lc8z99cbNf1rUw+aY
         hXOFNmrUFb7IlVwEN9INb4ll2P6AcPu58QVfZ1E5lzKKB75cPrl390L2j9BETANhTpBq
         KnAvQHUuKtI5v3cGH+e3Dx4+FmjUqQCTQTiGxzFs5PemHgGvP25cA7Pn0FCP2ADfWt3y
         wlXw==
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

The IO depth of queues belong to CLASS_IDLE is limited to 1,
so that it can avoid introducing a larger tail latency under
a device with a larger IO depth. Although limiting the IO
depth may reduce the performance of idle_class, it is
generally not a big problem, because idle_class usually does
not have strict performance requirements.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 block/bfq-iosched.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 5f7a0cc..8eaf0eb 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4831,6 +4831,17 @@ static struct request *__bfq_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	if (!bfqq)
 		goto exit;
 
+	/*
+	 * Here, the IO depth of queues belong to CLASS_IDLE is limited
+	 * to 1, so that it can avoid introducing a larger tail latency
+	 * under a device with a larger IO depth. Although limiting the
+	 * IO depth may reduce the performance of idle_class, it is
+	 * generally not a big problem, because idle_class usually
+	 * does not have strict performance requirements.
+	 */
+	if (bfq_class_idle(bfqq) && bfqq->dispatched)
+		goto exit;
+
 	rq = bfq_dispatch_rq_from_bfqq(bfqd, bfqq);
 
 	if (rq) {
-- 
1.8.3.1

