From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: restore the call to eventfd->poll()
Date: Fri, 26 Apr 2013 10:54:52 +0800
Message-ID: <5179EC7C.5060208@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

I mistakenly removed the call to eventfd->poll() while I was actually
intending to remove the return value...

Calling evenfd->poll() will hook cgroup_event_wake() to the poll
waitqueue, which will be called to unregister eventfd when rmdir a
cgroup or close eventfd.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a45aa12..4b0f2ef 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3882,6 +3882,8 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 	if (ret)
 		goto fail;
 
+	efile->f_op->poll(efile, &event->pt);
+
 	/*
 	 * Events should be removed after rmdir of cgroup directory, but before
 	 * destroying subsystem state objects. Let's take reference to cgroup
-- 
1.8.0.2
