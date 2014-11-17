From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3 cgroup/for-3.19] cgroup: add cgroup_subsys->css_released()
Date: Mon, 17 Nov 2014 15:56:52 -0500
Message-ID: <20141117205652.GA23126@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=elbFqBZ4l9iRs8W7EaikkurIQ/fDiqIsz3g+JKh8+f4=;
        b=ZiCAhzR/of9oZUe5tze0zn5TXNDCWyYUHdcMH0llxXfRthWSg2vsx91qlI92G5wAE1
         Iij2CwTgTerbzLg/fhNBe4q0CzkwI7xq6cGUVZCvlEW3+ltynmt+0qKCUCE6ZvBPePXb
         wKE3I7MTwXTVsf9ypm0buFw6tdBL5TfTiMwkdhcM1rtxiEP4zyAj3NWbhkdAntPoBt4p
         A4nPPcgpW0aeLQPI+cxc155VFdW/V4FHc5xyAhi3dmbpkMjJbu1erOdA9nL9nlBylaH8
         ZrMZmZQvd9/7fgN48ZWOhIlC7ssUhvWvtS8u7etRR4kh6pNypnYEaohl8bdiwWQlIw7U
         X1kg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Add a new cgroup subsys callback css_released().  This is called when
the reference count of the css (cgroup_subsys_state) reaches zero
before RCU scheduling free.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |    2 ++
 2 files changed, 3 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -612,6 +612,7 @@ struct cgroup_subsys {
 	struct cgroup_subsys_state *(*css_alloc)(struct cgroup_subsys_state *parent_css);
 	int (*css_online)(struct cgroup_subsys_state *css);
 	void (*css_offline)(struct cgroup_subsys_state *css);
+	void (*css_released)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
 	void (*css_reset)(struct cgroup_subsys_state *css);
 
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4380,6 +4380,8 @@ static void css_release_work_fn(struct w
 	if (ss) {
 		/* css release path */
 		cgroup_idr_remove(&ss->css_idr, css->id);
+		if (ss->css_released)
+			ss->css_released(css);
 	} else {
 		/* cgroup release path */
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
