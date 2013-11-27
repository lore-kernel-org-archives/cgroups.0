From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH] memcg: make memcg_update_cache_sizes() static
Date: Wed, 27 Nov 2013 19:46:02 +0400
Message-ID: <1385567162-14973-2-git-send-email-vdavydov@parallels.com>
References: <1385567162-14973-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1385567162-14973-1-git-send-email-vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This function is not used outside of memcontrol.c so make it static.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 40efb9d..b20b915 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3084,7 +3084,7 @@ int memcg_cache_id(struct mem_cgroup *memcg)
  * But when we create a new cache, we can call this as well if its parent
  * is kmem-limited. That will have to hold set_limit_mutex as well.
  */
-int memcg_update_cache_sizes(struct mem_cgroup *memcg)
+static int memcg_update_cache_sizes(struct mem_cgroup *memcg)
 {
 	int num, ret;
 
-- 
1.7.10.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
