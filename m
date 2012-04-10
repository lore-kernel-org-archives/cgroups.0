From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-3.5] cgroup: remove cgroup_subsys->populate()
Date: Tue, 10 Apr 2012 10:16:36 -0700
Message-ID: <20120410171636.GB21311@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=DJN9hSJWyf3+GIUVSUlkRiuecnI8KSUS8R5loElGp90=;
        b=EGWtiz3ULhSz4TjhUaCEKe2TwXxyqp08PiDS7JwzNWOKAkySX9xi2kVqDUqGYfp4Xm
         23DovLVbMOv/w469F58ua9dy5jkS9M9fKEmLUL2TGyVYGFpSyQs337br+pyCibnTmMrH
         heoGRD4rafYtW3QigJnCLlwsUBVnQ526+4Au1YdgY9ubhf24/RD/zEcTqj+lcN54pIL3
         musGB5CifPaDOSjS3itjyxVKxWTWRHRzsKRNKrcUd7EiYYv5/Fstup0t3DmEClM2AG7F
         WszjJ1JXLpsD5/ddQDaVd5Fvdu115znOPkpXuCy/xPLTppaBwrfZe08ervON7eDy+bf4
         znxQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

With memcg converted, cgroup_subsys->populate() doesn't have any user
left.  Remove it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Li, can you please ack this?  Thanks.

 include/linux/cgroup.h |    1 -
 kernel/cgroup.c        |    3 ---
 2 files changed, 4 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 565c803..d3f5fba 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -472,7 +472,6 @@ struct cgroup_subsys {
 	void (*fork)(struct task_struct *task);
 	void (*exit)(struct cgroup *cgrp, struct cgroup *old_cgrp,
 		     struct task_struct *task);
-	int (*populate)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup *cgrp);
 	void (*bind)(struct cgroup *root);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2905977..b2f203f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3842,9 +3842,6 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 	for_each_subsys(cgrp->root, ss) {
 		struct cftype_set *set;
 
-		if (ss->populate && (err = ss->populate(ss, cgrp)) < 0)
-			return err;
-
 		list_for_each_entry(set, &ss->cftsets, node)
 			cgroup_addrm_files(cgrp, ss, set->cfts, true);
 	}
