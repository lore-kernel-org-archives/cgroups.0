From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH] blk-cgroup: Remove obsolete macro
Date: Thu, 28 Jan 2021 15:18:50 +0800
Message-ID: <2d053708b596fe148c1d9e63a97117c150a0004a.1611818240.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, tj@kernel.org
Cc: baolin.wang@linux.alibaba.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Remove the obsolete 'MAX_KEY_LEN' macro.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4b4fcb5..a317c03 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -32,8 +32,6 @@
 #include <linux/psi.h>
 #include "blk.h"
 
-#define MAX_KEY_LEN 100
-
 /*
  * blkcg_pol_mutex protects blkcg_policy[] and policy [de]activation.
  * blkcg_pol_register_mutex nests outside of it and synchronizes entire
-- 
1.8.3.1

