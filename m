From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 01/11] cgroup: allow subsystems to create files for sane_behavior
 only
Date: Wed, 21 Aug 2013 17:58:58 +0800
Message-ID: <52148F62.5060409@huawei.com>
References: <52148F52.0@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52148F52.0@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Containers <containers@lists.linux-foundation.org>

So we can add new cgroupfs interfaces for sane_behavior only.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 1 +
 kernel/cgroup.c        | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 3aac34d..7ba7764 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -411,6 +411,7 @@ enum {
 	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cgrp */
 	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cgrp */
 	CFTYPE_INSANE		= (1 << 2),	/* don't create if sane_behavior */
+	CFTYPE_SANE		= (1 << 3),	/* only create if sane_behavior */
 };
 
 #define MAX_CFTYPE_NAME		64
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 737d752..6c770ee 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2809,6 +2809,8 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 		/* does cft->flags tell us to skip this file on @cgrp? */
 		if ((cft->flags & CFTYPE_INSANE) && cgroup_sane_behavior(cgrp))
 			continue;
+		if ((cft->flags & CFTYPE_SANE) && !cgroup_sane_behavior(cgrp))
+			continue;
 		if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
 			continue;
 		if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgrp->parent)
-- 
1.8.0.2
