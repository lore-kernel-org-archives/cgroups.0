From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 03/14] memcg: update memcg_has_children() to use
 css_next_child()
Date: Tue, 13 May 2014 12:53:06 -0400
Message-ID: <20140513165306.GE1866@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NmlNfSPwt5FstJicCTvfl2bQ6ucNKImAp5uUHJBhPPM=;
        b=qK46xsbGhMQ0xzy2QbkOkX7Msn1kBN2QdLJeCLaT1NK3F8R/D2/QK7SKJ2ba0XVkL0
         jvO2/qUlkBeHIbVWNaIRtzezp8UfK6uDX3/kRguUU/WRyfkKV3tFPOIk9ag/iAbOp/a+
         YSa8znhWsBFpcPOmxy1PXzCMoP/iKYKUri8pyAUNGVLpG4eWEKSHfKaDKJgN8GhkU0cS
         UMmHX3BA7Pw5IM/o2Ol/Jl2ETRyv9YKsxLuCYMQV5mu5SfsFoKKaqZubuk6/ULH+PHlQ
         gbTk82kK0C/JTxphoWnTf3DOoat5W1lmOTbEgvBA50JQmGs15msoZ8TOKbaooQZnP3t4
         YrxA==
Content-Disposition: inline
In-Reply-To: <1399671091-23867-4-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Michal Hocko <mhocko@suse.cz>

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

v2: Added comment noting that testing use_hierarchy is the
    responsibility of the callers of memcg_has_children() as suggested
    by Michal Hocko.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4834,18 +4834,28 @@ static void mem_cgroup_reparent_charges(
 	} while (usage > 0);
 }
 
+/*
+ * Test whether @memcg has children, dead or alive.  Note that this
+ * function doesn't care whether @memcg has use_hierarchy enabled and
+ * returns %true if there are child csses according to the cgroup
+ * hierarchy.  Testing use_hierarchy is the caller's responsiblity.
+ */
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
@@ -4920,7 +4930,7 @@ static int mem_cgroup_hierarchy_write(st
 	 */
 	if ((!parent_memcg || !parent_memcg->use_hierarchy) &&
 				(val == 1 || val == 0)) {
-		if (list_empty(&memcg->css.cgroup->children))
+		if (!memcg_has_children(memcg))
 			memcg->use_hierarchy = val;
 		else
 			retval = -EBUSY;
@@ -5037,7 +5047,8 @@ static int __memcg_activate_kmem(struct
 	 * of course permitted.
 	 */
 	mutex_lock(&memcg_create_mutex);
-	if (cgroup_has_tasks(memcg->css.cgroup) || memcg_has_children(memcg))
+	if (cgroup_has_tasks(memcg->css.cgroup) ||
+	    (memcg->use_hierarchy && memcg_has_children(memcg)))
 		err = -EBUSY;
 	mutex_unlock(&memcg_create_mutex);
 	if (err)
