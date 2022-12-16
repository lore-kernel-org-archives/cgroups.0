From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v2 04/10] block, bfq: use helper macro RQ_BFQQ to get bfqq of request
Date: Fri, 16 Dec 2022 19:12:24 +0800
Message-ID: <20221216111230.3638832-5-shikemeng@huaweicloud.com>
References: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang@26.com, shikemeng@huaweicloud.com

Use helper macro RQ_BFQQ to get bfqq of request.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 block/bfq-iosched.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 9441fc98961a..c3c4c83ee95f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6683,14 +6683,14 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
 		return NULL;
 
 	/*
-	 * Assuming that elv.priv[1] is set only if everything is set
+	 * Assuming that RQ_BFQQ(rq) is set only if everything is set
 	 * for this rq. This holds true, because this function is
 	 * invoked only for insertion or merging, and, after such
 	 * events, a request cannot be manipulated any longer before
 	 * being removed from bfq.
 	 */
-	if (rq->elv.priv[1])
-		return rq->elv.priv[1];
+	if (RQ_BFQQ(rq))
+		return RQ_BFQQ(rq);
 
 	bic = icq_to_bic(rq->elv.icq);
 
-- 
2.30.0

