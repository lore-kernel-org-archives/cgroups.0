From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 2/2] blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()
Date: Thu, 16 Sep 2021 22:35:04 -0400
Message-ID: <20210917023504.816909-2-sashal@kernel.org>
References: <20210917023504.816909-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846107;
        bh=3FZ4OhyV04fwq5QQvsGXb9bwYzoXuVANBmyw28fIJXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxjsRBgbeiuHnZF8/b4VZGQKe1niDffgSMryKcWhc9a9vBe7CPfvI0gtjNLDIEiTj
         avEjZWli95XnRPNt91usxYXAglQxCl7w51agPdxDCTUnuwhAkN92J2dnIMh9wiOUx9
         KYSfddT4b4WcUvL0/tcpSalwAyvSiZcPQi+dIyBoHoGKxOfPmTxWNZE8T3ZLWmmlmC
         X0NzrWGpC5mMS1IZcr8mcv08P6+sV9s0HVz+Imph2N9BMrcGJz1wAcv5XNzijzWUcU
         IKx1BkEDg6IAEdntDdvChCfEq/0J/UvmGbh0vsLpK43pXK67jwqJDgGJK/vV4/icUG
         dlSZEPPgc0Rcw==
In-Reply-To: <20210917023504.816909-1-sashal@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Jinlin <lijinlin3@huawei.com>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, tj@kernel.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org

From: Li Jinlin <lijinlin3@huawei.com>

[ Upstream commit 884f0e84f1e3195b801319c8ec3d5774e9bf2710 ]

The pending timer has been set up in blk_throtl_init(). However, the
timer is not deleted in blk_throtl_exit(). This means that the timer
handler may still be running after freeing the timer, which would
result in a use-after-free.

Fix by calling del_timer_sync() to delete the timer in blk_throtl_exit().

Signed-off-by: Li Jinlin <lijinlin3@huawei.com>
Link: https://lore.kernel.org/r/20210907121242.2885564-1-lijinlin3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a8cd7b3d9647..fcbbe2e45a2b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2414,6 +2414,7 @@ int blk_throtl_init(struct request_queue *q)
 void blk_throtl_exit(struct request_queue *q)
 {
 	BUG_ON(!q->td);
+	del_timer_sync(&q->td->service_queue.pending_timer);
 	throtl_shutdown_wq(q);
 	blkcg_deactivate_policy(q, &blkcg_policy_throtl);
 	free_percpu(q->td->latency_buckets);
-- 
2.30.2

