From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-3.19 2/3] cgroup: restructure child_subsys_mask
 handling in cgroup_subtree_control_write()
Date: Thu, 13 Nov 2014 16:58:48 -0500
Message-ID: <20141113215848.GB2598@htj.dyndns.org>
References: <20141113215813.GA2598@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+evrZaF1G7wN3XpU3jnbfJNY6A1FcFeqLCEqf1OVHfc=;
        b=OwJ9r2vDG1P4mx9QvixcXiOLZRXHCjPez4XT/iDKXX3eIZl0tbOC3gBTHV1V2ZBq2G
         a3MrVLun4a12YGJ3jU5tbC8yWrE3gKtE8iuvLDLu5kNiZa6m25xRcSvcviGq9Y586zgF
         4cEp34lVxvUF9361ik6UG1E0tVoQJXBnI1xyeloB6q61Jpewx775RXdrkFAYaghi15Ez
         igy107+tY9Z2sZ9CmRULoYE77q28GE9dfLPDy8VtXgQ/eIsENXaRd72zdYrFeYfZxeaW
         mWOhririG34pUc43FNzwl5lURNQ/WHK95uoS90YkHILHcYo5BA/q0bECOmU6SSHpnaHw
         N/og==
Content-Disposition: inline
In-Reply-To: <20141113215813.GA2598@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Make cgroup_subtree_control_write() first calculate new
subtree_control (new_sc), child_subsys_mask (new_ss) and
css_enable/disable masks before applying them to the cgroup.  Also,
store the original subtree_control (old_sc) and child_subsys_mask
(old_ss) and use them to restore the orignal state after failure.

This patch shouldn't cause any behavior changes.  This prepares for a
fix for a bug in the async css offline wait logic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2653,7 +2653,7 @@ static ssize_t cgroup_subtree_control_wr
 					    loff_t off)
 {
 	unsigned int enable = 0, disable = 0;
-	unsigned int css_enable, css_disable, old_ctrl, new_ctrl;
+	unsigned int css_enable, css_disable, old_sc, new_sc, old_ss, new_ss;
 	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
 	char *tok;
@@ -2770,18 +2770,19 @@ static ssize_t cgroup_subtree_control_wr
 	 * subsystems than specified may need to be enabled or disabled
 	 * depending on subsystem dependencies.
 	 */
-	cgrp->subtree_control |= enable;
-	cgrp->subtree_control &= ~disable;
+	old_sc = cgrp->subtree_control;
+	old_ss = cgrp->child_subsys_mask;
+	new_sc = (old_sc | enable) & ~disable;
+	new_ss = cgroup_calc_child_subsys_mask(cgrp, new_sc);
 
-	old_ctrl = cgrp->child_subsys_mask;
-	cgroup_refresh_child_subsys_mask(cgrp);
-	new_ctrl = cgrp->child_subsys_mask;
-
-	css_enable = ~old_ctrl & new_ctrl;
-	css_disable = old_ctrl & ~new_ctrl;
+	css_enable = ~old_ss & new_ss;
+	css_disable = old_ss & ~new_ss;
 	enable |= css_enable;
 	disable |= css_disable;
 
+	cgrp->subtree_control = new_sc;
+	cgrp->child_subsys_mask = new_ss;
+
 	/*
 	 * Create new csses or make the existing ones visible.  A css is
 	 * created invisible if it's being implicitly enabled through
@@ -2844,9 +2845,8 @@ out_unlock:
 	return ret ?: nbytes;
 
 err_undo_css:
-	cgrp->subtree_control &= ~enable;
-	cgrp->subtree_control |= disable;
-	cgroup_refresh_child_subsys_mask(cgrp);
+	cgrp->subtree_control = old_sc;
+	cgrp->child_subsys_mask = old_ss;
 
 	for_each_subsys(ss, ssid) {
 		if (!(enable & (1 << ssid)))
