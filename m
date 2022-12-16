From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v2 07/10] block, bfq: remove redundant check in bfq_put_cooperator
Date: Fri, 16 Dec 2022 19:12:27 +0800
Message-ID: <20221216111230.3638832-8-shikemeng@huaweicloud.com>
References: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang@26.com, shikemeng@huaweicloud.com

We have already avoided a circular list in bfq_setup_merge (see comments
in bfq_setup_merge() for details), so bfq_queue will not appear in it's
new_bfqq list. Just remove this check.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 block/bfq-iosched.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7c91d16dbf6f..89995815dbae 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5273,8 +5273,6 @@ void bfq_put_cooperator(struct bfq_queue *bfqq)
 	 */
 	__bfqq = bfqq->new_bfqq;
 	while (__bfqq) {
-		if (__bfqq == bfqq)
-			break;
 		next = __bfqq->new_bfqq;
 		bfq_put_queue(__bfqq);
 		__bfqq = next;
-- 
2.30.0

