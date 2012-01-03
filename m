From: kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] memcg: mark rcu protected member as __rcu
Date: Tue,  3 Jan 2012 18:33:52 -0500
Message-ID: <1325633632-9978-2-git-send-email-kosaki.motohiro@gmail.com>
References: <1325633632-9978-1-git-send-email-kosaki.motohiro@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=9IdorHQPuJJk/oltwEc/QSTiSe8brj/l2oNYe0jr3HA=;
        b=SO1K0heLJ0ojC2M7CNvsZ3XZpfZ8wwPfODr4PrsHcp+A6r2Cfjc7GKV0jiEfrUg17P
         pCc/1lUJR9QS7HAgK7/WodxXOsu7Cf990BugHlrEzIXSnFjMiOtUbVMC6WTXoIpgF9kV
         JhCQQRUuRozp8MsXXNr1jbhXdvh5Q9zH0S+1Y=
In-Reply-To: <1325633632-9978-1-git-send-email-kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Currently "make C=2 mm/memcontrol.o" makes following warnings. fix it.

mm/memcontrol.c:4243:21: error: incompatible types in comparison expression (different address spaces)
mm/memcontrol.c:4245:21: error: incompatible types in comparison expression (different address spaces)

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6adeeec..138be2b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -195,7 +195,7 @@ struct mem_cgroup_threshold_ary {
 
 struct mem_cgroup_thresholds {
 	/* Primary thresholds array */
-	struct mem_cgroup_threshold_ary *primary;
+	struct mem_cgroup_threshold_ary __rcu *primary;
 	/*
 	 * Spare threshold array.
 	 * This is needed to make mem_cgroup_unregister_event() "never fail".
-- 
1.7.1
