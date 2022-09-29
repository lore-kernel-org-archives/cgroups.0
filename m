From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 2/3] block: Correct comment for scale_cookie_change
Date: Thu, 29 Sep 2022 15:40:54 +0800
Message-ID: <20220929074055.30080-3-shikemeng@huawei.com>
References: <20220929074055.30080-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220929074055.30080-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

Default queue depth of iolatency_grp is unlimited, so we scale down
quickly(once by half) in scale_cookie_change. Remove the "subtract
1/16th" part which is not the truth.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-iolatency.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index a8cc5abe91e5..2666afd7abdb 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -364,7 +364,7 @@ static void scale_cookie_change(struct blk_iolatency *blkiolat,
 }
 
 /*
- * Change the queue depth of the iolatency_grp.  We add/subtract 1/16th of the
+ * Change the queue depth of the iolatency_grp.  We add 1/16th of the
  * queue depth at a time so we don't get wild swings and hopefully dial in to
  * fairer distribution of the overall queue depth.
  */
-- 
2.30.0

