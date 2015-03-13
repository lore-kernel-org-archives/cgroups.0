From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH -mm] memcg: zap mem_cgroup_lookup
Date: Fri, 13 Mar 2015 17:57:22 +0300
Message-ID: <1426258642-14074-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

mem_cgroup_lookup is a wrapper around mem_cgroup_from_id, which checks
that id != 0 before issuing the function call. Today, there is no point
in this additional check apart from optimization, because there is no
css with id <= 0, so that css_from_id, called by mem_cgroup_from_id,
will return NULL for any id <= 0. Since mem_cgroup_from_id is only
called from mem_cgroup_lookup, let us zap mem_cgroup_lookup,
substituting calls to it with mem_cgroup_from_id and moving the check if
id > 0 to css_from_id.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 kernel/cgroup.c |    2 +-
 mm/memcontrol.c |   24 ++++++++----------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 29a7b2cc593e..747e953ffee9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5451,7 +5451,7 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return idr_find(&ss->css_idr, id);
+	return id > 0 ? idr_find(&ss->css_idr, id) : NULL;
 }
 
 #ifdef CONFIG_CGROUP_DEBUG
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d18d3a6e7337..f9df75ef55d7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -454,6 +454,12 @@ static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 	return memcg->css.id;
 }
 
+/*
+ * A helper function to get mem_cgroup from ID. must be called under
+ * rcu_read_lock().  The caller is responsible for calling
+ * css_tryget_online() if the mem_cgroup is used for charging. (dropping
+ * refcnt from swap can be called against removed memcg.)
+ */
 static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 {
 	struct cgroup_subsys_state *css;
@@ -2341,20 +2347,6 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 }
 
 /*
- * A helper function to get mem_cgroup from ID. must be called under
- * rcu_read_lock().  The caller is responsible for calling
- * css_tryget_online() if the mem_cgroup is used for charging. (dropping
- * refcnt from swap can be called against removed memcg.)
- */
-static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
-{
-	/* ID 0 is unused ID */
-	if (!id)
-		return NULL;
-	return mem_cgroup_from_id(id);
-}
-
-/*
  * try_get_mem_cgroup_from_page - look up page's memcg association
  * @page: the page
  *
@@ -2380,7 +2372,7 @@ struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 		ent.val = page_private(page);
 		id = lookup_swap_cgroup_id(ent);
 		rcu_read_lock();
-		memcg = mem_cgroup_lookup(id);
+		memcg = mem_cgroup_from_id(id);
 		if (memcg && !css_tryget_online(&memcg->css))
 			memcg = NULL;
 		rcu_read_unlock();
@@ -5859,7 +5851,7 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry)
 
 	id = swap_cgroup_record(entry, 0);
 	rcu_read_lock();
-	memcg = mem_cgroup_lookup(id);
+	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
 		if (!mem_cgroup_is_root(memcg))
 			page_counter_uncharge(&memcg->memsw, 1);
-- 
1.7.10.4
