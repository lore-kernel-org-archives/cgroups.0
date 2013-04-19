From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: fix broken file xattrs
Date: Thu, 18 Apr 2013 23:13:03 -0700
Message-ID: <20130419061303.GB9691@mtj.dyndns.org>
References: <5170DBC1.3020201@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=twpGQlE53NlqyywJHCTC/MWxCG5J/dn4vQ+ey/nQ6U4=;
        b=ywwFhWst3PjNSM/Ab372vT74IZ0wweBSOwSm8zbhU2taff7RZnCOtnJxbG5DVK7ZHR
         8/ISl3U1z5aDtIMSmvT41+WNMZ5GKxM380/+Hr2zWt57IrRbH2JgXSnI2NUtfLRPVwcM
         m+6/giF7eJ8wYK7GTpd72SzVDDELxaeAXCz3ANeMSPiQT1ul0ZOA8ufi1X2PH/RT++R7
         zE60eRaLNF4pEwJ81IVueWL1HRNg2Pwo7MWAQsl9MTYZh4ZYDkszUzK4+fDPSqLlWzs/
         uoggthAVHtWtLlB01zb3oM2A19542jvHvhqUC/ZW2usHPX8Tk83U9JRfUXZKBWnmj/hT
         c+Vw==
Content-Disposition: inline
In-Reply-To: <5170DBC1.3020201-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

From 712317ad97f41e738e1a19aa0a6392a78a84094e Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Thu, 18 Apr 2013 23:09:52 -0700

We should store file xattrs in struct cfent instead of struct cftype,
because cftype is a type while cfent is object instance of cftype.

For example each cgroup has a tasks file, and each tasks file is
associated with a uniq cfent, but all those files share the same
struct cftype.

Alexey Kodanev reported a crash, which can be reproduced:

  # mount -t cgroup -o xattr /sys/fs/cgroup
  # mkdir /sys/fs/cgroup/test
  # setfattr -n trusted.value -v test_value /sys/fs/cgroup/tasks
  # rmdir /sys/fs/cgroup/test
  # umount /sys/fs/cgroup
  oops!

In this case, simple_xattrs_free() will free the same struct simple_xattrs
twice.

tj: Dropped unused local variable @cft from cgroup_diput().

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.8.x
Reported-by: Alexey Kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Applied to cgroup/for-3.10 with slight modification.

Thanks.

 include/linux/cgroup.h |  3 ---
 kernel/cgroup.c        | 11 ++++++-----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index cda7eb2..c371888 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -422,9 +422,6 @@ struct cftype {
 	/* CFTYPE_* flags */
 	unsigned int flags;
 
-	/* file xattrs */
-	struct simple_xattrs xattrs;
-
 	int (*open)(struct inode *inode, struct file *file);
 	ssize_t (*read)(struct cgroup *cgrp, struct cftype *cft,
 			struct file *file,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c16719e..192d762 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -117,6 +117,9 @@ struct cfent {
 	struct list_head		node;
 	struct dentry			*dentry;
 	struct cftype			*type;
+
+	/* file xattrs */
+	struct simple_xattrs		xattrs;
 };
 
 /*
@@ -882,13 +885,12 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
 		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
-		struct cftype *cft = cfe->type;
 
 		WARN_ONCE(!list_empty(&cfe->node) &&
 			  cgrp != &cgrp->root->top_cgroup,
 			  "cfe still linked for %s\n", cfe->type->name);
+		simple_xattrs_free(&cfe->xattrs);
 		kfree(cfe);
-		simple_xattrs_free(&cft->xattrs);
 	}
 	iput(inode);
 }
@@ -2501,7 +2503,7 @@ static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
 	if (S_ISDIR(dentry->d_inode->i_mode))
 		return &__d_cgrp(dentry)->xattrs;
 	else
-		return &__d_cft(dentry)->xattrs;
+		return &__d_cfe(dentry)->xattrs;
 }
 
 static inline int xattr_enabled(struct dentry *dentry)
@@ -2677,8 +2679,6 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	umode_t mode;
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 
-	simple_xattrs_init(&cft->xattrs);
-
 	if (subsys && !(cgrp->root->flags & CGRP_ROOT_NOPREFIX)) {
 		strcpy(name, subsys->name);
 		strcat(name, ".");
@@ -2703,6 +2703,7 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 		cfe->type = (void *)cft;
 		cfe->dentry = dentry;
 		dentry->d_fsdata = cfe;
+		simple_xattrs_init(&cfe->xattrs);
 		list_add_tail(&cfe->node, &parent->files);
 		cfe = NULL;
 	}
-- 
1.8.1.4
