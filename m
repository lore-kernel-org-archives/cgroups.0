From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] cgroup: replace cgroup_subsys->disabled tests with cgroup_subsys_enabled()
Date: Tue, 15 Sep 2015 21:51:24 -0400
Message-ID: <1442368285-16306-4-git-send-email-tj@kernel.org>
References: <1442368285-16306-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YqCGltnOhX1faVxxfMO9JKRjY6xH4XElOLj4j/ntkts=;
        b=gV01OW6gR/naj4gNZ7DGgQA2hqAe+bCvwAhheNiFb8U1AROqQLs9lnqyA8iBhSgY6G
         zIfl3btl2Doe+Nv4B013nTA2ZU4VPcfQuS5WocxI61QIhrVvX9nRzoVe3I8ei4LYWZzR
         Evx7Hlt0J/uHl6z5/tFb4bQMcnfAVStFFE5HGpqIsvBPI8fNN1FzwOpDOX5oq35mIuL4
         Y7gxYDatoH6XCmVhCkRcr8oJOL4kIZfHbM6dUL9Zw3vfej2NWzz4NtlhQPYA24ZFBj0B
         KYaJ0xbw3lljPjUOfk0XgdOjZ+EhK3UmBKX/gMlxFjYBBt50cLFM4UCoz1cNDaRSdcdR
         GX5g==
In-Reply-To: <1442368285-16306-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>

Replace cgroup_subsys->disabled tests in controllers with
cgroup_subsys_enabled().  cgroup_subsys_enabled() requires literal
subsys name as its parameter and thus can't be used for cgroup core
which iterates through controllers.  For cgroup core, introduce and
use cgroup_ssid_enabled() which uses slower static_key_enabled() test
and can be indexed by subsys ID.

This leaves cgroup_subsys->disabled unused.  Removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
---
 include/linux/cgroup-defs.h    |  1 -
 include/linux/hugetlb_cgroup.h |  4 +---
 include/linux/memcontrol.h     |  4 +---
 kernel/cgroup.c                | 28 +++++++++++++++++++++-------
 4 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 4d8fcf2..c5d41c3 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -419,7 +419,6 @@ struct cgroup_subsys {
 		     struct task_struct *task);
 	void (*bind)(struct cgroup_subsys_state *root_css);
 
-	int disabled;
 	int early_init;
 
 	/*
diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index bcc853e..7edd305 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -48,9 +48,7 @@ int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
 
 static inline bool hugetlb_cgroup_disabled(void)
 {
-	if (hugetlb_cgrp_subsys.disabled)
-		return true;
-	return false;
+	return !cgroup_subsys_enabled(hugetlb_cgrp_subsys);
 }
 
 extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ad800e6..9aa7820 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -347,9 +347,7 @@ ino_t page_cgroup_ino(struct page *page);
 
 static inline bool mem_cgroup_disabled(void)
 {
-	if (memory_cgrp_subsys.disabled)
-		return true;
-	return false;
+	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3619389..5703ba7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -224,6 +224,19 @@ static void kill_css(struct cgroup_subsys_state *css);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
 
+/**
+ * cgroup_ssid_enabled - cgroup subsys enabled test by subsys ID
+ * @ssid: subsys ID of interest
+ *
+ * cgroup_subsys_enabled() can only be used with literal subsys names which
+ * is fine for individual subsystems but unsuitable for cgroup core.  This
+ * is slower static_key_enabled() based test indexed by @ssid.
+ */
+static bool cgroup_ssid_enabled(int ssid)
+{
+	return static_key_enabled(cgroup_subsys_enabled_key[ssid]);
+}
+
 /* IDR wrappers which synchronize using cgroup_idr_lock */
 static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
 			    gfp_t gfp_mask)
@@ -1482,7 +1495,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 		for_each_subsys(ss, i) {
 			if (strcmp(token, ss->legacy_name))
 				continue;
-			if (ss->disabled)
+			if (!cgroup_ssid_enabled(i))
 				continue;
 
 			/* Mutually exclusive option 'all' + subsystem name */
@@ -1513,7 +1526,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	 */
 	if (all_ss || (!one_ss && !opts->none && !opts->name))
 		for_each_subsys(ss, i)
-			if (!ss->disabled)
+			if (cgroup_ssid_enabled(i))
 				opts->subsys_mask |= (1 << i);
 
 	/*
@@ -2762,7 +2775,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		if (tok[0] == '\0')
 			continue;
 		for_each_subsys_which(ss, ssid, &tmp_ss_mask) {
-			if (ss->disabled || strcmp(tok + 1, ss->name))
+			if (!cgroup_ssid_enabled(ssid) ||
+			    strcmp(tok + 1, ss->name))
 				continue;
 
 			if (*tok == '+') {
@@ -3320,7 +3334,7 @@ static int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	int ret;
 
-	if (ss->disabled)
+	if (!cgroup_ssid_enabled(ss->id))
 		return 0;
 
 	if (!cfts || cfts[0].name[0] == '\0')
@@ -5082,7 +5096,7 @@ int __init cgroup_init(void)
 		 * disabled flag and cftype registration needs kmalloc,
 		 * both of which aren't available during early_init.
 		 */
-		if (ss->disabled)
+		if (!cgroup_ssid_enabled(ssid))
 			continue;
 
 		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
@@ -5217,7 +5231,8 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 	for_each_subsys(ss, i)
 		seq_printf(m, "%s\t%d\t%d\t%d\n",
 			   ss->legacy_name, ss->root->hierarchy_id,
-			   atomic_read(&ss->root->nr_cgrps), !ss->disabled);
+			   atomic_read(&ss->root->nr_cgrps),
+			   cgroup_ssid_enabled(i));
 
 	mutex_unlock(&cgroup_mutex);
 	return 0;
@@ -5508,7 +5523,6 @@ static int __init cgroup_disable(char *str)
 				continue;
 
 			static_branch_disable(cgroup_subsys_enabled_key[i]);
-			ss->disabled = 1;
 			printk(KERN_INFO "Disabling %s control group subsystem\n",
 			       ss->name);
 			break;
-- 
2.4.3
