From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: memcontrol: let v2 cgroups follow changes in system swappiness
Date: Fri,  8 Apr 2016 18:49:04 -0400
Message-ID: <1460155744-15942-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Cgroup2 currently doesn't have a per-cgroup swappiness setting. We
might want to add one later - that's a different discussion - but
until we do, the cgroups should always follow the system setting.
Otherwise it will be unchangeably set to whatever the ancestor
inherited from the system setting at the time of cgroup creation.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 4.5
---
 include/linux/swap.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index e58dba3..15d17c8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -534,6 +534,10 @@ static inline swp_entry_t get_swap_page(void)
 #ifdef CONFIG_MEMCG
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
+	/* Cgroup2 doesn't have per-cgroup swappiness */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return vm_swappiness;
+
 	/* root ? */
 	if (mem_cgroup_disabled() || !memcg->css.parent)
 		return vm_swappiness;
-- 
2.8.0
