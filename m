From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC 08/17] drm: Allow for migration of clients
Date: Wed, 19 Oct 2022 18:32:45 +0100
Message-ID: <20221019173254.3361334-9-tvrtko.ursulin@linux.intel.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666200844; x=1697736844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iblWtj3oQ+Gzcpob6q0KDZMo8KPs6N0OMQ7W8Hrwr8E=;
  b=c0C5n/3KLGiKF2usH6erg2PnyHShFnFTJJ1TrCRDdUHGYYK1zO6otd9u
   SJGwz9NtddkANEhYM1ZwKKCLljxo0mFDQRDWuYuyUSqo3MA8tn7kHM8Z/
   TYwukPvK53m9diJmJx+AmiQXAmY2/RTcSJSMB/Biz/DUIn0xVBhfsFUsg
   1nBWJ710UZ8O6W5IoNHes1vM8GQOYUlkIKq8LuizsDHd/28/q3FAHkxK5
   ZDchScIDOy1rBu+xKlArJvvmUyC9+rg2EYcOMjiI8/L62VnW6rEuRyYad
   s8YKAnNymScoZ/oY4rhNxrvT5H7ILw09CFBl9Wfpd51ZsWX/WAtsCpi+v
   Q==;
In-Reply-To: <20221019173254.3361334-1-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

From: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a helper which allows migrating the tracked client from one process to
another.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/gpu/drm/drm_cgroup.c | 111 ++++++++++++++++++++++++++++++-----
 include/drm/drm_clients.h    |   7 +++
 include/drm/drm_file.h       |   1 +
 3 files changed, 103 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/drm_cgroup.c b/drivers/gpu/drm/drm_cgroup.c
index 7ed9c7150cae..59b730ed1334 100644
--- a/drivers/gpu/drm/drm_cgroup.c
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -8,9 +8,21 @@
 
 static DEFINE_XARRAY(drm_pid_clients);
 
+static void
+__del_clients(struct drm_pid_clients *clients, struct drm_file *file_priv)
+{
+	list_del_rcu(&file_priv->clink);
+	if (atomic_dec_and_test(&clients->num)) {
+		xa_erase(&drm_pid_clients, (unsigned long)file_priv->cpid);
+		kfree_rcu(clients, rcu);
+	}
+
+	put_pid(file_priv->cpid);
+	file_priv->cpid = NULL;
+}
+
 void drm_clients_close(struct drm_file *file_priv)
 {
-	unsigned long pid = (unsigned long)file_priv->pid;
 	struct drm_device *dev = file_priv->minor->dev;
 	struct drm_pid_clients *clients;
 
@@ -19,19 +31,32 @@ void drm_clients_close(struct drm_file *file_priv)
 	if (!dev->driver->cg_ops)
 		return;
 
-	clients = xa_load(&drm_pid_clients, pid);
-	list_del_rcu(&file_priv->clink);
-	if (atomic_dec_and_test(&clients->num)) {
-		xa_erase(&drm_pid_clients, pid);
-		kfree_rcu(clients, rcu);
+	clients = xa_load(&drm_pid_clients, (unsigned long)file_priv->cpid);
+	if (WARN_ON_ONCE(!clients))
+		return;
 
-		/*
-		 * FIXME: file_priv is not RCU protected so we add this hack
-		 * to avoid any races with code which walks clients->file_list
-		 * and accesses file_priv.
-		 */
-		synchronize_rcu();
+	__del_clients(clients, file_priv);
+
+	/*
+	 * FIXME: file_priv is not RCU protected so we add this hack
+	 * to avoid any races with code which walks clients->file_list
+	 * and accesses file_priv.
+	 */
+	synchronize_rcu();
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
 	}
+
+	return clients;
 }
 
 int drm_clients_open(struct drm_file *file_priv)
@@ -48,12 +73,9 @@ int drm_clients_open(struct drm_file *file_priv)
 
 	clients = xa_load(&drm_pid_clients, pid);
 	if (!clients) {
-		clients = kmalloc(sizeof(*clients), GFP_KERNEL);
+		clients = __alloc_clients();
 		if (!clients)
 			return -ENOMEM;
-		atomic_set(&clients->num, 0);
-		INIT_LIST_HEAD(&clients->file_list);
-		init_rcu_head(&clients->rcu);
 		new_client = true;
 	}
 	atomic_inc(&clients->num);
@@ -69,9 +91,66 @@ int drm_clients_open(struct drm_file *file_priv)
 		}
 	}
 
+	file_priv->cpid = get_pid(file_priv->pid);
+
 	return 0;
 }
 
+void drm_clients_migrate(struct drm_file *file_priv)
+{
+	struct drm_device *dev = file_priv->minor->dev;
+	struct drm_pid_clients *existing_clients;
+	struct drm_pid_clients *clients, *spare;
+	struct pid *pid = task_pid(current);
+
+	if (!dev->driver->cg_ops)
+		return;
+
+	// TODO: only do this if drmcs level property allows it?
+
+	spare = __alloc_clients();
+	if (WARN_ON(!spare))
+		return;
+
+	mutex_lock(&dev->filelist_mutex);
+	rcu_read_lock();
+
+	existing_clients = xa_load(&drm_pid_clients, (unsigned long)pid);
+	clients = xa_load(&drm_pid_clients, (unsigned long)file_priv->cpid);
+
+	if (WARN_ON_ONCE(!clients))
+		goto out_unlock;
+	else if (clients == existing_clients)
+		goto out_unlock;
+
+	__del_clients(clients, file_priv);
+	smp_mb(); /* hmmm? del_rcu followed by add_rcu? */
+
+	if (!existing_clients) {
+		void *xret;
+
+		xret = xa_store(&drm_pid_clients, (unsigned long)pid, spare,
+				GFP_KERNEL);
+		if (WARN_ON(xa_err(xret)))
+			goto out_unlock;
+		clients = spare;
+		spare = NULL;
+	} else {
+		clients = existing_clients;
+	}
+
+	atomic_inc(&clients->num);
+	list_add_tail_rcu(&file_priv->clink, &clients->file_list);
+	file_priv->cpid = get_pid(pid);
+
+out_unlock:
+	rcu_read_unlock();
+	mutex_unlock(&dev->filelist_mutex);
+
+	kfree(spare);
+}
+EXPORT_SYMBOL_GPL(drm_clients_migrate);
+
 unsigned int drm_pid_priority_levels(struct pid *pid, bool *non_uniform)
 {
 	unsigned int min_levels = UINT_MAX;
diff --git a/include/drm/drm_clients.h b/include/drm/drm_clients.h
index 10d21138f7af..3a0b1cdb338f 100644
--- a/include/drm/drm_clients.h
+++ b/include/drm/drm_clients.h
@@ -17,6 +17,8 @@ struct drm_pid_clients {
 #if IS_ENABLED(CONFIG_CGROUP_DRM)
 void drm_clients_close(struct drm_file *file_priv);
 int drm_clients_open(struct drm_file *file_priv);
+
+void drm_clients_migrate(struct drm_file *file_priv);
 #else
 static inline void drm_clients_close(struct drm_file *file_priv)
 {
@@ -26,6 +28,11 @@ static inline int drm_clients_open(struct drm_file *file_priv)
 {
 	return 0;
 }
+
+static inline void drm_clients_migrate(struct drm_file *file_priv)
+{
+
+}
 #endif
 
 unsigned int drm_pid_priority_levels(struct pid *pid, bool *non_uniform);
diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
index a4360e28e2db..2c1e356d3b73 100644
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -280,6 +280,7 @@ struct drm_file {
 
 #if IS_ENABLED(CONFIG_CGROUP_DRM)
 	struct list_head clink;
+	struct pid *cpid;
 #endif
 
 	/**
-- 
2.34.1

