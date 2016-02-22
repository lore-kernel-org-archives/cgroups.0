From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] Revert "cgroup: add cgroup_subsys->css_e_css_changed()"
Date: Mon, 22 Feb 2016 18:05:45 -0500
Message-ID: <1456182349-18156-3-git-send-email-tj@kernel.org>
References: <1456182349-18156-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jpFKMtFkO+0UiqyO7wSad9Br27Cx+SVRKR2pER1F4tw=;
        b=a/2ydVO/l2ipLb9hND68nuaIg99lx0t+RHbpT5jeqJS1pMmDdQJBV67nVY95b92PnO
         FXvRpCOM3MfPm2FnKyhjKi5J0sm4j6Jeey+FK80U7KwREQ5M0SQnG6TGuaqinnsEwbIR
         f6+kK7KzE19AIkIQQGjYIofFnxVWTWn59yR2b+o2WHHuAVsA+bEonjIXdeCgOQ8dFl+c
         RRei3sdrSe4PJ1Gw1+FUQkWvsruKSJa6w2ExxBbs6y+arI+hGs/BGHfhDU68btsKs9GL
         chalp81shnUqStJsqKTAQRuhUs580uHAg7QIojVy7lt6eYXeHzoZCs+B5q9xHos7ND63
         fjtw==
In-Reply-To: <1456182349-18156-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

This reverts commit 56c807ba4e91f0980567b6a69de239677879b17f.

cgroup_subsys->css_e_css_changed() was supposed to be used by cgroup
writeback support; however, the change to per-inode cgroup association
made it unnecessary and the callback doesn't have any user.  Remove
it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h |  1 -
 kernel/cgroup.c             | 18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 789471d..4f3c0da 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -434,7 +434,6 @@ struct cgroup_subsys {
 	void (*css_released)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
 	void (*css_reset)(struct cgroup_subsys_state *css);
-	void (*css_e_css_changed)(struct cgroup_subsys_state *css);
 
 	int (*can_attach)(struct cgroup_taskset *tset);
 	void (*cancel_attach)(struct cgroup_taskset *tset);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 68b032d..7727b6e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3127,24 +3127,6 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		}
 	}
 
-	/*
-	 * The effective csses of all the descendants (excluding @cgrp) may
-	 * have changed.  Subsystems can optionally subscribe to this event
-	 * by implementing ->css_e_css_changed() which is invoked if any of
-	 * the effective csses seen from the css's cgroup may have changed.
-	 */
-	for_each_subsys(ss, ssid) {
-		struct cgroup_subsys_state *this_css = cgroup_css(cgrp, ss);
-		struct cgroup_subsys_state *css;
-
-		if (!ss->css_e_css_changed || !this_css)
-			continue;
-
-		css_for_each_descendant_pre(css, this_css)
-			if (css != this_css)
-				ss->css_e_css_changed(css);
-	}
-
 	kernfs_activate(cgrp->kn);
 	ret = 0;
 out_unlock:
-- 
2.5.0

