From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/11] cgroup: implement CFTYPE_ONLY_ON_DFL
Date: Thu, 13 Mar 2014 15:50:13 -0400
Message-ID: <1394740213-17626-12-git-send-email-tj@kernel.org>
References: <1394740213-17626-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xJqZWIAyMRylRpKI6QpXLS/DWV3zkNQcaF4aGSK9U/w=;
        b=A6AARIQqxa56gI86YCADa+adZvmoJC4BgifguXDUmd0EuikGivxgSz1EOLyEEvgSxz
         QBG0fl3gh2hef/5LSZJ9Bk2E5G5Ar1JXBZF06gZnaH0z+sA0beTgK7mS+ofyiQ+nKTXi
         XtZ6MiYj2/iWRVfWam0Ygf5+j9rWCLBNOxFs0Mrjvq/c10gdf3MjbXjpfpr5gFzIK8W/
         htzqZlhlfsjo8NXhtVa93LegsMdkCTSnO6Fkq/lHqqTGwlJz6/d9EEAnUPARN/XGClpU
         EOdlrVR3j2qxi4zkvK0NTWs+NiekMVQfA0UPy7CP2m2JYm3VPZhxQkuwbbKtBHvp0Ksu
         eJpw==
In-Reply-To: <1394740213-17626-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

This cftype flag makes the file only appear on the default hierarchy.
This will later be used for cgroup.controllers file.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 1 +
 kernel/cgroup.c        | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7e9fa50..43d1ed3 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -384,6 +384,7 @@ enum {
 	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cgrp */
 	CFTYPE_INSANE		= (1 << 2),	/* don't create if sane_behavior */
 	CFTYPE_NO_PREFIX	= (1 << 3),	/* (DON'T USE FOR NEW FILES) no subsys prefix */
+	CFTYPE_ONLY_ON_DFL	= (1 << 4),	/* only on default hierarchy */
 };
 
 #define MAX_CFTYPE_NAME		64
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c42230c..79e3573 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2356,6 +2356,8 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
 		/* does cft->flags tell us to skip this file on @cgrp? */
+		if ((cft->flags & CFTYPE_ONLY_ON_DFL) && !cgroup_on_dfl(cgrp))
+			continue;
 		if ((cft->flags & CFTYPE_INSANE) && cgroup_sane_behavior(cgrp))
 			continue;
 		if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
-- 
1.8.5.3
