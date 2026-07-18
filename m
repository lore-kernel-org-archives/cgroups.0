Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E96D38237B;
	Sat, 18 Jul 2026 08:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784362652; cv=none; b=X7ieeSN9ndBL3vy3O0rrNHNmIKdC3nWEMl+lNptxuh6Fkl5elcbPCpotE5FIrl7lUydm2jJjfIfPQShEwIZOVWlTqkSxffb6rSOFETvkTggQsEhuMRqy/wmIforBdf7U8juldFDLXiOwROH5OXfK+K278MXr51O2NQhUPDV1H6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784362652; c=relaxed/simple;
	bh=K0UbTGuc3DLaO1vzkCGRaMwyK8w+Be3RK5A2XuUASBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fC/LlHFvpUWYnOfvNslo+RJfRaF7YufPMJJHZmGCaSAiwX52HSLxQIm9xHA6NBQxSKLItcAwTRNvgdXmJgX8yfamigE4XBzevI7cavY9XFgw0LWz+7DOVIfoSN0zWZnpz26jU6mb9KdfejRXxIaEH6MJox0/Ku7nK/wQQR7A3mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8/AKoCZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8/AKoCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993D41F00A3A;
	Sat, 18 Jul 2026 08:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784362649;
	bh=aPaMV4VRySYPVjfa4tRpj2woreqlDkpWI/LbTtVuGEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8/AKoCZlGjIutyrDwNRMUc3cqUenfCp9X1RNC6btb0yqonziBddDbLFowc9KNBDa
	 /tlQgg52I563U3FLalbDmxVu/h8ypXGf0ZR4MdZ7A/uaeF5RjJOcZVHhIXeHcXPin7
	 Lp7XAEq6rKIy54VCsr6oaH2p3XW2CQU6nqf9PEHO2S3FpDbtSTSvWTxvD765buhXCp
	 Iy2ppwOzFS6GOAITqaJOMobgEl06hTyEfcShz5AYc/tcFtN71BBWdaSkcP034mksnS
	 JcQ5bXBsPqb1hKltJdzWwoXUV9TjBd7vUtfALKeXeAsDXCLN79j7ed8yH0/cAaBn+l
	 y2qUBIrzYvxlA==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: sched-ext@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] cgroup: Add cgroup_task_notifier and task migration events
Date: Fri, 17 Jul 2026 22:17:20 -1000
Message-ID: <20260718081727.582037-2-tj@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260718081727.582037-1-tj@kernel.org>
References: <20260718081727.582037-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A subsystem can attach to the cgroup hierarchy itself, independent of which
controllers are enabled where - BPF hooks already behave this way and
sched_ext sub-schedulers do too. Controller callbacks can't track task
migrations for them: sched_ext must re-home a task whose migration crosses a
sub-scheduler boundary, but the cpu controller's attach callbacks fire only
when the task_group changes and miss moves whenever the controller topology
is coarser than the sub-scheduler topology.

Add cgroup_task_notifier with per-task migration events mirroring the
can_attach/attach/cancel_attach phases so that a consumer which prepares
per-task state can also veto a migration: CGROUP_TASK_MIGRATING fires
pre-commit, CGROUP_TASK_MIGRATED post-commit and
CGROUP_TASK_MIGRATE_CANCELED unwinds a failed migration. Only migrations
that change a task's dfl cgroup are reported.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 26 ++++++++++++
 kernel/cgroup/cgroup.c | 93 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 110 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f2aa46a4f871..aa92db5f05de 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -82,12 +82,38 @@ enum cgroup_lifetime_events {
 	CGROUP_LIFETIME_OFFLINE,
 };
 
+/*
+ * Events on cgroup_task_notifier, data is struct cgroup_task_migrate_ctx.
+ * MIGRATING fires per task before the migration commits and an error return
+ * from the chain fails the migration, in which case tasks that were already
+ * notified receive MIGRATE_CANCELED. MIGRATED fires per task after the
+ * migration is committed and can't fail. Only migrations that change a task's
+ * dfl cgroup are reported.
+ */
+enum cgroup_task_events {
+	CGROUP_TASK_MIGRATING,
+	CGROUP_TASK_MIGRATED,
+	CGROUP_TASK_MIGRATE_CANCELED,
+};
+
+/*
+ * @src_dcgrp and @dst_dcgrp are @task's dfl cgroups before and after the
+ * migration. @src_dcgrp is NULL for CGROUP_TASK_MIGRATED as per-task sources
+ * are not tracked past the commit point.
+ */
+struct cgroup_task_migrate_ctx {
+	struct task_struct	*task;
+	struct cgroup		*src_dcgrp;
+	struct cgroup		*dst_dcgrp;
+};
+
 extern struct file_system_type cgroup_fs_type;
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 extern struct blocking_notifier_head cgroup_lifetime_notifier;
+extern struct blocking_notifier_head cgroup_task_notifier;
 
 #define SUBSYS(_x) extern struct cgroup_subsys _x ## _cgrp_subsys;
 #include <linux/cgroup_subsys.h>
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 38f8d9df8fbc..2f6b634c84ca 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -88,6 +88,8 @@ EXPORT_SYMBOL_GPL(css_set_lock);
 
 struct blocking_notifier_head cgroup_lifetime_notifier =
 	BLOCKING_NOTIFIER_INIT(cgroup_lifetime_notifier);
+struct blocking_notifier_head cgroup_task_notifier =
+	BLOCKING_NOTIFIER_INIT(cgroup_task_notifier);
 
 DEFINE_SPINLOCK(trace_cgroup_path_lock);
 char trace_cgroup_path[TRACE_CGROUP_PATH_LEN];
@@ -2676,14 +2678,27 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 	return NULL;
 }
 
+static void cgroup_migrate_notify_canceled(struct css_set *src_cset,
+					   struct task_struct *task)
+{
+	struct cgroup_task_migrate_ctx ctx = {
+		.task = task,
+		.src_dcgrp = src_cset->dfl_cgrp,
+		.dst_dcgrp = src_cset->mg_dst_cset->dfl_cgrp,
+	};
+
+	blocking_notifier_call_chain(&cgroup_task_notifier,
+				     CGROUP_TASK_MIGRATE_CANCELED, &ctx);
+}
+
 /**
  * cgroup_migrate_execute - migrate a taskset
  * @mgctx: migration context
  *
- * Migrate tasks in @mgctx as setup by migration preparation functions.
- * This function fails iff one of the ->can_attach callbacks fails and
- * guarantees that either all or none of the tasks in @mgctx are migrated.
- * @mgctx is consumed regardless of success.
+ * Migrate tasks in @mgctx as setup by migration preparation functions. This
+ * function fails iff one of the ->can_attach callbacks or CGROUP_TASK_MIGRATING
+ * notifications fails and guarantees that either all or none of the tasks in
+ * @mgctx are migrated. @mgctx is consumed regardless of success.
  */
 static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
 {
@@ -2691,6 +2706,7 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
 	struct cgroup_subsys *ss;
 	struct task_struct *task, *tmp_task;
 	struct css_set *cset, *tmp_cset;
+	bool dfl_migration = false;
 	int ssid, failed_ssid, ret;
 
 	/* check that we can legitimately attach to the cgroup */
@@ -2707,6 +2723,33 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
 		} while_each_subsys_mask();
 	}
 
+	/*
+	 * Notify each task about the impending migration. An error return fails
+	 * the migration. Only migrations on the default hierarchy are reported:
+	 * a migration modifies either every moved task's dfl cgroup or, on
+	 * cgroup1 or for subtree_control writes, none.
+	 */
+	list_for_each_entry(cset, &tset->src_csets, mg_node) {
+		if (cset->dfl_cgrp == cset->mg_dst_cset->dfl_cgrp)
+			continue;
+		dfl_migration = true;
+		list_for_each_entry(task, &cset->mg_tasks, cg_list) {
+			struct cgroup_task_migrate_ctx ctx = {
+				.task = task,
+				.src_dcgrp = cset->dfl_cgrp,
+				.dst_dcgrp = cset->mg_dst_cset->dfl_cgrp,
+			};
+
+			ret = blocking_notifier_call_chain_robust(&cgroup_task_notifier,
+								  CGROUP_TASK_MIGRATING,
+								  CGROUP_TASK_MIGRATE_CANCELED,
+								  &ctx);
+			ret = notifier_to_errno(ret);
+			if (ret)
+				goto out_cancel_migrating;
+		}
+	}
+
 	/*
 	 * Now that we're guaranteed success, proceed to move all tasks to
 	 * the new cgroup.  There are no failure cases after here, so this
@@ -2750,9 +2793,41 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
 		} while_each_subsys_mask();
 	}
 
+	/*
+	 * Notify each task after successful migration. The operation can no
+	 * longer fail and the return value is ignored. The MIGRATING loop
+	 * above explains why only dfl migrations are reported. Per-task
+	 * sources are not tracked past the commit point, so src_dcgrp is
+	 * NULL.
+	 */
+	if (dfl_migration) {
+		list_for_each_entry(cset, &tset->dst_csets, mg_node) {
+			list_for_each_entry(task, &cset->mg_tasks, cg_list) {
+				struct cgroup_task_migrate_ctx ctx = {
+					.task = task,
+					.dst_dcgrp = cset->dfl_cgrp,
+				};
+
+				blocking_notifier_call_chain(
+					&cgroup_task_notifier,
+					CGROUP_TASK_MIGRATED, &ctx);
+			}
+		}
+	}
+
 	ret = 0;
 	goto out_release_tset;
 
+out_cancel_migrating:
+	list_for_each_entry_continue_reverse(task, &cset->mg_tasks, cg_list)
+		cgroup_migrate_notify_canceled(cset, task);
+	list_for_each_entry_continue_reverse(cset, &tset->src_csets, mg_node) {
+		if (cset->dfl_cgrp == cset->mg_dst_cset->dfl_cgrp)
+			continue;
+		list_for_each_entry_reverse(task, &cset->mg_tasks, cg_list)
+			cgroup_migrate_notify_canceled(cset, task);
+	}
+	failed_ssid = CGROUP_SUBSYS_COUNT;
 out_cancel_attach:
 	if (tset->nr_tasks) {
 		do_each_subsys_mask(ss, ssid, mgctx->ss_mask) {
@@ -2976,11 +3051,11 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
  * cgroup_migrate_prepare_dst() on the targets before invoking this
  * function and following up with cgroup_migrate_finish().
  *
- * As long as a controller's ->can_attach() doesn't fail, this function is
- * guaranteed to succeed.  This means that, excluding ->can_attach()
- * failure, when migrating multiple targets, the success or failure can be
- * decided for all targets by invoking group_migrate_prepare_dst() before
- * actually starting migrating.
+ * As long as a controller's ->can_attach() or a CGROUP_TASK_MIGRATING
+ * notification doesn't fail, this function is guaranteed to succeed.  This
+ * means that, excluding those failures, when migrating multiple targets,
+ * the success or failure can be decided for all targets by invoking
+ * group_migrate_prepare_dst() before actually starting migrating.
  */
 int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 		   struct cgroup_mgctx *mgctx)
-- 
2.55.0

