From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: disallow disabled controllers on the default hierarchy
Date: Thu, 5 Jun 2014 17:16:30 +0800
Message-ID: <5390356E.70305@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

After booting with cgroup_disable=memory, I still saw memcg files
in the default hierarchy, and I can write to them, though it won't
take effect.

  # dmesg
  ...
  Disabling memory control group subsystem
  ...
  # mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup
  # ls /cgroup
  ...
  memory.failcnt                   memory.move_charge_at_immigrate
  memory.force_empty               memory.numa_stat
  memory.limit_in_bytes            memory.oom_control
  ...
  # cat /cgroup/memory.usage_in_bytes
  0

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d5032d2..57b647a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3070,6 +3070,9 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	int ret;
 
+	if (ss->disabled)
+		return 0;
+
 	if (!cfts || cfts[0].name[0] == '\0')
 		return 0;
 
@@ -4679,8 +4682,6 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 
 	BUG_ON(online_css(css));
 
-	cgrp_dfl_root.subsys_mask |= 1 << ss->id;
-
 	mutex_unlock(&cgroup_mutex);
 }
 
@@ -4760,10 +4761,13 @@ int __init cgroup_init(void)
 
 		/*
 		 * cftype registration needs kmalloc and can't be done
-		 * during early_init.  Register base cftypes separately.
+		 * during early_init, and the disable flag is set after
+		 * early_init.  Register base cftypes separately.
 		 */
-		if (ss->base_cftypes)
+		if (!ss->disabled) {
+			cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 			WARN_ON(cgroup_add_cftypes(ss, ss->base_cftypes));
+		}
 	}
 
 	cgroup_kobj = kobject_create_and_add("cgroup", fs_kobj);
-- 
1.8.0.2
