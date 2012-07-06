From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/memcg: swappiness should between 0 and 100
Date: Fri,  6 Jul 2012 12:51:52 +0800
Message-ID: <1341550312-6815-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=AkwTclw8GnJUtH1YeFsqPty7/21gwZoRLsvuK1dfkik=;
        b=ea0vqoUC5s5hXZKV2efj6FBDAiupRnD9rkHGIkzFkO1bOdWw8O1gXfaG8nw2PfT7FO
         89q5zOh53L8r7DIDiX7bcbKJJxla2tQ6g6X2vxPqTv0VC8LTssTkPET+D2AaW/txjpYx
         l8UtV0hBAyTXncNsRKYrXRIrOQjWhKi/AfWaISyJLlDdBHxUxSpHM7Yy+oOH99/gDJPC
         JUWRmoBdhYShV9gmOgFUP/DjGHhiUES+JcmyZeYHKvCdQqYyPNjHpLRZ7gEsFRFB7k4K
         PgAU2/8t7rG/3NOIFc/GZkjovcDf6vH9G8usfqpdn2UxW3LL6xRqhEOKoAAkvI0G9en8
         neMQ==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5e4d1ab..69a7d45 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4176,7 +4176,7 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup *parent;
 
-	if (val > 100)
+	if (val > 100 || val < 0)
 		return -EINVAL;
 
 	if (cgrp->parent == NULL)
-- 
1.7.5.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
