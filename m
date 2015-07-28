From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 02/10] cgroup: introduce cgroup_subsys->legacy_name
Date: Tue, 28 Jul 2015 13:56:47 -0400
Message-ID: <20150728175647.GH5322@mtj.duckdns.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
 <1437763434-28699-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=saAMkUTYEo7mPfp97pWusqG8bWUu6nq+5SRynfOGHGo=;
        b=ZWICCbWoB7nIIrtdpqcLZZhs5BuS5Rm8TN8C5WdWi5MdyCe133rcP68TSrmIawIpME
         PSmM+QhahzV+4gj1MQWvxwUjcg/cbwkvlvdrNEyGscvtB1hwBD1odYIQGwv5H9L/b8ji
         9fVLeZCKSJne+vACGAr6leZBQ3niVXCgjtu+iyt9hAGcGc8UL71bbu0p0DVWeNlae3Uy
         x4M1YJd7c6BM8qmYBwr03VR9bdh5qhJQdt5N/+LLUDqVre9TIEMUg5zl4UDuK22qvdt8
         zDQb4SNSIxWVwkzf0QiY8W9AXTbheu8SnxCE07AVckOUYIKmTEaAsKla4kEcTT3iYHcH
         SIfg==
Content-Disposition: inline
In-Reply-To: <1437763434-28699-3-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, avanzini.arianna@gmail.com, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org

This allows cgroup subsystems to use a different name on the unified
hierarchy.  cgroup_subsys->name is used on the unified hierarchy,
->legacy_name elsewhere.  If ->legacy_name is not explicitly set, it's
automatically set to ->name and the userland visible behavior remains
unchanged.

v2: Make parse_cgroupfs_options() only consider ->legacy_name as mount
    options are used only on legacy hierarchies.  Suggested by Li
    Zefan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org
---
git branch updated accordingly.  Thanks.

 include/linux/cgroup-defs.h |  3 +++
 kernel/cgroup.c             | 29 ++++++++++++++++++-----------
 2 files changed, 21 insertions(+), 11 deletions(-)

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
index 6c85e6d..1276569 100644
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
@@ -1448,7 +1451,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 		}
 
 		for_each_subsys(ss, i) {
-			if (strcmp(token, ss->name))
+			if (strcmp(token, ss->legacy_name))
 				continue;
 			if (ss->disabled)
 				continue;
@@ -4994,6 +4997,8 @@ int __init cgroup_init_early(void)
 
 		ss->id = i;
 		ss->name = cgroup_subsys_name[i];
+		if (!ss->legacy_name)
+			ss->legacy_name = cgroup_subsys_name[i];
 
 		if (ss->early_init)
 			cgroup_init_subsys(ss, true);
@@ -5141,7 +5146,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 			for_each_subsys(ss, ssid)
 				if (root->subsys_mask & (1 << ssid))
 					seq_printf(m, "%s%s", count++ ? "," : "",
-						   ss->name);
+						   ss->legacy_name);
 		if (strlen(root->name))
 			seq_printf(m, "%sname=%s", count ? "," : "",
 				   root->name);
@@ -5181,7 +5186,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 
 	for_each_subsys(ss, i)
 		seq_printf(m, "%s\t%d\t%d\t%d\n",
-			   ss->name, ss->root->hierarchy_id,
+			   ss->legacy_name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps), !ss->disabled);
 
 	mutex_unlock(&cgroup_mutex);
@@ -5403,12 +5408,14 @@ static int __init cgroup_disable(char *str)
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
