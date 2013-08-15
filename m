From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 03/12] cgroup: implement CFTYPE_NO_PREFIX
Date: Thu, 15 Aug 2013 12:02:21 -0400
Message-ID: <1376582550-12548-4-git-send-email-tj@kernel.org>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IKceJ2LSBMOk0EREefiZ1Ny8TmQGS3u356oJw2rKCFo=;
        b=Bp1kwNAHxZG9arFBwl0LNF1GZCBkb/cAS9d/vRsXgx24uLMGdvMwukQwmpoHC9WQo8
         3E5efeXu8nazBs0Mc078qs/a10zDIG/njzUWhE0+GXvsHnXkqBegUk34vbk16YwBSaGr
         Malw3pgRGmLWKKimQ4R32VdAxlkAeXV+qJ2MI+d1eli+jXsMefA5nsMWlzzqlmjS3PRP
         72eNFoGU/vNGnAj4iIX4DOv/bJFEe2bpQObjm6P627n/PHCaVGWBlGBNI6bNTpl60OJV
         YpuCrRVkiNHylHtzJIK4lgcbrR3nSwA3cRFmze9sfWtLk8h/hihj1xZNXgg2HH2rc9A1
         fNyw==
In-Reply-To: <1376582550-12548-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

When cgroup files are created, cgroup core automatically prepends the
name of the subsystem as prefix.  This patch adds CFTYPE_NO_ which
disables the automatic prefix.  This is to work around historical
baggages and shouldn't be used for new files.

This will be used to move "cgroup.event_control" from cgroup core to
memcg.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup.h | 1 +
 kernel/cgroup.c        | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5029176..00c6329 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -411,6 +411,7 @@ enum {
 	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cgrp */
 	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cgrp */
 	CFTYPE_INSANE		= (1 << 2),	/* don't create if sane_behavior */
+	CFTYPE_NO_PREFIX	= (1 << 3),	/* (DON'T USE FOR NEW FILES) no subsys prefix */
 };
 
 #define MAX_CFTYPE_NAME		64
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f09ce8d..73d1c70 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2756,7 +2756,8 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 	umode_t mode;
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 
-	if (cft->ss && !(cgrp->root->flags & CGRP_ROOT_NOPREFIX)) {
+	if (cft->ss && !(cft->flags & CFTYPE_NO_PREFIX) &&
+	    !(cgrp->root->flags & CGRP_ROOT_NOPREFIX)) {
 		strcpy(name, cft->ss->name);
 		strcat(name, ".");
 	}
-- 
1.8.3.1
