From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] cgroup: make CFTYPE_ONLY_ON_DFL and CFTYPE_NO_ internal to cgroup core
Date: Wed,  2 Jul 2014 19:50:55 -0400
Message-ID: <1404345055-8196-6-git-send-email-tj@kernel.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m5KdzfO60IOdh8vDzmUXJ5ETsCg7Z0TVYpZIBM7cqYs=;
        b=OoejRJuiIAWmWulyrDoFhX9Hl1sI8c6YfaLrspCIp7+YdC9sriyier8BAL6l7f3xz6
         9vYBwyTLHYxaM6bYCRvAJXgx4ycTl9SAzBCyDeadYUFZbniy87jAE8io0KXPX7GoQIen
         zX6UC3k8DvSdMSZKUjnQxl/6N5Fe4JV+vm/t7OzXU/rjShIXZl5AMcaJxtv/iIzMkKtB
         xZq8AeSvfp1ESPNx49QILwids38aM0QmBGCL76/66DtPash0xGMZtwqpFBXytXW7I6/x
         ItHxJJGBCXdp2VUDoShm8EvFeGfjwTBwLERUIvuxyOWH/B8o4LFAAnpr6AyBzIZTpOLg
         8ptQ==
In-Reply-To: <1404345055-8196-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup now distinguishes cftypes for the default and legacy
hierarchies more explicitly by using separate arrays and
CFTYPE_ONLY_ON_DFL and CFTYPE_INSANE should be and are used only
inside cgroup core proper.  Let's make it clear that the flags are
internal by prefixing them with double underscores.

CFTYPE_INSANE is renamed to __CFTYPE_NOT_ON_DFL for consistency.  The
two flags are also collected and assigned bits >= 16 so that they
aren't mixed with the published flags.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 6 ++++--
 kernel/cgroup.c        | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 62a2be1..c047887c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -376,9 +376,11 @@ struct css_set {
 enum {
 	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cgrp */
 	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cgrp */
-	CFTYPE_INSANE		= (1 << 2),	/* don't create if sane_behavior */
 	CFTYPE_NO_PREFIX	= (1 << 3),	/* (DON'T USE FOR NEW FILES) no subsys prefix */
-	CFTYPE_ONLY_ON_DFL	= (1 << 4),	/* only on default hierarchy */
+
+	/* internal flags, do not use outside cgroup core proper */
+	__CFTYPE_ONLY_ON_DFL	= (1 << 16),	/* only on default hierarchy */
+	__CFTYPE_NOT_ON_DFL	= (1 << 17),	/* not on default hierarchy */
 };
 
 #define MAX_CFTYPE_NAME		64
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 94cdb7b..028ebf1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2921,9 +2921,9 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
 		/* does cft->flags tell us to skip this file on @cgrp? */
-		if ((cft->flags & CFTYPE_ONLY_ON_DFL) && !cgroup_on_dfl(cgrp))
+		if ((cft->flags & __CFTYPE_ONLY_ON_DFL) && !cgroup_on_dfl(cgrp))
 			continue;
-		if ((cft->flags & CFTYPE_INSANE) && cgroup_on_dfl(cgrp))
+		if ((cft->flags & __CFTYPE_NOT_ON_DFL) && cgroup_on_dfl(cgrp))
 			continue;
 		if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgroup_parent(cgrp))
 			continue;
@@ -3104,7 +3104,7 @@ int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	struct cftype *cft;
 
 	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-		cft->flags |= CFTYPE_ONLY_ON_DFL;
+		cft->flags |= __CFTYPE_ONLY_ON_DFL;
 	return cgroup_add_cftypes(ss, cfts);
 }
 
@@ -3121,7 +3121,7 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	struct cftype *cft;
 
 	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-		cft->flags |= CFTYPE_INSANE;
+		cft->flags |= __CFTYPE_NOT_ON_DFL;
 	return cgroup_add_cftypes(ss, cfts);
 }
 
-- 
1.9.3
