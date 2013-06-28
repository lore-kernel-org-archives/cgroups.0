From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 9/9] blkcg: make blkcg_policy_register() correctly handle cgroup_add_cftypes() failures
Date: Fri, 28 Jun 2013 16:45:45 -0700
Message-ID: <1372463145-4245-10-git-send-email-tj@kernel.org>
References: <1372463145-4245-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=NjI3oDS2knXF2ijPCzT0Qhpu/TeI6Vpa8XtfSfJo90g=;
        b=Rb3hPWsnqhNEUCyBH8ZTh5JiOt+Gr3Wr3XHliV7lS+nz91yzrAafBAvH4xnyZxtPSX
         /VuukdCCLUVDKzTPSr/AXwuN+M339mxlO9XpCsoZAS3hUkBEf0wnB+nV3wqx+vdf7s6x
         36dV1lbMTziz2bX02yZZT15zmnDYS254a5w+0YSC0qXn/4/6GN/1wdMsKPNq+MH/rF4N
         9KAG0AtXMeW3ALA45KaoF2euyrjzPEKp6n8rdnvvWWkcB0BEXEiysKhqyXbXc9XkGPYB
         g0b/h78y/2D7GDxb6w7AaGk3qFFYX6meWU+fYERJTAHSVRCzE+tv8taWSq/H5KPPTC7c
         VVYg==
In-Reply-To: <1372463145-4245-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hello, Jens.

How should this one be routed?  It can go through either block or
cgroup tree.

Thanks!

------------------------- 8< -------------------------
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: blkcg: make blkcg_policy_register() correctly handle cgroup_add_cftypes() failures

blkcg_policy_register() currently triggers WARN when
cgroup_add_cftypes() fails and proceeds, which is a rather crappy way
to handle errors.  It was written that way as cgroup_add_cftypes()
itself didn't handle errors correctly.  Now that cgroup_add_cftypes()
correctly handles errors in itself, let's handle its failure properly.

Remove the WARN_ON() and cancel and fail policy registration on
cgroup_add_cftypes() failure.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
---
 block/blk-cgroup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e8918ff..b27a9d2 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1127,10 +1127,13 @@ int blkcg_policy_register(struct blkcg_policy *pol)
 	pol->plid = i;
 	blkcg_policy[i] = pol;
 
-	/* everything is in place, add intf files for the new policy */
-	if (pol->cftypes)
-		WARN_ON(cgroup_add_cftypes(&blkio_subsys, pol->cftypes));
+	/* try to add intf files for the new policy */
 	ret = 0;
+	if (pol->cftypes) {
+		ret = cgroup_add_cftypes(&blkio_subsys, pol->cftypes);
+		if (ret)
+			blkcg_policy[i] = NULL;
+	}
 out_unlock:
 	mutex_unlock(&blkcg_pol_mutex);
 	return ret;
-- 
1.8.3.1
