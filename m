From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH] block: Remove redundant 'return' statement
Date: Mon, 28 Sep 2020 08:42:26 +0800
Message-ID: <633f73addfc154700b2f983bee6230f82de4c984.1601253090.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Remove redundant 'return' statement for 'void' functions.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-iocost.c    | 2 +-
 block/blk-iolatency.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ef9476f..e38c406 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3343,7 +3343,7 @@ static int __init ioc_init(void)
 
 static void __exit ioc_exit(void)
 {
-	return blkcg_policy_unregister(&blkcg_policy_iocost);
+	blkcg_policy_unregister(&blkcg_policy_iocost);
 }
 
 module_init(ioc_init);
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index f90429c..81be009 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -1046,7 +1046,7 @@ static int __init iolatency_init(void)
 
 static void __exit iolatency_exit(void)
 {
-	return blkcg_policy_unregister(&blkcg_policy_iolatency);
+	blkcg_policy_unregister(&blkcg_policy_iolatency);
 }
 
 module_init(iolatency_init);
-- 
1.8.3.1

