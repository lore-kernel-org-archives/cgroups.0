From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fail if monitored file and event_control are in different
 cgroup
Date: Mon, 18 Feb 2013 14:13:35 +0800
Message-ID: <5121C68F.1000309@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If we pass fd of memory.usage_in_bytes of cgroup A to cgroup.event_control
of cgroup B, then we won't get memory usage notification from A but B!

What's worse, if A and B are in different mount hierarchy, we'll end up
accessing NULL pointer!

Disallow this kind of invalid usage.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 65c8101..a41673c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3911,6 +3911,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 				      const char *buffer)
 {
 	struct cgroup_event *event = NULL;
+	struct cgroup *cgrp_cfile;
 	unsigned int efd, cfd;
 	struct file *efile = NULL;
 	struct file *cfile = NULL;
@@ -3966,6 +3967,16 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 		goto fail;
 	}
 
+	/*
+	 * The file to be monitored must be in the same cgroup as
+	 * cgroup.event_control is.
+	 */
+	cgrp_cfile = __d_cgrp(cfile->f_dentry->d_parent);
+	if (cgrp_cfile != cgrp) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	if (!event->cft->register_event || !event->cft->unregister_event) {
 		ret = -EINVAL;
 		goto fail;
-- 
1.8.0.2
