From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] cgroup: remove CGRP_ROOT_OPTION_MASK
Date: Wed,  2 Jul 2014 19:45:44 -0400
Message-ID: <1404344747-7957-2-git-send-email-tj@kernel.org>
References: <1404344747-7957-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CHM/WED+yuI857gV0p5M8Y10m+rdIB7T2rBign3/viw=;
        b=UH6zwuVc9nfQD7DpANjrzHygQnrnUg+KsTRSEVAhS+UUAG17zL0tsFP+KzrUw0D+53
         fsTW8eTKSVMsTwFcAh/wgA2lx+ZQTyxFGQ7pzdmzNMdSC1x3Zyl2fjQwNzZKYaw4BvF8
         rLXtwcfhBzQRaWkTHpryzYX8sGH2jXrxwSEBaaRclBfN9u3B5qvDGabXKLpi9jvpPyCw
         fDDjof8ccbSyZZo6GzGgloAQKfQx9lP+7oEeyuhIuxt4/qtljksJxPID85KaRhkPhxg0
         S00ZjBo97Dx35JiXcJ447kz7dR0WuJEMZuyki/yDPUDT1NV5UEoDQMV3PThz2tzHuLKa
         ydJQ==
In-Reply-To: <1404344747-7957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup_root->flags only contains CGRP_ROOT_* flags and there's no
reason to mask the flags.  Remove CGRP_ROOT_OPTION_MASK.

This doesn't cause any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 3 ---
 kernel/cgroup.c        | 7 +++----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8a111dd..7748e5b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -312,9 +312,6 @@ enum {
 
 	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
 	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
-
-	/* mount options live below bit 16 */
-	CGRP_ROOT_OPTION_MASK	= (1 << 16) - 1,
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7868fc3..e27f4d4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1434,11 +1434,10 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	removed_mask = root->subsys_mask & ~opts.subsys_mask;
 
 	/* Don't allow flags or name to change at remount */
-	if (((opts.flags ^ root->flags) & CGRP_ROOT_OPTION_MASK) ||
+	if ((opts.flags ^ root->flags) ||
 	    (opts.name && strcmp(opts.name, root->name))) {
 		pr_err("option or name mismatch, new: 0x%x \"%s\", old: 0x%x \"%s\"\n",
-		       opts.flags & CGRP_ROOT_OPTION_MASK, opts.name ?: "",
-		       root->flags & CGRP_ROOT_OPTION_MASK, root->name);
+		       opts.flags, opts.name ?: "", root->flags, root->name);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -1706,7 +1705,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			goto out_unlock;
 		}
 
-		if ((root->flags ^ opts.flags) & CGRP_ROOT_OPTION_MASK) {
+		if (root->flags ^ opts.flags) {
 			if ((root->flags | opts.flags) & CGRP_ROOT_SANE_BEHAVIOR) {
 				pr_err("sane_behavior: new mount options should match the existing superblock\n");
 				ret = -EINVAL;
-- 
1.9.3
