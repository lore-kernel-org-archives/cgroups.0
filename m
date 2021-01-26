From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH] blk-cgroup: Use cond_resched() when destroy blkgs
Date: Tue, 26 Jan 2021 21:33:25 +0800
Message-ID: <8f4fb91ced02e58ef425189c83214086f1154a0c.1611664710.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: axboe@kernel.dk, tj@kernel.org
Cc: joseph.qi@linux.alibaba.com, baolin.wang@linux.alibaba.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On !PREEMPT kernel, we can get below softlockup when doing stress
testing with creating and destroying block cgroup repeatly. The
reason is it may take a long time to acquire the queue's lock in
the loop of blkcg_destroy_blkgs(), thus we can use cond_resched()
instead of cpu_relax() to avoid this issue, since the
blkcg_destroy_blkgs() is not called from atomic contexts.

[ 4757.010308] watchdog: BUG: soft lockup - CPU#11 stuck for 94s!
[ 4757.010698] Call trace:
[ 4757.010700]  blkcg_destroy_blkgs+0x68/0x150
[ 4757.010701]  cgwb_release_workfn+0x104/0x158
[ 4757.010702]  process_one_work+0x1bc/0x3f0
[ 4757.010704]  worker_thread+0x164/0x468
[ 4757.010705]  kthread+0x108/0x138

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3465d6e..af7c0ce 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1028,7 +1028,7 @@ void blkcg_destroy_blkgs(struct blkcg *blkcg)
 			spin_unlock(&q->queue_lock);
 		} else {
 			spin_unlock_irq(&blkcg->lock);
-			cpu_relax();
+			cond_resched();
 			spin_lock_irq(&blkcg->lock);
 		}
 	}
-- 
1.8.3.1

