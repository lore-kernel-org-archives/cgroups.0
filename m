From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.14] cgroup: remove now unused list_head @pending
 in cgroup_apply_cftypes()
Date: Sun, 16 Jul 2017 21:39:29 -0400
Message-ID: <20170717013929.GH2969123@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=UtwfawcScA4zCt/SvQxnLXiPY8QbAZEJ4BmoHjdYrPM=;
        b=p3XrcnFppP1PXjn85jIGWoDBb/ZJCiOSkJKK1tEFa4Yp6nLPmNS8jnxQNieZ8mmGvl
         Q3pHiRoUGtMSMoM7jiWbhNkRJyJIUByKWTG+4T0wCNESC84YfQOxVUY20PxqsMYXdvwP
         rE3QYydpdJdSz0k8BLRp7l0PbI6JPxapt31Jv0LDaq0Efb0G05dATpoQkH6orNDT/ZHO
         SAqty7S9OLWMR45TCwfO8h4LQ8+TP5JIHXlA2JB0/KFgCsOpxaHuo3961Qu/0nYWyVl+
         hFuEUWcYLopvZ6GK+L0808M7howhD5wokoEAFeApmUJgUC6T6x2T2zXhEQ1iGnMBSChG
         /izw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, kernel-team@fb.com

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applying to cgroup/for-4.14.

Thanks.

 kernel/cgroup/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3230,7 +3230,6 @@ restart:
 
 static int cgroup_apply_cftypes(struct cftype *cfts, bool is_add)
 {
-	LIST_HEAD(pending);
 	struct cgroup_subsys *ss = cfts[0].ss;
 	struct cgroup *root = &ss->root->cgrp;
 	struct cgroup_subsys_state *css;
