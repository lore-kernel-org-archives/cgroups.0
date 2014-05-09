From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 03/14] memcg: update memcg_has_children() to use css_next_child()
Date: Fri,  9 May 2014 17:31:20 -0400
Message-ID: <1399671091-23867-4-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YUm/IJkAn53tYmxPIR8wTPI69ZmDwbzmUKP8aH0iNbk=;
        b=Zcph/GtmLsnGzGUy7KEBTTcWXR7vE7yUHVEX/iaH2AluHJYjCBbOSd96+qvMnqHfq6
         YixvzheNe0g1p04nRw2Db9SwzIQWUuNhELhMgLFF9rw8C9dbp7+1PvJdRd/BGAKhWHZZ
         NCQ7HLPSHlOwnUBaFn5APf2eqtkz1DXk/T+/av5ckE6VyFHtqfzmWa84bY4872TSICqd
         Qj8zokWWwxQanZDbXkdFAHYW21GFv+s2PxIcBYTCQSY1wjwphOPduxf8P2hMBQeZkGxB
         mxxIRU4dCll+el81K9lRl2i+YGi2juR5v9pvgKd4vQ+aoU7UWNNMgCKRyU267q9//ghg
         clfg==
In-Reply-To: <1399671091-23867-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Currently, memcg_has_children() and mem_cgroup_hierarchy_write()
directly test cgroup->children for list emptiness.  It's semantically
correct in traditional hierarchies as it actually wants to test for
any children dead or alive; however, cgroup->children is not a
published field and scheduled to go away.

This patch moves out .use_hierarchy test out of memcg_has_children()
and updates it to use css_next_child() to test whether there exists
any children.  With .use_hierarchy test moved out, it can also be used
by mem_cgroup_hierarchy_write().

A side note: As .use_hierarchy is going away, it doesn't really matter
but I'm not sure about how it's used in __memcg_activate_kmem().  The
condition tested by memcg_has_children() is mushy when seen from
userland as its result is affected by dead csses which aren't visible
from userland.  I think the rule would be a lot clearer if we have a
dedicated "freshly minted" flag which gets cleared when the first task
is migrated into it or the first child is created and then gate
activation with that.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 036453a..eb6e1b5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4834,18 +4834,23 @@ static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 	} while (usage > 0);
 }
 
+/* test whether @memcg has children, dead or alive */
 static inline bool memcg_has_children(struct mem_cgroup *memcg)
 {
-	lockdep_assert_held(&memcg_create_mutex);
+	bool ret;
+
 	/*
-	 * The lock does not prevent addition or deletion to the list
-	 * of children, but it prevents a new child from being
-	 * initialized based on this parent in css_online(), so it's
-	 * enough to decide whether hierarchically inherited
-	 * attributes can still be changed or not.
+	 * The lock does not prevent addition or deletion of children, but
+	 * it prevents a new child from being initialized based on this
+	 * parent in css_online(), so it's enough to decide whether
+	 * hierarchically inherited attributes can still be changed or not.
 	 */
-	return memcg->use_hierarchy &&
-		!list_empty(&memcg->css.cgroup->children);
+	lockdep_assert_held(&memcg_create_mutex);
+
+	rcu_read_lock();
+	ret = css_next_child(NULL, &memcg->css);
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
@@ -4921,7 +4926,7 @@ static int mem_cgroup_hierarchy_write(struct cgroup_subsys_state *css,
 	 */
 	if ((!parent_memcg || !parent_memcg->use_hierarchy) &&
 				(val == 1 || val == 0)) {
-		if (list_empty(&memcg->css.cgroup->children))
+		if (!memcg_has_children(memcg))
 			memcg->use_hierarchy = val;
 		else
 			retval = -EBUSY;
@@ -5038,7 +5043,8 @@ static int __memcg_activate_kmem(struct mem_cgroup *memcg,
 	 * of course permitted.
 	 */
 	mutex_lock(&memcg_create_mutex);
-	if (cgroup_has_tasks(memcg->css.cgroup) || memcg_has_children(memcg))
+	if (cgroup_has_tasks(memcg->css.cgroup) ||
+	    (memcg->use_hierarchy && memcg_has_children(memcg)))
 		err = -EBUSY;
 	mutex_unlock(&memcg_create_mutex);
 	if (err)
-- 
1.9.0
