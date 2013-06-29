From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.11 3/2] cgroup: CGRP_ROOT_SUBSYS_BOUND should
 also be ignored when mounting an existing hierarchy
Date: Sat, 29 Jun 2013 14:17:40 -0700
Message-ID: <20130629211740.GA23902@mtj.dyndns.org>
References: <20130628023930.GA2500@htj.dyndns.org>
 <20130628024003.GB2500@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=d6d9HLs4oViq1nmeYq9uEV+LI0olkMQaMF8aG+UEsCU=;
        b=wo7vBF8AYSwc3/PduytuB1z+7CfsZoaE3Dig1FTsLAV8O7eRUG/WI+ANdYsxW8tda3
         ACiq8Idd3em9J0oFJdqEsBg6EXS67jR4d/kWPbEXDJ15orBzclZC4N7ruuax1jAbh7Tr
         pwbgfUzoTIsFmrUVWYj0DOuikP5s8pxNqg4nqiYcdOg5nsA6EfvY5H8cq+5cW6oAzhsH
         biNZY6atvdQjXZSE+gdMJoU+7p0VSXin0+/sCKaMwP/mjQu2ggcVZOCdXTLWUvibZrQJ
         yNE50H6JUnFQtGqYtcc0ppJPw8SzVLOQwA618Vw+Tn1EQf+13Y+Xf7ClFV08ZmhYjDwr
         32JQ==
Content-Disposition: inline
In-Reply-To: <20130628024003.GB2500-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From c7ba8287cd11f2fc9e2feee9e1fac34b7293658f Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Sat, 29 Jun 2013 14:06:10 -0700

0ce6cba357 ("cgroup: CGRP_ROOT_SUBSYS_BOUND should be ignored when
comparing mount options") only updated the remount path but
CGRP_ROOT_SUBSYS_BOUND should also be ignored when comparing options
while mounting an existing hierarchy.  As option mismatch triggers a
warning but doesn't fail the mount without sane_behavior, this only
triggers a spurious warning message.

Fix it by only comparing CGRP_ROOT_OPTION_MASK bits when comparing new
and existing root options.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Oops, missed one.  This one isn't critical but let's get it fixed too.

Thanks.

 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5a2fcf5..e5583d1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1703,7 +1703,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		 */
 		cgroup_free_root(opts.new_root);
 
-		if (root->flags != opts.flags) {
+		if ((root->flags ^ opts.flags) & CGRP_ROOT_OPTION_MASK) {
 			if ((root->flags | opts.flags) & CGRP_ROOT_SANE_BEHAVIOR) {
 				pr_err("cgroup: sane_behavior: new mount options should match the existing superblock\n");
 				ret = -EINVAL;
-- 
1.8.3.1
