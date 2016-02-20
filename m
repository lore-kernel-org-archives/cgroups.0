From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Sat, 20 Feb 2016 16:30:04 +0530
Message-ID: <1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RnWz86QYuRY/y/AkHBpK7vrij/CJi5PGZmkvKc/ZkWA=;
        b=MM9hOgcGrm3EtMrFf0sHOdwW9mpU8VymQjYXY34WloauGgr5CdwoCVzM8kiuywsF/s
         13zXEti8GRqGtKeAR2U/XY4U9Xq4dVS6amHKMwkqTc6I8XL77rOvfxjYx/EWpex+0QaS
         jTic71Z6vhyjlsidBAW8eMAbWcWxM7CNPnTbFyTyddFQwn9epmuwlAw1Kh1wMFEH/hxb
         tpTFvFmfmC3AXYIuqToWnsxYC6ac36qqd8FDjoC+FdVMsVP6NC/SN0AnabnBWl9E6cGq
         BJhELl1NkBAvpTn6DgPaWyc4Oce3uOSWDxrPYS/rs3CDo5aMsG8sE/vjz6kK0wBkcz9v
         5Lpg==
In-Reply-To: <1455966006-13774-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Added rdma cgroup controller that does accounting, limit enforcement
on rdma/IB verbs and hw resources.

Added rdma cgroup header file which defines its APIs to perform
charing/uncharing functionality and device registration which will
participate in controller functions of accounting and limit
enforcements. It also define rdmacg_device structure to bind IB stack
and RDMA cgroup controller.

RDMA resources are tracked using resource pool. Resource pool is per
device, per cgroup entity which allows setting up accounting limits
on per device basis.

Resources are not defined by the RDMA cgroup, instead they are defined
by the external module IB stack. This allows extending IB stack
without changing kernel, as IB stack is going through changes
and enhancements.

Resource pool is created/destroyed dynamically whenever
charging/uncharging occurs respectively and whenever user
configuration is done. Its a tradeoff of memory vs little more code
space that creates resource pool whenever necessary,
instead of creating them during cgroup creation and device registration
time.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup_rdma.h   |  53 +++
 include/linux/cgroup_subsys.h |   4 +
 init/Kconfig                  |  10 +
 kernel/Makefile               |   1 +
 kernel/cgroup_rdma.c          | 753 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 821 insertions(+)
 create mode 100644 include/linux/cgroup_rdma.h
 create mode 100644 kernel/cgroup_rdma.c

diff --git a/include/linux/cgroup_rdma.h b/include/linux/cgroup_rdma.h
new file mode 100644
index 0000000..b370733
--- /dev/null
+++ b/include/linux/cgroup_rdma.h
@@ -0,0 +1,53 @@
+#ifndef _CGROUP_RDMA_H
+#define _CGROUP_RDMA_H
+
+#include <linux/cgroup.h>
+
+struct rdma_cgroup {
+#ifdef CONFIG_CGROUP_RDMA
+	struct cgroup_subsys_state	css;
+
+	spinlock_t rpool_list_lock;	/* protects resource pool list */
+	struct list_head rpool_head;	/* head to keep track of all resource
+					 * pools that belongs to this cgroup.
+					 */
+#endif
+};
+
+#ifdef CONFIG_CGROUP_RDMA
+
+struct rdmacg_device;
+
+struct rdmacg_pool_info {
+	const char **resource_name_table;
+	int table_len;
+};
+
+struct rdmacg_device {
+	struct rdmacg_pool_info pool_info;
+	struct list_head	rdmacg_list;
+	struct list_head	rpool_head;
+	spinlock_t		rpool_lock;	/* protects rsource pool list */
+	char			*name;
+};
+
+/* APIs for RDMA/IB stack to publish when a device wants to
+ * participate in resource accounting
+ */
+int rdmacg_register_device(struct rdmacg_device *device);
+void rdmacg_unregister_device(struct rdmacg_device *device);
+
+/* APIs for RDMA/IB stack to charge/uncharge pool specific resources */
+int rdmacg_try_charge(struct rdma_cgroup **rdmacg,
+		      struct rdmacg_device *device,
+		      int resource_index,
+		      int num);
+void rdmacg_uncharge(struct rdma_cgroup *cg,
+		     struct rdmacg_device *device,
+		     int resource_index,
+		     int num);
+void rdmacg_query_limit(struct rdmacg_device *device,
+			int *limits, int max_count);
+
+#endif	/* CONFIG_CGROUP_RDMA */
+#endif	/* _CGROUP_RDMA_H */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 0df0336a..d0e597c 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -56,6 +56,10 @@ SUBSYS(hugetlb)
 SUBSYS(pids)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_RDMA)
+SUBSYS(rdma)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/init/Kconfig b/init/Kconfig
index 2232080..1741b65 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1054,6 +1054,16 @@ config CGROUP_PIDS
 	  since the PIDs limit only affects a process's ability to fork, not to
 	  attach to a cgroup.
 
+config CGROUP_RDMA
+	bool "RDMA controller"
+	help
+	  Provides enforcement of RDMA resources defined by IB stack.
+	  It is fairly easy for consumers to exhaust RDMA resources, which
+	  can result into resource unavailibility to other consumers.
+	  RDMA controller is designed to stop this from happening.
+	  Attaching processes with active RDMA resources to the cgroup
+	  hierarchy is allowed even if can cross the hierarchy's limit.
+
 config CGROUP_FREEZER
 	bool "Freezer controller"
 	help
diff --git a/kernel/Makefile b/kernel/Makefile
index baa55e5..501f5df 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += cgroup_pids.o
+obj-$(CONFIG_CGROUP_RDMA) += cgroup_rdma.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
diff --git a/kernel/cgroup_rdma.c b/kernel/cgroup_rdma.c
new file mode 100644
index 0000000..4412b03
--- /dev/null
+++ b/kernel/cgroup_rdma.c
@@ -0,0 +1,753 @@
+/*
+ * This file is subject to the terms and conditions of version 2 of the GNU
+ * General Public License.  See the file COPYING in the main directory of the
+ * Linux distribution for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/atomic.h>
+#include <linux/seq_file.h>
+#include <linux/hashtable.h>
+#include <linux/cgroup.h>
+#include <linux/parser.h>
+#include <linux/cgroup_rdma.h>
+
+#define RDMACG_MAX_STR "max"
+
+static DEFINE_MUTEX(dev_mutex);
+static LIST_HEAD(dev_list_head);
+
+enum rdmacg_file_type {
+	RDMACG_RESOURCE_MAX,
+	RDMACG_RESOURCE_STAT,
+};
+
+/* resource tracker per resource for rdma cgroup */
+struct rdmacg_resource {
+	int max;
+	int usage;
+};
+
+/**
+ * resource pool object which represents, per cgroup, per device
+ * resources. There are multiple instance
+ * of this object per cgroup, therefore it cannot be embedded within
+ * rdma_cgroup structure. Its maintained as list.
+ */
+struct rdmacg_resource_pool {
+	struct list_head cg_list;
+	struct list_head dev_list;
+
+	struct rdmacg_device *device;
+	struct rdmacg_resource *resources;
+	struct rdma_cgroup *cg;	/* owner cg used during device cleanup */
+
+	int	refcnt;		/* count active user tasks of this pool */
+	int	num_max_cnt;	/* total number counts which are set to max */
+};
+
+static struct rdma_cgroup *css_rdmacg(struct cgroup_subsys_state *css)
+{
+	return container_of(css, struct rdma_cgroup, css);
+}
+
+static struct rdma_cgroup *parent_rdmacg(struct rdma_cgroup *cg)
+{
+	return css_rdmacg(cg->css.parent);
+}
+
+static inline struct rdma_cgroup *task_rdmacg(struct task_struct *task)
+{
+	return css_rdmacg(task_css(task, rdma_cgrp_id));
+}
+
+static inline void set_resource_limit(struct rdmacg_resource_pool *rpool,
+				      int index, int new_max)
+{
+	if (new_max == S32_MAX) {
+		if (rpool->resources[index].max != S32_MAX)
+			rpool->num_max_cnt++;
+	} else {
+		if (rpool->resources[index].max == S32_MAX)
+			rpool->num_max_cnt--;
+	}
+	rpool->resources[index].max = new_max;
+}
+
+static void set_all_resource_max_limit(struct rdmacg_resource_pool *rpool)
+{
+	struct rdmacg_pool_info *pool_info = &rpool->device->pool_info;
+	int i;
+
+	for (i = 0; i < pool_info->table_len; i++)
+		set_resource_limit(rpool, i, S32_MAX);
+}
+
+static void free_cg_rpool_mem(struct rdmacg_resource_pool *rpool)
+{
+	kfree(rpool->resources);
+	kfree(rpool);
+}
+
+static void free_cg_rpool(struct rdmacg_resource_pool *rpool)
+{
+	spin_lock(&rpool->device->rpool_lock);
+	list_del(&rpool->dev_list);
+	spin_unlock(&rpool->device->rpool_lock);
+
+	free_cg_rpool_mem(rpool);
+}
+
+static struct rdmacg_resource_pool*
+find_cg_rpool_locked(struct rdma_cgroup *cg,
+		     struct rdmacg_device *device)
+
+{
+	struct rdmacg_resource_pool *pool;
+
+	lockdep_assert_held(&cg->rpool_list_lock);
+
+	list_for_each_entry(pool, &cg->rpool_head, cg_list)
+		if (pool->device == device)
+			return pool;
+
+	return NULL;
+}
+
+static int
+alloc_cg_rpool(struct rdma_cgroup *cg,
+	       struct rdmacg_device *device)
+{
+	struct rdmacg_resource_pool *rpool, *other_rpool;
+	struct rdmacg_pool_info *pool_info = &device->pool_info;
+	int ret;
+
+	rpool = kzalloc(sizeof(*rpool), GFP_KERNEL);
+	if (!rpool) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	rpool->resources = kcalloc(pool_info->table_len,
+				   sizeof(*rpool->resources),
+				   GFP_KERNEL);
+	if (!rpool->resources) {
+		ret = -ENOMEM;
+		goto alloc_err;
+	}
+
+	rpool->device = device;
+	rpool->cg = cg;
+	INIT_LIST_HEAD(&rpool->cg_list);
+	INIT_LIST_HEAD(&rpool->dev_list);
+	spin_lock_init(&device->rpool_lock);
+	set_all_resource_max_limit(rpool);
+
+	spin_lock(&cg->rpool_list_lock);
+
+	other_rpool = find_cg_rpool_locked(cg, device);
+
+	/*
+	 * if other task added resource pool for this device for this cgroup
+	 * than free up which was recently created and use the one we found.
+	 */
+	if (other_rpool) {
+		spin_unlock(&cg->rpool_list_lock);
+		free_cg_rpool(rpool);
+		return 0;
+	}
+
+	list_add_tail(&rpool->cg_list, &cg->rpool_head);
+
+	spin_lock(&device->rpool_lock);
+	list_add_tail(&rpool->dev_list, &device->rpool_head);
+	spin_unlock(&device->rpool_lock);
+
+	spin_unlock(&cg->rpool_list_lock);
+	return 0;
+
+alloc_err:
+	kfree(rpool);
+err:
+	return ret;
+}
+
+/**
+ * uncharge_cg_resource - uncharge resource for rdma cgroup
+ * @cg: pointer to cg to uncharge and all parents in hierarchy
+ * @device: pointer to ib device
+ * @index: index of the resource to uncharge in cg (resource pool)
+ * @num: the number of rdma resource to uncharge
+ *
+ * It also frees the resource pool in the hierarchy for the resource pool
+ * which was created as part of charing operation.
+ */
+static void uncharge_cg_resource(struct rdma_cgroup *cg,
+				 struct rdmacg_device *device,
+				 int index, int num)
+{
+	struct rdmacg_resource_pool *rpool;
+	struct rdmacg_pool_info *pool_info = &device->pool_info;
+
+	spin_lock(&cg->rpool_list_lock);
+	rpool = find_cg_rpool_locked(cg, device);
+
+	/*
+	 * A negative count (or overflow) is invalid,
+	 * it indicates a bug in the rdma controller.
+	 */
+	rpool->resources[index].usage -= num;
+
+	WARN_ON_ONCE(rpool->resources[index].usage < 0);
+	rpool->refcnt--;
+	if (rpool->refcnt == 0 && rpool->num_max_cnt == pool_info->table_len) {
+		/*
+		 * No user of the rpool and all entries are set to max, so
+		 * safe to delete this rpool.
+		 */
+		list_del(&rpool->cg_list);
+		spin_unlock(&cg->rpool_list_lock);
+
+		free_cg_rpool(rpool);
+		return;
+	}
+	spin_unlock(&cg->rpool_list_lock);
+}
+
+/**
+ * rdmacg_uncharge_resource - hierarchically uncharge rdma resource count
+ * @device: pointer to rdmacg device
+ * @index: index of the resource to uncharge in cg in given resource pool
+ * @num: the number of rdma resource to uncharge
+ *
+ */
+void rdmacg_uncharge(struct rdma_cgroup *cg,
+		     struct rdmacg_device *device,
+		     int index, int num)
+{
+	struct rdma_cgroup *p;
+
+	for (p = cg; p; p = parent_rdmacg(p))
+		uncharge_cg_resource(p, device, index, num);
+
+	css_put(&cg->css);
+}
+EXPORT_SYMBOL(rdmacg_uncharge);
+
+/**
+ * charge_cg_resource - charge resource for rdma cgroup
+ * @cg: pointer to cg to charge
+ * @device: pointer to rdmacg device
+ * @index: index of the resource to charge in cg (resource pool)
+ * @num: the number of rdma resource to charge
+ */
+static int charge_cg_resource(struct rdma_cgroup *cg,
+			      struct rdmacg_device *device,
+			      int index, int num)
+{
+	struct rdmacg_resource_pool *rpool;
+	s64 new;
+	int ret = 0;
+
+retry:
+	spin_lock(&cg->rpool_list_lock);
+	rpool = find_cg_rpool_locked(cg, device);
+	if (!rpool) {
+		spin_unlock(&cg->rpool_list_lock);
+		ret = alloc_cg_rpool(cg, device);
+		if (ret)
+			goto err;
+		else
+			goto retry;
+	}
+	new = num + rpool->resources[index].usage;
+	if (new > rpool->resources[index].max) {
+		ret = -EAGAIN;
+	} else {
+		rpool->refcnt++;
+		rpool->resources[index].usage = new;
+	}
+	spin_unlock(&cg->rpool_list_lock);
+err:
+	return ret;
+}
+
+/**
+ * rdmacg_try_charge_resource - hierarchically try to charge the rdma resource
+ * @device: pointer to rdmacg device
+ * @rdmacg: pointer to rdma cgroup which will own this resource
+ * @index: index of the resource to charge in cg (resource pool)
+ * @num: the number of rdma resource to charge
+ *
+ * This function follows charing resource in hierarchical way.
+ * It will fail if the charge would cause the new value to exceed the
+ * hierarchical limit.
+ * Returns 0 if the charge succeded, otherwise -EAGAIN, -ENOMEM or -EINVAL.
+ * Returns pointer to rdmacg for this resource.
+ *
+ * Charger needs to account resources on three criteria.
+ * (a) per cgroup & (b) per device resource usage.
+ * Per cgroup resource usage ensures that tasks of cgroup doesn't cross
+ * the configured limits.
+ * Per device provides granular configuration in multi device usage.
+ * It allocates resource pool in the hierarchy for each parent it come
+ * across for first resource. Later on resource pool will be available.
+ * Therefore it will be much faster thereon to charge/uncharge.
+ */
+int rdmacg_try_charge(struct rdma_cgroup **rdmacg,
+		      struct rdmacg_device *device,
+		      int index, int num)
+{
+	struct rdma_cgroup *cg, *p, *q;
+	int ret;
+
+	cg = task_rdmacg(current);
+
+	for (p = cg; p; p = parent_rdmacg(p)) {
+		ret = charge_cg_resource(p, device, index, num);
+		if (ret)
+			goto err;
+	}
+	/*
+	 * hold on to css, as cgroup can be removed but resource
+	 * accounting happens on css.
+	 */
+	css_get(&cg->css);
+	*rdmacg = cg;
+	return 0;
+
+err:
+	for (q = cg; q != p; q = parent_rdmacg(q))
+		uncharge_cg_resource(q, device, index, num);
+	return ret;
+}
+EXPORT_SYMBOL(rdmacg_try_charge);
+
+/**
+ * rdmacg_register_rdmacg_device - register rdmacg device to rdma controller.
+ * @device: pointer to rdmacg device whose resources need to be accounted.
+ *
+ * If IB stack wish a device to participate in rdma cgroup resource
+ * tracking, it must invoke this API to register with rdma cgroup before
+ * any user space application can start using the RDMA resources.
+ * Returns 0 on success or EINVAL when table length given is beyond
+ * supported size.
+ */
+int rdmacg_register_device(struct rdmacg_device *device)
+{
+	if (device->pool_info.table_len > 64)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&device->rdmacg_list);
+	INIT_LIST_HEAD(&device->rpool_head);
+	spin_lock_init(&device->rpool_lock);
+
+	mutex_lock(&dev_mutex);
+	list_add_tail(&device->rdmacg_list, &dev_list_head);
+	mutex_unlock(&dev_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(rdmacg_register_device);
+
+/**
+ * rdmacg_unregister_rdmacg_device - unregister the rdmacg device
+ * from rdma controller.
+ * @device: pointer to rdmacg device which was previously registered with rdma
+ *          controller using rdmacg_register_device().
+ *
+ * IB stack must invoke this after all the resources of the IB device
+ * are destroyed and after ensuring that no more resources will be created
+ * when this API is invoked.
+ */
+void rdmacg_unregister_device(struct rdmacg_device *device)
+{
+	struct rdmacg_resource_pool *rpool, *tmp;
+	struct rdma_cgroup *cg;
+
+	/*
+	 * Synchronize with any active resource settings,
+	 * usage query happening via configfs.
+	 * At this stage, there should not be any active resource pools
+	 * for this device, as RDMA/IB stack is expected to shutdown,
+	 * tear down all the applications and free up resources.
+	 */
+	mutex_lock(&dev_mutex);
+	list_del_init(&device->rdmacg_list);
+	mutex_unlock(&dev_mutex);
+
+	/*
+	 * Now that this device off the cgroup list, its safe to free
+	 * all the rpool resources.
+	 */
+	list_for_each_entry_safe(rpool, tmp, &device->rpool_head, dev_list) {
+		list_del_init(&rpool->dev_list);
+		cg = rpool->cg;
+
+		spin_lock(&cg->rpool_list_lock);
+		list_del_init(&rpool->cg_list);
+		spin_unlock(&cg->rpool_list_lock);
+
+		free_cg_rpool_mem(rpool);
+	}
+}
+EXPORT_SYMBOL(rdmacg_unregister_device);
+
+/**
+ * rdmacg_query_limit - query the resource limits that
+ * might have been configured by the user.
+ * @device: pointer to ib device
+ * @type: the type of resource pool to know the limits of.
+ * @limits: pointer to an array of limits where rdma cg will provide
+ *          the configured limits of the cgroup.
+ * @limits_array_len: number of array elements to be filled up at limits.
+ *
+ * This function follows charing resource in hierarchical way.
+ * It will fail if the charge would cause the new value to exceed the
+ * hierarchical limit.
+ */
+void rdmacg_query_limit(struct rdmacg_device *device,
+			int *limits, int max_count)
+{
+	struct rdma_cgroup *cg, *p;
+	struct rdmacg_resource_pool *rpool;
+	struct rdmacg_pool_info *pool_info;
+	int i;
+
+	cg = task_rdmacg(current);
+	pool_info = &device->pool_info;
+
+	for (i = 0; i < max_count; i++)
+		limits[i] = S32_MAX;
+
+	/*
+	 * Check in hirerchy which pool get the least amount of
+	 * resource limits.
+	 */
+	for (p = cg; p; p = parent_rdmacg(p)) {
+		spin_lock(&cg->rpool_list_lock);
+		rpool = find_cg_rpool_locked(cg, device);
+		if (rpool) {
+			for (i = 0; i < max_count; i++)
+				limits[i] = min_t(int, limits[i],
+					rpool->resources[i].max);
+		}
+		spin_unlock(&cg->rpool_list_lock);
+	}
+}
+EXPORT_SYMBOL(rdmacg_query_limit);
+
+static int parse_resource(char *c, struct rdmacg_pool_info *pool_info,
+			  int *intval)
+{
+	substring_t argstr;
+	const char **table = pool_info->resource_name_table;
+	char *name, *value = c;
+	size_t len;
+	int ret, i = 0;
+
+	name = strsep(&value, "=");
+	if (!name || !value)
+		return -EINVAL;
+
+	len = strlen(value);
+
+	for (i = 0; i < pool_info->table_len; i++) {
+		if (strcmp(table[i], name))
+			continue;
+
+		argstr.from = value;
+		argstr.to = value + len;
+
+		ret = match_int(&argstr, intval);
+		if (ret >= 0) {
+			if (*intval < 0)
+				break;
+			return i;
+		}
+		if (strncmp(value, RDMACG_MAX_STR, len) == 0) {
+			*intval = S32_MAX;
+			return i;
+		}
+		break;
+	}
+	return -EINVAL;
+}
+
+static int rdmacg_parse_limits(char *options,
+			       struct rdmacg_pool_info *pool_info,
+			       int *new_limits, u64 *enables)
+{
+	char *c;
+	int err = -EINVAL;
+
+	/* parse resource options */
+	while ((c = strsep(&options, " ")) != NULL) {
+		int index, intval;
+
+		index = parse_resource(c, pool_info, &intval);
+		if (index < 0)
+			goto err;
+
+		new_limits[index] = intval;
+		*enables |= BIT(index);
+	}
+	return 0;
+
+err:
+	return err;
+}
+
+static struct rdmacg_device *rdmacg_get_device_locked(const char *name)
+{
+	struct rdmacg_device *device;
+
+	list_for_each_entry(device, &dev_list_head, rdmacg_list)
+		if (!strcmp(name, device->name))
+			return device;
+
+	return NULL;
+}
+
+static ssize_t rdmacg_resource_set_max(struct kernfs_open_file *of,
+				       char *buf, size_t nbytes, loff_t off)
+{
+	struct rdma_cgroup *cg = css_rdmacg(of_css(of));
+	const char *dev_name;
+	struct rdmacg_resource_pool *rpool;
+	struct rdmacg_device *device;
+	char *options = strstrip(buf);
+	struct rdmacg_pool_info *pool_info;
+	u64 enables = 0;
+	int *new_limits;
+	int i = 0, ret = 0;
+
+	/* extract the device name first */
+	dev_name = strsep(&options, " ");
+	if (!dev_name) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* acquire lock to synchronize with hot plug devices */
+	mutex_lock(&dev_mutex);
+
+	device = rdmacg_get_device_locked(dev_name);
+	if (!device) {
+		ret = -ENODEV;
+		goto parse_err;
+	}
+
+	pool_info = &device->pool_info;
+
+	new_limits = kcalloc(pool_info->table_len, sizeof(int), GFP_KERNEL);
+	if (!new_limits) {
+		ret = -ENOMEM;
+		goto parse_err;
+	}
+
+	ret = rdmacg_parse_limits(options, pool_info, new_limits, &enables);
+	if (ret)
+		goto opt_err;
+
+retry:
+	spin_lock(&cg->rpool_list_lock);
+	rpool = find_cg_rpool_locked(cg, device);
+	if (!rpool) {
+		spin_unlock(&cg->rpool_list_lock);
+		ret = alloc_cg_rpool(cg, device);
+		if (ret)
+			goto opt_err;
+		else
+			goto retry;
+	}
+
+	/* now set the new limits of the rpool */
+	while (enables) {
+		/* if user set the limit, enables bit is set */
+		if (enables & BIT(i)) {
+			enables &= ~BIT(i);
+			set_resource_limit(rpool, i, new_limits[i]);
+		}
+		i++;
+	}
+	if (rpool->refcnt == 0 &&
+	    rpool->num_max_cnt == pool_info->table_len) {
+		/*
+		 * No user of the rpool and all entries are
+		 * set to max, so safe to delete this rpool.
+		 */
+		list_del(&rpool->cg_list);
+		spin_unlock(&cg->rpool_list_lock);
+		free_cg_rpool(rpool);
+	} else {
+		spin_unlock(&cg->rpool_list_lock);
+	}
+
+opt_err:
+	kfree(new_limits);
+parse_err:
+	mutex_unlock(&dev_mutex);
+err:
+	return ret ?: nbytes;
+}
+
+static u32 *get_cg_rpool_values(struct rdma_cgroup *cg,
+				struct rdmacg_device *device,
+				enum rdmacg_file_type sf_type,
+				int count)
+{
+	struct rdmacg_resource_pool *rpool;
+	u32 *value_tbl;
+	int i, ret;
+
+	value_tbl = kcalloc(count, sizeof(u32), GFP_KERNEL);
+	if (!value_tbl) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	spin_lock(&cg->rpool_list_lock);
+
+	rpool = find_cg_rpool_locked(cg, device);
+
+	for (i = 0; i < count; i++) {
+		if (sf_type == RDMACG_RESOURCE_MAX) {
+			if (rpool)
+				value_tbl[i] = rpool->resources[i].max;
+			else
+				value_tbl[i] = S32_MAX;
+		} else {
+			if (rpool)
+				value_tbl[i] = rpool->resources[i].usage;
+		}
+	}
+
+	spin_unlock(&cg->rpool_list_lock);
+
+	return value_tbl;
+
+err:
+	return ERR_PTR(ret);
+}
+
+static int print_rpool_values(struct seq_file *sf,
+			      struct rdmacg_pool_info *pool_info,
+			      u32 *value_tbl)
+{
+	int i;
+
+	for (i = 0; i < pool_info->table_len; i++) {
+		seq_puts(sf, pool_info->resource_name_table[i]);
+		seq_putc(sf, '=');
+		if (value_tbl[i] == S32_MAX)
+			seq_puts(sf, RDMACG_MAX_STR);
+		else
+			seq_printf(sf, "%d", value_tbl[i]);
+		seq_putc(sf, ' ');
+	}
+	return 0;
+}
+
+static int rdmacg_resource_read(struct seq_file *sf, void *v)
+{
+	struct rdmacg_device *device;
+	struct rdma_cgroup *cg = css_rdmacg(seq_css(sf));
+	struct rdmacg_pool_info *pool_info;
+	u32 *value_tbl;
+	int ret = 0;
+
+	mutex_lock(&dev_mutex);
+
+	list_for_each_entry(device, &dev_list_head, rdmacg_list) {
+		pool_info = &device->pool_info;
+
+		/* get the value from resource pool */
+		value_tbl = get_cg_rpool_values(cg, device,
+						seq_cft(sf)->private,
+						pool_info->table_len);
+		if (IS_ERR_OR_NULL(value_tbl)) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		seq_printf(sf, "%s ", device->name);
+		ret = print_rpool_values(sf, pool_info, value_tbl);
+		seq_putc(sf, '\n');
+
+		kfree(value_tbl);
+		if (ret)
+			break;
+	}
+
+	mutex_unlock(&dev_mutex);
+	return ret;
+}
+
+static struct cftype rdmacg_files[] = {
+	{
+		.name = "max",
+		.write = rdmacg_resource_set_max,
+		.seq_show = rdmacg_resource_read,
+		.private = RDMACG_RESOURCE_MAX,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "current",
+		.seq_show = rdmacg_resource_read,
+		.private = RDMACG_RESOURCE_STAT,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{ }	/* terminate */
+};
+
+static struct cgroup_subsys_state *
+rdmacg_css_alloc(struct cgroup_subsys_state *parent)
+{
+	struct rdma_cgroup *cg;
+
+	cg = kzalloc(sizeof(*cg), GFP_KERNEL);
+	if (!cg)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&cg->rpool_head);
+	spin_lock_init(&cg->rpool_list_lock);
+	return &cg->css;
+}
+
+static void rdmacg_css_free(struct cgroup_subsys_state *css)
+{
+	struct rdma_cgroup *cg = css_rdmacg(css);
+
+	kfree(cg);
+}
+
+/**
+ * rdmacg_css_offline - cgroup css_offline callback
+ * @css: css of interest
+ *
+ * This function is called when @css is about to go away and responsible
+ * for shooting down all rdmacg associated with @css. As part of that it
+ * marks all the resource pool entries to max value, so that when resources are
+ * uncharged, associated resource pool can be freed as well.
+ */
+static void rdmacg_css_offline(struct cgroup_subsys_state *css)
+{
+	struct rdma_cgroup *cg = css_rdmacg(css);
+	struct rdmacg_resource_pool *rpool;
+
+	spin_lock(&cg->rpool_list_lock);
+
+	list_for_each_entry(rpool, &cg->rpool_head, cg_list)
+		set_all_resource_max_limit(rpool);
+
+	spin_unlock(&cg->rpool_list_lock);
+}
+
+struct cgroup_subsys rdma_cgrp_subsys = {
+	.css_alloc	= rdmacg_css_alloc,
+	.css_free	= rdmacg_css_free,
+	.css_offline	= rdmacg_css_offline,
+	.legacy_cftypes	= rdmacg_files,
+	.dfl_cftypes	= rdmacg_files,
+};
-- 
1.8.3.1
