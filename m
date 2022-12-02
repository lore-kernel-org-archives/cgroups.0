From: Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] blk-cgroup: Fix some kernel-doc comments
Date: Fri,  2 Dec 2022 09:17:13 +0800
Message-ID: <20221202011713.14834-1-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>, Abaci Robot <abaci@linux.alibaba.com>

Make the description of @gendisk to @disk in blkcg_schedule_throttle()
to clear the below warnings:

block/blk-cgroup.c:1850: warning: Function parameter or member 'disk' not described in 'blkcg_schedule_throttle'
block/blk-cgroup.c:1850: warning: Excess function parameter 'gendisk' description in 'blkcg_schedule_throttle'

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3338
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1bb939d3b793..77f44472b41e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1831,7 +1831,7 @@ void blkcg_maybe_throttle_current(void)
 
 /**
  * blkcg_schedule_throttle - this task needs to check for throttling
- * @gendisk: disk to throttle
+ * @disk: disk to throttle
  * @use_memdelay: do we charge this to memory delay for PSI
  *
  * This is called by the IO controller when we know there's delay accumulated
-- 
2.20.1.7.g153144c

