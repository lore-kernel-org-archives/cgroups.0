From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/7] devcg: device cgroup's extension for RDMA resource.
Date: Tue,  8 Sep 2015 02:08:21 +0530
Message-ID: <1441658303-18081-6-git-send-email-pandit.parav@gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GVmgmPy42BMNKIS70Ru70ZqFbf+opJlJW9R9xGqCnQk=;
        b=HPY9wYxHCsBBPg0/1NpFCDAWaq/2Fsr1w4r/wAjsKnerNzB15rtVBgh6kHlI9UOJxs
         XC41GDCR4/WhA8nJJJb0DGwGi4JfKAff+D4jAB3g+EOlTm0aqMN5P1Yd9TRwhBEjtBVv
         TKUXZaZ+55xuAqaFFTaFn/Y5i0Gg3OqYfvzxh0/MgVKsk2oCCb74W9wk+vVWnmuL0Sax
         lFJTDNoAh4rP6fCY8PqsRMEsIvb4wt0Lm1IHUk0SkaYQihNtBMTzJBxEygp/kKCoUss1
         vPB2rpUBTztfVYM4zLj9jnRtJSulCpmpKhtImuFxJSzb/je97mRgoD38lksR944gO/UG
         GsyA==
In-Reply-To: <1441658303-18081-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Extension of device cgroup for RDMA device resources.
This implements RDMA resource tracker to limit RDMA resources such as
AH, CQ, PD, QP, MR, SRQ etc resources for processes of the cgroup.
It implements RDMA resource limit module to limit consuming RDMA
resources for processes of the cgroup.
RDMA resources are tracked on per task basis.
RDMA resources across multiple such devices are limited among multiple
processes of the owning device cgroup.

RDMA device cgroup extension returns error when user space applications
try to allocate resources more than its configured limit.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/device_rdma_cgroup.h |  83 ++++++++
 security/device_rdma_cgroup.c      | 422 +++++++++++++++++++++++++++++++++++++
 2 files changed, 505 insertions(+)
 create mode 100644 include/linux/device_rdma_cgroup.h
 create mode 100644 security/device_rdma_cgroup.c

diff --git a/include/linux/device_rdma_cgroup.h b/include/linux/device_rdma_cgroup.h
new file mode 100644
index 0000000..a2c261b
--- /dev/null
+++ b/include/linux/device_rdma_cgroup.h
@@ -0,0 +1,83 @@
+#ifndef _DEVICE_RDMA_CGROUP_H
+#define _DEVICE_RDMA_CGROUP_H
+
+#include <linux/cgroup.h>
+
+/* RDMA resources from device cgroup perspective */
+enum devcgroup_rdma_rt {
+	DEVCG_RDMA_RES_TYPE_UCTX,
+	DEVCG_RDMA_RES_TYPE_CQ,
+	DEVCG_RDMA_RES_TYPE_PD,
+	DEVCG_RDMA_RES_TYPE_AH,
+	DEVCG_RDMA_RES_TYPE_MR,
+	DEVCG_RDMA_RES_TYPE_MW,
+	DEVCG_RDMA_RES_TYPE_SRQ,
+	DEVCG_RDMA_RES_TYPE_QP,
+	DEVCG_RDMA_RES_TYPE_FLOW,
+	DEVCG_RDMA_RES_TYPE_MAX,
+};
+
+struct ib_ucontext;
+
+#define DEVCG_RDMA_MAX_RESOURCES S32_MAX
+
+#ifdef CONFIG_CGROUP_RDMA_RESOURCE
+
+#define DEVCG_RDMA_MAX_RESOURCE_STR "max"
+
+enum devcgroup_rdma_access_files {
+	DEVCG_RDMA_LIST_USAGE,
+};
+
+struct task_rdma_res_counter {
+	/* allows atomic increment of task and cgroup counters
+	 *  to avoid race with migration task.
+	 */
+	spinlock_t lock;
+	u32 usage[DEVCG_RDMA_RES_TYPE_MAX];
+};
+
+struct devcgroup_rdma_tracker {
+	int limit;
+	atomic_t usage;
+	int failcnt;
+};
+
+struct devcgroup_rdma {
+	struct devcgroup_rdma_tracker tracker[DEVCG_RDMA_RES_TYPE_MAX];
+};
+
+struct dev_cgroup;
+
+void init_devcgroup_rdma_tracker(struct dev_cgroup *dev_cg);
+ssize_t devcgroup_rdma_set_max_resource(struct kernfs_open_file *of,
+					char *buf,
+					size_t nbytes, loff_t off);
+int devcgroup_rdma_get_max_resource(struct seq_file *m, void *v);
+int devcgroup_rdma_show_usage(struct seq_file *m, void *v);
+
+int devcgroup_rdma_try_charge_resource(enum devcgroup_rdma_rt type, int num);
+void devcgroup_rdma_uncharge_resource(struct ib_ucontext *ucontext,
+				      enum devcgroup_rdma_rt type, int num);
+void devcgroup_rdma_fork(struct task_struct *task, void *priv);
+
+int devcgroup_rdma_can_attach(struct cgroup_subsys_state *css,
+			      struct cgroup_taskset *tset);
+void devcgroup_rdma_cancel_attach(struct cgroup_subsys_state *css,
+				  struct cgroup_taskset *tset);
+int devcgroup_rdma_query_resource_limit(enum devcgroup_rdma_rt type);
+#else
+
+static inline int devcgroup_rdma_try_charge_resource(
+				enum devcgroup_rdma_rt type, int num)
+{ return 0; }
+static inline void devcgroup_rdma_uncharge_resource(
+				struct ib_ucontext *ucontext,
+				enum devcgroup_rdma_rt type, int num)
+{ }
+static inline int devcgroup_rdma_query_resource_limit(
+				enum devcgroup_rdma_rt type)
+{ return DEVCG_RDMA_MAX_RESOURCES; }
+#endif
+
+#endif
diff --git a/security/device_rdma_cgroup.c b/security/device_rdma_cgroup.c
new file mode 100644
index 0000000..fb4cc59
--- /dev/null
+++ b/security/device_rdma_cgroup.c
@@ -0,0 +1,422 @@
+/*
+ * RDMA device cgroup controller of device controller cgroup.
+ *
+ * Provides a cgroup hierarchy to limit various RDMA resource allocation to a
+ * configured limit of the cgroup.
+ *
+ * Its easy for user space applications to consume of RDMA device specific
+ * hardware resources. Such resource exhaustion should be prevented so that
+ * user space applications and other kernel consumers gets chance to allocate
+ * and effectively use the hardware resources.
+ *
+ * In order to use the device rdma controller, set the maximum resource count
+ * per cgroup, which ensures that total rdma resources for processes belonging
+ * to a cgroup doesn't exceed configured limit.
+ *
+ * RDMA resource limits are hierarchical, so the highest configured limit of
+ * the hierarchy is enforced. Allowing resource limit configuration to default
+ * cgroup allows fair share to kernel space ULPs as well.
+ *
+ * This file is subject to the terms and conditions of version 2 of the GNU
+ * General Public License.  See the file COPYING in the main directory of the
+ * Linux distribution for more details.
+ */
+
+#include <linux/slab.h>
+#include <linux/device_rdma_cgroup.h>
+#include <linux/device_cgroup.h>
+#include <rdma/ib_verbs.h>
+
+/**
+ * init_devcgroup_rdma_tracker - initialize resource limits.
+ * @dev_cg: device cgroup pointer for which limits should be
+ * initialized.
+ */
+void init_devcgroup_rdma_tracker(struct dev_cgroup *dev_cg)
+{
+	int i;
+
+	for (i = 0; i < DEVCG_RDMA_RES_TYPE_MAX; i++)
+		dev_cg->rdma.tracker[i].limit = DEVCG_RDMA_MAX_RESOURCES;
+}
+
+ssize_t devcgroup_rdma_set_max_resource(struct kernfs_open_file *of,
+					char *buf,
+					size_t nbytes, loff_t off)
+{
+	struct cgroup_subsys_state *css = of_css(of);
+	struct dev_cgroup *dev_cg = css_to_devcgroup(css);
+	s64 new_limit;
+	int type = of_cft(of)->private;
+	int err;
+
+	buf = strstrip(buf);
+	if (!strcmp(buf, DEVCG_RDMA_MAX_RESOURCE_STR)) {
+		new_limit = DEVCG_RDMA_MAX_RESOURCES;
+		goto max_limit;
+	}
+
+	err = kstrtoll(buf, 0, &new_limit);
+	if (err)
+		return err;
+
+	if (new_limit < 0 || new_limit >= DEVCG_RDMA_MAX_RESOURCES)
+		return -EINVAL;
+
+max_limit:
+	dev_cg->rdma.tracker[type].limit = new_limit;
+	return nbytes;
+}
+
+int devcgroup_rdma_get_max_resource(struct seq_file *sf, void *v)
+{
+	struct dev_cgroup *dev_cg = css_to_devcgroup(seq_css(sf));
+	int type = seq_cft(sf)->private;
+	u32 usage;
+
+	if (dev_cg->rdma.tracker[type].limit ==	DEVCG_RDMA_MAX_RESOURCES) {
+		seq_printf(sf, "%s\n", DEVCG_RDMA_MAX_RESOURCE_STR);
+	} else {
+		usage = dev_cg->rdma.tracker[type].limit;
+		seq_printf(sf, "%u\n", usage);
+	}
+	return 0;
+}
+
+static const char * const rdma_res_name[] = {
+	[DEVCG_RDMA_RES_TYPE_UCTX] = "uctx",
+	[DEVCG_RDMA_RES_TYPE_CQ] = "cq",
+	[DEVCG_RDMA_RES_TYPE_PD] = "pd",
+	[DEVCG_RDMA_RES_TYPE_AH] = "ah",
+	[DEVCG_RDMA_RES_TYPE_MR] = "mr",
+	[DEVCG_RDMA_RES_TYPE_MW] = "mw",
+	[DEVCG_RDMA_RES_TYPE_SRQ] = "srq",
+	[DEVCG_RDMA_RES_TYPE_QP] = "qp",
+	[DEVCG_RDMA_RES_TYPE_FLOW] = "flow",
+};
+
+int devcgroup_rdma_show_usage(struct seq_file *m, void *v)
+{
+	struct dev_cgroup *devcg = css_to_devcgroup(seq_css(m));
+	const char *res_name = NULL;
+	u32 usage;
+	int i;
+
+	for (i = 0; i < DEVCG_RDMA_RES_TYPE_MAX; i++) {
+		res_name = rdma_res_name[i];
+		usage = atomic_read(&devcg->rdma.tracker[i].usage);
+		if (usage == DEVCG_RDMA_MAX_RESOURCES)
+			seq_printf(m, "%s %s\n", res_name,
+				   DEVCG_RDMA_MAX_RESOURCE_STR);
+		else
+			seq_printf(m, "%s %u\n", res_name, usage);
+	};
+	return 0;
+}
+
+static void rdma_free_res_counter(struct task_struct *task)
+{
+	struct task_rdma_res_counter *res_cnt = NULL;
+	bool free_res = false;
+
+	task_lock(task);
+	res_cnt = task->rdma_res_counter;
+	if (res_cnt &&
+	    res_cnt->usage[DEVCG_RDMA_RES_TYPE_UCTX] == 0) {
+		/* free resource counters if this is the last
+		 * ucontext, which is getting deallocated.
+		 */
+		task->rdma_res_counter = NULL;
+		free_res = true;
+	}
+	task_unlock(task);
+
+	/* synchronize with task migration activity from one to other cgroup
+	 * which might be reading this task's resource counters.
+	 */
+	synchronize_rcu();
+	if (free_res)
+		kfree(res_cnt);
+}
+
+static void uncharge_resource(struct dev_cgroup *dev_cg,
+			      enum devcgroup_rdma_rt type, s64 num)
+{
+	/*
+	 * A negative count (or overflow for that matter) is invalid,
+	 * and indicates a bug in the device rdma controller.
+	 */
+	WARN_ON_ONCE(atomic_add_negative(-num,
+					 &dev_cg->rdma.tracker[type].usage));
+}
+
+static void uncharge_task_resource(struct task_struct *task,
+				   struct dev_cgroup *cg,
+				   enum devcgroup_rdma_rt type,
+				   int num)
+{
+	struct dev_cgroup *p;
+
+	if (!num)
+		return;
+
+	/* protect against actual task which might be
+	 * freeing resource counter memory due to no resource
+	 * consumption.
+	 */
+	task_lock(task);
+	if (!task->rdma_res_counter) {
+		task_unlock(task);
+		return;
+	}
+	for (p = cg; p; p = parent_devcgroup(p))
+		uncharge_resource(p, type, num);
+
+	task_unlock(task);
+}
+
+/**
+ * devcgroup_rdma_uncharge_resource - hierarchically uncharge
+ * rdma resource count
+ * @ucontext: the ucontext from which to uncharge the resource
+ * pass null when caller knows that there was past allocation
+ * and its calling from same process context to which this resource
+ * belongs.
+ * @type: the type of resource to uncharge
+ * @num: the number of resource to uncharge
+ */
+void devcgroup_rdma_uncharge_resource(struct ib_ucontext *ucontext,
+				      enum devcgroup_rdma_rt type, int num)
+{
+	struct dev_cgroup *dev_cg, *p;
+	struct task_struct *ctx_task;
+
+	if (!num)
+		return;
+
+	/* get cgroup of ib_ucontext it belong to, to uncharge
+	 * so that when its called from any worker tasks or any
+	 * other tasks to which this resource doesn't belong to,
+	 * it can be uncharged correctly.
+	 */
+	if (ucontext)
+		ctx_task = get_pid_task(ucontext->tgid, PIDTYPE_PID);
+	else
+		ctx_task = current;
+	dev_cg = task_devcgroup(ctx_task);
+
+	spin_lock(&ctx_task->rdma_res_counter->lock);
+	ctx_task->rdma_res_counter->usage[type] -= num;
+
+	for (p = dev_cg; p; p = parent_devcgroup(p))
+		uncharge_resource(p, type, num);
+
+	spin_unlock(&ctx_task->rdma_res_counter->lock);
+
+	if (type == DEVCG_RDMA_RES_TYPE_UCTX)
+		rdma_free_res_counter(ctx_task);
+}
+EXPORT_SYMBOL(devcgroup_rdma_uncharge_resource);
+
+/**
+ * This function does not follow configured rdma resource limit.
+ * It cannot fail and the new rdma resource count may exceed the limit.
+ * This is only used during task migration where there is no other
+ * way out than violating the limit.
+ */
+static void charge_resource(struct dev_cgroup *dev_cg,
+			    enum devcgroup_rdma_rt type, int num)
+{
+	struct dev_cgroup *p;
+
+	for (p = dev_cg; p; p = parent_devcgroup(p)) {
+		struct devcgroup_rdma *rdma = &p->rdma;
+
+		atomic_add(num, &rdma->tracker[type].usage);
+	}
+}
+
+/**
+ * try_charge_resource - hierarchically try to charge
+ * the rdma resource count
+ * @type: the type of resource to uncharge
+ * @num: the number of rdma resource to charge
+ *
+ * This function follows the set limit. It will fail if the charge would cause
+ * the new value to exceed the hierarchical limit. Returns 0 if the charge
+ * succeded, otherwise -EAGAIN.
+ */
+static int try_charge_resource(struct dev_cgroup *dev_cg,
+			       enum devcgroup_rdma_rt type, int num)
+{
+	struct dev_cgroup *p, *q;
+
+	for (p = dev_cg; p; p = parent_devcgroup(p)) {
+		struct devcgroup_rdma *rdma = &p->rdma;
+		s64 new = atomic_add_return(num,
+					&rdma->tracker[type].usage);
+
+		if (new > rdma->tracker[type].limit)
+			goto revert;
+	}
+	return 0;
+
+revert:
+	for (q = dev_cg; q != p; q = parent_devcgroup(q))
+		uncharge_resource(q, type, num);
+	uncharge_resource(q, type, num);
+	return -EAGAIN;
+}
+
+/**
+ * devcgroup_rdma_try_charge_resource - hierarchically try to charge
+ * the rdma resource count
+ * @type: the type of resource to uncharge
+ * @num: the number of rdma resource to charge
+ *
+ * This function follows the set limit in hierarchical way.
+ * It will fail if the charge would cause the new value to exceed the
+ * hierarchical limit.
+ * Returns 0 if the charge succeded, otherwise -EAGAIN.
+ */
+int devcgroup_rdma_try_charge_resource(enum devcgroup_rdma_rt type, int num)
+{
+	struct dev_cgroup *dev_cg = task_devcgroup(current);
+	struct task_rdma_res_counter *res_cnt = current->rdma_res_counter;
+	int status;
+
+	if (!res_cnt) {
+		res_cnt = kzalloc(sizeof(*res_cnt), GFP_KERNEL);
+		if (!res_cnt)
+			return -ENOMEM;
+
+		spin_lock_init(&res_cnt->lock);
+		rcu_assign_pointer(current->rdma_res_counter, res_cnt);
+	}
+
+	/* synchronize with migration task by taking lock, to avoid
+	 * race condition of performing cgroup resource migration
+	 * in non atomic way with this task, which can leads to leaked
+	 * resources in older cgroup.
+	 */
+	spin_lock(&res_cnt->lock);
+	status = try_charge_resource(dev_cg, type, num);
+	if (status)
+		goto busy;
+
+	/* single task updating its rdma resource usage, so atomic is
+	 * not required.
+	 */
+	current->rdma_res_counter->usage[type] += num;
+
+busy:
+	spin_unlock(&res_cnt->lock);
+	return status;
+}
+EXPORT_SYMBOL(devcgroup_rdma_try_charge_resource);
+
+/**
+ * devcgroup_rdma_query_resource_limit - query the resource limit
+ * for a given resource type of the calling user process. It returns the
+ * hierarchically smallest limit of the cgroup hierarchy.
+ * @type: the type of resource to query the limit
+ * Returns resource limit across all the RDMA devices accessible
+ * to this process.
+ */
+int devcgroup_rdma_query_resource_limit(enum devcgroup_rdma_rt type)
+{
+	struct dev_cgroup *dev_cg, *p;
+	int cur_limit, limit;
+
+	dev_cg = task_devcgroup(current);
+	limit = dev_cg->rdma.tracker[type].limit;
+
+	/* find the controller in the given hirerchy with lowest limit,
+	 * and report its limit to avoid confusion to user and applications,
+	 * who rely on the query functionality.
+	 */
+	for (p = dev_cg; p; p = parent_devcgroup(p)) {
+		cur_limit = p->rdma.tracker[type].limit;
+		limit = min_t(int, cur_limit, limit);
+	}
+	return limit;
+}
+EXPORT_SYMBOL(devcgroup_rdma_query_resource_limit);
+
+int devcgroup_rdma_can_attach(struct cgroup_subsys_state *dst_css,
+			      struct cgroup_taskset *tset)
+{
+	struct dev_cgroup *dst_cg = css_to_devcgroup(dst_css);
+	struct dev_cgroup *old_cg;
+	struct task_struct *task;
+	struct task_rdma_res_counter *task_res_cnt;
+	int val, i;
+
+	cgroup_taskset_for_each(task, tset) {
+		old_cg = task_devcgroup(task);
+
+		/* protect against a task which might be deallocating
+		 * rdma_res_counter structure because last resource
+		 * of the task might undergoing deallocation.
+		 */
+		rcu_read_lock();
+		task_res_cnt = rcu_dereference(task->rdma_res_counter);
+		if (!task_res_cnt)
+			goto empty_task;
+
+		spin_lock(&task_res_cnt->lock);
+		for (i = 0; i < DEVCG_RDMA_RES_TYPE_MAX; i++) {
+			val = task_res_cnt->usage[i];
+
+			charge_resource(dst_cg, i, val);
+			uncharge_task_resource(task, old_cg, i, val);
+		}
+		spin_unlock(&task_res_cnt->lock);
+
+empty_task:
+		rcu_read_unlock();
+	}
+	return 0;
+}
+
+void devcgroup_rdma_cancel_attach(struct cgroup_subsys_state *dst_css,
+				  struct cgroup_taskset *tset)
+{
+	struct dev_cgroup *dst_cg = css_to_devcgroup(dst_css);
+	struct dev_cgroup *old_cg;
+	struct task_struct *task;
+	struct task_rdma_res_counter *task_res_cnt;
+	u32 val; int i;
+
+	cgroup_taskset_for_each(task, tset) {
+		old_cg = task_devcgroup(task);
+
+		/* protect against task deallocating rdma_res_counter structure
+		 * because last ucontext resource of the task might be
+		 * getting deallocated.
+		 */
+		rcu_read_lock();
+		task_res_cnt = rcu_dereference(task->rdma_res_counter);
+		if (!task_res_cnt)
+			goto empty_task;
+
+		spin_lock(&task_res_cnt->lock);
+		for (i = 0; i < DEVCG_RDMA_RES_TYPE_MAX; i++) {
+			val = task_res_cnt->usage[i];
+
+			charge_resource(old_cg, i, val);
+			uncharge_task_resource(task, dst_cg, i, val);
+		}
+		spin_unlock(&task_res_cnt->lock);
+empty_task:
+		rcu_read_unlock();
+	}
+}
+
+void devcgroup_rdma_fork(struct task_struct *task, void *priv)
+{
+	/* There is per task resource counters,
+	 * so whatever clone as copied over, ignore it.
+	 */
+	task->rdma_res_counter = NULL;
+}
-- 
1.8.3.1
