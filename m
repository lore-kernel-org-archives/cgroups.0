From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 10/10] blkcg: implement interface for the unified hierarchy
Date: Thu, 30 Jul 2015 18:58:24 -0400
Message-ID: <20150730225824.GF3504@mtj.duckdns.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
 <1437763434-28699-11-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jeAN8gkLJrusZ7sfGEc3FAdK3/WxkbichLHCcJMMVCQ=;
        b=jS1InVB3WlKH2pLzGkGLTnp7sZw/c1dZ2mMai+vC4Rw17yva5J1gT7DDQHI1zy8Isn
         PAWijW7tcD8/CPxzOLWXPor38R+y+sAKY5D2sJb1dpaomT6yiJh5X+YIl2ols9/Rnh7L
         TgzyeU2qC66wYD/Qb6tr7VL8WcevEEgLDFP5uq1kwnPlUWNCId3T+TKHwzL1trCA+tz7
         NL5Mkj9Ul8ti8DGfkxx12FacEyetlGx/BJCkt02ERD4tR52jCDfUNIBwd7RE6m2WLygE
         /kXShZ8SXuin7toRzUGZrn0fAXPy6DyApt9NDEr2vFFJ4TLb1GXQzT77CBRRTywDO2HC
         tNWA==
Content-Disposition: inline
In-Reply-To: <1437763434-28699-11-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 1618deedf2fb0788ae11ac544f45671ceb6e43ec Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 30 Jul 2015 18:51:53 -0400

blkcg interface grew to be the biggest of all controllers and
unfortunately most inconsistent too.  The interface files are
inconsistent with a number of cloes duplicates.  Some files have
recursive variants while others don't.  There's distinction between
normal and leaf weights which isn't intuitive and there are a lot of
stat knobs which don't make much sense outside of debugging and expose
too much implementation details to userland.

In the unified hierarchy, everything is always hierarchical and
internal nodes can't have tasks rendering the two structural issues
twisting the current interface.  The interface has to be updated in a
significant anyway and this is a good chance to revamp it as a whole.
This patch implements blkcg interface for the unified hierarchy.

* (from a previous patch) blkcg is identified by "io" instead of
  "blkio" on the unified hierarchy.  Given that the whole interface is
  updated anyway, the rename shouldn't carry noticeable conversion
  overhead.

* The original interface consisted of 27 files is replaced with the
  following three files.

  blkio.stat	: per-blkcg stats
  blkio.weight	: per-cgroup and per-cgroup-queue weight settings
  blkio.max	: per-cgroup-queue bps and iops max limits

Documentation/cgroups/unified-hierarchy.txt updated accordingly.

v2: blkcg_policy->dfl_cftypes wasn't removed on
    blkcg_policy_unregister() corrupting the cftypes list.  Fixed.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
git branch updated accordingly.

Thanks.

 Documentation/cgroups/unified-hierarchy.txt |  57 +++++++++++++-
 block/blk-cgroup.c                          |  53 +++++++++++++
 block/blk-throttle.c                        | 112 ++++++++++++++++++++++++++++
 block/cfq-iosched.c                         |  61 +++++++++++++--
 include/linux/blk-cgroup.h                  |   1 +
 5 files changed, 277 insertions(+), 7 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 86847a7..4e23d4c 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -374,9 +374,62 @@ supported and the interface files "release_agent" and
 
 5-3. Per-Controller Changes
 
-5-3-1. blkio
+5-3-1. io
 
-- blk-throttle becomes properly hierarchical.
+- blkio is renamed to io.  The interface is overhauled anyway.  The
+  new name is more in line with the other two major controllers, cpu
+  and memory, and better suited given that it may be used for cgroup
+  writeback without involving block layer.
+
+- Everything including stat is always hierarchical making separate
+  recursive stat files pointless and, as no internal node can have
+  tasks, leaf weights are meaningless.  The operation model is
+  simplified and the interface is overhauled accordingly.
+
+  io.stat
+
+	The stat file.  The reported stats are from the point where
+	bio's are issued to request_queue.  The stats are counted
+	independent of which policies are enabled.  Each line in the
+	file follows the following format.  More fields may later be
+	added at the end.
+
+	  $MAJ:$MIN rbytes=$RBYTES wbytes=$WBYTES rios=$RIOS wrios=$WIOS
+
+  io.weight
+
+	The weight setting, currently only available and effective if
+	cfq-iosched is in use for the target device.  The weight is
+	between 10 and 1000 and defaults to 500.  The first line
+	always contains the default weight in the following format to
+	use when per-device setting is missing.
+
+	  default $WEIGHT
+
+	Subsequent lines list per-device weights of the following
+	format.
+
+	  $MAJ:$MIN $WEIGHT
+
+	Writing "$WEIGHT" or "default $WEIGHT" changes the default
+	setting.  Writing "$MAJ:$MIN $WEIGHT" sets per-device weight
+	while "$MAJ:$MIN default" clears it.
+
+	This file is available only on non-root cgroups.
+
+  io.max
+
+	The maximum bandwidth and/or iops setting, only available if
+	blk-throttle is enabled.  The file is of the following format.
+
+	  $MAJ:$MIN rbps=$RBPS wbps=$WBPS riops=$RIOPS wiops=$WIOPS
+
+	${R|W}BPS are read/write bytes per second and ${R|W}IOPS are
+	read/write IOs per second.  "max" indicates no limit.  Writing
+	to the file follows the same format but the individual
+	settings may be ommitted or specified in any order.
+
+	This file is available only on non-root cgroups.
 
 
 5-3-2. cpuset
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b5e72d7..88bdb73 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -854,6 +854,53 @@ void blkg_conf_finish(struct blkg_conf_ctx *ctx)
 }
 EXPORT_SYMBOL_GPL(blkg_conf_finish);
 
+static int blkcg_print_stat(struct seq_file *sf, void *v)
+{
+	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
+	struct blkcg_gq *blkg;
+
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
+		const char *dname;
+		struct blkg_rwstat rwstat;
+		u64 rbytes, wbytes, rios, wios;
+
+		dname = blkg_dev_name(blkg);
+		if (!dname)
+			continue;
+
+		spin_lock_irq(blkg->q->queue_lock);
+
+		rwstat = blkg_rwstat_recursive_sum(blkg, NULL,
+					offsetof(struct blkcg_gq, stat_bytes));
+		rbytes = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_READ]);
+		wbytes = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_WRITE]);
+
+		rwstat = blkg_rwstat_recursive_sum(blkg, NULL,
+					offsetof(struct blkcg_gq, stat_ios));
+		rios = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_READ]);
+		wios = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_WRITE]);
+
+		spin_unlock_irq(blkg->q->queue_lock);
+
+		if (rbytes || wbytes || rios || wios)
+			seq_printf(sf, "%s rbytes=%llu wbytes=%llu rios=%llu wios=%llu\n",
+				   dname, rbytes, wbytes, rios, wios);
+	}
+
+	rcu_read_unlock();
+	return 0;
+}
+
+struct cftype blkcg_files[] = {
+	{
+		.name = "stat",
+		.seq_show = blkcg_print_stat,
+	},
+	{ }	/* terminate */
+};
+
 struct cftype blkcg_legacy_files[] = {
 	{
 		.name = "reset_stats",
@@ -1101,6 +1148,7 @@ struct cgroup_subsys io_cgrp_subsys = {
 	.css_offline = blkcg_css_offline,
 	.css_free = blkcg_css_free,
 	.can_attach = blkcg_can_attach,
+	.dfl_cftypes = blkcg_files,
 	.legacy_cftypes = blkcg_legacy_files,
 	.legacy_name = "blkio",
 #ifdef CONFIG_MEMCG
@@ -1273,6 +1321,9 @@ int blkcg_policy_register(struct blkcg_policy *pol)
 	mutex_unlock(&blkcg_pol_mutex);
 
 	/* everything is in place, add intf files for the new policy */
+	if (pol->dfl_cftypes)
+		WARN_ON(cgroup_add_dfl_cftypes(&io_cgrp_subsys,
+					       pol->dfl_cftypes));
 	if (pol->legacy_cftypes)
 		WARN_ON(cgroup_add_legacy_cftypes(&io_cgrp_subsys,
 						  pol->legacy_cftypes));
@@ -1312,6 +1363,8 @@ void blkcg_policy_unregister(struct blkcg_policy *pol)
 		goto out_unlock;
 
 	/* kill the intf files first */
+	if (pol->dfl_cftypes)
+		cgroup_rm_cftypes(pol->dfl_cftypes);
 	if (pol->legacy_cftypes)
 		cgroup_rm_cftypes(pol->legacy_cftypes);
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a8bb2fd..c75a263 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1265,6 +1265,117 @@ static struct cftype throtl_legacy_files[] = {
 	{ }	/* terminate */
 };
 
+static u64 tg_prfill_max(struct seq_file *sf, struct blkg_policy_data *pd,
+			 int off)
+{
+	struct throtl_grp *tg = pd_to_tg(pd);
+	const char *dname = blkg_dev_name(pd->blkg);
+	char bufs[4][21] = { "max", "max", "max", "max" };
+
+	if (!dname)
+		return 0;
+	if (tg->bps[READ] == -1 && tg->bps[WRITE] == -1 &&
+	    tg->iops[READ] == -1 && tg->iops[WRITE] == -1)
+		return 0;
+
+	if (tg->bps[READ] != -1)
+		snprintf(bufs[0], sizeof(bufs[0]), "%llu", tg->bps[READ]);
+	if (tg->bps[WRITE] != -1)
+		snprintf(bufs[1], sizeof(bufs[1]), "%llu", tg->bps[WRITE]);
+	if (tg->iops[READ] != -1)
+		snprintf(bufs[2], sizeof(bufs[2]), "%u", tg->iops[READ]);
+	if (tg->iops[WRITE] != -1)
+		snprintf(bufs[3], sizeof(bufs[3]), "%u", tg->iops[WRITE]);
+
+	seq_printf(sf, "%s rbps=%s wbps=%s riops=%s wiops=%s\n",
+		   dname, bufs[0], bufs[1], bufs[2], bufs[3]);
+	return 0;
+}
+
+static int tg_print_max(struct seq_file *sf, void *v)
+{
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), tg_prfill_max,
+			  &blkcg_policy_throtl, seq_cft(sf)->private, false);
+	return 0;
+}
+
+static ssize_t tg_set_max(struct kernfs_open_file *of,
+			  char *buf, size_t nbytes, loff_t off)
+{
+	struct blkcg *blkcg = css_to_blkcg(of_css(of));
+	struct blkg_conf_ctx ctx;
+	struct throtl_grp *tg;
+	u64 v[4];
+	int ret;
+
+	ret = blkg_conf_prep(blkcg, &blkcg_policy_throtl, buf, &ctx);
+	if (ret)
+		return ret;
+
+	tg = blkg_to_tg(ctx.blkg);
+
+	v[0] = tg->bps[READ];
+	v[1] = tg->bps[WRITE];
+	v[2] = tg->iops[READ];
+	v[3] = tg->iops[WRITE];
+
+	while (true) {
+		char tok[27];	/* wiops=18446744073709551616 */
+		char *p;
+		u64 val = -1;
+		int len;
+
+		if (sscanf(ctx.body, "%26s%n", tok, &len) != 1)
+			break;
+		if (tok[0] == '\0')
+			break;
+		ctx.body += len;
+
+		ret = -EINVAL;
+		p = tok;
+		strsep(&p, "=");
+		if (!p || (sscanf(p, "%llu", &val) != 1 && strcmp(p, "max")))
+			goto out_finish;
+
+		ret = -ERANGE;
+		if (!val)
+			goto out_finish;
+
+		ret = -EINVAL;
+		if (!strcmp(tok, "rbps"))
+			v[0] = val;
+		else if (!strcmp(tok, "wbps"))
+			v[1] = val;
+		else if (!strcmp(tok, "riops"))
+			v[2] = min_t(u64, val, UINT_MAX);
+		else if (!strcmp(tok, "wiops"))
+			v[3] = min_t(u64, val, UINT_MAX);
+		else
+			goto out_finish;
+	}
+
+	tg->bps[READ] = v[0];
+	tg->bps[WRITE] = v[1];
+	tg->iops[READ] = v[2];
+	tg->iops[WRITE] = v[3];
+
+	tg_conf_updated(tg);
+	ret = 0;
+out_finish:
+	blkg_conf_finish(&ctx);
+	return ret ?: nbytes;
+}
+
+static struct cftype throtl_files[] = {
+	{
+		.name = "max",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = tg_print_max,
+		.write = tg_set_max,
+	},
+	{ }	/* terminate */
+};
+
 static void throtl_shutdown_wq(struct request_queue *q)
 {
 	struct throtl_data *td = q->td;
@@ -1273,6 +1384,7 @@ static void throtl_shutdown_wq(struct request_queue *q)
 }
 
 static struct blkcg_policy blkcg_policy_throtl = {
+	.dfl_cftypes		= throtl_files,
 	.legacy_cftypes		= throtl_legacy_files,
 
 	.pd_alloc_fn		= throtl_pd_alloc,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7a72301..97da571 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1740,7 +1740,7 @@ static int cfq_print_leaf_weight(struct seq_file *sf, void *v)
 
 static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
 					char *buf, size_t nbytes, loff_t off,
-					bool is_leaf_weight)
+					bool on_dfl, bool is_leaf_weight)
 {
 	struct blkcg *blkcg = css_to_blkcg(of_css(of));
 	struct blkg_conf_ctx ctx;
@@ -1753,9 +1753,17 @@ static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
 	if (ret)
 		return ret;
 
-	ret = -EINVAL;
-	if (sscanf(ctx.body, "%llu", &v) != 1)
+	if (sscanf(ctx.body, "%llu", &v) == 1) {
+		/* require "default" on dfl */
+		ret = -ERANGE;
+		if (!v && on_dfl)
+			goto out_finish;
+	} else if (!strcmp(strim(ctx.body), "default")) {
+		v = 0;
+	} else {
+		ret = -EINVAL;
 		goto out_finish;
+	}
 
 	cfqg = blkg_to_cfqg(ctx.blkg);
 	cfqgd = blkcg_to_cfqgd(blkcg);
@@ -1779,13 +1787,13 @@ static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
 static ssize_t cfqg_set_weight_device(struct kernfs_open_file *of,
 				      char *buf, size_t nbytes, loff_t off)
 {
-	return __cfqg_set_weight_device(of, buf, nbytes, off, false);
+	return __cfqg_set_weight_device(of, buf, nbytes, off, false, false);
 }
 
 static ssize_t cfqg_set_leaf_weight_device(struct kernfs_open_file *of,
 					   char *buf, size_t nbytes, loff_t off)
 {
-	return __cfqg_set_weight_device(of, buf, nbytes, off, true);
+	return __cfqg_set_weight_device(of, buf, nbytes, off, false, true);
 }
 
 static int __cfq_set_weight(struct cgroup_subsys_state *css, u64 val,
@@ -2103,6 +2111,48 @@ static struct cftype cfq_blkcg_legacy_files[] = {
 #endif	/* CONFIG_DEBUG_BLK_CGROUP */
 	{ }	/* terminate */
 };
+
+static int cfq_print_weight_on_dfl(struct seq_file *sf, void *v)
+{
+	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
+	struct cfq_group_data *cgd = blkcg_to_cfqgd(blkcg);
+
+	seq_printf(sf, "default %u\n", cgd->weight);
+	blkcg_print_blkgs(sf, blkcg, cfqg_prfill_weight_device,
+			  &blkcg_policy_cfq, 0, false);
+	return 0;
+}
+
+static ssize_t cfq_set_weight_on_dfl(struct kernfs_open_file *of,
+				     char *buf, size_t nbytes, loff_t off)
+{
+	char *endp;
+	int ret;
+	u64 v;
+
+	buf = strim(buf);
+
+	/* "WEIGHT" or "default WEIGHT" sets the default weight */
+	v = simple_strtoull(buf, &endp, 0);
+	if (*endp == '\0' || sscanf(buf, "default %llu", &v) == 1) {
+		ret = __cfq_set_weight(of_css(of), v, false);
+		return ret ?: nbytes;
+	}
+
+	/* "MAJ:MIN WEIGHT" */
+	return __cfqg_set_weight_device(of, buf, nbytes, off, true, false);
+}
+
+static struct cftype cfq_blkcg_files[] = {
+	{
+		.name = "weight",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = cfq_print_weight_on_dfl,
+		.write = cfq_set_weight_on_dfl,
+	},
+	{ }	/* terminate */
+};
+
 #else /* GROUP_IOSCHED */
 static struct cfq_group *cfq_lookup_cfqg(struct cfq_data *cfqd,
 					 struct blkcg *blkcg)
@@ -4659,6 +4709,7 @@ static struct elevator_type iosched_cfq = {
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static struct blkcg_policy blkcg_policy_cfq = {
+	.dfl_cftypes		= cfq_blkcg_files,
 	.legacy_cftypes		= cfq_blkcg_legacy_files,
 
 	.cpd_alloc_fn		= cfq_cpd_alloc,
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index b270aef..9a7c4bd 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -148,6 +148,7 @@ typedef void (blkcg_pol_reset_pd_stats_fn)(struct blkg_policy_data *pd);
 struct blkcg_policy {
 	int				plid;
 	/* cgroup files for the policy */
+	struct cftype			*dfl_cftypes;
 	struct cftype			*legacy_cftypes;
 
 	/* operations */
-- 
2.4.3
