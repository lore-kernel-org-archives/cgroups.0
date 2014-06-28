From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] cgroup: reorganize cgroup_subtree_control_write()
Date: Fri, 27 Jun 2014 21:03:07 -0400
Message-ID: <1403917392-32555-2-git-send-email-tj@kernel.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tLgqyLsh0sJdGTENCuN4PQpydJuYn7j8GdII5Vq3JRs=;
        b=WDSmjJwHqp9yALOYCH2c0WAiZUpNMa4I1v2vdQ5NpwC63Xvs6izcWR/IaNo99iOSC0
         QIHm8CtK99GJBBvMmZDi5BrJXla+yVhU9QDEfS+QQBghymV43o8s7LgktX7JFV4leAWU
         rZmFKVvefYgMiVoKDFWPqXHLFzR00fN2l+DCQXacNoTZ9dFCtNR9MJJLiWuIb/VdMLN8
         fdNTS9bw3uBivbHYue1W1xW+VHfECIvYKYY6nH/mwcR2maHseWt3aTf7Zwd9uwKOQeSc
         ESO5eP9ScORczVlyJ6uyFhVuvnBmusK2Edox1ad/uZgLCB3Ce97AE1pmdtG3Cwq86oLx
         +jlg==
In-Reply-To: <1403917392-32555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, vgoyal@redhat.com, axboe@kernel.dk, Tejun Heo <tj@kernel.org>

Make the following two reorganizations to
cgroup_subtree_control_write().  These are to prepare for future
changes and shouldn't cause any functional difference.

* Move availability above css offlining wait.

* Move cgrp->child_subsys_mask update above new css creation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7868fc3..a46d7e2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2613,6 +2613,14 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 				continue;
 			}
 
+			/* unavailable or not enabled on the parent? */
+			if (!(cgrp_dfl_root.subsys_mask & (1 << ssid)) ||
+			    (cgroup_parent(cgrp) &&
+			     !(cgroup_parent(cgrp)->child_subsys_mask & (1 << ssid)))) {
+				ret = -ENOENT;
+				goto out_unlock;
+			}
+
 			/*
 			 * Because css offlining is asynchronous, userland
 			 * might try to re-enable the same controller while
@@ -2635,14 +2643,6 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 				return restart_syscall();
 			}
-
-			/* unavailable or not enabled on the parent? */
-			if (!(cgrp_dfl_root.subsys_mask & (1 << ssid)) ||
-			    (cgroup_parent(cgrp) &&
-			     !(cgroup_parent(cgrp)->child_subsys_mask & (1 << ssid)))) {
-				ret = -ENOENT;
-				goto out_unlock;
-			}
 		} else if (disable & (1 << ssid)) {
 			if (!(cgrp->child_subsys_mask & (1 << ssid))) {
 				disable &= ~(1 << ssid);
@@ -2673,12 +2673,10 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
-	/*
-	 * Create csses for enables and update child_subsys_mask.  This
-	 * changes cgroup_e_css() results which in turn makes the
-	 * subsequent cgroup_update_dfl_csses() associate all tasks in the
-	 * subtree to the updated csses.
-	 */
+	cgrp->child_subsys_mask |= enable;
+	cgrp->child_subsys_mask &= ~disable;
+
+	/* create new csses */
 	for_each_subsys(ss, ssid) {
 		if (!(enable & (1 << ssid)))
 			continue;
@@ -2690,9 +2688,11 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		}
 	}
 
-	cgrp->child_subsys_mask |= enable;
-	cgrp->child_subsys_mask &= ~disable;
-
+	/*
+	 * At this point, cgroup_e_css() results reflect the new csses
+	 * making the following cgroup_update_dfl_csses() properly update
+	 * css associations of all tasks in the subtree.
+	 */
 	ret = cgroup_update_dfl_csses(cgrp);
 	if (ret)
 		goto err_undo_css;
-- 
1.9.3
