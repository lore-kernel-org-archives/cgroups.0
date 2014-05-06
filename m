From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 2/5] cgroup: replace cftype->write_string() with
 cftype->write()
Date: Tue, 6 May 2014 10:07:19 -0400
Message-ID: <20140506140719.GD27738@htj.dyndns.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
 <1399380266-3324-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iE/zu+7NebF7DgFG7k7BI4pqraNAsvZwZqGfOhdHDFE=;
        b=cLqtgvslUUmY0oYmR7bazEsCkOWBKPaAU65DQCT3+vPPxIXovxdfLfRMA5F9jSR98G
         ZjLB412XSbUNaJy8NBO64qpVMhRsSueC1Ho/2AcYuMR3K2zEgHnH5tCnwDTz0qTJbtXU
         8AgSRxK4Rg8NhW7sD+drHgZknve1N/mw7WSnMUfXh1+4VFX3sS1YnL/7I+Vkqc/4/zzs
         6b4rjWQ19cDPrnGI2wpDbjVx5wbl2/cQg2B2ZnSYXZHItce3IaurvUEmdMV+eQh9QKNk
         xedFQOXB/Vlro+yA6haiLZ2T9JAMWNfFMCGH/CLiMLtphX1DtpoTHcNpHBk8VlRd5WwV
         Pzyg==
Content-Disposition: inline
In-Reply-To: <1399380266-3324-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

Convert all cftype->write_string() users to the new cftype->write()
which maps directly to kernfs write operation and has full access to
kernfs and cgroup contexts.  The conversions are mostly mechanical.

* @css and @cft are accessed using of_css() and of_cft() accessors
  respectively instead of being specified as arguments.

* Should return @nbytes on success instead of 0.

* @buf is not trimmed automatically.  Trim if necessary.  Note that
  blkcg and netprio don't need this as the parsers already handle
  whitespaces.

cftype->write_string() has no user left after the conversions and
removed.

While at it, remove unnecessary local variable @p in
cgroup_subtree_control_write() and stale comment about
CGROUP_LOCAL_BUFFER_SIZE in cgroup_freezer.c.

This patch doesn't introduce any visible behavior changes.

v2: netprio was missing from conversion.  Converted.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
---
 block/blk-throttle.c      | 32 ++++++++++++++++----------------
 block/cfq-iosched.c       | 28 ++++++++++++++--------------
 include/linux/cgroup.h    | 10 +---------
 kernel/cgroup.c           | 38 +++++++++++++++++++-------------------
 kernel/cgroup_freezer.c   | 20 +++++++++-----------
 kernel/cpuset.c           | 16 +++++++++-------
 mm/hugetlb_cgroup.c       | 17 +++++++++--------
 mm/memcontrol.c           | 46 +++++++++++++++++++++++++---------------------
 net/core/netprio_cgroup.c | 12 ++++++------
 net/ipv4/tcp_memcontrol.c | 16 +++++++++-------
 security/device_cgroup.c  | 14 +++++++-------
 11 files changed, 124 insertions(+), 125 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 033745c..5e8fd1b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1346,10 +1346,10 @@ static int tg_print_conf_uint(struct seq_file *sf, void *v)
 	return 0;
 }
 
-static int tg_set_conf(struct cgroup_subsys_state *css, struct cftype *cft,
-		       const char *buf, bool is_u64)
+static ssize_t tg_set_conf(struct kernfs_open_file *of,
+			   char *buf, size_t nbytes, loff_t off, bool is_u64)
 {
-	struct blkcg *blkcg = css_to_blkcg(css);
+	struct blkcg *blkcg = css_to_blkcg(of_css(of));
 	struct blkg_conf_ctx ctx;
 	struct throtl_grp *tg;
 	struct throtl_service_queue *sq;
@@ -1368,9 +1368,9 @@ static int tg_set_conf(struct cgroup_subsys_state *css, struct cftype *cft,
 		ctx.v = -1;
 
 	if (is_u64)
-		*(u64 *)((void *)tg + cft->private) = ctx.v;
+		*(u64 *)((void *)tg + of_cft(of)->private) = ctx.v;
 	else
-		*(unsigned int *)((void *)tg + cft->private) = ctx.v;
+		*(unsigned int *)((void *)tg + of_cft(of)->private) = ctx.v;
 
 	throtl_log(&tg->service_queue,
 		   "limit change rbps=%llu wbps=%llu riops=%u wiops=%u",
@@ -1404,19 +1404,19 @@ static int tg_set_conf(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 
 	blkg_conf_finish(&ctx);
-	return 0;
+	return nbytes;
 }
 
-static int tg_set_conf_u64(struct cgroup_subsys_state *css, struct cftype *cft,
-			   char *buf)
+static ssize_t tg_set_conf_u64(struct kernfs_open_file *of,
+			       char *buf, size_t nbytes, loff_t off)
 {
-	return tg_set_conf(css, cft, buf, true);
+	return tg_set_conf(of, buf, nbytes, off, true);
 }
 
-static int tg_set_conf_uint(struct cgroup_subsys_state *css, struct cftype *cft,
-			    char *buf)
+static ssize_t tg_set_conf_uint(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
 {
-	return tg_set_conf(css, cft, buf, false);
+	return tg_set_conf(of, buf, nbytes, off, false);
 }
 
 static struct cftype throtl_files[] = {
@@ -1424,25 +1424,25 @@ static struct cftype throtl_files[] = {
 		.name = "throttle.read_bps_device",
 		.private = offsetof(struct throtl_grp, bps[READ]),
 		.seq_show = tg_print_conf_u64,
-		.write_string = tg_set_conf_u64,
+		.write = tg_set_conf_u64,
 	},
 	{
 		.name = "throttle.write_bps_device",
 		.private = offsetof(struct throtl_grp, bps[WRITE]),
 		.seq_show = tg_print_conf_u64,
-		.write_string = tg_set_conf_u64,
+		.write = tg_set_conf_u64,
 	},
 	{
 		.name = "throttle.read_iops_device",
 		.private = offsetof(struct throtl_grp, iops[READ]),
 		.seq_show = tg_print_conf_uint,
-		.write_string = tg_set_conf_uint,
+		.write = tg_set_conf_uint,
 	},
 	{
 		.name = "throttle.write_iops_device",
 		.private = offsetof(struct throtl_grp, iops[WRITE]),
 		.seq_show = tg_print_conf_uint,
-		.write_string = tg_set_conf_uint,
+		.write = tg_set_conf_uint,
 	},
 	{
 		.name = "throttle.io_service_bytes",
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e0985f1..a73020b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1670,11 +1670,11 @@ static int cfq_print_leaf_weight(struct seq_file *sf, void *v)
 	return 0;
 }
 
-static int __cfqg_set_weight_device(struct cgroup_subsys_state *css,
-				    struct cftype *cft, const char *buf,
-				    bool is_leaf_weight)
+static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
+					char *buf, size_t nbytes, loff_t off,
+					bool is_leaf_weight)
 {
-	struct blkcg *blkcg = css_to_blkcg(css);
+	struct blkcg *blkcg = css_to_blkcg(of_css(of));
 	struct blkg_conf_ctx ctx;
 	struct cfq_group *cfqg;
 	int ret;
@@ -1697,19 +1697,19 @@ static int __cfqg_set_weight_device(struct cgroup_subsys_state *css,
 	}
 
 	blkg_conf_finish(&ctx);
-	return ret;
+	return ret ?: nbytes;
 }
 
-static int cfqg_set_weight_device(struct cgroup_subsys_state *css,
-				  struct cftype *cft, char *buf)
+static ssize_t cfqg_set_weight_device(struct kernfs_open_file *of,
+				      char *buf, size_t nbytes, loff_t off)
 {
-	return __cfqg_set_weight_device(css, cft, buf, false);
+	return __cfqg_set_weight_device(of, buf, nbytes, off, false);
 }
 
-static int cfqg_set_leaf_weight_device(struct cgroup_subsys_state *css,
-				       struct cftype *cft, char *buf)
+static ssize_t cfqg_set_leaf_weight_device(struct kernfs_open_file *of,
+					   char *buf, size_t nbytes, loff_t off)
 {
-	return __cfqg_set_weight_device(css, cft, buf, true);
+	return __cfqg_set_weight_device(of, buf, nbytes, off, true);
 }
 
 static int __cfq_set_weight(struct cgroup_subsys_state *css, struct cftype *cft,
@@ -1837,7 +1837,7 @@ static struct cftype cfq_blkcg_files[] = {
 		.name = "weight_device",
 		.flags = CFTYPE_ONLY_ON_ROOT,
 		.seq_show = cfqg_print_leaf_weight_device,
-		.write_string = cfqg_set_leaf_weight_device,
+		.write = cfqg_set_leaf_weight_device,
 	},
 	{
 		.name = "weight",
@@ -1851,7 +1851,7 @@ static struct cftype cfq_blkcg_files[] = {
 		.name = "weight_device",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = cfqg_print_weight_device,
-		.write_string = cfqg_set_weight_device,
+		.write = cfqg_set_weight_device,
 	},
 	{
 		.name = "weight",
@@ -1863,7 +1863,7 @@ static struct cftype cfq_blkcg_files[] = {
 	{
 		.name = "leaf_weight_device",
 		.seq_show = cfqg_print_leaf_weight_device,
-		.write_string = cfqg_set_leaf_weight_device,
+		.write = cfqg_set_leaf_weight_device,
 	},
 	{
 		.name = "leaf_weight",
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index da7a0ca..5f717d7 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -455,8 +455,7 @@ struct cftype {
 
 	/*
 	 * The maximum length of string, excluding trailing nul, that can
-	 * be passed to write_string.  If < PAGE_SIZE-1, PAGE_SIZE-1 is
-	 * assumed.
+	 * be passed to write.  If < PAGE_SIZE-1, PAGE_SIZE-1 is assumed.
 	 */
 	size_t max_write_len;
 
@@ -503,13 +502,6 @@ struct cftype {
 			 s64 val);
 
 	/*
-	 * write_string() is passed a nul-terminated kernelspace
-	 * buffer of maximum length determined by max_write_len.
-	 * Returns 0 or -ve error code.
-	 */
-	int (*write_string)(struct cgroup_subsys_state *css, struct cftype *cft,
-			    char *buffer);
-	/*
 	 * trigger() callback can be used to get some kick from the
 	 * userspace, when the actual string written is not important
 	 * at all. The private field can be used to determine the
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f8fc556..39d7f65 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1035,7 +1035,7 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 		mode |= S_IRUGO;
 
 	if (cft->write_u64 || cft->write_s64 || cft->write ||
-	    cft->write_string || cft->trigger)
+	    cft->trigger)
 		mode |= S_IWUSR;
 
 	return mode;
@@ -2352,20 +2352,21 @@ static int cgroup_procs_write(struct cgroup_subsys_state *css,
 	return attach_task_by_pid(css->cgroup, tgid, true);
 }
 
-static int cgroup_release_agent_write(struct cgroup_subsys_state *css,
-				      struct cftype *cft, char *buffer)
+static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
+					  char *buf, size_t nbytes, loff_t off)
 {
-	struct cgroup_root *root = css->cgroup->root;
+	struct cgroup *cgrp = of_css(of)->cgroup;
+	struct cgroup_root *root = cgrp->root;
 
 	BUILD_BUG_ON(sizeof(root->release_agent_path) < PATH_MAX);
-	if (!cgroup_lock_live_group(css->cgroup))
+	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
 	spin_lock(&release_agent_path_lock);
-	strlcpy(root->release_agent_path, buffer,
+	strlcpy(root->release_agent_path, strstrip(buf),
 		sizeof(root->release_agent_path));
 	spin_unlock(&release_agent_path_lock);
 	mutex_unlock(&cgroup_mutex);
-	return 0;
+	return nbytes;
 }
 
 static int cgroup_release_agent_show(struct seq_file *seq, void *v)
@@ -2530,21 +2531,22 @@ out_finish:
 }
 
 /* change the enabled child controllers for a cgroup in the default hierarchy */
-static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
-					struct cftype *cft, char *buffer)
+static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
+					    char *buf, size_t nbytes,
+					    loff_t off)
 {
 	unsigned int enable = 0, disable = 0;
-	struct cgroup *cgrp = dummy_css->cgroup, *child;
+	struct cgroup *cgrp = of_css(of)->cgroup, *child;
 	struct cgroup_subsys *ss;
-	char *tok, *p;
+	char *tok;
 	int ssid, ret;
 
 	/*
 	 * Parse input - space separated list of subsystem names prefixed
 	 * with either + or -.
 	 */
-	p = buffer;
-	while ((tok = strsep(&p, " "))) {
+	buf = strstrip(buf);
+	while ((tok = strsep(&buf, " "))) {
 		if (tok[0] =='\0')
 			continue;
 		for_each_subsys(ss, ssid) {
@@ -2692,7 +2694,7 @@ out_unlock_tree:
 out_unbreak:
 	kernfs_unbreak_active_protection(cgrp->control_kn);
 	cgroup_put(cgrp);
-	return ret;
+	return ret ?: nbytes;
 
 err_undo_css:
 	cgrp->child_subsys_mask &= ~enable;
@@ -2738,9 +2740,7 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	css = cgroup_css(cgrp, cft->ss);
 	rcu_read_unlock();
 
-	if (cft->write_string) {
-		ret = cft->write_string(css, cft, strstrip(buf));
-	} else if (cft->write_u64) {
+	if (cft->write_u64) {
 		unsigned long long v;
 		ret = kstrtoull(buf, 0, &v);
 		if (!ret)
@@ -3984,7 +3984,7 @@ static struct cftype cgroup_base_files[] = {
 		.name = "cgroup.subtree_control",
 		.flags = CFTYPE_ONLY_ON_DFL,
 		.seq_show = cgroup_subtree_control_show,
-		.write_string = cgroup_subtree_control_write,
+		.write = cgroup_subtree_control_write,
 	},
 	{
 		.name = "cgroup.populated",
@@ -4018,7 +4018,7 @@ static struct cftype cgroup_base_files[] = {
 		.name = "release_agent",
 		.flags = CFTYPE_INSANE | CFTYPE_ONLY_ON_ROOT,
 		.seq_show = cgroup_release_agent_show,
-		.write_string = cgroup_release_agent_write,
+		.write = cgroup_release_agent_write,
 		.max_write_len = PATH_MAX - 1,
 	},
 	{ }	/* terminate */
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 2bc4a22..d2b4bc7 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -71,10 +71,6 @@ bool cgroup_freezing(struct task_struct *task)
 	return ret;
 }
 
-/*
- * cgroups_write_string() limits the size of freezer state strings to
- * CGROUP_LOCAL_BUFFER_SIZE
- */
 static const char *freezer_state_strs(unsigned int state)
 {
 	if (state & CGROUP_FROZEN)
@@ -441,20 +437,22 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
 	rcu_read_unlock();
 }
 
-static int freezer_write(struct cgroup_subsys_state *css, struct cftype *cft,
-			 char *buffer)
+static ssize_t freezer_write(struct kernfs_open_file *of,
+			     char *buf, size_t nbytes, loff_t off)
 {
 	bool freeze;
 
-	if (strcmp(buffer, freezer_state_strs(0)) == 0)
+	buf = strstrip(buf);
+
+	if (strcmp(buf, freezer_state_strs(0)) == 0)
 		freeze = false;
-	else if (strcmp(buffer, freezer_state_strs(CGROUP_FROZEN)) == 0)
+	else if (strcmp(buf, freezer_state_strs(CGROUP_FROZEN)) == 0)
 		freeze = true;
 	else
 		return -EINVAL;
 
-	freezer_change_state(css_freezer(css), freeze);
-	return 0;
+	freezer_change_state(css_freezer(of_css(of)), freeze);
+	return nbytes;
 }
 
 static u64 freezer_self_freezing_read(struct cgroup_subsys_state *css,
@@ -478,7 +476,7 @@ static struct cftype files[] = {
 		.name = "state",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = freezer_read,
-		.write_string = freezer_write,
+		.write = freezer_write,
 	},
 	{
 		.name = "self_freezing",
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 7c0e8da..97cbb59 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1603,13 +1603,15 @@ out_unlock:
 /*
  * Common handling for a write to a "cpus" or "mems" file.
  */
-static int cpuset_write_resmask(struct cgroup_subsys_state *css,
-				struct cftype *cft, char *buf)
+static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
+				    char *buf, size_t nbytes, loff_t off)
 {
-	struct cpuset *cs = css_cs(css);
+	struct cpuset *cs = css_cs(of_css(of));
 	struct cpuset *trialcs;
 	int retval = -ENODEV;
 
+	buf = strstrip(buf);
+
 	/*
 	 * CPU or memory hotunplug may leave @cs w/o any execution
 	 * resources, in which case the hotplug code asynchronously updates
@@ -1633,7 +1635,7 @@ static int cpuset_write_resmask(struct cgroup_subsys_state *css,
 		goto out_unlock;
 	}
 
-	switch (cft->private) {
+	switch (of_cft(of)->private) {
 	case FILE_CPULIST:
 		retval = update_cpumask(cs, trialcs, buf);
 		break;
@@ -1648,7 +1650,7 @@ static int cpuset_write_resmask(struct cgroup_subsys_state *css,
 	free_trial_cpuset(trialcs);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
-	return retval;
+	return retval ?: nbytes;
 }
 
 /*
@@ -1750,7 +1752,7 @@ static struct cftype files[] = {
 	{
 		.name = "cpus",
 		.seq_show = cpuset_common_seq_show,
-		.write_string = cpuset_write_resmask,
+		.write = cpuset_write_resmask,
 		.max_write_len = (100U + 6 * NR_CPUS),
 		.private = FILE_CPULIST,
 	},
@@ -1758,7 +1760,7 @@ static struct cftype files[] = {
 	{
 		.name = "mems",
 		.seq_show = cpuset_common_seq_show,
-		.write_string = cpuset_write_resmask,
+		.write = cpuset_write_resmask,
 		.max_write_len = (100U + 6 * MAX_NUMNODES),
 		.private = FILE_MEMLIST,
 	},
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 595d7fd..faea871 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -253,15 +253,16 @@ static u64 hugetlb_cgroup_read_u64(struct cgroup_subsys_state *css,
 	return res_counter_read_u64(&h_cg->hugepage[idx], name);
 }
 
-static int hugetlb_cgroup_write(struct cgroup_subsys_state *css,
-				struct cftype *cft, char *buffer)
+static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
+				    char *buf, size_t nbytes, loff_t off)
 {
 	int idx, name, ret;
 	unsigned long long val;
-	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(css);
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
 
-	idx = MEMFILE_IDX(cft->private);
-	name = MEMFILE_ATTR(cft->private);
+	buf = strstrip(buf);
+	idx = MEMFILE_IDX(of_cft(of)->private);
+	name = MEMFILE_ATTR(of_cft(of)->private);
 
 	switch (name) {
 	case RES_LIMIT:
@@ -271,7 +272,7 @@ static int hugetlb_cgroup_write(struct cgroup_subsys_state *css,
 			break;
 		}
 		/* This function does all necessary parse...reuse it */
-		ret = res_counter_memparse_write_strategy(buffer, &val);
+		ret = res_counter_memparse_write_strategy(buf, &val);
 		if (ret)
 			break;
 		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
@@ -280,7 +281,7 @@ static int hugetlb_cgroup_write(struct cgroup_subsys_state *css,
 		ret = -EINVAL;
 		break;
 	}
-	return ret;
+	return ret ?: nbytes;
 }
 
 static int hugetlb_cgroup_reset(struct cgroup_subsys_state *css,
@@ -331,7 +332,7 @@ static void __init __hugetlb_cgroup_file_init(int idx)
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.limit_in_bytes", buf);
 	cft->private = MEMFILE_PRIVATE(idx, RES_LIMIT);
 	cft->read_u64 = hugetlb_cgroup_read_u64;
-	cft->write_string = hugetlb_cgroup_write;
+	cft->write = hugetlb_cgroup_write;
 
 	/* Add the usage file */
 	cft = &h->cgroup_files[1];
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3f82f6..0258419 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5141,17 +5141,18 @@ static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
  * The user of this function is...
  * RES_LIMIT.
  */
-static int mem_cgroup_write(struct cgroup_subsys_state *css, struct cftype *cft,
-			    char *buffer)
+static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
 {
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	enum res_type type;
 	int name;
 	unsigned long long val;
 	int ret;
 
-	type = MEMFILE_TYPE(cft->private);
-	name = MEMFILE_ATTR(cft->private);
+	buf = strstrip(buf);
+	type = MEMFILE_TYPE(of_cft(of)->private);
+	name = MEMFILE_ATTR(of_cft(of)->private);
 
 	switch (name) {
 	case RES_LIMIT:
@@ -5160,7 +5161,7 @@ static int mem_cgroup_write(struct cgroup_subsys_state *css, struct cftype *cft,
 			break;
 		}
 		/* This function does all necessary parse...reuse it */
-		ret = res_counter_memparse_write_strategy(buffer, &val);
+		ret = res_counter_memparse_write_strategy(buf, &val);
 		if (ret)
 			break;
 		if (type == _MEM)
@@ -5173,7 +5174,7 @@ static int mem_cgroup_write(struct cgroup_subsys_state *css, struct cftype *cft,
 			return -EINVAL;
 		break;
 	case RES_SOFT_LIMIT:
-		ret = res_counter_memparse_write_strategy(buffer, &val);
+		ret = res_counter_memparse_write_strategy(buf, &val);
 		if (ret)
 			break;
 		/*
@@ -5190,7 +5191,7 @@ static int mem_cgroup_write(struct cgroup_subsys_state *css, struct cftype *cft,
 		ret = -EINVAL; /* should be BUG() ? */
 		break;
 	}
-	return ret;
+	return ret ?: nbytes;
 }
 
 static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
@@ -5962,9 +5963,10 @@ static void memcg_event_ptable_queue_proc(struct file *file,
  * Input must be in format '<event_fd> <control_fd> <args>'.
  * Interpretation of args is defined by control file implementation.
  */
-static int memcg_write_event_control(struct cgroup_subsys_state *css,
-				     struct cftype *cft, char *buffer)
+static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
+					 char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_subsys_state *css = of_css(of);
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup_event *event;
 	struct cgroup_subsys_state *cfile_css;
@@ -5975,15 +5977,17 @@ static int memcg_write_event_control(struct cgroup_subsys_state *css,
 	char *endp;
 	int ret;
 
-	efd = simple_strtoul(buffer, &endp, 10);
+	buf = strstrip(buf);
+
+	efd = simple_strtoul(buf, &endp, 10);
 	if (*endp != ' ')
 		return -EINVAL;
-	buffer = endp + 1;
+	buf = endp + 1;
 
-	cfd = simple_strtoul(buffer, &endp, 10);
+	cfd = simple_strtoul(buf, &endp, 10);
 	if ((*endp != ' ') && (*endp != '\0'))
 		return -EINVAL;
-	buffer = endp + 1;
+	buf = endp + 1;
 
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (!event)
@@ -6061,7 +6065,7 @@ static int memcg_write_event_control(struct cgroup_subsys_state *css,
 		goto out_put_cfile;
 	}
 
-	ret = event->register_event(memcg, event->eventfd, buffer);
+	ret = event->register_event(memcg, event->eventfd, buf);
 	if (ret)
 		goto out_put_css;
 
@@ -6074,7 +6078,7 @@ static int memcg_write_event_control(struct cgroup_subsys_state *css,
 	fdput(cfile);
 	fdput(efile);
 
-	return 0;
+	return nbytes;
 
 out_put_css:
 	css_put(css);
@@ -6105,13 +6109,13 @@ static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_LIMIT),
-		.write_string = mem_cgroup_write,
+		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
 		.name = "soft_limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
-		.write_string = mem_cgroup_write,
+		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
@@ -6136,7 +6140,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "cgroup.event_control",		/* XXX: for compat */
-		.write_string = memcg_write_event_control,
+		.write = memcg_write_event_control,
 		.flags = CFTYPE_NO_PREFIX,
 		.mode = S_IWUGO,
 	},
@@ -6169,7 +6173,7 @@ static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "kmem.limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
-		.write_string = mem_cgroup_write,
+		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
@@ -6215,7 +6219,7 @@ static struct cftype memsw_cgroup_files[] = {
 	{
 		.name = "memsw.limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_LIMIT),
-		.write_string = mem_cgroup_write,
+		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 3825f66..b990cef 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -185,15 +185,15 @@ static int read_priomap(struct seq_file *sf, void *v)
 	return 0;
 }
 
-static int write_priomap(struct cgroup_subsys_state *css, struct cftype *cft,
-			 char *buffer)
+static ssize_t write_priomap(struct kernfs_open_file *of,
+			     char *buf, size_t nbytes, loff_t off)
 {
 	char devname[IFNAMSIZ + 1];
 	struct net_device *dev;
 	u32 prio;
 	int ret;
 
-	if (sscanf(buffer, "%"__stringify(IFNAMSIZ)"s %u", devname, &prio) != 2)
+	if (sscanf(buf, "%"__stringify(IFNAMSIZ)"s %u", devname, &prio) != 2)
 		return -EINVAL;
 
 	dev = dev_get_by_name(&init_net, devname);
@@ -202,11 +202,11 @@ static int write_priomap(struct cgroup_subsys_state *css, struct cftype *cft,
 
 	rtnl_lock();
 
-	ret = netprio_set_prio(css, dev, prio);
+	ret = netprio_set_prio(of_css(of), dev, prio);
 
 	rtnl_unlock();
 	dev_put(dev);
-	return ret;
+	return ret ?: nbytes;
 }
 
 static int update_netprio(const void *v, struct file *file, unsigned n)
@@ -239,7 +239,7 @@ static struct cftype ss_files[] = {
 	{
 		.name = "ifpriomap",
 		.seq_show = read_priomap,
-		.write_string = write_priomap,
+		.write = write_priomap,
 	},
 	{ }	/* terminate */
 };
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index d4f015a..841fd3f 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -102,17 +102,19 @@ static int tcp_update_limit(struct mem_cgroup *memcg, u64 val)
 	return 0;
 }
 
-static int tcp_cgroup_write(struct cgroup_subsys_state *css, struct cftype *cft,
-			    char *buffer)
+static ssize_t tcp_cgroup_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
 {
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned long long val;
 	int ret = 0;
 
-	switch (cft->private) {
+	buf = strstrip(buf);
+
+	switch (of_cft(of)->private) {
 	case RES_LIMIT:
 		/* see memcontrol.c */
-		ret = res_counter_memparse_write_strategy(buffer, &val);
+		ret = res_counter_memparse_write_strategy(buf, &val);
 		if (ret)
 			break;
 		ret = tcp_update_limit(memcg, val);
@@ -121,7 +123,7 @@ static int tcp_cgroup_write(struct cgroup_subsys_state *css, struct cftype *cft,
 		ret = -EINVAL;
 		break;
 	}
-	return ret;
+	return ret ?: nbytes;
 }
 
 static u64 tcp_read_stat(struct mem_cgroup *memcg, int type, u64 default_val)
@@ -193,7 +195,7 @@ static int tcp_cgroup_reset(struct cgroup_subsys_state *css, unsigned int event)
 static struct cftype tcp_files[] = {
 	{
 		.name = "kmem.tcp.limit_in_bytes",
-		.write_string = tcp_cgroup_write,
+		.write = tcp_cgroup_write,
 		.read_u64 = tcp_cgroup_read,
 		.private = RES_LIMIT,
 	},
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 8365909..82d6b4f 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -651,27 +651,27 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 	return rc;
 }
 
-static int devcgroup_access_write(struct cgroup_subsys_state *css,
-				  struct cftype *cft, char *buffer)
+static ssize_t devcgroup_access_write(struct kernfs_open_file *of,
+				      char *buf, size_t nbytes, loff_t off)
 {
 	int retval;
 
 	mutex_lock(&devcgroup_mutex);
-	retval = devcgroup_update_access(css_to_devcgroup(css),
-					 cft->private, buffer);
+	retval = devcgroup_update_access(css_to_devcgroup(of_css(of)),
+					 of_cft(of)->private, strstrip(buf));
 	mutex_unlock(&devcgroup_mutex);
-	return retval;
+	return retval ?: nbytes;
 }
 
 static struct cftype dev_cgroup_files[] = {
 	{
 		.name = "allow",
-		.write_string  = devcgroup_access_write,
+		.write = devcgroup_access_write,
 		.private = DEVCG_ALLOW,
 	},
 	{
 		.name = "deny",
-		.write_string = devcgroup_access_write,
+		.write = devcgroup_access_write,
 		.private = DEVCG_DENY,
 	},
 	{
-- 
1.9.0
