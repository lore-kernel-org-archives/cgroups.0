From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH v2 5/5] blk-iocost: Correct comment in blk_iocost_init
Date: Tue, 18 Oct 2022 20:19:32 +0800
Message-ID: <20221018121932.10792-6-shikemeng@huawei.com>
References: <20221018121932.10792-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221018121932.10792-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

There is no iocg_pd_init function. The pd_alloc_fn function pointer of
iocost policy is set with ioc_pd_init. Just correct it.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 761295ed9c5a..96c1571a8a1d 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2880,7 +2880,7 @@ static int blk_iocost_init(struct gendisk *disk)
 	spin_unlock_irq(&ioc->lock);
 
 	/*
-	 * rqos must be added before activation to allow iocg_pd_init() to
+	 * rqos must be added before activation to allow ioc_pd_init() to
 	 * lookup the ioc from q. This means that the rqos methods may get
 	 * called before policy activation completion, can't assume that the
 	 * target bio has an iocg associated and need to test for NULL iocg.
-- 
2.30.0

