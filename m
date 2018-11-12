From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH 04/12] cgroup: link cftypes of the same subsystem with the same name
Date: Mon, 12 Nov 2018 10:56:24 +0100
Message-ID: <20181112095632.69114-5-paolo.valente@linaro.org>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=symMBI0AEZzZj3jXIeKSzDkA196PYWRtmcxOC8y15f0=;
        b=PLZQsYk8zx5Q6H+H+XLenq9zy5WTTXzbjsINOjU45dyhex93N5hCav2aGJsu5FmV2p
         TwXAeQNkschEKoKPJaFtk3IKly/y954thUgWArusiHRfCOorjEt67znBLPbkOXdFz+uH
         jkwbbS5vgHj6TxcDWHCYS9W4Y1QoGNib19Qyw=
In-Reply-To: <20181112095632.69114-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Paolo Valente <paolo.valente@linaro.org>

From: Angelo Ruocco <angeloruocco90@gmail.com>

When a cgroup policy is activated, it creates its files in its
subsystem directory. Two policies are not able to create a file with
the same name: if a policy tries to create a file that has the same
name as a file created by another policy, the cgroup core stops it,
warns the user about the error, and then proceeds to delete all the
files created by the last policy.

However, in some specific situations, it may be useful for two or more
policies to use a common file, e.g., the I/O schedulers bfq and cfq
have the same "weight" attribute, that changes the behavior of the two
schedulers in a similar way.

This commit prepares the interface that allows two policies of the same
subsystem to share files. It adds a flag CFTYPE_SHARE_FILE for cftypes,
flag that allows cftypes to be linked together if they are part of the
same subsystem and have the same name.

There is a limitation for a cftype that wants to share a file: it can't
have the hooks seq_start/next/stop. The reason is that there is no
consistent way to show portions of a file once multiple cftypes are
attached to it, and thus more than one seq_show() is invoked: there are
neither an univocal start point, nor univocal "next" and "stop"
operations.

Signed-off-by: Angelo Ruocco <angeloruocco90@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
---
 include/linux/cgroup-defs.h |  9 ++++++
 kernel/cgroup/cgroup.c      | 78 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 7841db6e7fb3..d659763c7221 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -93,6 +93,8 @@ enum {
 	CFTYPE_NO_PREFIX	= (1 << 3),	/* (DON'T USE FOR NEW FILES) no subsys prefix */
 	CFTYPE_WORLD_WRITABLE	= (1 << 4),	/* (DON'T USE FOR NEW FILES) S_IWUGO */
 
+	CFTYPE_SHARES_FILE	= (1 << 5),	/* shares file w/ other cfts */
+
 	/* internal flags, do not use outside cgroup core proper */
 	__CFTYPE_ONLY_ON_DFL	= (1 << 16),	/* only on default hierarchy */
 	__CFTYPE_NOT_ON_DFL	= (1 << 17),	/* not on default hierarchy */
@@ -528,6 +530,13 @@ struct cftype {
 	 */
 	struct cgroup_subsys *ss;	/* NULL for cgroup core files */
 	struct list_head node;		/* anchored at ss->cfts */
+
+	/*
+	 * List of cftypes that are sharing the same file. It allows the hook
+	 * functions of the cftypes in the list to be called together.
+	 */
+	struct list_head share_node;
+
 	struct kernfs_ops *kf_ops;
 
 	int (*open)(struct kernfs_open_file *of);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 74012b61fe19..e3cc437669a8 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1579,9 +1579,12 @@ struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn, bool drain_offline)
 	return NULL;
 }
 
-static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
+static void cgroup_rm_file(struct cgroup *cgrp, struct cftype *cft)
 {
 	char name[CGROUP_FILE_NAME_MAX];
+	struct kernfs_node *kn = kernfs_find(cgrp->kn,
+			cgroup_file_name(cgrp, cft, name));
+	struct cftype *cfts = kn->priv;
 
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -1596,7 +1599,19 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 		del_timer_sync(&cfile->notify_timer);
 	}
 
-	kernfs_remove_by_name(cgrp->kn, cgroup_file_name(cgrp, cft, name));
+	/* Delete the file only if it's used by one cftype */
+	if (list_empty(&cft->share_node) || atomic_read(&kn->count) == 1) {
+		kernfs_remove(kn);
+	} else {
+		/*
+		 * Update the "priv" pointer of the kernfs_node if the cftype
+		 * that first created the file is removed.
+		 */
+		if (cft == cfts)
+			kn->priv = list_next_entry(cft, share_node);
+
+		kernfs_put(kn);
+	}
 }
 
 /**
@@ -3467,6 +3482,7 @@ static int cgroup_file_open(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
 
+
 	if (cft->open)
 		return cft->open(of);
 	return 0;
@@ -3615,6 +3631,23 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	key = &cft->lockdep_key;
 #endif
+
+	if (cft->flags & CFTYPE_SHARES_FILE) {
+		kn = kernfs_find(cgrp->kn, cgroup_file_name(cgrp, cft, name));
+		if (kn) {
+			struct cftype *cfts = kn->priv;
+
+			if (cfts->flags & CFTYPE_SHARES_FILE) {
+				/*
+				 * kn->count keeps track of how many cftypes
+				 * share kn
+				 */
+				kernfs_get(kn);
+				goto out_set_cfile;
+			}
+		}
+	}
+
 	kn = __kernfs_create_file(cgrp->kn, cgroup_file_name(cgrp, cft, name),
 				  cgroup_file_mode(cft),
 				  GLOBAL_ROOT_UID, GLOBAL_ROOT_GID,
@@ -3629,6 +3662,7 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
 		return ret;
 	}
 
+out_set_cfile:
 	if (cft->file_offset) {
 		struct cgroup_file *cfile = (void *)css + cft->file_offset;
 
@@ -3726,11 +3760,46 @@ static void cgroup_exit_cftypes(struct cftype *cfts)
 		cft->kf_ops = NULL;
 		cft->ss = NULL;
 
+		list_del(&cft->share_node);
+
 		/* revert flags set by cgroup core while adding @cfts */
 		cft->flags &= ~(__CFTYPE_ONLY_ON_DFL | __CFTYPE_NOT_ON_DFL);
 	}
 }
 
+/*
+ * Link a cftype that wants to share a file to the list of cftypes that are
+ * using it.
+ *
+ * The conditions for a cftype to be put in an existing list of cftypes and
+ * thus start to share a file are:
+ *	- to have the flag CFTYPE_SHARES_FILE set;
+ *	- to have all flags coincide with the flags of the other cftypes in the
+ *	  list;
+ *	- to not have a seq_start hook: there is no consistent way to show
+ *	  portions of a file once multiple cftypes are attached to it, and thus
+ *	  more than one seq_show() is invoked.
+ *
+ * Once two or more cftypes are linked together, the file only points
+ * to the first of them.
+ */
+static void cgroup_link_cftype(struct cgroup_subsys *ss, struct cftype *cft)
+{
+	struct cftype *cfts;
+
+	list_for_each_entry(cfts, &ss->cfts, node) {
+		struct cftype *c;
+
+		for (c = cfts; c->name[0] != '\0'; c++)
+			if (c != cft && !(c->flags ^ cft->flags) &&
+			    !(c->seq_start || cft->seq_start) &&
+			    !strcmp(c->name, cft->name)) {
+				list_add(&cft->share_node, &c->share_node);
+				return;
+			}
+	}
+}
+
 static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	struct cftype *cft;
@@ -3760,6 +3829,11 @@ static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 
 		cft->kf_ops = kf_ops;
 		cft->ss = ss;
+
+		INIT_LIST_HEAD(&cft->share_node);
+
+		if (cft->flags & CFTYPE_SHARES_FILE)
+			cgroup_link_cftype(ss, cft);
 	}
 
 	return 0;
-- 
2.16.1

