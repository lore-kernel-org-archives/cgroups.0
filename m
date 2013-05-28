From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: warn about mismatching options of a new mount of an
 existing hierarchy
Date: Wed, 29 May 2013 07:59:34 +0900
Message-ID: <20130528225934.GB6149@mtj.dyndns.org>
References: <519F8F40.3040601@oracle.com>
 <20130526041007.GD13771@mtj.dyndns.org>
 <51A20F15.4030606@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=seOxoEPU4Ev0Hg/ogarAQM+Vg6TBO6WZKmyLcfMtbGE=;
        b=IRmbigVnm04yn8Wy2jOEVmAL4fByMK6Toj1IplTuH1vGQY5T/8vWLwhMf1grIGrVl4
         iBmrY9aRul3Ba5FXV5ROiQ/EfAOfQJBL9ZsQqHhZnxfEpTo2DOrzavTmUcjwNvv/NbYT
         GbglnHApT+SnSytVpOj6NDz6tOGL/r77tCgf3Wr7hpSdceYK334/gKl+r39Gb2ca44RS
         4IbQmNzg/UNOQZH+EXruSIi4u4aLanZFXFaCSk6088eTbbInDAWnHlsh/KsRocMo6oUz
         s+YzQEiwpKF5hDVFBPb3aJVIcMEeN00vb9kC2hTfHztjajSnOtDZgzVgdxoddcM2V20l
         KidQ==
Content-Disposition: inline
In-Reply-To: <51A20F15.4030606-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Alexey Kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied the following to cgroup/for-3.10-fixes.  Thanks.

From 3620761338c69c940cfa83cf169a043259274a88 Mon Sep 17 00:00:00 2001
From: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date: Sun, 26 May 2013 21:33:09 +0800

With the new __DEVEL__sane_behavior mount option was introduced,
if the root cgroup is alive with no xattr function, to mount a
new cgroup with xattr will be rejected in terms of design which
just fine.  However, if the root cgroup does not mounted with
__DEVEL__sane_hehavior, to create a new cgroup with xattr option
will succeed although after that the EA function does not works
as expected but will get ENOTSUPP for setting up attributes under
either cgroup. e.g.

setfattr: /cgroup2/test: Operation not supported

Instead of keeping silence in this case, it's better to drop a log
entry in warning level.  That would be helpful to understand the
reason behind the scene from the user's perspective, and this is
essentially an improvement does not break the backward compatibilities.

With this fix, above mount attemption will keep up works as usual but
the following line cound be found at the system log:

[ ...] cgroup: new mount options do not match the existing superblock

tj: minor formatting / message updates.

Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reported-by: Alexey Kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 31e9ef3..a7c9e6d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1686,11 +1686,14 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		 */
 		cgroup_drop_root(opts.new_root);
 
-		if (((root->flags | opts.flags) & CGRP_ROOT_SANE_BEHAVIOR) &&
-		    root->flags != opts.flags) {
-			pr_err("cgroup: sane_behavior: new mount options should match the existing superblock\n");
-			ret = -EINVAL;
-			goto drop_new_super;
+		if (root->flags != opts.flags) {
+			if ((root->flags | opts.flags) & CGRP_ROOT_SANE_BEHAVIOR) {
+				pr_err("cgroup: sane_behavior: new mount options should match the existing superblock\n");
+				ret = -EINVAL;
+				goto drop_new_super;
+			} else {
+				pr_warning("cgroup: new mount options do not match the existing superblock, will be ignored\n");
+			}
 		}
 
 		/* no subsys rebinding, so refcounts don't change */
-- 
1.8.1.4
