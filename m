From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cpuset: Fix cpuset sched_relax_domain_level
Date: Fri, 13 Feb 2015 11:58:07 +0800
Message-ID: <54DD764F.9080208@huawei.com>
References: <54DD6D55.2070603@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54DD6D55.2070603-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>

The cpuset.sched_relax_domain_level can control how far we do
immediate load balancing on a system. However, it was found on recent
kernels that echo'ing a value into cpuset.sched_relax_domain_level
did not reduce any immediate load balancing.

The reason this occurred was because the update_domain_attr_tree() traversal
did not update for the "top_cpuset". This resulted in nothing being changed
when modifying the sched_relax_domain_level parameter.

This patch is able to address that problem by having update_domain_attr_tree()
allow updates for the root in the cpuset traversal.

Fixes: fc560a26acce ("cpuset: replace cpuset->stack_list with cpuset_for_each_descendant_pre()")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+
Signed-off-by: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

This is a resend. I forgot to edit the subject when sending this patch...

---
 kernel/cpuset.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 29463c2..9e25599 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -548,9 +548,6 @@ static void update_domain_attr_tree(struct sched_domain_attr *dattr,
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, root_cs) {
-		if (cp == root_cs)
-			continue;
-
 		/* skip the whole subtree if @cp doesn't have any CPU */
 		if (cpumask_empty(cp->cpus_allowed)) {
 			pos_css = css_rightmost_descendant(pos_css);
-- 1.8.0.2
