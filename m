From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: Remove stale comments
Date: Wed, 13 May 2020 10:13:11 +0800
Message-ID: <0ce73f20-6b19-38c7-81c5-b0b71013fcb7@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

- The default root is where we can create v2 cgroups.
- The __DEVEL__sane_behavior mount option has been removed long long ago.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

found these when fixing the netprio cgroup bug.

---
 kernel/cgroup/cgroup.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 06b5ea9..7a01674 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -153,11 +153,7 @@ static struct static_key_true *cgroup_subsys_on_dfl_key[] = {
 
 static DEFINE_PER_CPU(struct cgroup_rstat_cpu, cgrp_dfl_root_rstat_cpu);
 
-/*
- * The default hierarchy, reserved for the subsystems that are otherwise
- * unattached - it never has more than a single cgroup, and all tasks are
- * part of that cgroup.
- */
+/* the default hierarchy */
 struct cgroup_root cgrp_dfl_root = { .cgrp.rstat_cpu = &cgrp_dfl_root_rstat_cpu };
 EXPORT_SYMBOL_GPL(cgrp_dfl_root);
 
@@ -251,9 +247,6 @@ bool cgroup_ssid_enabled(int ssid)
  * cases where a subsystem should behave differnetly depending on the
  * interface version.
  *
- * The set of behaviors which change on the default hierarchy are still
- * being determined and the mount option is prefixed with __DEVEL__.
- *
  * List of changed behaviors:
  *
  * - Mount options "noprefix", "xattr", "clone_children", "release_agent"
-- 
2.7.4
