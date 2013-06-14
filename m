From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v4 2/9] memcg, kmem: fix reference count handling on the error
 path
Date: Fri, 14 Jun 2013 09:53:59 +0800
Message-ID: <51BA77B7.5030405@huawei.com>
References: <51BA7794.2000305@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <51BA7794.2000305@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@openvz.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>

From: Michal Hocko <mhocko@suse.cz>

mem_cgroup_css_online calls mem_cgroup_put if memcg_init_kmem
fails. This is not correct because only memcg_propagate_kmem takes an
additional reference while mem_cgroup_sockets_init is allowed to fail as
well (although no current implementation fails) but it doesn't take any
reference. This all suggests that it should be memcg_propagate_kmem that
should clean up after itself so this patch moves mem_cgroup_put over
there.

Unfortunately this is not that easy (as pointed out by Li Zefan) because
memcg_kmem_mark_dead marks the group dead (KMEM_ACCOUNTED_DEAD) if it
is marked active (KMEM_ACCOUNTED_ACTIVE) which is the case even if
memcg_propagate_kmem fails so the additional reference is dropped in
that case in kmem_cgroup_destroy which means that the reference would be
dropped two times.

The easiest way then would be to simply remove mem_cgrroup_put from
mem_cgroup_css_online and rely on kmem_cgroup_destroy doing the right
thing.

Cc: <stable@vger.kernel.org> # 3.8+
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0bacc0d..b5ec4da 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6325,14 +6325,6 @@ mem_cgroup_css_online(struct cgroup *cont)
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
 	mutex_unlock(&memcg_create_mutex);
-	if (error) {
-		/*
-		 * We call put now because our (and parent's) refcnts
-		 * are already in place. mem_cgroup_put() will internally
-		 * call __mem_cgroup_free, so return directly
-		 */
-		mem_cgroup_put(memcg);
-	}
 	return error;
 }
 
-- 
1.8.0.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
