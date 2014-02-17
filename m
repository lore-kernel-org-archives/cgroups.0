From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: add a validation check to cgroup_add_cftyps()
Date: Mon, 17 Feb 2014 10:41:50 +0800
Message-ID: <530176EE.6030605@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Fengguang reported this bug:

BUG: unable to handle kernel NULL pointer dereference at 0000003c
IP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1
...
Call Trace:
  [<cc9d1129>] ? kmem_cache_alloc_trace+0x33f/0x3b7
  [<cc90c6fc>] cgroup_add_cftypes+0x8f/0xca
  [<cd78b646>] cgroup_init+0x6a/0x26a
  [<cd764d7d>] start_kernel+0x4d7/0x57a
  [<cd7642ef>] i386_start_kernel+0x92/0x96

This happens in a corner case. If CGROUP_SCHED=y but CFS_BANDWIDTH=n &&
FAIR_GROUP_SCHED=n && RT_GROUP_SCHED=n, we have:

cpu_files[] = {
	{ }	/* terminate */
}

When we pass cpu_files to cgroup_apply_cftypes(), as cpu_files[0].ss
is NULL, we'll access NULL pointer.

The bug was introduced by commit de00ffa56ea3132c6013fc8f07133b8a1014cf53
("cgroup: make cgroup_subsys->base_cftypes use cgroup_add_cftypes()").

Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index eaffc08..465c1d8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2356,6 +2356,9 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	int ret;
 
+	if (!cfts || cfts[0].name[0] == '\0')
+		return 0;
+
 	ret = cgroup_init_cftypes(ss, cfts);
 	if (ret)
 		return ret;
-- 
1.8.0.2
