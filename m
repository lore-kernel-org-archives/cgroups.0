From: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH] mm/memcontrol: replace '== root_mem_cgroup' with
 mem_cgroup_is_root
Date: Wed, 4 Nov 2020 23:14:57 +0800
Message-ID: <20201104151457.GA108301@rlk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=VSar2
        wdEREwQtbNXW3U+mTBkXhxZPJuA5rzAVzEzkCs=; b=gYO0gQUMv+jpq36YMD8Fi
        UfjghN2SHyz1DTDEjGMQdEL1wXxcaOdGzTKDvu4Ir06UOO/JvNOY7AxzOcGx7xiP
        DYi0QxthHpC4FUhM15wKo4rdIwx3i9DsJj0U0gCi2thsbWXcSU9bok3BZ/Qqt+4N
        URBSnA7boydsgxPSTus6G4=
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sh_def-9Onoh4P/yGk@public.gmane.org

We have supplied the inline func: mem_cgroup_is_root().
So we may use mem_cgroup_is_root() instead of using
'memcg == root_mem_cgroup' or 'memcg != root_mem_cgroup'
directly, which is more readable.

Signed-off-by: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
---
 mm/memcontrol.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3dcbf24d2227..ac7af04ef88f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -868,7 +868,7 @@ void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
 	memcg = mem_cgroup_from_obj(p);
 
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg || memcg == root_mem_cgroup) {
+	if (!memcg || mem_cgroup_is_root(memcg)) {
 		__mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
@@ -1312,7 +1312,7 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 	struct mem_cgroup *iter;
 	int ret = 0;
 
-	BUG_ON(memcg == root_mem_cgroup);
+	BUG_ON(mem_cgroup_is_root(memcg));
 
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct css_task_iter it;
@@ -2069,7 +2069,7 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 	rcu_read_lock();
 
 	memcg = mem_cgroup_from_task(victim);
-	if (memcg == root_mem_cgroup)
+	if (mem_cgroup_is_root(memcg))
 		goto out;
 
 	/*
@@ -2978,7 +2978,7 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 	else
 		memcg = mem_cgroup_from_task(current);
 
-	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		objcg = rcu_dereference(memcg->objcg);
 		if (objcg && obj_cgroup_tryget(objcg))
 			break;
@@ -7027,7 +7027,7 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
-	if (memcg == root_mem_cgroup)
+	if (mem_cgroup_is_root(memcg))
 		goto out;
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
 		goto out;
@@ -7156,7 +7156,7 @@ static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
 		 */
-		if (WARN_ON_ONCE(memcg == root_mem_cgroup)) {
+		if (WARN_ON_ONCE(mem_cgroup_is_root(memcg))) {
 			VM_BUG_ON(1);
 			break;
 		}
@@ -7313,7 +7313,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 
 	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return nr_swap_pages;
-	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
 		nr_swap_pages = min_t(long, nr_swap_pages,
 				      READ_ONCE(memcg->swap.max) -
 				      page_counter_read(&memcg->swap));
@@ -7335,7 +7335,7 @@ bool mem_cgroup_swap_full(struct page *page)
 	if (!memcg)
 		return false;
 
-	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
-- 
2.29.0


