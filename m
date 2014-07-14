From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/6] cgroup: rename cgroup_subsys->base_cftypes to ->legacy_cftypes
Date: Mon, 14 Jul 2014 11:44:04 -0400
Message-ID: <1405352648-4279-3-git-send-email-tj@kernel.org>
References: <1405352648-4279-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=scxQRkR3aTeKfhIvt6OlOwqnpw/TzVmwusDxAK8iqj4=;
        b=p41oWLXagNVxYW5vzIgj1yhFbKWyI+cvL0gMMlUnXSddB+R8LtFWtQG6gyMG1EXVGu
         UyZn/k/U1vqDBZ2SypHgpsPvRkt14sBmuwab820cdJnDQNLdYH9TyqWUN6DDGMdOb2S4
         3/9hYTvimCelMPo+um7d8FXXutexDCoGmcGwX6a0stJA4NhdR4ISmx517VNoBDYGE51n
         i8S2YdgPpMhZvPVhP6XLZUqbOZ+Uulj19ezs2UhMv840KtBHl7Z63vOxb5hp7CUto2mn
         jx5AhNMfN4YAZqzNovPO5q4f81w8JFavPFVKmeMoCwhTuHdPsN8ZWa6s5w/QAm5XyPes
         84GA==
In-Reply-To: <1405352648-4279-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Currently, cgroup_subsys->base_cftypes is used for both the unified
default hierarchy and legacy ones and subsystems can mark each file
with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE if it has to appear
only on one of them.  This is quite hairy and error-prone.  Also, we
may end up exposing interface files to the default hierarchy without
thinking it through.

cgroup_subsys will grow two separate cftype arrays and apply each only
on the hierarchies of the matching type.  This will allow organizing
cftypes in a lot clearer way and encourage subsystems to scrutinize
the interface which is being exposed in the new default hierarchy.

In preparation, this patch renames cgroup_subsys->base_cftypes to
cgroup_subsys->legacy_cftypes.  This patch is pure rename.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 block/blk-cgroup.c           | 2 +-
 include/linux/cgroup.h       | 2 +-
 kernel/cgroup.c              | 4 ++--
 kernel/cgroup_freezer.c      | 2 +-
 kernel/cpuset.c              | 2 +-
 kernel/sched/core.c          | 2 +-
 kernel/sched/cpuacct.c       | 2 +-
 mm/memcontrol.c              | 2 +-
 net/core/netclassid_cgroup.c | 2 +-
 net/core/netprio_cgroup.c    | 2 +-
 security/device_cgroup.c     | 2 +-
 11 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 63c3cd4..5cfbc72 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -924,7 +924,7 @@ struct cgroup_subsys blkio_cgrp_subsys = {
 	.css_offline = blkcg_css_offline,
 	.css_free = blkcg_css_free,
 	.can_attach = blkcg_can_attach,
-	.base_cftypes = blkcg_files,
+	.legacy_cftypes = blkcg_files,
 #ifdef CONFIG_MEMCG
 	/*
 	 * This ensures that, if available, memcg is automatically enabled
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7bb2744..a6e9c2e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -672,7 +672,7 @@ struct cgroup_subsys {
 	struct list_head cfts;
 
 	/* base cftypes, automatically registered with subsys itself */
-	struct cftype *base_cftypes;
+	struct cftype *legacy_cftypes;	/* used on the legacy hierarchies */
 
 	/*
 	 * A subsystem may depend on other subsystems.  When such subsystem
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7e5fee5..6496a83 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4890,7 +4890,7 @@ int __init cgroup_init(void)
 		 */
 		if (!ss->disabled) {
 			cgrp_dfl_root.subsys_mask |= 1 << ss->id;
-			WARN_ON(cgroup_add_cftypes(ss, ss->base_cftypes));
+			WARN_ON(cgroup_add_cftypes(ss, ss->legacy_cftypes));
 		}
 	}
 
@@ -5480,6 +5480,6 @@ static struct cftype debug_files[] =  {
 struct cgroup_subsys debug_cgrp_subsys = {
 	.css_alloc = debug_css_alloc,
 	.css_free = debug_css_free,
-	.base_cftypes = debug_files,
+	.legacy_cftypes = debug_files,
 };
 #endif /* CONFIG_CGROUP_DEBUG */
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index a79e40f..92b98cc 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -480,5 +480,5 @@ struct cgroup_subsys freezer_cgrp_subsys = {
 	.css_free	= freezer_css_free,
 	.attach		= freezer_attach,
 	.fork		= freezer_fork,
-	.base_cftypes	= files,
+	.legacy_cftypes	= files,
 };
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 53a9bbf..f337f42 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2036,7 +2036,7 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.cancel_attach	= cpuset_cancel_attach,
 	.attach		= cpuset_attach,
 	.bind		= cpuset_bind,
-	.base_cftypes	= files,
+	.legacy_cftypes	= files,
 	.early_init	= 1,
 };
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3bdf01b..6628e80 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8088,7 +8088,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
 	.exit		= cpu_cgroup_exit,
-	.base_cftypes	= cpu_files,
+	.legacy_cftypes	= cpu_files,
 	.early_init	= 1,
 };
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 9cf350c..dd7cbb5 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -278,6 +278,6 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 struct cgroup_subsys cpuacct_cgrp_subsys = {
 	.css_alloc	= cpuacct_css_alloc,
 	.css_free	= cpuacct_css_free,
-	.base_cftypes	= files,
+	.legacy_cftypes	= files,
 	.early_init	= 1,
 };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2a4bd6..8331f27 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7048,7 +7048,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.attach = mem_cgroup_move_task,
 	.bind = mem_cgroup_bind,
-	.base_cftypes = mem_cgroup_files,
+	.legacy_cftypes = mem_cgroup_files,
 	.early_init = 0,
 };
 
diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
index 30d903b..1f2a126 100644
--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -107,5 +107,5 @@ struct cgroup_subsys net_cls_cgrp_subsys = {
 	.css_online		= cgrp_css_online,
 	.css_free		= cgrp_css_free,
 	.attach			= cgrp_attach,
-	.base_cftypes		= ss_files,
+	.legacy_cftypes		= ss_files,
 };
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 2f385b9..cbd0a19 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -249,7 +249,7 @@ struct cgroup_subsys net_prio_cgrp_subsys = {
 	.css_online	= cgrp_css_online,
 	.css_free	= cgrp_css_free,
 	.attach		= net_prio_attach,
-	.base_cftypes	= ss_files,
+	.legacy_cftypes	= ss_files,
 };
 
 static int netprio_device_event(struct notifier_block *unused,
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index d9d69e6..188c1d2 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -796,7 +796,7 @@ struct cgroup_subsys devices_cgrp_subsys = {
 	.css_free = devcgroup_css_free,
 	.css_online = devcgroup_online,
 	.css_offline = devcgroup_offline,
-	.base_cftypes = dev_cgroup_files,
+	.legacy_cftypes = dev_cgroup_files,
 };
 
 /**
-- 
1.9.3
