From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv1 3/6] rdmacg: implements rdma cgroup
Date: Wed,  6 Jan 2016 00:28:03 +0530
Message-ID: <1452020286-9508-4-git-send-email-pandit.parav@gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k2YEpVbMeZ3BfZDcJVYhbYs1Ky9/BxkzclUIvrSXxtE=;
        b=mzRkCZ7b/1nFAXmIQ1pSPETxVWwqfQx5CodY0zLmwPx2lhZ01D5yg6GoS+P+gmDm6g
         Tpb2cDj9InY3mYFs3nqEcKitBmYL5yM86xl2rSK+RzpkzJAJcMFVUZCsfE7LPjoExvno
         9S4kReksWdqNRsxEFT/kQBdUtPeVaepGLeutIFXPC/HwMtVW6A9jKzEjkTw9nULoGZ26
         +Lcmps4cKzmctCXo0xJ0F81O9QPH0ZcacOHYddkbMqmsvD+nqW2yrdaZ731FLcGaToHj
         D1/8tGxGGJd9Et/PVKr5pK7/cjmyYeagmC3pgXFf0mJ+dbbjkvPo2FzYE50/A+k8YUoU
         oQyA==
In-Reply-To: <1452020286-9508-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Adds RDMA controller to limit the number of RDMA resources that can be
consumed by processes of a rdma cgroup.

RDMA resources are global resource that can be exhauasted without
reaching any kmemcg or other policy. RDMA cgroup implementation allows
limiting RDMA/IB well defined resources to be limited per cgroup.

RDMA resources are tracked using resource pool. Resource pool is per
device, per cgroup, per resource pool_type entity which allows setting
up accounting limits on per device basis.

RDMA cgroup returns error when user space applications try to allocate
resources more than its configured limit.

Rdma cgroup implements resource accounting for two types of resource
pools.
(a) RDMA IB specification level verb resources defined by IB stack
(b) HCA vendor device specific resources defined by vendor device driver

Resources are not defined by the RDMA cgroup, instead they are defined
by the external module, typically IB stack and optionally by HCA drivers
for those RDMA devices which doesn't have one to one mapping of IB verb
resource with hardware resource.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup_subsys.h |    4 +
 init/Kconfig                  |   12 +
 kernel/Makefile               |    1 +
 kernel/cgroup_rdma.c          | 1220 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1237 insertions(+)
 create mode 100644 kernel/cgroup_rdma.c

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
index f8754f5..f8055f5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1070,6 +1070,18 @@ config CGROUP_PIDS
 	  since the PIDs limit only affects a process's ability to fork, not to
 	  attach to a cgroup.
 
+config CGROUP_RDMA
+	bool "RDMA controller"
+	help
+	  Provides enforcement of RDMA resources at RDMA/IB verb level and
+	  enforcement of any RDMA/IB capable hardware advertized resources.
+	  Its fairly easy for applications to exhaust RDMA resources, which
+	  can result into kernel consumers or other application consumers of
+	  RDMA resources left with no resources. RDMA controller is designed
+	  to stop this from happening.
+	  Attaching existing processes with active RDMA resources to the cgroup
+	  hierarchy will be allowed even if can cross the hierarchy's limit.
+
 config CGROUP_FREEZER
 	bool "Freezer controller"
 	help
diff --git a/kernel/Makefile b/kernel/Makefile
index 53abf00..26e413c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += cgroup_pids.o
+obj-$(CONFIG_CGROUP_RDMA) += cgroup_rdma.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
diff --git a/kernel/cgroup_rdma.c b/kernel/cgroup_rdma.c
new file mode 100644
index 0000000..14c6fab
--- /dev/null
+++ b/kernel/cgroup_rdma.c
@@ -0,0 +1,1220 @@
+/*
+ * This file is subject to the terms and conditions of version 2 of the GNU
+ * General Public License.  See the file COPYING in the main directory of the
+ * Linux distribution for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/threads.h>
+#include <linux/pid.h>
+#include <linux/spinlock.h>
+#include <linux/parser.h>
+#include <rdma/ib_verbs.h>
+#include <linux/atomic.h>
+#include <linux/seq_file.h>
+#include <linux/hashtable.h>
+#include <linux/cgroup.h>
+#include <linux/cgroup_rdma.h>
+
+enum rdmacg_file_type {
+	RDMACG_VERB_RESOURCE_LIMIT,
+	RDMACG_VERB_RESOURCE_USAGE,
+	RDMACG_VERB_RESOURCE_FAILCNT,
+	RDMACG_VERB_RESOURCE_LIST,
+	RDMACG_HW_RESOURCE_LIMIT,
+	RDMACG_HW_RESOURCE_USAGE,
+	RDMACG_HW_RESOURCE_FAILCNT,
+	RDMACG_HW_RESOURCE_LIST,
+};
+
+#define RDMACG_USR_CMD_REMOVE "remove"
+
+/* resource tracker per resource for rdma cgroup */
+struct cg_resource {
+	atomic_t usage;
+	int limit;
+	atomic_t failcnt;
+};
+
+/**
+ * pool type indicating either it got created as part of default
+ * operation or user has configured the group.
+ * Depends on the creator of the pool, its decided to free up
+ * later or not.
+ */
+enum rpool_creator {
+	RDMACG_RPOOL_CREATOR_DEFAULT,
+	RDMACG_RPOOL_CREATOR_USR,
+};
+
+/**
+ * resource pool object which represents, per cgroup, per device,
+ * per resource pool_type resources.
+ */
+struct cg_resource_pool {
+	struct list_head cg_list;
+	struct ib_device *device;
+	enum rdmacg_resource_pool_type type;
+
+	struct cg_resource *resources;
+
+	atomic_t refcnt;	/* count active user tasks of this pool */
+	atomic_t creator;	/* user created or default type */
+};
+
+struct rdma_cgroup {
+	struct cgroup_subsys_state	css;
+
+	struct list_head rpool_head;	/* head to keep track of all resource
+					 * pools that belongs to this cgroup.
+					 */
+	spinlock_t	cg_list_lock;	/* protects cgroup resource pool list */
+
+};
+
+/* hash table to keep map of tgid to owner cgroup */
+DEFINE_HASHTABLE(pid_cg_map_tbl, 7);
+DEFINE_SPINLOCK(pid_cg_map_lock);	/* lock to protect hash table access */
+
+/* Keeps mapping of pid to its owning cgroup at rdma level,
+ * This mapping doesn't change, even if process migrates from one to other
+ * rdma cgroup.
+ */
+struct pid_cg_map {
+	struct pid *pid;		/* hash key */
+	struct rdma_cgroup *cg;
+
+	struct hlist_node hlist;	/* pid to cgroup hash table link */
+	atomic_t refcnt;		/* count active user tasks to figure out
+					 * when to free the memory
+					 */
+};
+
+static DEFINE_MUTEX(dev_mutex);
+static LIST_HEAD(dev_list);
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
+static struct rdmacg_resource_pool_ops*
+	get_pool_ops(struct ib_device *device,
+		     enum rdmacg_resource_pool_type pool_type)
+{
+	return device->rpool_ops[pool_type];
+}
+
+static inline void set_resource_limit(struct cg_resource_pool *rpool,
+				      int index,
+				      int new_limit)
+{
+	rpool->resources[index].limit = new_limit;
+}
+
+static void _free_cg_rpool(struct cg_resource_pool *rpool)
+{
+	kfree(rpool->resources);
+	kfree(rpool);
+}
+
+static void _dealloc_cg_rpool(struct rdma_cgroup *cg,
+			      struct cg_resource_pool *rpool)
+{
+	spin_lock(&cg->cg_list_lock);
+
+	/* if its started getting used by other task,
+	 * before we take the spin lock, then skip,
+	 * freeing it.
+	 */
+	if (atomic_read(&rpool->refcnt) == 0) {
+		list_del_init(&rpool->cg_list);
+		spin_unlock(&cg->cg_list_lock);
+
+		_free_cg_rpool(rpool);
+		return;
+	}
+	spin_unlock(&cg->cg_list_lock);
+}
+
+static void dealloc_cg_rpool(struct rdma_cgroup *cg,
+			     struct cg_resource_pool *rpool)
+{
+	/* Don't free the resource pool which is created by the
+	 * user, otherwise we miss the configured limits. We don't
+	 * gain much either by splitting storage of limit and usage.
+	 * So keep it around until user deletes the limits.
+	 */
+	if (atomic_read(&rpool->creator) == RDMACG_RPOOL_CREATOR_DEFAULT)
+		_dealloc_cg_rpool(cg, rpool);
+}
+
+static void put_cg_rpool(struct rdma_cgroup *cg,
+			 struct cg_resource_pool *rpool)
+{
+	if (atomic_dec_and_test(&rpool->refcnt))
+		dealloc_cg_rpool(cg, rpool);
+}
+
+static struct cg_resource_pool*
+	alloc_cg_rpool(struct rdma_cgroup *cg,
+		       struct ib_device *device,
+		       int count,
+		       enum rdmacg_resource_pool_type type)
+{
+	struct cg_resource_pool *rpool;
+	int i, ret;
+
+	rpool = kzalloc(sizeof(*rpool), GFP_KERNEL);
+	if (!rpool) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	rpool->resources = kcalloc(count, sizeof(*rpool->resources),
+				   GFP_KERNEL);
+	if (!rpool->resources) {
+		ret = -ENOMEM;
+		goto alloc_err;
+	}
+
+	/* set pool ownership and type, so that it can be freed correctly */
+	rpool->device = device;
+	rpool->type = type;
+	INIT_LIST_HEAD(&rpool->cg_list);
+	atomic_set(&rpool->creator, RDMACG_RPOOL_CREATOR_DEFAULT);
+
+	for (i = 0; i < count; i++)
+		set_resource_limit(rpool, i, S32_MAX);
+
+	return rpool;
+
+alloc_err:
+	kfree(rpool);
+err:
+	return ERR_PTR(ret);
+}
+
+static struct cg_resource_pool*
+	find_cg_rpool(struct rdma_cgroup *cg,
+		      struct ib_device *device,
+		      enum rdmacg_resource_pool_type type)
+
+{
+	struct cg_resource_pool *pool;
+
+	list_for_each_entry(pool, &cg->rpool_head, cg_list)
+		if (pool->device == device && pool->type == type)
+			return pool;
+
+	return NULL;
+}
+
+static struct cg_resource_pool*
+	_get_cg_rpool(struct rdma_cgroup *cg,
+		      struct ib_device *device,
+		      enum rdmacg_resource_pool_type type)
+{
+	struct cg_resource_pool *rpool;
+
+	spin_lock(&cg->cg_list_lock);
+	rpool = find_cg_rpool(cg, device, type);
+	if (rpool)
+		goto found;
+found:
+	spin_unlock(&cg->cg_list_lock);
+	return rpool;
+}
+
+/**
+ * get_cg_rpool - get pid_cg map reference.
+ * @cg: cgroup for which resouce pool to be allocated.
+ * @device: device for which to allocate resource pool.
+ * @type: type of the resource pool.
+ *
+ * It searches a cgroup resource pool object for a given pid, if it finds
+ * it would return it. If none is present, it would allocate
+ * new resource pool entry of default type.
+ * Returns resource pool on success, else return error pointer or null.
+ */
+static struct cg_resource_pool*
+	get_cg_rpool(struct rdma_cgroup *cg,
+		     struct ib_device *device,
+		     enum rdmacg_resource_pool_type type)
+{
+	struct cg_resource_pool *rpool, *other_rpool;
+	struct rdmacg_pool_info *pool_info;
+	struct rdmacg_resource_pool_ops *ops;
+	int ret = 0;
+
+	spin_lock(&cg->cg_list_lock);
+	rpool = find_cg_rpool(cg, device, type);
+	if (rpool) {
+		atomic_inc(&rpool->refcnt);
+		spin_unlock(&cg->cg_list_lock);
+		return rpool;
+	}
+	spin_unlock(&cg->cg_list_lock);
+
+	/* ops cannot be NULL at this stage, as caller made to charge/get
+	 * the resource pool being aware of such need and invoking with
+	 * because it has setup resource pool ops.
+	 */
+	ops = get_pool_ops(device, type);
+	pool_info = ops->get_resource_pool_tokens(device);
+	if (!pool_info) {
+		ret = -EINVAL;
+		goto err;
+	}
+	if (pool_info->resource_count == 0 ||
+	    pool_info->resource_count > RDMACG_MAX_RESOURCE_INDEX) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* allocate resource pool */
+	rpool = alloc_cg_rpool(cg, device, pool_info->resource_count, type);
+	if (IS_ERR_OR_NULL(rpool))
+		return rpool;
+
+	/* cgroup lock is held to synchronize with multiple
+	 * resource pool creation in parallel.
+	 */
+	spin_lock(&cg->cg_list_lock);
+	other_rpool = find_cg_rpool(cg, device, type);
+	/* if other task added resource pool for this device for this cgroup
+	 * free up which was recently created and use the one we found.
+	 */
+	if (other_rpool) {
+		atomic_inc(&other_rpool->refcnt);
+		spin_unlock(&cg->cg_list_lock);
+		_free_cg_rpool(rpool);
+		return other_rpool;
+	}
+
+	atomic_inc(&rpool->refcnt);
+	list_add_tail(&rpool->cg_list, &cg->rpool_head);
+
+	spin_unlock(&cg->cg_list_lock);
+	return rpool;
+
+err:
+	spin_unlock(&cg->cg_list_lock);
+	return ERR_PTR(ret);
+}
+
+static struct pid_cg_map *find_owner_cg_for_pid(struct pid *pid)
+{
+	struct pid_cg_map *map;
+	unsigned long key = (unsigned long)pid;
+
+	hash_for_each_possible(pid_cg_map_tbl, map, hlist, key)
+		if (map->pid == pid)
+			return map;
+
+	return NULL;
+}
+
+/**
+ * put_pid_cg_map - release pid_cg map reference.
+ * @map: pointer to map
+ *
+ * It free the map object if this is the last reference,
+ * otherwise just decrement the refcnt.
+ */
+static void put_pid_cg_map(struct pid_cg_map *map)
+{
+	struct rdma_cgroup *cg = map->cg;
+	struct pid_cg_map *free_map = NULL;
+
+	if (atomic_dec_and_test(&map->refcnt)) {
+		spin_lock(&pid_cg_map_lock);
+		if (atomic_read(&map->refcnt) == 0) {
+			/* read the refcnt again to make sure, if its
+			 * already in use before above spin lock
+			 * is taken by other task, than dont free it.
+			 */
+			hash_del(&map->hlist);
+			free_map = map;
+		}
+		spin_unlock(&pid_cg_map_lock);
+		if (free_map) {
+			/* now that pid is getting detached from cg,
+			 * drop the css ref count.
+			 */
+			css_put(&cg->css);
+			kfree(free_map);
+		}
+	}
+}
+
+/**
+ * _get_pid_cg_map - get the rdma cgroup from pid
+ * @cg: pointer to cgroup
+ *
+ * It search and return a cgroup map for a given pid, if it finds
+ * it would return it. If none is present, it would allocate
+ * new map entry.
+ * Returns map object on success, else return error pointer or null.
+ */
+static struct pid_cg_map *_get_pid_cg_map(struct pid *pid)
+{
+	struct pid_cg_map *map;
+
+	spin_lock(&pid_cg_map_lock);
+	map = find_owner_cg_for_pid(pid);
+	spin_unlock(&pid_cg_map_lock);
+
+	/* if we dont find a map for a given pid, its either
+	 * bug in caller with wrong pid, or bug in rdma
+	 * controller.
+	 */
+	WARN_ON(!map);
+	return map;
+}
+
+/**
+ * get_pid_cg_map - get the rdma cgroup from pid
+ * @cg: pointer to cgroup
+ *
+ * It searches a cgroup map object for a given pid, if it finds
+ * it would return it. If none is present, it would allocate
+ * new map entry.
+ * Returns map object on success, else return error pointer or null.
+ */
+static struct pid_cg_map *get_pid_cg_map(struct pid *pid)
+{
+	struct pid_cg_map *map, *other_map;
+
+	spin_lock(&pid_cg_map_lock);
+
+	map = find_owner_cg_for_pid(pid);
+	if (map)
+		atomic_inc(&map->refcnt);
+
+	spin_unlock(&pid_cg_map_lock);
+
+	/* existing cg found, as most likely the case
+	 * after first resource allocation.
+	 */
+	if (likely(map))
+		return map;
+
+	/* cg not found for this tgid */
+	map = kzalloc(sizeof(*map), GFP_KERNEL);
+	if (!map)
+		return NULL;
+	map->pid = pid;
+	INIT_HLIST_NODE(&map->hlist);
+
+	/* always consider the cgroup of calling process to map to,
+	 * as pid's cgroup and pid's thread leader might have been already
+	 * terminated by now.
+	 */
+	map->cg = task_rdmacg(current);
+
+	/* search again, in case if other process has perform binding, before
+	 * this task can do.
+	 */
+	spin_lock(&pid_cg_map_lock);
+	other_map = find_owner_cg_for_pid(pid);
+	if (other_map) {
+		/* found the map added by other task, reuse it */
+		atomic_inc(&other_map->refcnt);
+		spin_unlock(&pid_cg_map_lock);
+		kfree(map);
+
+		map = other_map;
+	} else {
+		hash_add(pid_cg_map_tbl, &map->hlist, (unsigned long)pid);
+		atomic_inc(&map->refcnt);
+		spin_unlock(&pid_cg_map_lock);
+
+		/* Hold the reference to css for every new map added.
+		 * so that even if task migrate to new cgroup, we hold the css.
+		 * We hold the reference to css, until rdma resources
+		 * are bound to it. This can keep the css to be around
+		 * for longer time, but it ensures that resource
+		 * charing/uncharging happens to right cgroup,
+		 * even when parent resource creator task is terminated
+		 * (and cgroup also might have been removed, but css is not).
+		 */
+		css_get(&map->cg->css);
+	}
+	return map;
+}
+
+/**
+ * uncharge_cg_resource - hierarchically uncharge resource for rdma cgroup
+ * @cg: pointer to cg to uncharge and all parents in hierarchy
+ * @device: pointer to ib device
+ * @type: the type of resource pool to uncharge
+ * @index: index of the resource to uncharge in cg (resource pool)
+ * @num: the number of rdma resource to uncharge
+ *
+ * It also frees the resource pool in the hierarchy for the resource pool
+ * of default type which was created as part of charing operation.
+ */
+static void uncharge_cg_resource(struct rdma_cgroup *cg,
+				 struct ib_device *device,
+				 enum rdmacg_resource_pool_type type,
+				 int index,
+				 int num)
+{
+	struct cg_resource_pool *rpool;
+
+	rpool = _get_cg_rpool(cg, device, type);
+	/*
+	 * A negative count (or overflow) is invalid,
+	 * and indicates a bug in the device rdma controller.
+	 */
+	WARN_ON_ONCE(atomic_add_negative(-num,
+					 &rpool->resources[index].usage));
+	put_cg_rpool(cg, rpool);
+}
+
+/**
+ * rdmacg_uncharge_resource - hierarchically uncharge rdma resource count
+ * @device: pointer to ib device
+ * @pid: thread group pid which will owns the resource
+ * @type: the type of resource pool to charge
+ * @index: index of the resource to uncharge in cg in given resource pool type
+ * @num: the number of rdma resource to uncharge
+ *
+ */
+void rdmacg_uncharge_resource(struct ib_device *device,
+			      struct pid *pid,
+			      enum rdmacg_resource_pool_type type,
+			      int index,
+			      int num)
+{
+	struct pid_cg_map *map;
+	struct rdma_cgroup *cg, *p;
+
+	if (!num)
+		return;
+
+	map = _get_pid_cg_map(pid);
+	cg = map->cg;
+
+	for (p = cg; p; p = parent_rdmacg(p))
+		uncharge_cg_resource(p, device, type, index, num);
+
+	put_pid_cg_map(map);
+}
+EXPORT_SYMBOL(rdmacg_uncharge_resource);
+
+/**
+ * try_charge_resource - hierarchically try to charge given resource
+ * @cg: pointer to cg to charge and all parents in hierarchy
+ * @device: pointer to ib device
+ * @type: the type of resource pool to charge
+ * @index: index of the resource to charge in cg (resource pool)
+ * @num: the number of rdma resource to charge
+ *
+ * This function follows the set limit. It will fail if the charge would cause
+ * the new value to exceed the hierarchical limit.
+ * Returns 0 if the charge succeded, otherwise -EAGAIN.
+ *
+ * It allocates resource pool in the hierarchy for each parent it come
+ * across for first resource. Later on resource pool will be available.
+ * Therefore it will be much faster thereon to charge/uncharge.
+ */
+static int try_charge_resource(struct rdma_cgroup *cg,
+			       struct ib_device *device,
+			       enum rdmacg_resource_pool_type type,
+			       int index,
+			       int num)
+{
+	struct cg_resource_pool *rpool;
+	struct rdma_cgroup *p, *q;
+	int ret;
+
+	for (p = cg; p; p = parent_rdmacg(p)) {
+		s64 new;
+
+		rpool = get_cg_rpool(p, device, type);
+		if (IS_ERR_OR_NULL(rpool)) {
+			ret = PTR_ERR(rpool);
+			goto err;
+		}
+
+		new = atomic_add_return(num, &rpool->resources[index].usage);
+		if (new > rpool->resources[index].limit) {
+			atomic_inc(&rpool->resources[index].failcnt);
+			ret = -EAGAIN;
+			goto revert;
+		}
+	}
+	return 0;
+
+revert:
+	uncharge_cg_resource(p, device, type, index, num);
+err:
+	for (q = cg; q != p; q = parent_rdmacg(q))
+		uncharge_cg_resource(q, device, type, index, num);
+	return ret;
+}
+
+/**
+ * rdmacg_try_charge_resource - hierarchically try to charge
+ * the rdma resource count
+ * @device: pointer to ib device
+ * @pid: thread group pid which will own the resource until its
+ *       destroyed.
+ * @type: the type of resource pool to charge
+ * @index: index of the resource to charge in cg (resource pool)
+ * @num: the number of rdma resource to charge
+ *
+ * This function follows charing resource in hierarchical way.
+ * It will fail if the charge would cause the new value to exceed the
+ * hierarchical limit.
+ * Returns 0 if the charge succeded, otherwise -EAGAIN, -ENOMEM or -EINVAL.
+ */
+int rdmacg_try_charge_resource(struct ib_device *device,
+			       struct pid *pid,
+			       enum rdmacg_resource_pool_type type,
+			       int index,
+			       int num)
+{
+	struct rdma_cgroup *cg;
+	struct pid_cg_map *map;
+	int status;
+
+	map = get_pid_cg_map(pid);
+	if (!map)
+		return -ENOMEM;
+	cg = map->cg;
+
+	/* Charger needs to account resources on three criteria.
+	 * (a) per cgroup (b) per device & (c) per resource type resource usage.
+	 * Per cgroup resource usage ensures that tasks of cgroup doesn't cross
+	 * the configured limits.
+	 * Per device provides granular configuration in multi device usage.
+	 * Per resource type allows resource charing for multiple
+	 * category of resources (at present two, (a) verb level & (b) hw driver
+	 * define.
+	 */
+
+	/* charge the cgroup resource pool */
+	status = try_charge_resource(cg, device, type, index, num);
+	if (status)
+		goto charge_err;
+
+	return 0;
+
+charge_err:
+	put_pid_cg_map(map);
+	return status;
+}
+EXPORT_SYMBOL(rdmacg_try_charge_resource);
+
+/**
+ * rdmacg_register_ib_device - register the ib device from rdma cgroup.
+ * @device: pointer to ib device whose resources need to be accounted.
+ *
+ * If IB subsystem wish a device to participate in rdma cgroup resource
+ * tracking, it must invoke this API to register with rdma cgroup before
+ * any user space application can start using the RDMA resources. IB subsystem
+ * and/or HCA driver must invoke rdmacg_set_rpool_ops() either for verb or
+ * for hw or for both the types as they are mandetory operations to have
+ * to register with rdma cgroup.
+ *
+ */void rdmacg_register_ib_device(struct ib_device *device)
+{
+	INIT_LIST_HEAD(&device->rdmacg_list);
+
+	mutex_lock(&dev_mutex);
+	list_add_tail(&device->rdmacg_list, &dev_list);
+	mutex_unlock(&dev_mutex);
+}
+EXPORT_SYMBOL(rdmacg_register_ib_device);
+
+/**
+ * rdmacg_unregister_ib_device - unregister the ib device from rdma cgroup.
+ * @device: pointer to ib device which was previously registered with rdma
+ *          cgroup using rdmacg_register_ib_device().
+ *
+ * IB subsystem must invoke this after all the resources of the IB device
+ * are destroyed and after ensuring that no more resources will be created
+ * when this API is invoked.
+ */
+void rdmacg_unregister_ib_device(struct ib_device *device)
+{
+	/* Synchronize with any active resource settings,
+	 * usage query happening via configfs.
+	 * At this stage, there should not be any active resource pools
+	 * for this device, as RDMA/IB subsystem is expected to shutdown,
+	 * tear down all the applications and free up resources.
+	 */
+	mutex_lock(&dev_mutex);
+	list_del_init(&device->rdmacg_list);
+	mutex_unlock(&dev_mutex);
+}
+EXPORT_SYMBOL(rdmacg_unregister_ib_device);
+
+/**
+ * rdmacg_set_rpool_ops - helper function to set the resource pool
+ *                        call back function to provide matching
+ *                        string tokens to for defining names of the
+ *                        resources.
+ * @device: pointer to ib device for which to set the resource pool
+ *          operations.
+ * @pool_type: resource pool type, either VERBS type or HW type.
+ * @ops: pointer to function pointers to return (a) matching token
+ *       which will be invoked to find out string tokens and
+ *       (b) to find out maximum resource limits that is supported
+ *       by each device of given resource pool type.
+ *
+ * This helper function allows setting resouce pool specific operation
+ * callback functions.
+ * It must be called one by respective subsystem that implements resource
+ * definition of rdma and owns the task of charging/uncharing the resource.
+ * This must be called before ib device is registered with the rdma cgroup
+ * using rdmacg_register_ib_device().
+ */
+void rdmacg_set_rpool_ops(struct ib_device *device,
+			  enum rdmacg_resource_pool_type pool_type,
+			  struct rdmacg_resource_pool_ops *ops)
+{
+	device->rpool_ops[pool_type] = ops;
+}
+EXPORT_SYMBOL(rdmacg_set_rpool_ops);
+
+/**
+ * rdmacg_clear_rpool_ops -
+ * helper function to clear the resource pool ops which was setup
+ * before using rdmacg_set_rpool_ops.
+ * @device: pointer to ib device for which to clear the resource pool
+ *          operations.
+ * @pool_type: resource pool type, either VERBS type or HW type.
+ *
+ * This must be called after deregistering ib device using rdma cgroup
+ * using rdmacg_unregister_ib_device().
+ */
+void rdmacg_clear_rpool_ops(struct ib_device *device,
+			    enum rdmacg_resource_pool_type pool_type)
+{
+	device->rpool_ops[pool_type] = NULL;
+}
+EXPORT_SYMBOL(rdmacg_clear_rpool_ops);
+
+/**
+ * rdmacg_query_resource_limit - query the resource limits that
+ * might have been configured by the user.
+ * @device: pointer to ib device
+ * @pid: thread group pid that wants to know the resource limits
+ *       of the cgroup.
+ * @type: the type of resource pool to know the limits of.
+ * @limits: pointer to an array of limits where rdma cg will provide
+ *          the configured limits of the cgroup.
+ * @limits_array_len: number of array elements to be filled up at limits.
+ *
+ * This function follows charing resource in hierarchical way.
+ * It will fail if the charge would cause the new value to exceed the
+ * hierarchical limit.
+ * Returns 0 if the charge succeded, otherwise appropriate error code.
+ */
+int rdmacg_query_resource_limit(struct ib_device *device,
+				struct pid *pid,
+				enum rdmacg_resource_pool_type type,
+				int *limits, int limits_array_len)
+{
+	struct rdma_cgroup *cg, *p, *q;
+	struct task_struct *task;
+	struct cg_resource_pool *rpool;
+	struct rdmacg_pool_info *pool_info;
+	struct rdmacg_resource_pool_ops *ops;
+	int i, status = 0;
+
+	task = pid_task(pid, PIDTYPE_PID);
+	cg = task_rdmacg(task);
+
+	ops = get_pool_ops(device, type);
+	if (!ops) {
+		status = -EINVAL;
+		goto err;
+	}
+	pool_info = ops->get_resource_pool_tokens(device);
+	if (!pool_info) {
+		status = -EINVAL;
+		goto err;
+	}
+	if (pool_info->resource_count == 0 ||
+	    pool_info->resource_count > RDMACG_MAX_RESOURCE_INDEX ||
+	    pool_info->resource_count < limits_array_len) {
+		status = -EINVAL;
+		goto err;
+	}
+
+	/* initialize to max */
+	for (i = 0; i < limits_array_len; i++)
+		limits[i] = S32_MAX;
+
+	/* check in hirerchy which pool get the least amount of
+	 * resource limits.
+	 */
+	for (p = cg; p; p = parent_rdmacg(p)) {
+		/* get handle to cgroups rpool */
+		rpool = get_cg_rpool(cg, device, type);
+		if (IS_ERR_OR_NULL(rpool))
+			goto rpool_err;
+
+		for (i = 0; i < limits_array_len; i++)
+			limits[i] = min_t(int, limits[i],
+					rpool->resources[i].limit);
+
+		put_cg_rpool(cg, rpool);
+	}
+	return 0;
+
+rpool_err:
+	for (q = cg; q != p; q = parent_rdmacg(q))
+		put_cg_rpool(cg, _get_cg_rpool(cg, device, type));
+err:
+	return status;
+}
+EXPORT_SYMBOL(rdmacg_query_resource_limit);
+
+static int rdmacg_parse_limits(char *options, struct match_token *opt_tbl,
+			       int *new_limits, u64 *enables)
+{
+	substring_t argstr[MAX_OPT_ARGS];
+	const char *c;
+	int err = -ENOMEM;
+
+	/* parse resource options */
+	while ((c = strsep(&options, " ")) != NULL) {
+		int token, intval, ret;
+
+		err = -EINVAL;
+		token = match_token((char *)c, opt_tbl, argstr);
+		if (token < 0)
+			goto err;
+
+		ret = match_int(&argstr[0], &intval);
+		if (ret < 0) {
+			pr_err("bad value (not int) at '%s'\n", c);
+			goto err;
+		}
+		new_limits[token] = intval;
+		*enables |= BIT(token);
+	}
+	return 0;
+
+err:
+	return err;
+}
+
+static enum rdmacg_resource_pool_type of_to_pool_type(int of_type)
+{
+	enum rdmacg_resource_pool_type pool_type;
+
+	switch (of_type) {
+	case RDMACG_VERB_RESOURCE_LIMIT:
+	case RDMACG_VERB_RESOURCE_USAGE:
+	case RDMACG_VERB_RESOURCE_FAILCNT:
+	case RDMACG_VERB_RESOURCE_LIST:
+		pool_type = RDMACG_RESOURCE_POOL_VERB;
+		break;
+	case RDMACG_HW_RESOURCE_LIMIT:
+	case RDMACG_HW_RESOURCE_USAGE:
+	case RDMACG_HW_RESOURCE_FAILCNT:
+	case RDMACG_HW_RESOURCE_LIST:
+	default:
+		pool_type = RDMACG_RESOURCE_POOL_HW;
+		break;
+	};
+	return pool_type;
+}
+
+static struct ib_device *_rdmacg_get_device(const char *name)
+{
+	struct ib_device *device;
+
+	list_for_each_entry(device, &dev_list, rdmacg_list)
+		if (!strncmp(name, device->name, IB_DEVICE_NAME_MAX))
+			return device;
+
+	return NULL;
+}
+
+static void remove_unused_cg_rpool(struct rdma_cgroup *cg,
+				   struct ib_device *device,
+				   enum rdmacg_resource_pool_type type,
+				   int count)
+{
+	struct cg_resource_pool *rpool = NULL;
+	int i;
+
+	spin_lock(&cg->cg_list_lock);
+	rpool = find_cg_rpool(cg, device, type);
+	if (!rpool) {
+		spin_unlock(&cg->cg_list_lock);
+		return;
+	}
+	/* found the resource pool, check now what to do
+	 * based on its reference count.
+	 */
+	if (atomic_read(&rpool->refcnt) == 0) {
+		/* if there is no active user of the rpool,
+		 * free the memory, default group will get
+		 * allocated automatically when new resource
+		 * is created.
+		 */
+		list_del_init(&rpool->cg_list);
+
+		spin_unlock(&cg->cg_list_lock);
+
+		_free_cg_rpool(rpool);
+	} else {
+		/* if there are active processes and thereby
+		 * active resources, set limits to max.
+		 * Resource pool will get freed later on,
+		 * when last resource will get deallocated.
+		 */
+		for (i = 0; i < count; i++)
+			set_resource_limit(rpool, i, S32_MAX);
+		atomic_set(&rpool->creator, RDMACG_RPOOL_CREATOR_DEFAULT);
+
+		spin_unlock(&cg->cg_list_lock);
+	}
+}
+
+static ssize_t rdmacg_resource_set_limit(struct kernfs_open_file *of,
+					 char *buf, size_t nbytes, loff_t off)
+{
+	struct rdma_cgroup *cg = css_rdmacg(of_css(of));
+	const char *dev_name;
+	struct cg_resource_pool *rpool;
+	struct rdmacg_resource_pool_ops *ops;
+	struct ib_device *device;
+	char *options = strstrip(buf);
+	enum rdmacg_resource_pool_type pool_type;
+	struct rdmacg_pool_info *resource_tokens;
+	u64 enables = 0;
+	int *new_limits;
+	int i = 0, ret = 0;
+	bool remove = false;
+
+	/* extract the device name first */
+	dev_name = strsep(&options, " ");
+	if (!dev_name) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* check if user asked to remove the cgroup limits */
+	if (strstr(options, RDMACG_USR_CMD_REMOVE))
+		remove = true;
+
+	new_limits = kcalloc(RDMACG_MAX_RESOURCE_INDEX, sizeof(int),
+			     GFP_KERNEL);
+	if (!new_limits) {
+		ret = -ENOMEM;
+		goto opt_err;
+	}
+
+	/* acquire lock to synchronize with hot plug devices */
+	mutex_lock(&dev_mutex);
+
+	device = _rdmacg_get_device(dev_name);
+	if (!device) {
+		ret = -ENODEV;
+		goto parse_err;
+	}
+	pool_type = of_to_pool_type(of_cft(of)->private);
+	ops = get_pool_ops(device, pool_type);
+	if (!ops) {
+		ret = -EINVAL;
+		goto parse_err;
+	}
+
+	resource_tokens = ops->get_resource_pool_tokens(device);
+	if (IS_ERR_OR_NULL(resource_tokens)) {
+		ret = -EINVAL;
+		goto parse_err;
+	}
+
+	if (remove) {
+		remove_unused_cg_rpool(cg, device, pool_type,
+				       resource_tokens->resource_count);
+		/* user asked to clear the limits; ignore rest of the options */
+		goto parse_err;
+	}
+
+	/* user didn't ask to remove, act on the options */
+	ret = rdmacg_parse_limits(options,
+				  resource_tokens->resource_table,
+				  new_limits, &enables);
+	if (ret)
+		goto parse_err;
+
+	rpool = get_cg_rpool(cg, device, pool_type);
+	if (IS_ERR_OR_NULL(rpool)) {
+		if (IS_ERR(rpool))
+			ret = PTR_ERR(rpool);
+		else
+			ret = -ENOMEM;
+		goto parse_err;
+	}
+	/* set pool type as user regardless of previous type as
+	 * user is configuring the limit now.
+	 */
+	atomic_set(&rpool->creator, RDMACG_RPOOL_CREATOR_USR);
+
+	/* now set the new limits on the existing or newly created rool */
+	while (enables) {
+		/* if user set the limit, enables bit is set */
+		if (enables & BIT(i)) {
+			enables &= ~BIT(i);
+			set_resource_limit(rpool, i, new_limits[i]);
+		}
+		i++;
+	}
+	atomic_dec(&rpool->refcnt);
+parse_err:
+	mutex_unlock(&dev_mutex);
+opt_err:
+	kfree(new_limits);
+err:
+	return ret ?: nbytes;
+}
+
+static int get_resource_val(struct cg_resource *resource,
+			    enum rdmacg_file_type type)
+{
+	int val = 0;
+
+	switch (type) {
+	case RDMACG_VERB_RESOURCE_LIMIT:
+	case RDMACG_HW_RESOURCE_LIMIT:
+		val = resource->limit;
+		break;
+	case RDMACG_VERB_RESOURCE_USAGE:
+	case RDMACG_HW_RESOURCE_USAGE:
+		val = atomic_read(&resource->usage);
+		break;
+	case RDMACG_VERB_RESOURCE_FAILCNT:
+	case RDMACG_HW_RESOURCE_FAILCNT:
+		val = atomic_read(&resource->failcnt);
+		break;
+	default:
+		val = 0;
+		break;
+	};
+	return val;
+}
+
+static int rdmacg_resource_read(struct seq_file *sf, void *v)
+{
+	struct rdma_cgroup *cg = css_rdmacg(seq_css(sf));
+	struct cg_resource_pool *rpool;
+	struct rdmacg_pool_info *pool_info;
+	struct match_token *resource_table;
+	struct rdmacg_resource_pool_ops *ops;
+	enum rdmacg_resource_pool_type pool_type;
+	int i, value, ret = 0;
+
+	pool_type = of_to_pool_type(seq_cft(sf)->private);
+
+	mutex_lock(&dev_mutex);
+
+	list_for_each_entry(rpool, &cg->rpool_head, cg_list) {
+		if (rpool->type != pool_type)
+			continue;
+
+		ops = get_pool_ops(rpool->device, pool_type);
+		if (!ops) {
+			ret = -EPERM;
+			goto err;
+		}
+
+		pool_info = ops->get_resource_pool_tokens(rpool->device);
+		if (IS_ERR_OR_NULL(pool_info)) {
+			ret = -EINVAL;
+			goto err;
+		}
+		seq_printf(sf, "%s ", rpool->device->name);
+
+		resource_table = pool_info->resource_table;
+		for (i = 0; i < pool_info->resource_count; i++) {
+			value = get_resource_val(&rpool->resources[i],
+						 seq_cft(sf)->private);
+			seq_printf(sf, resource_table[i].pattern, value);
+			seq_putc(sf, ' ');
+		}
+		seq_putc(sf, '\n');
+	}
+
+err:
+	mutex_unlock(&dev_mutex);
+	return ret;
+}
+
+static int rdmacg_resource_list(struct seq_file *sf, void *v)
+{
+	struct ib_device *device;
+	struct rdmacg_pool_info *pool_info;
+	struct match_token *resource_table;
+	struct rdmacg_resource_pool_ops *ops;
+	enum rdmacg_resource_pool_type pool_type;
+	int i, ret = 0;
+	char *name, *org_ptr;
+	char **namep;
+
+	pool_type = of_to_pool_type(seq_cft(sf)->private);
+
+	mutex_lock(&dev_mutex);
+
+	list_for_each_entry(device, &dev_list, rdmacg_list) {
+		ops = get_pool_ops(device, pool_type);
+		if (!ops)
+			continue;
+
+		pool_info = ops->get_resource_pool_tokens(device);
+		if (IS_ERR_OR_NULL(pool_info)) {
+			ret = -EINVAL;
+			goto err;
+		}
+		seq_printf(sf, "%s ", device->name);
+
+		resource_table = pool_info->resource_table;
+		for (i = 0; i < pool_info->resource_count; i++) {
+			name = kzalloc(strlen(resource_table[i].pattern),
+				       GFP_KERNEL);
+			if (!name) {
+				ret = -ENOMEM;
+				goto err;
+			}
+			namep = &name;
+			org_ptr = name;
+			strcpy(name, resource_table[i].pattern);
+			name = strsep(namep, "=");
+			if (!*namep) {
+				kfree(org_ptr);
+				continue;
+			}
+			seq_puts(sf, name);
+			seq_putc(sf, ' ');
+			kfree(org_ptr);
+		}
+		seq_putc(sf, '\n');
+	}
+
+err:
+	mutex_unlock(&dev_mutex);
+	return ret;
+}
+
+static struct cftype rdmacg_files[] = {
+	{
+		.name = "resource.verb.limit",
+		.write = rdmacg_resource_set_limit,
+		.seq_show = rdmacg_resource_read,
+		.private = RDMACG_VERB_RESOURCE_LIMIT,
+	},
+	{
+		.name = "resource.verb.usage",
+		.seq_show = rdmacg_resource_read,
+		.private = RDMACG_VERB_RESOURCE_USAGE,
+	},
+	{
+		.name = "resource.verb.failcnt",
+		.seq_show = rdmacg_resource_read,
+		.private = RDMACG_VERB_RESOURCE_FAILCNT,
+	},
+	{
+		.name = "resource.verb.list",
+		.seq_show = rdmacg_resource_list,
+		.private = RDMACG_VERB_RESOURCE_LIST,
+	},
+	{
+		.name = "resource.hw.limit",
+		.write = rdmacg_resource_set_limit,
+		.seq_show = rdmacg_resource_read,
+		.private = RDMACG_HW_RESOURCE_LIMIT,
+	},
+	{
+		.name = "resource.hw.usage",
+		.seq_show = rdmacg_resource_read,
+		.private = RDMACG_HW_RESOURCE_USAGE,
+	},
+	{
+		.name = "resource.hw.failcnt",
+		.seq_show = rdmacg_resource_read,
+		.private = RDMACG_HW_RESOURCE_FAILCNT,
+	},
+	{
+		.name = "resource.hw.list",
+		.seq_show = rdmacg_resource_list,
+		.private = RDMACG_HW_RESOURCE_LIST,
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
+	spin_lock_init(&cg->cg_list_lock);
+
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
+ * marks all the resource pool as default type, so that when resources are
+ * freeded, associated resource pool can be freed as well.
+ *
+ */
+static void rdmacg_css_offline(struct cgroup_subsys_state *css)
+{
+	struct rdma_cgroup *cg = css_rdmacg(css);
+	struct cg_resource_pool *rpool;
+
+	spin_lock(&cg->cg_list_lock);
+
+	/* mark resource pool as of default type, so that they can be freed
+	 * later on when actual resources are freed.
+	 */
+	list_for_each_entry(rpool, &cg->rpool_head, cg_list)
+		atomic_set(&rpool->creator, RDMACG_RPOOL_CREATOR_DEFAULT);
+
+	spin_unlock(&cg->cg_list_lock);
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
