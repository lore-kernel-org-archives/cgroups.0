From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/9] cgroup: remove cftype->release()
Date: Sun, 24 Nov 2013 17:11:29 -0500
Message-ID: <1385331096-7918-3-git-send-email-tj@kernel.org>
References: <1385331096-7918-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=co0LnwbYfaIT3+XCo+JnOZycO3409p9B2kbPCNzPH8U=;
        b=Ygo81ACMPkdoTsWJr6ORBPA9K4YEeuu/sC9pJPF3IZ3Kd9nAcKqTqHE8eJWErKdTA1
         2J8Zt20FrvjIieKIEEGX1fspiZZbxgzXCNILIAEEFcrD7iNZ2HxgBX2xYiUgCi9AJse6
         ye5xa5OSLZ3l2TPqhhH34+SoK0a6VWBVSrx5P4QhWV0/uve2cmyAy/uZkPAOX5AOF0kv
         sRbOzEG/37a/Q0GcPFYI0JR8SW5eHOHMy5voRAYAytuktLc1LbPQP2Mcam4BUwpgj6gc
         aIgkAxbxm5DlKWH3z5W/nuSMYrzLhLzcdUGJMTdyFCMH58jkBrIYKReVPGZ2Gb8N53CI
         TATg==
In-Reply-To: <1385331096-7918-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Now that pidlist files don't use cftype->release(), it doesn't have
any user left.  Remove it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h | 2 --
 kernel/cgroup.c        | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 492fa01..5207c28 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -499,8 +499,6 @@ struct cftype {
 	 * kick type for multiplexing.
 	 */
 	int (*trigger)(struct cgroup_subsys_state *css, unsigned int event);
-
-	int (*release)(struct inode *inode, struct file *file);
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 61a5e2e..2fd888f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2447,12 +2447,9 @@ static int cgroup_file_open(struct inode *inode, struct file *file)
 static int cgroup_file_release(struct inode *inode, struct file *file)
 {
 	struct cfent *cfe = __d_cfe(file->f_dentry);
-	struct cftype *cft = __d_cft(file->f_dentry);
 	struct cgroup_subsys_state *css = cfe->css;
 	int ret = 0;
 
-	if (cft->release)
-		ret = cft->release(inode, file);
 	if (css->ss)
 		css_put(css);
 	return ret;
-- 
1.8.4.2
