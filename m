From: Jan Kara <jack@suse.cz>
Subject: [PATCH] memcg: Fix NULL pointer deref in task_in_mem_cgroup()
Date: Thu, 23 Oct 2014 18:47:45 +0200
Message-ID: <1414082865-4091-1-git-send-email-jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>

'curr' pointer in task_in_mem_cgroup() can be NULL when we race with
somebody clearing task->mm. Check for it before dereferencing the
pointer.

Coverity-id: 1198369
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 23976fd885fd..18ab127a0767 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1469,7 +1469,8 @@ bool task_in_mem_cgroup(struct task_struct *task,
 	 * hierarchy(even if use_hierarchy is disabled in "memcg").
 	 */
 	ret = mem_cgroup_same_or_subtree(memcg, curr);
-	css_put(&curr->css);
+	if (curr)
+		css_put(&curr->css);
 	return ret;
 }
 
-- 
1.8.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
