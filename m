From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 02/14] cgroup: remove pointless has tasks/children test from mem_cgroup_force_empty()
Date: Fri,  9 May 2014 17:31:19 -0400
Message-ID: <1399671091-23867-3-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xWsRHD4oOxbW2qqYvhCvLROk7qqYMFCgnBzOkkwv8fQ=;
        b=u8s5qpuOwqYrE9Bw7369YRpOhzx7omraX5G6R3K2RHryIohqFSlq4Y9w/kQS73JB/u
         JvkHfNvq0HGUyy4lf3+2SfoIqQ4BrkB1iZcIxWOrQcTqw+PjdwjMWUbb4Z/Ds9mj7VgD
         T90RXKCZ3gK3b90QsiA9fZ6QnzNlYFAJksgYaV+g8xRnrd5M3FF3yeXD4u4U35kVrDGU
         5JHzeU3SLSmkgfqlsTUI87BoemSQxzv9yB53UgM2dgOGO2dwBFlI6ZFGOSmolvyBtKeJ
         LfK/7H0aCVWPMCWlyEVxqymu7Gg4WkSXqEDCua+TQbTnfCzQup9oUKEVD6kA34pykCBw
         a3Ww==
In-Reply-To: <1399671091-23867-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

mem_cgroup_force_empty() is used only from
mem_cgroup_force_empty_write() and tests whether the target memcg has
any tasks or children without any synchronization and then returns
-EBUSY if so.

This is just weird.  The tests don't really mean anything as tasks and
children may be added after the tests and it also makes the behavior
of the knob arbitrary because there may be lingering offline and
removed children on the children list for extended period of time -
writes to the knob can return -EBUSY for reasons completely invisible
to userland.

The knob is best-effort anyway and the broken business test doesn't
affect its operation.  Remove it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a5e0417..036453a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4857,11 +4857,6 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
 static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 {
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	struct cgroup *cgrp = memcg->css.cgroup;
-
-	/* returns EBUSY if there is a task or if we come here twice. */
-	if (cgroup_has_tasks(cgrp) || !list_empty(&cgrp->children))
-		return -EBUSY;
 
 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
-- 
1.9.0
