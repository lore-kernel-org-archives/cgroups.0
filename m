From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 10/11] blk-throttle: remove unused variable td in tg_update_has_rules
Date: Wed, 23 Nov 2022 14:04:00 +0800
Message-ID: <20221123060401.20392-11-shikemeng@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221123060401.20392-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

remove unused variable td in tg_update_has_rules

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-throttle.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6f509cadd92b..82fe23e79b4b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -412,7 +412,6 @@ static void throtl_pd_init(struct blkg_policy_data *pd)
 static void tg_update_has_rules(struct throtl_grp *tg)
 {
 	struct throtl_grp *parent_tg = sq_to_tg(tg->service_queue.parent_sq);
-	struct throtl_data *td = tg->td;
 	int rw;
 
 	for (rw = READ; rw <= WRITE; rw++) {
-- 
2.30.0

