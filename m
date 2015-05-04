From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [RFC][PATCH] cgroup: disallow subtree controller enable/disable while
 there are tasks
Date: Mon, 4 May 2015 18:11:29 +0800
Message-ID: <554745D1.1000206@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

It's not safe if we enable/disable some controllers while there are
tasks in the substree, because task migration can fail.

For example rt bandwidth controller disallow having rt tasks in the
cgroup if no bandwidth has been allocated, which is the case when
a cgroup is just created.

A kernel warning is triggered immediately by doing:

  # mkdir child
  # <launch an rt task>
  # echo PID > child/cgroup.procs
  # echo '+cpu' > cgroup.subtree_control
  -bash: echo: write error: Invalid argument

------------[ cut here ]------------
WARNING: CPU: 0 PID: 4067 at kernel/cgroup.c:2677 cgroup_update_dfl_csses+0x2aa/0x3a0()
cgroup: failed to update controllers for the default hierarchy (-22), further operations may crash or hang


Disable this until we eliminate all ss->can_attach callbacks.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: f8f22e53a262 ("cgroup: implement dynamic subtree controller enable/disable on the default hierarchy")
Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 29a7b2c..fdd5393 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2840,6 +2840,20 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	}
 
 	/*
+	 * FIXME: currently we can't enable/disable controllers while
+	 * there are tasks in the subtree, because task migration
+	 * can fail.
+	 */
+	cgroup_for_each_live_child(child, cgrp) {
+		if (cgroup_has_tasks(child)) {
+			ret = -EBUSY;
+			goto err_undo_css;
+		}
+	}
+
+	/*
+	 * FIXME: this won't do anything because of the above check.
+	 *
 	 * At this point, cgroup_e_css() results reflect the new csses
 	 * making the following cgroup_update_dfl_csses() properly update
 	 * css associations of all tasks in the subtree.
-- 
1.8.0.2
