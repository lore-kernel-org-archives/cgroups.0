From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/8] memcg: convert to use cgroup->id
Date: Mon, 8 Apr 2013 16:22:11 +0800
Message-ID: <51627E33.4090107@huawei.com>
References: <51627DA9.7020507@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51627DA9.7020507-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

This is a preparation to kill css_id.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3561d0b..c4e0173 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -492,6 +492,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 	return (memcg == root_mem_cgroup);
 }
 
+static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
+{
+	return memcg->css.cgroup->id;
+}
+
 /* Writing them here to avoid exposing memcg's inner layout */
 #if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
 
@@ -4234,7 +4239,7 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 	 * css_get() was called in uncharge().
 	 */
 	if (do_swap_account && swapout && memcg)
-		swap_cgroup_record(ent, css_id(&memcg->css));
+		swap_cgroup_record(ent, mem_cgroup_id(memcg));
 }
 #endif
 
@@ -4286,8 +4291,8 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
 {
 	unsigned short old_id, new_id;
 
-	old_id = css_id(&from->css);
-	new_id = css_id(&to->css);
+	old_id = mem_cgroup_id(from);
+	new_id = mem_cgroup_id(to);
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
@@ -6428,7 +6433,7 @@ static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 	}
 	/* There is a swap entry and a page doesn't exist or isn't charged */
 	if (ent.val && !ret &&
-			css_id(&mc.from->css) == lookup_swap_cgroup_id(ent)) {
+	    mem_cgroup_id(mc.from) == lookup_swap_cgroup_id(ent)) {
 		ret = MC_TARGET_SWAP;
 		if (target)
 			target->ent = ent;
-- 
1.8.0.2
