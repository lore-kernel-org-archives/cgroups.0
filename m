From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] cgroup: make CFTYPE_ONLY_ON_DFL and CFTYPE_NO_ internal to cgroup core
Date: Mon, 14 Jul 2014 11:44:07 -0400
Message-ID: <1405352648-4279-6-git-send-email-tj@kernel.org>
References: <1405352648-4279-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C0+v5urLunk34GJoZABiS1HsXmDSO0Unfa0e+CwknaM=;
        b=YbSzIsI/LUrlNloSb6+vME6BxMRKyPPkvpPU6aSjAGSgBOxyYqrXp1q+9QSHOUBzRK
         n6gSzq8V8Fhh4ZaUKjclU8rPpetKIytoAZGmCGMiqF2Pfb+WdJ3vORxpoh5H/YtoZCLP
         dnoFCYrd2613V12M0W1U3iG2J0qGYeXiruD2ugj0cik23iTFy44YIfpwhQlSQcfCWGV5
         mgWqo3OMX/S5h/1zDlJKHnvO+nuH0m15P4y8eRcCvUiQ5tQcMbCC97mybX5gRyJkr2m3
         EIojjlFzYneT2f9+jyxGQitu5FJbmMaApu6m6FdkG4kHXvL77/lfz5+UGsc4GYAvdKoU
         sivw==
In-Reply-To: <1405352648-4279-1-git-send-email-tj@kernel.org>
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

v2: Convert the extra ones in cgroup_exit_cftypes() which are added by
    revision to the previous patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  6 ++++--
 kernel/cgroup.c        | 10 +++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9f76236..b5223c5 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -384,9 +384,11 @@ struct css_set {
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
index 374ebdf..f41d164 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3031,9 +3031,9 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 
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
@@ -3093,7 +3093,7 @@ static void cgroup_exit_cftypes(struct cftype *cfts)
 		cft->ss = NULL;
 
 		/* revert flags set by cgroup core while adding @cfts */
-		cft->flags &= ~(CFTYPE_ONLY_ON_DFL | CFTYPE_INSANE);
+		cft->flags &= ~(__CFTYPE_ONLY_ON_DFL | __CFTYPE_NOT_ON_DFL);
 	}
 }
 
@@ -3217,7 +3217,7 @@ int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	struct cftype *cft;
 
 	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-		cft->flags |= CFTYPE_ONLY_ON_DFL;
+		cft->flags |= __CFTYPE_ONLY_ON_DFL;
 	return cgroup_add_cftypes(ss, cfts);
 }
 
@@ -3234,7 +3234,7 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	struct cftype *cft;
 
 	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
-		cft->flags |= CFTYPE_INSANE;
+		cft->flags |= __CFTYPE_NOT_ON_DFL;
 	return cgroup_add_cftypes(ss, cfts);
 }
 
-- 
1.9.3
