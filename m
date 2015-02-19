From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH 2/2] memcg: disable hierarchy support if bound to the legacy cgroup hierarchy
Date: Thu, 19 Feb 2015 17:34:47 +0300
Message-ID: <421fb6bbff04eb70b8ad82b51efd373f0b4d170f.1424356325.git.vdavydov@parallels.com>
References: <131af5f5ee0eec55d0f94a785db4be04baf01f51.1424356325.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <131af5f5ee0eec55d0f94a785db4be04baf01f51.1424356325.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

If the memory cgroup controller is initially mounted in the scope of the
default cgroup hierarchy and then remounted to a legacy hierarchy, it
will still have hierarchy support enabled, which is incorrect. We should
disable hierarchy support if bound to the legacy cgroup hierarchy.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d18d3a6e7337..40889117c1f7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5232,7 +5232,9 @@ static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
 	 * on for the root memcg is enough.
 	 */
 	if (cgroup_on_dfl(root_css->cgroup))
-		mem_cgroup_from_css(root_css)->use_hierarchy = true;
+		root_mem_cgroup->use_hierarchy = true;
+	else
+		root_mem_cgroup->use_hierarchy = false;
 }
 
 static u64 memory_current_read(struct cgroup_subsys_state *css,
-- 
1.7.10.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
