From: Zheng Bin <zhengbin13@huawei.com>
Subject: [PATCH] block-throttle: set q->td to NULL if blkcg_activate_policy failed
Date: Wed, 5 Aug 2020 21:37:20 +0800
Message-ID: <20200805133720.1008782-1-zhengbin13@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org
Cc: yi.zhang@huawei.com, zhengbin13@huawei.com

Otherwise q->td will point to the released memory, although there is
no access to q->td in the following process, still recommend to do this.

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 block/blk-throttle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index fee3325edf27..05b87516eee9 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2399,6 +2399,7 @@ int blk_throtl_init(struct request_queue *q)
 		free_percpu(td->latency_buckets[READ]);
 		free_percpu(td->latency_buckets[WRITE]);
 		kfree(td);
+		q->td = NULL;
 	}
 	return ret;
 }
--
2.25.4

