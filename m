From: "Jerome Marchand" <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm: memcontrol: fix order calculation in try_charge()
Date: Tue, 15 Sep 2015 14:05:57 +0200
Message-ID: <1442318757-7141-1-git-send-email-jmarchan@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Since commit <6539cc05386> (mm: memcontrol: fold mem_cgroup_do_charge()),
the order to pass to mem_cgroup_oom() is calculated by passing the number
of pages to get_order() instead of the expected  size in bytes. AFAICT,
it only affects the value displayed in the oom warning message.
This patch fix this.

Signed-off-by: Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1742a2d..91bf094 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2032,7 +2032,8 @@ retry:
 
 	mem_cgroup_events(mem_over_limit, MEMCG_OOM, 1);
 
-	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(nr_pages));
+	mem_cgroup_oom(mem_over_limit, gfp_mask,
+		       get_order(nr_pages * PAGE_SIZE));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
 		return -ENOMEM;
-- 
1.9.3
