From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] memcg: Fix NULL pointer deref in task_in_mem_cgroup()
Date: Fri, 24 Oct 2014 10:58:07 +0200
Message-ID: <20141024085807.GA28644@dhcp22.suse.cz>
References: <1414082865-4091-1-git-send-email-jack@suse.cz>
 <20141023181929.GB15937@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141023181929.GB15937@phnom.home.cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jan Kara <jack@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu 23-10-14 14:19:29, Johannes Weiner wrote:
> On Thu, Oct 23, 2014 at 06:47:45PM +0200, Jan Kara wrote:
> > 'curr' pointer in task_in_mem_cgroup() can be NULL when we race with
> > somebody clearing task->mm. Check for it before dereferencing the
> > pointer.
> 
> If task->mm is already NULL, we fall back to mem_cgroup_from_task(),
> which definitely returns a memcg unless you pass NULL in there.  So I
> don't see how that could happen, and the NULL checks in the fallback
> branch as well as in __mem_cgroup_same_or_subtree seem bogus to me.

It came from 3a981f482cc2 (memcg: fix use_hierarchy css_is_ancestor oops
regression). I do not see mem_cgroup_same_or_subtree called from
page_referenced path so it is probably gone.
task_in_mem_cgroup is just confused because curr can never be NULL as
the task is never NULL.
---
From e78d0ed29aa6732773109bd5ad69ac887d76bb78 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 24 Oct 2014 10:46:08 +0200
Subject: [PATCH] memcg: Do not check NULL in __mem_cgroup_same_or_subtree

3a981f482cc2 (memcg: fix use_hierarchy css_is_ancestor oops
regression) has added NULL check into __mem_cgroup_same_or_subtree to
fix an oops in the page_referenced path. This is no longer needed
because all current paths are getting non-NULL memcg.

task_in_mem_cgroup is a little bit confused and assumes that
mem_cgroup_from_task may return NULL but this can never happen as the
task is alaways non-NULL. So get rid of that check as well.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3a203c7ec6c7..62064a5b496a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1339,7 +1339,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 {
 	if (root_memcg == memcg)
 		return true;
-	if (!root_memcg->use_hierarchy || !memcg)
+	if (!root_memcg->use_hierarchy)
 		return false;
 	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
 }
@@ -1374,8 +1374,7 @@ bool task_in_mem_cgroup(struct task_struct *task,
 		 */
 		rcu_read_lock();
 		curr = mem_cgroup_from_task(task);
-		if (curr)
-			css_get(&curr->css);
+		css_get(&curr->css);
 		rcu_read_unlock();
 	}
 	/*
-- 
2.1.1


-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
