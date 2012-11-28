From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/13] cpuset: remove unused cpuset_unlock()
Date: Wed, 28 Nov 2012 13:34:08 -0800
Message-ID: <1354138460-19286-2-git-send-email-tj@kernel.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=JfEx701fgOfdL0t/sU1gdBX1SH0yrxAOVL8s0CyiOe8=;
        b=rFnrAUfTVQM1/ZcXXTJ3t0x4zNogAumBhNnYaz3kti61mIkDUzE0EnrfmGPAglZ0I6
         TzdkPWhhga8REShiUz/xDVMbCoM83JYhiLP1vvbI4Fy3XeFtGviBSo/4xjNVSU3+Epox
         CgHbx7kQe4h2c4+5DRg/tqQ7b2N8izGHlV2zJe1xjlrH/O8lgI4zipxrg2gh0OlNaVXa
         P7ed1A5QihEfJeiz54RLDiV7xXt1DT4Xxedm0htTeg6OiLOb4ZOLBnQ10ChIIfQnrawk
         Ub0G/agCGGsGnp14iAbbMjm/kWyFa09U0Lbd+NuPWaQa1tQ8UfrqjrzhNBuZxkk6fnlu
         DEPQ==
In-Reply-To: <1354138460-19286-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cpuset.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b017887..a423774 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2412,17 +2412,6 @@ int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 }
 
 /**
- * cpuset_unlock - release lock on cpuset changes
- *
- * Undo the lock taken in a previous cpuset_lock() call.
- */
-
-void cpuset_unlock(void)
-{
-	mutex_unlock(&callback_mutex);
-}
-
-/**
  * cpuset_mem_spread_node() - On which node to begin search for a file page
  * cpuset_slab_spread_node() - On which node to begin search for a slab page
  *
-- 
1.7.11.7

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
