From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 5/9] cgroup: update error handling in cgroup_populate_dir()
Date: Thu, 11 Jul 2013 10:18:25 -0700
Message-ID: <20130711171825.GD10195@mtj.dyndns.org>
References: <1372463145-4245-1-git-send-email-tj@kernel.org>
 <1372463145-4245-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=e2pFudRqiKf+KlUQ6TN8Y9a0TQlYqsa4s9wLIixI5Ps=;
        b=qsbNOQGGS/s7vXDlrRqZIYCq8oQngCbGkc4d0RIJQYznKg1xQMDPJ0LaHD7EpnGe+f
         klQoQLaHVRwNl21Yw08GuVYiSsUm2J3qWqcU9kMGixIBeuYQ9/C1SzQMN6SZyMWeSrU+
         9C4M39Px2+LNFNaMoQkDfK52pVCl1o0OFhA6/rICrmUnua/OxZPFshuq9DwaJby9P2L+
         tQAOs5/GJfGax/IqFu5+ysxlAUiNkpzbPxHm7eSkgoM8sTwKcDzL+kkEy1M6PJj5oHue
         zAY7YMPw0KZdB0BNZNGJTp3GUe8MsG3wOf8QImt9o7AX2Ku7oV5mljBCOx4TX7oRSi2O
         R1lg==
Content-Disposition: inline
In-Reply-To: <1372463145-4245-6-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 4b5e65e0911690422a9b253b8ef68b14288e99c5 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Fri, 28 Jun 2013 16:24:11 -0700

cgroup_populate_dir() didn't use to check whether the actual file
creations were successful and could return success with only subset of
the requested files created, which is nasty.

This patch udpates cgroup_populate_dir() so that it either succeeds
with all files or fails with no file.

v2: The original patch also converted for_each_root_subsys() usages to
    for_each_subsys() without explaining why.  That part has been
    moved to a separate patch.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Li, I separated out the for_each_subsys() conversion to a separate
patch instead.

Thanks.

 kernel/cgroup.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4171,10 +4171,13 @@ static struct cftype cgroup_base_files[]
  * cgroup_populate_dir - create subsys files in a cgroup directory
  * @cgrp: target cgroup
  * @subsys_mask: mask of the subsystem ids whose files should be added
+ *
+ * On failure, no file is added.
  */
 static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 {
 	struct cgroup_subsys *ss;
+	int ret = 0;
 
 	/* process cftsets of each subsystem */
 	for_each_root_subsys(cgrp->root, ss) {
@@ -4182,8 +4185,11 @@ static int cgroup_populate_dir(struct cg
 		if (!test_bit(ss->subsys_id, &subsys_mask))
 			continue;
 
-		list_for_each_entry(set, &ss->cftsets, node)
-			cgroup_addrm_files(cgrp, ss, set->cfts, true);
+		list_for_each_entry(set, &ss->cftsets, node) {
+			ret = cgroup_addrm_files(cgrp, ss, set->cfts, true);
+			if (ret < 0)
+				goto err;
+		}
 	}
 
 	/* This cgroup is ready now */
@@ -4201,6 +4207,9 @@ static int cgroup_populate_dir(struct cg
 	}
 
 	return 0;
+err:
+	cgroup_clear_dir(cgrp, subsys_mask);
+	return ret;
 }
 
 static void css_dput_fn(struct work_struct *work)
