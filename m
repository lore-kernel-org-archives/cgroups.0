From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/3] cgroup: fix mount failure in a corner case
Date: Mon, 30 Jun 2014 10:18:33 -0400
Message-ID: <20140630141833.GA14807@htj.dyndns.org>
References: <53B0DE66.5080100@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=h4qgAb3TZbNV708XpfK8eoUrgC83rguaeOc8xLg8+jI=;
        b=Rs9Efw/51eIsYU5caz5MWbY4HJE4ldfmZ2MbUhMTGbxQoaqGsolOaAz1QEy2TSBMUn
         /F+0oHFxyBM/9Tp/gLR5I/H+8DdCB+Kg01hazrwjyEg32T76SKTfJY6ojLEb8HxUB4WV
         HB9VttXRmu8u8K+dGMg7d/oXkrqf7oSyRiVUCWELWIZRgbUOcoSKKhNvNoIYiRkuzRUk
         BNNmTW0zp0EYaERvzNKUOj+qu2Lbab3juX3PNFAU86yQdLFz14Kwk5j5ykd5DHFgN1uq
         XyK24aKGlID4RfXzvi3GgE30sFQpcTh5I80hnx/OQlQfQNgxmoL6Ty2ut5Tfy4GdXUGK
         LZtw==
Content-Disposition: inline
In-Reply-To: <53B0DE66.5080100-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Applied with minor updates.

Thanks.
------- 8< -------
From 970317aa48c6ef66cd023c039c2650c897bad927 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Mon, 30 Jun 2014 11:49:58 +0800
Subject: [PATCH 1/3] cgroup: fix mount failure in a corner case

  # cat test.sh
  #! /bin/bash

  mount -t cgroup -o cpu xxx /cgroup
  umount /cgroup

  mount -t cgroup -o cpu,cpuacct xxx /cgroup
  umount /cgroup
  # ./test.sh
  mount: xxx already mounted or /cgroup busy
  mount: according to mtab, xxx is already mounted on /cgroup

It's because the cgroupfs_root of the first mount was under destruction
asynchronously.

Fix this by delaying and then retrying mount for this case.

v3:
- put the refcnt immediately after getting it. (Tejun)

v2:
- use percpu_ref_tryget_live() rather that introducing
  percpu_ref_alive(). (Tejun)
- adjust comment.

tj: Updated the comment a bit.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.15
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d9a8be9..6406866 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1648,10 +1648,12 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			 int flags, const char *unused_dev_name,
 			 void *data)
 {
+	struct cgroup_subsys *ss;
 	struct cgroup_root *root;
 	struct cgroup_sb_opts opts;
 	struct dentry *dentry;
 	int ret;
+	int i;
 	bool new_sb;
 
 	/*
@@ -1677,6 +1679,27 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
+	/*
+	 * Destruction of cgroup root is asynchronous, so subsystems may
+	 * still be dying after the previous unmount.  Let's drain the
+	 * dying subsystems.  We just need to ensure that the ones
+	 * unmounted previously finish dying and don't care about new ones
+	 * starting.  Testing ref liveliness is good enough.
+	 */
+	for_each_subsys(ss, i) {
+		if (!(opts.subsys_mask & (1 << i)) ||
+		    ss->root == &cgrp_dfl_root)
+			continue;
+
+		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
+			mutex_unlock(&cgroup_mutex);
+			msleep(10);
+			ret = restart_syscall();
+			goto out_free;
+		}
+		cgroup_put(&ss->root->cgrp);
+	}
+
 	for_each_root(root) {
 		bool name_match = false;
 
-- 
1.9.3
