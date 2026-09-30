Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D9A1FBEA6
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 02:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790735519; cv=none; b=gL7lDdVYwv7soeWi6Oc//6eyKStNEJmEV/EzYk300CcdyfjNN18sjITYxz9QLzBfy6zILZULPS26shzBBBlR8Wh/s0gUnodPfCvL90sIrZgo+2Cw1I/yIO4xEfD3Xyl++ox3dW4/fbEWQCMx6NXgmRaYGYKWsFv66f7W1v6TU3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790735519; c=relaxed/simple;
	bh=NQsJVDotAkukN5y1RS0cDIvnui7p57zyAi/l3mfa8qY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F1ip12D8ya1laggo3luqyV0TpOYS9OGGJ1d85u24E0TgD79cBqhHUeQltSH6BqYZjUqQsI3Cj/mjxKThsAy9oHzPUEO2wBLKjYYLqdBmHTgoqe+vkYtojL809CkwMqke8nyKwD67uylJZtrJvtBqk31xyQPGxx+OxoFEBVRX3Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mY3vvcFy; arc=none smtp.client-ip=95.215.58.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mY3vvcFy"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NQsJVDotAkukN5y1RS0cDIvnui7p57zyAi/l3mfa8qY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790735515; v=1; x=1791340315;
 b=mY3vvcFysdi4oV1SeGz6z6gJZf9uimF6JSTWxumHPRQm4KYtEX3+LIWeMBmFgvKJZZKCtMgc
 vDWJQSircvSEzpC1iD1Xlzz6sPYxwYHCT5HvBGhxmr8ktbXybGQkpKf544IENtlWxV2Tsfop5Rg
 qml5n2IkQIJx4BoiXHkA58OM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c32d13c3e3f28c1c;
	Wed, 30 Sep 2026 02:31:54 +0000
X-Mizu-Trace-ID: c32d13c3e3f28c1c
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH next] cgroup/cpuset: Move cpuset_update_flag() to cpuset-v1.c
Date: Wed, 30 Sep 2026 10:31:39 +0800
Message-Id: <20260930023139.495964-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

cpuset_update_flag() is only used by the legacy (v1) interface: its
callers are the write handlers of cpuset1_files via cpuset_write_u64(),
and cpuset_css_offline() which invokes it only on the legacy hierarchy
(!cpuset_v2() && is_sched_load_balance()).

Move it, together with its sole helper cpuset1_update_tasks_flags(),
into cpuset-v1.c so both can go back to being static and drop out of
cpuset-internal.h.  As a result:

 - dup_or_alloc_cpuset(), free_cpuset() and validate_change() are now
   referenced from cpuset-v1.c, so they lose their static qualifier and
   gain declarations in cpuset-internal.h.

 - The v2 branch in cpuset_update_flag() that called
   cpuset_force_rebuild() is dead on the v1-only call paths and is
   dropped; the remaining rebuild_sched_domains_locked() path is kept.
   callback_lock, a static in cpuset.c, is taken through the existing
   cpuset_callback_lock_irq() wrapper.

 - The open-coded "!cpuset_v2() && is_sched_load_balance()" test in
   cpuset_css_offline() is wrapped in a new cpuset1_offline_css() helper
   (a no-op stub when CONFIG_CPUSETS_V1=n), removing the last
   cpuset_v2() branch from that path in cpuset.c.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset-internal.h |  8 ++--
 kernel/cgroup/cpuset-v1.c       | 59 +++++++++++++++++++++++++++-
 kernel/cgroup/cpuset.c          | 68 ++-------------------------------
 3 files changed, 67 insertions(+), 68 deletions(-)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index e7d010661fd3..5da9c91295b0 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -304,7 +304,9 @@ void cpuset_callback_lock_irq(void);
 void cpuset_callback_unlock_irq(void);
 void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus);
 void cpuset_update_tasks_nodemask(struct cpuset *cs);
-int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs, int turning_on);
+struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs);
+void free_cpuset(struct cpuset *cs);
+int validate_change(struct cpuset *cur, struct cpuset *trial);
 ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off);
 int cpuset_common_seq_show(struct seq_file *sf, void *v);
@@ -318,7 +320,6 @@ void cpuset_full_unlock(void);
 extern struct cftype cpuset1_files[];
 void cpuset1_update_task_spread_flags(struct cpuset *cs,
 					struct task_struct *tsk);
-void cpuset1_update_tasks_flags(struct cpuset *cs);
 void cpuset1_hotplug_update_tasks(struct cpuset *cs,
 			    struct cpumask *new_cpus, nodemask_t *new_mems,
 			    bool cpus_updated, bool mems_updated);
@@ -328,11 +329,11 @@ void cpuset1_init(struct cpuset *cs);
 void cpuset1_online_css(struct cgroup_subsys_state *css);
 int cpuset1_generate_sched_domains(cpumask_var_t **domains,
 			struct sched_domain_attr **attributes);
+void cpuset1_offline_css(struct cpuset *cs);
 
 #else
 static inline void cpuset1_update_task_spread_flags(struct cpuset *cs,
 					struct task_struct *tsk) {}
-static inline void cpuset1_update_tasks_flags(struct cpuset *cs) {}
 static inline void cpuset1_hotplug_update_tasks(struct cpuset *cs,
 			    struct cpumask *new_cpus, nodemask_t *new_mems,
 			    bool cpus_updated, bool mems_updated) {}
@@ -344,6 +345,7 @@ static inline void cpuset1_init(struct cpuset *cs) {}
 static inline void cpuset1_online_css(struct cgroup_subsys_state *css) {}
 static inline int cpuset1_generate_sched_domains(cpumask_var_t **domains,
 			struct sched_domain_attr **attributes) { return 0; };
+static inline void cpuset1_offline_css(struct cpuset *cs) {}
 
 #endif /* CONFIG_CPUSETS_V1 */
 
diff --git a/kernel/cgroup/cpuset-v1.c b/kernel/cgroup/cpuset-v1.c
index 562ad35f00d0..7c7f2887dfaf 100644
--- a/kernel/cgroup/cpuset-v1.c
+++ b/kernel/cgroup/cpuset-v1.c
@@ -229,7 +229,7 @@ void cpuset1_update_task_spread_flags(struct cpuset *cs,
  * function is called with cpuset_mutex held, cpuset membership stays
  * stable.
  */
-void cpuset1_update_tasks_flags(struct cpuset *cs)
+static void cpuset1_update_tasks_flags(struct cpuset *cs)
 {
 	struct css_task_iter it;
 	struct task_struct *task;
@@ -473,6 +473,51 @@ static u64 cpuset_read_u64(struct cgroup_subsys_state *css, struct cftype *cft)
 	return 0;
 }
 
+/*
+ * cpuset_update_flag - read a 0 or a 1 in a file and update associated flag
+ * bit:		the bit to update (see cpuset_flagbits_t)
+ * cs:		the cpuset to update
+ * turning_on:	whether the flag is being set or cleared
+ *
+ * Call with cpuset_mutex held.
+ */
+static int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
+			      int turning_on)
+{
+	struct cpuset *trialcs;
+	int balance_flag_changed;
+	int spread_page_changed;
+	int err;
+
+	trialcs = dup_or_alloc_cpuset(cs);
+	if (!trialcs)
+		return -ENOMEM;
+
+	assign_bit(bit, &trialcs->flags, turning_on);
+
+	err = validate_change(cs, trialcs);
+	if (err < 0)
+		goto out;
+
+	balance_flag_changed = (is_sched_load_balance(cs) !=
+				is_sched_load_balance(trialcs));
+
+	spread_page_changed = is_spread_page(cs) != is_spread_page(trialcs);
+
+	cpuset_callback_lock_irq();
+	cs->flags = trialcs->flags;
+	cpuset_callback_unlock_irq();
+
+	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
+		rebuild_sched_domains_locked();
+
+	if (spread_page_changed)
+		cpuset1_update_tasks_flags(cs);
+out:
+	free_cpuset(trialcs);
+	return err;
+}
+
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 			    u64 val)
 {
@@ -581,6 +626,18 @@ void cpuset1_online_css(struct cgroup_subsys_state *css)
 	cpuset_callback_unlock_irq();
 }
 
+/*
+ * Legacy-hierarchy handling when a cpuset is taken offline: if it had
+ * sched_load_balance enabled, turn it off so the scheduler domains are
+ * rebuilt.  A no-op on the default hierarchy.
+ */
+void cpuset1_offline_css(struct cpuset *cs)
+{
+	if (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+	    is_sched_load_balance(cs))
+		cpuset_update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
+}
+
 static void
 update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
 {
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index cf55b0719a2d..9287a97310a3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -162,7 +162,6 @@ static cpumask_var_t	isolated_hk_cpus;	/* T */
  * It can be set in
  *  - update_partition_sd_lb()
  *  - update_cpumasks_hier()
- *  - cpuset_update_flag()
  *  - cpuset_hotplug_update_tasks()
  *  - cpuset_handle_hotplug()
  *
@@ -608,7 +607,7 @@ static inline void free_tmpmasks(struct tmpmasks *tmp)
  *
  * Return: Pointer to newly allocated cpuset on success, NULL on failure
  */
-static struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs)
+struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs)
 {
 	struct cpuset *trial;
 
@@ -649,7 +648,7 @@ static struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs)
  * free_cpuset - free the cpuset
  * @cs: the cpuset to be freed
  */
-static inline void free_cpuset(struct cpuset *cs)
+void free_cpuset(struct cpuset *cs)
 {
 	free_cpumask_var(cs->cpus_allowed);
 	free_cpumask_var(cs->effective_cpus);
@@ -743,7 +742,7 @@ static inline bool mems_excl_conflict(struct cpuset *cs1, struct cpuset *cs2)
  * Return 0 if valid, -errno if not.
  */
 
-static int validate_change(struct cpuset *cur, struct cpuset *trial)
+int validate_change(struct cpuset *cur, struct cpuset *trial)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *c, *par;
@@ -2829,56 +2828,6 @@ bool current_cpuset_is_being_rebound(void)
 	return ret;
 }
 
-/*
- * cpuset_update_flag - read a 0 or a 1 in a file and update associated flag
- * bit:		the bit to update (see cpuset_flagbits_t)
- * cs:		the cpuset to update
- * turning_on: 	whether the flag is being set or cleared
- *
- * Call with cpuset_mutex held.
- */
-
-int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
-		       int turning_on)
-{
-	struct cpuset *trialcs;
-	int balance_flag_changed;
-	int spread_page_changed;
-	int err;
-
-	trialcs = dup_or_alloc_cpuset(cs);
-	if (!trialcs)
-		return -ENOMEM;
-
-	assign_bit(bit, &trialcs->flags, turning_on);
-
-	err = validate_change(cs, trialcs);
-	if (err < 0)
-		goto out;
-
-	balance_flag_changed = (is_sched_load_balance(cs) !=
-				is_sched_load_balance(trialcs));
-
-	spread_page_changed = is_spread_page(cs) != is_spread_page(trialcs);
-
-	spin_lock_irq(&callback_lock);
-	cs->flags = trialcs->flags;
-	spin_unlock_irq(&callback_lock);
-
-	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed) {
-		if (cpuset_v2())
-			cpuset_force_rebuild();
-		else
-			rebuild_sched_domains_locked();
-	}
-
-	if (spread_page_changed)
-		cpuset1_update_tasks_flags(cs);
-out:
-	free_cpuset(trialcs);
-	return err;
-}
-
 /**
  * update_prstate - update partition_root_state
  * @cs: the cpuset to update
@@ -3632,21 +3581,12 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	return 0;
 }
 
-/*
- * If the cpuset being removed has its flag 'sched_load_balance'
- * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains_locked(). That is not needed
- * in the default hierarchy where only changes in partition
- * will cause repartitioning.
- */
 static void cpuset_css_offline(struct cgroup_subsys_state *css)
 {
 	struct cpuset *cs = css_cs(css);
 
 	cpuset_full_lock();
-	if (!cpuset_v2() && is_sched_load_balance(cs))
-		cpuset_update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
-
+	cpuset1_offline_css(cs);
 	cpuset_dec();
 	cpuset_full_unlock();
 }
-- 
2.34.1

