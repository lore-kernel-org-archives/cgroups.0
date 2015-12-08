From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/8] mm: memcontrol: drop unused @css argument in memcg_init_kmem
Date: Tue,  8 Dec 2015 13:34:18 -0500
Message-ID: <1449599665-18047-2-git-send-email-hannes@cmpxchg.org>
References: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/net/tcp_memcontrol.h | 3 ++-
 mm/memcontrol.c              | 6 +++---
 net/ipv4/tcp_memcontrol.c    | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/tcp_memcontrol.h b/include/net/tcp_memcontrol.h
index 3a17b16..dc2da2f 100644
--- a/include/net/tcp_memcontrol.h
+++ b/include/net/tcp_memcontrol.h
@@ -1,6 +1,7 @@
 #ifndef _TCP_MEMCG_H
 #define _TCP_MEMCG_H
 
-int tcp_init_cgroup(struct mem_cgroup *memcg, struct cgroup_subsys *ss);
+int tcp_init_cgroup(struct mem_cgroup *memcg);
 void tcp_destroy_cgroup(struct mem_cgroup *memcg);
+
 #endif /* _TCP_MEMCG_H */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5fe45d68..eda8d43 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3561,7 +3561,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
+static int memcg_init_kmem(struct mem_cgroup *memcg)
 {
 	int ret;
 
@@ -3569,7 +3569,7 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 	if (ret)
 		return ret;
 
-	return tcp_init_cgroup(memcg, ss);
+	return tcp_init_cgroup(memcg);
 }
 
 static void memcg_deactivate_kmem(struct mem_cgroup *memcg)
@@ -4252,7 +4252,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-	ret = memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	ret = memcg_init_kmem(memcg);
 	if (ret)
 		return ret;
 
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index 18bc7f7..133eb5e 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -6,7 +6,7 @@
 #include <linux/memcontrol.h>
 #include <linux/module.h>
 
-int tcp_init_cgroup(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
+int tcp_init_cgroup(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct page_counter *counter_parent = NULL;
-- 
2.6.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
