From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 1/3] mm: memcontrol: remove bogus NULL check after mem_cgroup_from_task()
Date: Fri, 24 Oct 2014 09:49:47 -0400
Message-ID: <1414158589-26094-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

That function acts like a typecast - unless NULL is passed in, no NULL
can come out.  task_in_mem_cgroup() callers don't pass NULL tasks.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 23cf27cca370..bdf8520979cf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1335,7 +1335,7 @@ static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 bool task_in_mem_cgroup(struct task_struct *task,
 			const struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *curr = NULL;
+	struct mem_cgroup *curr;
 	struct task_struct *p;
 	bool ret;
 
@@ -1351,8 +1351,7 @@ bool task_in_mem_cgroup(struct task_struct *task,
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
2.1.2
