From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 5/8] blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()
Date: Thu, 16 Sep 2021 22:34:30 -0400
Message-ID: <20210917023437.816574-5-sashal@kernel.org>
References: <20210917023437.816574-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846085;
        bh=ShOueapY9efjuVpL9u11+txZuXerfKSAzn2XwpJAvlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfEW4P6VMe/gm6mJu1v2Qwy2sw608mD4Ak2kZZGio3LxorwdjfMqGasU4snIbBXWp
         iB/qXM59qqWJIm64ReZeRcq4VZ+U9emr13Ybhgj6fYdBaWzDw+w0HeTnrSHY+xKLUf
         8yT5WfytkrzVLA4utpiRk11MvQBwvnHOM8tYZYd7zUyS3to1UPkMgrjpXAzdwo8ZLm
         6t3K526zSfGO3JqiL9RyWPfjtzh0vN9HmNyB5CSkBz6L2OIsbThnLIGN8FzGQD+jE4
         LuMAmdOtXICwbplueE1pj1YFm6YNYkKEz8l3FF8OW1ZWyTeeRz8EBl61yZlPZAbjyy
         u/wP2oIwihkfw==
In-Reply-To: <20210917023437.816574-1-sashal@kernel.org>
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
index b771c4299982..7ada49a174bf 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2420,6 +2420,7 @@ int blk_throtl_init(struct request_queue *q)
 void blk_throtl_exit(struct request_queue *q)
 {
 	BUG_ON(!q->td);
+	del_timer_sync(&q->td->service_queue.pending_timer);
 	throtl_shutdown_wq(q);
 	blkcg_deactivate_policy(q, &blkcg_policy_throtl);
 	free_percpu(q->td->latency_buckets[READ]);
-- 
2.30.2

