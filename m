From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 1/4] blk-cgroup: Remove unnecessary blk_ioprio_exit in blkcg_init_queue
Date: Mon, 10 Oct 2022 10:38:56 +0800
Message-ID: <20221010023859.11896-2-shikemeng@huawei.com>
References: <20221010023859.11896-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221010023859.11896-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

Function blk_ioprio_init only alloc blkg_policy_data which will be freed
in blkg_destroy_all, so no blk_ioprio_exit is called when blk_throtl_init
is failed in blkcg_init_queue. Also blk_ioprio_exit is not called in
blkcg_exit_queue for the same reason. Just remove blk_ioprio_exit to
keep behavior consistent.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 869af9d72bcf..bc4dec705572 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1302,7 +1302,6 @@ int blkcg_init_queue(struct request_queue *q)
 	ret = blk_iolatency_init(q);
 	if (ret) {
 		blk_throtl_exit(q);
-		blk_ioprio_exit(q);
 		goto err_destroy_all;
 	}
 
-- 
2.30.0

