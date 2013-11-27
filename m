From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH] memcg: fix kmem_account_flags check in memcg_can_account_kmem()
Date: Wed, 27 Nov 2013 19:46:01 +0400
Message-ID: <1385567162-14973-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

We should start kmem accounting for a memory cgroup only after both its
kmem limit is set (KMEM_ACCOUNTED_ACTIVE) and related call sites are
patched (KMEM_ACCOUNTED_ACTIVATED). Currently memcg_can_account_kmem()
allows kmem accounting even if only one of the conditions is true.
Fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f1a0ae6..40efb9d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2956,7 +2956,8 @@ static DEFINE_MUTEX(set_limit_mutex);
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
 	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
-		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK);
+		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK) ==
+							KMEM_ACCOUNTED_MASK;
 }
 
 /*
-- 
1.7.10.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
