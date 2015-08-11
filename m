From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/8] cgroup: relocate cgroup_populate_dir()
Date: Tue, 11 Aug 2015 13:58:04 -0400
Message-ID: <1439315889-3492-4-git-send-email-tj@kernel.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+L5OT+guyBlaAdweA/jlf39XEDZO0rSX2WhsNsk8GbI=;
        b=OBGGBoana7gVdx6iDay5XjrGUSr6nOvhtcQ7tkq1FXOkDIW/ipczTNghsZOK4tgzmC
         nWv2VIpqy45hOwbD3/dRywPB3AGsK5ErwFOkwgN/0UQAC/f3Eb9FlZV2kEhScwcVj4HH
         zIWxyJuyQUldQTXrKPddbdMomEOXmoe0bzVSnDFkxM80foLZRw6TzhuFQG9wXooi6mLD
         wkjUKG61UQpJIBdHOULrkZAKFtYXVzm9UerpSih+RcAbHXz9x1i+6kil74UkXcs5ctrG
         Uij6NInV+cuU+Cd9WUwKlVOSvCmx+/Ye/5W9zGmcJPEOhXDZ1n4HnmByZvCqg66LA9G7
         NNyg==
In-Reply-To: <1439315889-3492-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Move it upwards so that it's right below cgroup_clear_dir() and the
forward declaration is unnecessary.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 kernel/cgroup.c | 63 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a909e4d..92b8cc7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1024,7 +1024,6 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
  * update of a tasks cgroup pointer by cgroup_attach_task()
  */
 
-static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask);
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops;
 static const struct file_operations proc_cgroupstats_operations;
 
@@ -1238,6 +1237,37 @@ static void cgroup_clear_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 	}
 }
 
+/**
+ * cgroup_populate_dir - create subsys files in a cgroup directory
+ * @cgrp: target cgroup
+ * @subsys_mask: mask of the subsystem ids whose files should be added
+ *
+ * On failure, no file is added.
+ */
+static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
+{
+	struct cgroup_subsys *ss;
+	int i, ret = 0;
+
+	/* process cftsets of each subsystem */
+	for_each_subsys(ss, i) {
+		struct cftype *cfts;
+
+		if (!(subsys_mask & (1 << i)))
+			continue;
+
+		list_for_each_entry(cfts, &ss->cfts, node) {
+			ret = cgroup_addrm_files(cgrp, cfts, true);
+			if (ret < 0)
+				goto err;
+		}
+	}
+	return 0;
+err:
+	cgroup_clear_dir(cgrp, subsys_mask);
+	return ret;
+}
+
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned long ss_mask)
 {
@@ -4337,37 +4367,6 @@ static struct cftype cgroup_legacy_base_files[] = {
 	{ }	/* terminate */
 };
 
-/**
- * cgroup_populate_dir - create subsys files in a cgroup directory
- * @cgrp: target cgroup
- * @subsys_mask: mask of the subsystem ids whose files should be added
- *
- * On failure, no file is added.
- */
-static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
-{
-	struct cgroup_subsys *ss;
-	int i, ret = 0;
-
-	/* process cftsets of each subsystem */
-	for_each_subsys(ss, i) {
-		struct cftype *cfts;
-
-		if (!(subsys_mask & (1 << i)))
-			continue;
-
-		list_for_each_entry(cfts, &ss->cfts, node) {
-			ret = cgroup_addrm_files(cgrp, cfts, true);
-			if (ret < 0)
-				goto err;
-		}
-	}
-	return 0;
-err:
-	cgroup_clear_dir(cgrp, subsys_mask);
-	return ret;
-}
-
 /*
  * css destruction is four-stage process.
  *
-- 
2.4.3
