From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-3.19 1/3] cgroup: separate out
 cgroup_calc_child_subsys_mask() from cgroup_refresh_child_subsys_mask()
Date: Thu, 13 Nov 2014 16:58:13 -0500
Message-ID: <20141113215813.GA2598@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=gdk4A6u/diF7Tyn7FdBalVMZ9UlM5l26lo25PYlm4dU=;
        b=vd6CYVyOvF4mSWlUHCDv3K24Lx5yyItg4osFdwu9nqbfnGGs721M2F1/rz62S+v72x
         pZUAcIf7DyQEO4IUJlbeyOtptkxFWvdYI9fgpjLo64YzWcb6OJh8ZTuTZM/LUjdXxdu8
         fxg/IgK31ECGaQ/5av8G9HACMN9dOg2Yq+9buwWSdANWdO3suhKD5zyHERYPYdlvu4IS
         BiIDR7l1d5SvZ6RCIqCnwNAoyH6g9cqXRrYR8MSMDaXYPuGx1y/+Tsxve7tdkHHQ3cCy
         Wzhz06UbiBWw24as3/OGLGGDYoL3TlOUUwjiBAlfgpt+8j6KWiMVWTFWuBrDcPHu8Kg1
         Skmg==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

cgroup_refresh_child_subsys_mask() calculates and updates the
effective @cgrp->child_subsys_maks according to the current
@cgrp->subtree_control.  Separate out the calculation part into
cgroup_calc_child_subsys_mask().  This will be used to fix a bug in
the async css offline wait logic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1019,31 +1019,30 @@ static void cgroup_put(struct cgroup *cg
 }
 
 /**
- * cgroup_refresh_child_subsys_mask - update child_subsys_mask
+ * cgroup_calc_child_subsys_mask - calculate child_subsys_mask
  * @cgrp: the target cgroup
+ * @subtree_control: the new subtree_control mask to consider
  *
  * On the default hierarchy, a subsystem may request other subsystems to be
  * enabled together through its ->depends_on mask.  In such cases, more
  * subsystems than specified in "cgroup.subtree_control" may be enabled.
  *
- * This function determines which subsystems need to be enabled given the
- * current @cgrp->subtree_control and records it in
- * @cgrp->child_subsys_mask.  The resulting mask is always a superset of
- * @cgrp->subtree_control and follows the usual hierarchy rules.
+ * This function calculates which subsystems need to be enabled if
+ * @subtree_control is to be applied to @cgrp.  The returned mask is always
+ * a superset of @subtree_control and follows the usual hierarchy rules.
  */
-static void cgroup_refresh_child_subsys_mask(struct cgroup *cgrp)
+static unsigned int cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
+						  unsigned int subtree_control)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
-	unsigned int cur_ss_mask = cgrp->subtree_control;
+	unsigned int cur_ss_mask = subtree_control;
 	struct cgroup_subsys *ss;
 	int ssid;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	if (!cgroup_on_dfl(cgrp)) {
-		cgrp->child_subsys_mask = cur_ss_mask;
-		return;
-	}
+	if (!cgroup_on_dfl(cgrp))
+		return cur_ss_mask;
 
 	while (true) {
 		unsigned int new_ss_mask = cur_ss_mask;
@@ -1067,7 +1066,20 @@ static void cgroup_refresh_child_subsys_
 		cur_ss_mask = new_ss_mask;
 	}
 
-	cgrp->child_subsys_mask = cur_ss_mask;
+	return cur_ss_mask;
+}
+
+/**
+ * cgroup_refresh_child_subsys_mask - update child_subsys_mask
+ * @cgrp: the target cgroup
+ *
+ * Update @cgrp->child_subsys_mask according to the current
+ * @cgrp->subtree_control using cgroup_calc_child_subsys_mask().
+ */
+static void cgroup_refresh_child_subsys_mask(struct cgroup *cgrp)
+{
+	cgrp->child_subsys_mask =
+		cgroup_calc_child_subsys_mask(cgrp, cgrp->subtree_control);
 }
 
 /**
