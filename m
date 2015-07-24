From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] cgroup: introduce cgroup_subsys->legacy_name
Date: Fri, 24 Jul 2015 14:43:46 -0400
Message-ID: <1437763434-28699-3-git-send-email-tj@kernel.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3uQTdS4/+JUQWFlguyKgdEFsMM1QKDI4fSYt4qI63J4=;
        b=ieEC3dQPZ5krkJ1Vn8jdAYO8U7BFPkQdREaWAflYHuIXISIe8o6xnkSYkqYbktKYzE
         fnOMEcNJxKn6D91NtdtyjzTg4AtvrO/EIUZx5WDDUimOJfIDiV/6/wVZWYpJePgJHLGx
         mBcgO3djyVA4WpbKyPRUgjHGIUiY9OrR9dlPjnh5UVjlGSIrYNQq834sGDslYCKDzsrP
         ktN4fZueBO3W7WfuyGF6NiwP0b1Z+GgvlmxNOJ4PahAIghojRDjkF0gRYEhWpGatujVu
         QMrDMGr60uw+/iP11h2VVtrON609LK0UDx7R0p98ql666OEorbdRm7eeHRiDia2tH/wN
         QGMw==
In-Reply-To: <1437763434-28699-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, avanzini.arianna@gmail.com, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

This allows cgroup subsystems to use a different name on the unified
hierarchy.  cgroup_subsys->name is used on the unified hierarchy,
->legacy_name elsewhere.  If ->legacy_name is not explicitly set, it's
automatically set to ->name and the userland visible behavior remains
unchanged.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org
---
 include/linux/cgroup-defs.h |  3 +++
 kernel/cgroup.c             | 30 +++++++++++++++++++-----------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8f5770a..7d0bb53 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -434,6 +434,9 @@ struct cgroup_subsys {
 	int id;
 	const char *name;
 
+	/* optional, initialized automatically during boot if not set */
+	const char *legacy_name;
+
 	/* link to parent, protected by cgroup_lock() */
 	struct cgroup_root *root;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6c85e6d..0da2efa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1027,10 +1027,13 @@ static const struct file_operations proc_cgroupstats_operations;
 static char *cgroup_file_name(struct cgroup *cgrp, const struct cftype *cft,
 			      char *buf)
 {
+	struct cgroup_subsys *ss = cft->ss;
+
 	if (cft->ss && !(cft->flags & CFTYPE_NO_PREFIX) &&
 	    !(cgrp->root->flags & CGRP_ROOT_NOPREFIX))
 		snprintf(buf, CGROUP_FILE_NAME_MAX, "%s.%s",
-			 cft->ss->name, cft->name);
+			 cgroup_on_dfl(cgrp) ? ss->name : ss->legacy_name,
+			 cft->name);
 	else
 		strncpy(buf, cft->name, CGROUP_FILE_NAME_MAX);
 	return buf;
@@ -1335,7 +1338,7 @@ static int cgroup_show_options(struct seq_file *seq,
 	if (root != &cgrp_dfl_root)
 		for_each_subsys(ss, ssid)
 			if (root->subsys_mask & (1 << ssid))
-				seq_printf(seq, ",%s", ss->name);
+				seq_printf(seq, ",%s", ss->legacy_name);
 	if (root->flags & CGRP_ROOT_NOPREFIX)
 		seq_puts(seq, ",noprefix");
 	if (root->flags & CGRP_ROOT_XATTR)
@@ -1448,7 +1451,8 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 		}
 
 		for_each_subsys(ss, i) {
-			if (strcmp(token, ss->name))
+			if (strcmp(token, ss->name) &&
+			    strcmp(token, ss->legacy_name))
 				continue;
 			if (ss->disabled)
 				continue;
@@ -4994,6 +4998,8 @@ int __init cgroup_init_early(void)
 
 		ss->id = i;
 		ss->name = cgroup_subsys_name[i];
+		if (!ss->legacy_name)
+			ss->legacy_name = cgroup_subsys_name[i];
 
 		if (ss->early_init)
 			cgroup_init_subsys(ss, true);
@@ -5141,7 +5147,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 			for_each_subsys(ss, ssid)
 				if (root->subsys_mask & (1 << ssid))
 					seq_printf(m, "%s%s", count++ ? "," : "",
-						   ss->name);
+						   ss->legacy_name);
 		if (strlen(root->name))
 			seq_printf(m, "%sname=%s", count ? "," : "",
 				   root->name);
@@ -5181,7 +5187,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 
 	for_each_subsys(ss, i)
 		seq_printf(m, "%s\t%d\t%d\t%d\n",
-			   ss->name, ss->root->hierarchy_id,
+			   ss->legacy_name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps), !ss->disabled);
 
 	mutex_unlock(&cgroup_mutex);
@@ -5403,12 +5409,14 @@ static int __init cgroup_disable(char *str)
 			continue;
 
 		for_each_subsys(ss, i) {
-			if (!strcmp(token, ss->name)) {
-				ss->disabled = 1;
-				printk(KERN_INFO "Disabling %s control group"
-					" subsystem\n", ss->name);
-				break;
-			}
+			if (strcmp(token, ss->name) &&
+			    strcmp(token, ss->legacy_name))
+				continue;
+
+			ss->disabled = 1;
+			printk(KERN_INFO "Disabling %s control group subsystem\n",
+			       ss->name);
+			break;
 		}
 	}
 	return 1;
-- 
2.4.3
