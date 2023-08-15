From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 1/4] blk-throttle: print signed value 'carryover_bytes/ios' for user
Date: Tue, 15 Aug 2023 09:41:20 +0800
Message-ID: <20230815014123.368929-2-yukuai1@huaweicloud.com>
References: <20230815014123.368929-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230815014123.368929-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, mkoutny@suse.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

'carryover_bytes/ios' can be negative, indicate that some bio is
dispatched in advance within slice while configuration is updated.
Print a huge value is not user-friendly.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 2 +-
 block/blk-throttle.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7397ff199d66..5184f17f5129 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -816,7 +816,7 @@ static void tg_update_carryover(struct throtl_grp *tg)
 		__tg_update_carryover(tg, WRITE);
 
 	/* see comments in struct throtl_grp for meaning of these fields. */
-	throtl_log(&tg->service_queue, "%s: %llu %llu %u %u\n", __func__,
+	throtl_log(&tg->service_queue, "%s: %lld %lld %d %d\n", __func__,
 		   tg->carryover_bytes[READ], tg->carryover_bytes[WRITE],
 		   tg->carryover_ios[READ], tg->carryover_ios[WRITE]);
 }
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index d1ccbfe9f797..bffbc9cfc8ab 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -127,8 +127,8 @@ struct throtl_grp {
 	 * bytes/ios are waited already in previous configuration, and they will
 	 * be used to calculate wait time under new configuration.
 	 */
-	uint64_t carryover_bytes[2];
-	unsigned int carryover_ios[2];
+	long long carryover_bytes[2];
+	int carryover_ios[2];
 
 	unsigned long last_check_time;
 
-- 
2.39.2

