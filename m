From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH v11 01/15] memcg: make cache index determination more robust
Date: Mon, 25 Nov 2013 16:07:34 +0400
Message-ID: <0ccced80c1270d6cb502cd03aac26bda9d2e0a6f.1385377616.git.vdavydov@parallels.com>
References: <cover.1385377616.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <cover.1385377616.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mhocko@suse.cz
Cc: glommer@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org

From: Glauber Costa <glommer@openvz.org>

I caught myself doing something like the following outside memcg core:

	memcg_id = -1;
	if (memcg && memcg_kmem_is_active(memcg))
		memcg_id = memcg_cache_id(memcg);

to be able to handle all possible memcgs in a sane manner. In particular, the
root cache will have kmemcg_id = -1 (just because we don't call memcg_kmem_init
to the root cache since it is not limitable). We have always coped with that by
making sure we sanitize which cache is passed to memcg_cache_id. Although this
example is given for root, what we really need to know is whether or not a
cache is kmem active.

But outside the memcg core testing for root, for instance, is not trivial since
we don't export mem_cgroup_is_root. I ended up realizing that this tests really
belong inside memcg_cache_id. This patch moves a similar but stronger test
inside memcg_cache_id and make sure it always return a meaningful value.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f1a0ae6..02b5176 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3073,7 +3073,9 @@ void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep)
  */
 int memcg_cache_id(struct mem_cgroup *memcg)
 {
-	return memcg ? memcg->kmemcg_id : -1;
+	if (!memcg || !memcg_can_account_kmem(memcg))
+		return -1;
+	return memcg->kmemcg_id;
 }
 
 /*
-- 
1.7.10.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
