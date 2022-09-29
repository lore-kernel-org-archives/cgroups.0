From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 1/3] block: Remove redundant parent blkcg_gp check in check_scale_change
Date: Thu, 29 Sep 2022 15:40:53 +0800
Message-ID: <20220929074055.30080-2-shikemeng@huawei.com>
References: <20220929074055.30080-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220929074055.30080-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

Function blkcg_iolatency_throttle will make sure blkg->parent is not
NULL before calls check_scale_change. And function check_scale_change
is only called in blkcg_iolatency_throttle.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-iolatency.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index e285152345a2..a8cc5abe91e5 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -403,9 +403,6 @@ static void check_scale_change(struct iolatency_grp *iolat)
 	u64 scale_lat;
 	int direction = 0;
 
-	if (lat_to_blkg(iolat)->parent == NULL)
-		return;
-
 	parent = blkg_to_lat(lat_to_blkg(iolat)->parent);
 	if (!parent)
 		return;
-- 
2.30.0

