From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH] memcg: remove KMEM_ACCOUNTED_ACTIVATED
Date: Mon, 2 Dec 2013 17:08:13 +0400
Message-ID: <1385989693-28788-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko-AlSwsSmVLrQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

The KMEM_ACCOUNTED_ACTIVATED was introduced by commit a8964b9b ("memcg:
use static branches when code not in use") in order to guarantee that
static_key_slow_inc(&memcg_kmem_enabled_key) will be called only once
for each memory cgroup when its kmem limit is set. The point is that at
that time the memcg_update_kmem_limit() function's workflow looked like
this:

	bool must_inc_static_branch = false;

	cgroup_lock();
	mutex_lock(&set_limit_mutex);
	if (!memcg->kmem_account_flags && val != RESOURCE_MAX) {
		/* The kmem limit is set for the first time */
		ret = res_counter_set_limit(&memcg->kmem, val);

		memcg_kmem_set_activated(memcg);
		must_inc_static_branch = true;
	} else
		ret = res_counter_set_limit(&memcg->kmem, val);
	mutex_unlock(&set_limit_mutex);
	cgroup_unlock();

	if (must_inc_static_branch) {
		/* We can't do this under cgroup_lock */
		static_key_slow_inc(&memcg_kmem_enabled_key);
		memcg_kmem_set_active(memcg);
	}

Today, we don't use cgroup_lock in memcg_update_kmem_limit(), and
static_key_slow_inc() is called under the set_limit_mutex, but the
leftover from the above-mentioned commit is still here. Let's remove it.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c |   26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f1a0ae6..f78661f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -344,14 +344,9 @@ static size_t memcg_size(void)
 /* internal only representation about the status of kmem accounting. */
 enum {
 	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
-	KMEM_ACCOUNTED_ACTIVATED, /* static key enabled. */
 	KMEM_ACCOUNTED_DEAD, /* dead memcg with pending kmem charges */
 };
 
-/* We account when limit is on, but only after call sites are patched */
-#define KMEM_ACCOUNTED_MASK \
-		((1 << KMEM_ACCOUNTED_ACTIVE) | (1 << KMEM_ACCOUNTED_ACTIVATED))
-
 #ifdef CONFIG_MEMCG_KMEM
 static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
 {
@@ -363,16 +358,6 @@ static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
 
-static void memcg_kmem_set_activated(struct mem_cgroup *memcg)
-{
-	set_bit(KMEM_ACCOUNTED_ACTIVATED, &memcg->kmem_account_flags);
-}
-
-static void memcg_kmem_clear_activated(struct mem_cgroup *memcg)
-{
-	clear_bit(KMEM_ACCOUNTED_ACTIVATED, &memcg->kmem_account_flags);
-}
-
 static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
 {
 	/*
@@ -2956,7 +2941,7 @@ static DEFINE_MUTEX(set_limit_mutex);
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
 	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
-		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK);
+		memcg_kmem_is_active(memcg);
 }
 
 /*
@@ -3091,19 +3076,10 @@ int memcg_update_cache_sizes(struct mem_cgroup *memcg)
 				0, MEMCG_CACHES_MAX_SIZE, GFP_KERNEL);
 	if (num < 0)
 		return num;
-	/*
-	 * After this point, kmem_accounted (that we test atomically in
-	 * the beginning of this conditional), is no longer 0. This
-	 * guarantees only one process will set the following boolean
-	 * to true. We don't need test_and_set because we're protected
-	 * by the set_limit_mutex anyway.
-	 */
-	memcg_kmem_set_activated(memcg);
 
 	ret = memcg_update_all_caches(num+1);
 	if (ret) {
 		ida_simple_remove(&kmem_limited_groups, num);
-		memcg_kmem_clear_activated(memcg);
 		return ret;
 	}
 
-- 
1.7.10.4
