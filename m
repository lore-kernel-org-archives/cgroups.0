From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC 05/13] drm/cgroup: Track clients per owning process
Date: Wed,  9 Nov 2022 16:11:33 +0000
Message-ID: <20221109161141.2987173-6-tvrtko.ursulin@linux.intel.com>
References: <20221109161141.2987173-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668010337; x=1699546337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DOi4RMupNEjpYyK4WovQ8kG/iXKjxHECtSroc0kXvAE=;
  b=CtuIL09I139syLEmVYuiqfQuO8R7ReTxij1KU7fqkZ2DseuIKLe+IXHU
   RH44Ltk2t0Y6ZGQS+cxmIXC6pn4DMkoK9QX5YVJlzCvDUs7F19ePIEJGF
   soGT3OyZ4zreF1ODbOEPJ63dsKtYMiwkk7/GCCHUtxkY9hf57JPDOx4K/
   ifbiMGTNI9nOLbP6GfUEHDu87A76he+uL6ZVPEvMsvWX+a34l1wuULZuu
   X/HXlXZwr7E3PEg4hDw8IBVFarQvkIs8uwuKhoxrxe5RLwwOSzGOP4AZr
   rUZdc+6dNOsV1Lz9YBqYkhkUSMyqEN7DCCilJJgZa6MrKYByZ31c4x8w0
   Q==;
In-Reply-To: <20221109161141.2987173-1-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

From: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

To enable propagation of settings from the cgroup drm controller to drm we
need to start tracking which processes own which drm clients.

Implement that by tracking the struct pid pointer of the owning process in
a new XArray, pointing to a structure containing a list of associated
struct drm_file pointers.

Clients are added and removed under the filelist mutex and RCU list
operations are used below it to allow for lockless lookup.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/gpu/drm/Makefile     |   1 +
 drivers/gpu/drm/drm_cgroup.c | 123 +++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_file.c   |  21 ++++--
 include/drm/drm_clients.h    |  44 +++++++++++++
 include/drm/drm_file.h       |   4 ++
 5 files changed, 189 insertions(+), 4 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_cgroup.c
 create mode 100644 include/drm/drm_clients.h

diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index c44a54cadb61..4495dda2a720 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -59,6 +59,7 @@ drm-$(CONFIG_DRM_LEGACY) += \
 	drm_scatter.o \
 	drm_vm.o
 drm-$(CONFIG_DRM_LIB_RANDOM) += lib/drm_random.o
+drm-$(CONFIG_CGROUP_DRM) += drm_cgroup.o
 drm-$(CONFIG_COMPAT) += drm_ioc32.o
 drm-$(CONFIG_DRM_PANEL) += drm_panel.o
 drm-$(CONFIG_OF) += drm_of.o
diff --git a/drivers/gpu/drm/drm_cgroup.c b/drivers/gpu/drm/drm_cgroup.c
new file mode 100644
index 000000000000..56aa8303974a
--- /dev/null
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2022 Intel Corporation
+ */
+
+#include <drm/drm_drv.h>
+#include <drm/drm_clients.h>
+
+static DEFINE_XARRAY(drm_pid_clients);
+
+static void
+__del_clients(struct drm_pid_clients *clients,
+	      struct drm_file *file_priv,
+	      unsigned long pid)
+{
+	list_del_rcu(&file_priv->clink);
+	if (atomic_dec_and_test(&clients->num)) {
+		xa_erase(&drm_pid_clients, pid);
+		kfree_rcu(clients, rcu);
+	}
+}
+
+void drm_clients_close(struct drm_file *file_priv)
+{
+	struct drm_device *dev = file_priv->minor->dev;
+	struct drm_pid_clients *clients;
+	struct pid *pid;
+
+	lockdep_assert_held(&dev->filelist_mutex);
+
+	pid = rcu_access_pointer(file_priv->pid);
+	clients = xa_load(&drm_pid_clients, (unsigned long)pid);
+	if (WARN_ON_ONCE(!clients))
+		return;
+
+	__del_clients(clients, file_priv, (unsigned long)pid);
+}
+
+static struct drm_pid_clients *__alloc_clients(void)
+{
+	struct drm_pid_clients *clients;
+
+	clients = kmalloc(sizeof(*clients), GFP_KERNEL);
+	if (clients) {
+		atomic_set(&clients->num, 0);
+		INIT_LIST_HEAD(&clients->file_list);
+		init_rcu_head(&clients->rcu);
+	}
+
+	return clients;
+}
+
+int drm_clients_open(struct drm_file *file_priv)
+{
+	struct drm_device *dev = file_priv->minor->dev;
+	struct drm_pid_clients *clients;
+	bool new_client = false;
+	unsigned long pid;
+
+	lockdep_assert_held(&dev->filelist_mutex);
+
+	pid = (unsigned long)rcu_access_pointer(file_priv->pid);
+	clients = xa_load(&drm_pid_clients, pid);
+	if (!clients) {
+		clients = __alloc_clients();
+		if (!clients)
+			return -ENOMEM;
+		new_client = true;
+	}
+	atomic_inc(&clients->num);
+	list_add_tail_rcu(&file_priv->clink, &clients->file_list);
+	if (new_client) {
+		void *xret;
+
+		xret = xa_store(&drm_pid_clients, pid, clients, GFP_KERNEL);
+		if (xa_err(xret)) {
+			list_del_init(&file_priv->clink);
+			kfree(clients);
+			return PTR_ERR(clients);
+		}
+	}
+
+	return 0;
+}
+
+void
+drm_clients_migrate(struct drm_file *file_priv,
+		    unsigned long old,
+		    unsigned long new)
+{
+	struct drm_device *dev = file_priv->minor->dev;
+	struct drm_pid_clients *existing_clients;
+	struct drm_pid_clients *clients;
+
+	lockdep_assert_held(&dev->filelist_mutex);
+
+	existing_clients = xa_load(&drm_pid_clients, new);
+	clients = xa_load(&drm_pid_clients, old);
+
+	if (WARN_ON_ONCE(!clients))
+		return;
+	else if (WARN_ON_ONCE(clients == existing_clients))
+		return;
+
+	__del_clients(clients, file_priv, old);
+
+	if (!existing_clients) {
+		void *xret;
+
+		clients = __alloc_clients();
+		if (WARN_ON(!clients))
+			return;
+
+		xret = xa_store(&drm_pid_clients, new, clients, GFP_KERNEL);
+		if (WARN_ON(xa_err(xret)))
+			return;
+	} else {
+		clients = existing_clients;
+	}
+
+	atomic_inc(&clients->num);
+	list_add_tail_rcu(&file_priv->clink, &clients->file_list);
+}
diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index 4f5cff5c0bea..16ca5b88f414 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -40,6 +40,7 @@
 #include <linux/slab.h>
 
 #include <drm/drm_client.h>
+#include <drm/drm_clients.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_file.h>
 #include <drm/drm_print.h>
@@ -298,6 +299,7 @@ static void drm_close_helper(struct file *filp)
 
 	mutex_lock(&dev->filelist_mutex);
 	list_del(&file_priv->lhead);
+	drm_clients_close(file_priv);
 	mutex_unlock(&dev->filelist_mutex);
 
 	drm_file_free(file_priv);
@@ -349,10 +351,8 @@ static int drm_open_helper(struct file *filp, struct drm_minor *minor)
 
 	if (drm_is_primary_client(priv)) {
 		ret = drm_master_open(priv);
-		if (ret) {
-			drm_file_free(priv);
-			return ret;
-		}
+		if (ret)
+			goto err_free;
 	}
 
 	filp->private_data = priv;
@@ -360,6 +360,9 @@ static int drm_open_helper(struct file *filp, struct drm_minor *minor)
 	priv->filp = filp;
 
 	mutex_lock(&dev->filelist_mutex);
+	ret = drm_clients_open(priv);
+	if (ret)
+		goto err_unlock;
 	list_add(&priv->lhead, &dev->filelist);
 	mutex_unlock(&dev->filelist_mutex);
 
@@ -387,6 +390,13 @@ static int drm_open_helper(struct file *filp, struct drm_minor *minor)
 #endif
 
 	return 0;
+
+err_unlock:
+	mutex_unlock(&dev->filelist_mutex);
+err_free:
+	drm_file_free(priv);
+
+	return ret;
 }
 
 /**
@@ -523,6 +533,9 @@ void drm_file_update_pid(struct drm_file *filp)
 	dev = filp->minor->dev;
 	mutex_lock(&dev->filelist_mutex);
 	old = rcu_replace_pointer(filp->pid, pid, 1);
+	if (pid != old)
+		drm_clients_migrate(filp,
+				    (unsigned long)old, (unsigned long)pid);
 	mutex_unlock(&dev->filelist_mutex);
 
 	if (pid != old) {
diff --git a/include/drm/drm_clients.h b/include/drm/drm_clients.h
new file mode 100644
index 000000000000..fbb8cffdf7a9
--- /dev/null
+++ b/include/drm/drm_clients.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2022 Intel Corporation
+ */
+
+#ifndef _DRM_CLIENTS_H_
+#define _DRM_CLIENTS_H_
+
+#include <drm/drm_file.h>
+
+struct drm_pid_clients {
+	atomic_t num;
+	struct list_head file_list;
+	struct rcu_head rcu;
+};
+
+#if IS_ENABLED(CONFIG_CGROUP_DRM)
+void drm_clients_close(struct drm_file *file_priv);
+int drm_clients_open(struct drm_file *file_priv);
+
+void
+drm_clients_migrate(struct drm_file *file_priv,
+		    unsigned long old,
+		    unsigned long new);
+#else
+static inline void drm_clients_close(struct drm_file *file_priv)
+{
+}
+
+static inline int drm_clients_open(struct drm_file *file_priv)
+{
+	return 0;
+}
+
+static void
+drm_clients_migrate(struct drm_file *file_priv,
+		    unsigned long old,
+		    unsigned long new)
+{
+
+}
+#endif
+
+#endif
diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
index b8be69b551af..ad20aaad40f5 100644
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -275,6 +275,10 @@ struct drm_file {
 	/** @minor: &struct drm_minor for this file. */
 	struct drm_minor *minor;
 
+#if IS_ENABLED(CONFIG_CGROUP_DRM)
+	struct list_head clink;
+#endif
+
 	/**
 	 * @object_idr:
 	 *
-- 
2.34.1

