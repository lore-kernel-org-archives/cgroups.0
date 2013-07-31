From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3/7] cgroup: restructure the failure path in cgroup_write_event_control()
Date: Wed, 31 Jul 2013 16:17:06 +0800
Message-ID: <51F8C802.7070404@huawei.com>
References: <51F8C7C5.9040608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51F8C7C5.9040608@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

It uses a single label and checks the validity of each pointer. This
is err-prone, and actually we once had a bug because one of the check
was insufficient.

Use multi lables as we do in other places.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 916a699..f0d7f5d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3945,31 +3945,31 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
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
@@ -3979,18 +3979,18 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
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
 
@@ -4010,16 +4010,13 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 
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
