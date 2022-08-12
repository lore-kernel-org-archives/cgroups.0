From: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH] cgroup: use root_mem_cgroup as css when current is not enabled
Date: Fri, 12 Aug 2022 18:09:26 +0800
Message-ID: <1660298966-11493-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

Memory charged on group B abserved on belowing v2 hierarchy where we just would
like to only have group E's memory be controlled and B's descendants compete freely
for memory. This should be the consequences of unified hierarchy. Solve this by
have the cgroup without valid memory css alloced use root_mem_cgroup instead of
its ancestor's.

 A(subtree_control = memory) - B(subtree_control = NULL) - C()
                                                         \ D()
			     - E(subtree_control = memory) - F()
							   \ G()

Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1779ccd..b29b3f6 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -533,6 +533,14 @@ static struct cgroup_subsys_state *cgroup_e_css_by_mask(struct cgroup *cgrp,
 	 * can't test the csses directly.  Test ss_mask.
 	 */
 	while (!(cgroup_ss_mask(cgrp) & (1 << ss->id))) {
+		/*
+		 * charging to the parent cgroup which hasn't distribute
+		 * memory control to its descendants doesn't make sense
+		 * especially on cgroup v2, where the parent could be configured
+		 * to use memory controller as its sibling want to use it
+		 */
+		if (memory_cgrp_id == ss->id)
+			return &root_mem_cgroup->css;
 		cgrp = cgroup_parent(cgrp);
 		if (!cgrp)
 			return NULL;
-- 
1.9.1

