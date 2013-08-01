From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 3/7] cgroup: restructure the failure path in cgroup_write_event_control()
Date: Thu, 1 Aug 2013 09:51:47 +0800
Message-ID: <51F9BF33.4060306@huawei.com>
References: <51F8C7C5.9040608@huawei.com> <51F8C802.7070404@huawei.com> <20130731104448.GH2810@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130731104448.GH2810-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

It uses a single label and checks the validity of each pointer. This
is err-prone, and actually we had a bug because one of the check was
insufficient.

Use multi lables as we do in other places.

v2:
- drop initializations of local variables.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index fb11569..ae905a5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3934,11 +3934,11 @@ static void cgroup_event_ptable_queue_proc(struct file *file,
 static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 				      const char *buffer)
 {
-	struct cgroup_event *event = NULL;
+	struct cgroup_event *event;
 	struct cgroup *cgrp_cfile;
 	unsigned int efd, cfd;
-	struct file *efile = NULL;
-	struct file *cfile = NULL;
+	struct file *efile;
+	struct file *cfile;
 	char *endp;
 	int ret;
 
@@ -3964,31 +3964,31 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 	efile = eventfd_fget(efd);
 	if (IS_ERR(efile)) {
 		ret = PTR_ERR(efile);
-		goto fail;
+		goto out_kfree;
 	}
 
 	event->eventfd = eventfd_ctx_fileget(efile);
 	if (IS_ERR(event->eventfd)) {
 		ret = PTR_ERR(event->eventfd);
-		goto fail;
+		goto out_put_efile;
 	}
 
 	cfile = fget(cfd);
 	if (!cfile) {
 		ret = -EBADF;
-		goto fail;
+		goto out_put_eventfd;
 	}
 
 	/* the process need read permission on control file */
 	/* AV: shouldn't we check that it's been opened for read instead? */
 	ret = inode_permission(file_inode(cfile), MAY_READ);
 	if (ret < 0)
-		goto fail;
+		goto out_put_cfile;
 
 	event->cft = __file_cft(cfile);
 	if (IS_ERR(event->cft)) {
 		ret = PTR_ERR(event->cft);
-		goto fail;
+		goto out_put_cfile;
 	}
 
 	/*
@@ -3998,18 +3998,18 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 	cgrp_cfile = __d_cgrp(cfile->f_dentry->d_parent);
 	if (cgrp_cfile != cgrp) {
 		ret = -EINVAL;
-		goto fail;
+		goto out_put_cfile;
 	}
 
 	if (!event->cft->register_event || !event->cft->unregister_event) {
 		ret = -EINVAL;
-		goto fail;
+		goto out_put_cfile;
 	}
 
 	ret = event->cft->register_event(cgrp, event->cft,
 			event->eventfd, buffer);
 	if (ret)
-		goto fail;
+		goto out_put_cfile;
 
 	efile->f_op->poll(efile, &event->pt);
 
@@ -4029,16 +4029,13 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 
 	return 0;
 
-fail:
-	if (cfile)
-		fput(cfile);
-
-	if (event && event->eventfd && !IS_ERR(event->eventfd))
-		eventfd_ctx_put(event->eventfd);
-
-	if (!IS_ERR_OR_NULL(efile))
-		fput(efile);
-
+out_put_cfile:
+	fput(cfile);
+out_put_eventfd:
+	eventfd_ctx_put(event->eventfd);
+out_put_efile:
+	fput(efile);
+out_kfree:
 	kfree(event);
 
 	return ret;
-- 
1.8.0.2
