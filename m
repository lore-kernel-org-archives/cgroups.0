From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 03/13] drm: Update file owner during use
Date: Wed,  9 Nov 2022 16:11:31 +0000
Message-ID: <20221109161141.2987173-4-tvrtko.ursulin@linux.intel.com>
References: <20221109161141.2987173-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1668010330; x=1699546330;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=408bXFKjUghNe6DBLZiEo8jtNRxH417j6r34+CGHn8g=;
 b=cRqKOJJZ8TMXswF4ulXuW3iRT192KjlnMKxzqiDYQHdrd439BKztpxdL
 x6n6KxNezcuPIsIFgw8FYGZn8koLj6ekahk5tL8PiSnpPvezA9del4icT
 LYCFelEBbXj/RZQ7W728Nbpl91K4mByOUCDZ4aHLkoFxtNVN3iFsITDwV
 golZfdrFL1uWc5dxMSY231GEElslV5CXxEl2h+f+LLe31t+z/QMCEz8+H
 xYFmy1byR+NfJ572x2cKKK0x5gHZbtm+HRmvg4gfi5DW81AHFI6J050Eo
 2oieO0+eN4XzziTyPPXQpiurIGIwcswH4KOP8b8yfop7cDZx5U+9lpqIQ A==;
In-Reply-To: <20221109161141.2987173-1-tvrtko.ursulin@linux.intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Intel-gfx@lists.freedesktop.org
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

With the typical model where the display server opends the file descriptor
and then hands it over to the client we were showing stale data in
debugfs.

Fix it by updating the drm_file->pid on ioctl access from a different
process.

The field is also made RCU protected to allow for lockless readers. Update
side is protected with dev->filelist_mutex.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: "Christian K=C3=B6nig" <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |  6 +++--
 drivers/gpu/drm/drm_auth.c              |  3 ++-
 drivers/gpu/drm/drm_debugfs.c           | 10 +++++----
 drivers/gpu/drm/drm_file.c              | 30 +++++++++++++++++++++++++
 drivers/gpu/drm/drm_ioctl.c             |  3 +++
 drivers/gpu/drm/nouveau/nouveau_drm.c   |  5 ++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c     |  6 +++--
 include/drm/drm_file.h                  | 13 +++++++++--
 8 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/=
amdgpu/amdgpu_gem.c
index 4b940f8bd72b..d732ffb1c0d8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -958,6 +958,7 @@ static int amdgpu_debugfs_gem_info_show(struct seq_file=
 *m, void *unused)
 	list_for_each_entry(file, &dev->filelist, lhead) {
 		struct task_struct *task;
 		struct drm_gem_object *gobj;
+		struct pid *pid;
 		int id;
=20
 		/*
@@ -967,8 +968,9 @@ static int amdgpu_debugfs_gem_info_show(struct seq_file=
 *m, void *unused)
 		 * Therefore, we need to protect this ->comm access using RCU.
 		 */
 		rcu_read_lock();
-		task =3D pid_task(file->pid, PIDTYPE_TGID);
-		seq_printf(m, "pid %8d command %s:\n", pid_nr(file->pid),
+		pid =3D rcu_dereference(file->pid);
+		task =3D pid_task(pid, PIDTYPE_TGID);
+		seq_printf(m, "pid %8d command %s:\n", pid_nr(pid),
 			   task ? task->comm : "<unknown>");
 		rcu_read_unlock();
=20
diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
index cf92a9ae8034..2ed2585ded37 100644
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -235,7 +235,8 @@ static int drm_new_set_master(struct drm_device *dev, s=
truct drm_file *fpriv)
 static int
 drm_master_check_perm(struct drm_device *dev, struct drm_file *file_priv)
 {
-	if (file_priv->pid =3D=3D task_pid(current) && file_priv->was_master)
+	if (file_priv->was_master &&
+	    rcu_access_pointer(file_priv->pid) =3D=3D task_pid(current))
 		return 0;
=20
 	if (!capable(CAP_SYS_ADMIN))
diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index 42f657772025..cbcd79f01d50 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -90,15 +90,17 @@ static int drm_clients_info(struct seq_file *m, void *d=
ata)
 	 */
 	mutex_lock(&dev->filelist_mutex);
 	list_for_each_entry_reverse(priv, &dev->filelist, lhead) {
-		struct task_struct *task;
 		bool is_current_master =3D drm_is_current_master(priv);
+		struct task_struct *task;
+		struct pid *pid;
=20
-		rcu_read_lock(); /* locks pid_task()->comm */
-		task =3D pid_task(priv->pid, PIDTYPE_TGID);
+		rcu_read_lock(); /* Locks priv->pid and pid_task()->comm! */
+		pid =3D rcu_dereference(priv->pid);
+		task =3D pid_task(pid, PIDTYPE_PID);
 		uid =3D task ? __task_cred(task)->euid : GLOBAL_ROOT_UID;
 		seq_printf(m, "%20s %5d %3d   %c    %c %5d %10u\n",
 			   task ? task->comm : "<unknown>",
-			   pid_vnr(priv->pid),
+			   pid_vnr(pid),
 			   priv->minor->index,
 			   is_current_master ? 'y' : 'n',
 			   priv->authenticated ? 'y' : 'n',
diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index 5cde5014cea1..4f5cff5c0bea 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -502,6 +502,36 @@ int drm_release(struct inode *inode, struct file *filp)
 }
 EXPORT_SYMBOL(drm_release);
=20
+void drm_file_update_pid(struct drm_file *filp)
+{
+	struct drm_device *dev;
+	struct pid *pid, *old;
+
+	/* Master nodes are not expected to be passed between processes. */
+	if (filp->was_master)
+		return;
+
+	pid =3D task_tgid(current);
+
+	/*
+	 * Quick unlocked check since the model is a single handover followed by
+	 * exclusive repeated use.
+	 */
+	if (pid =3D=3D rcu_access_pointer(filp->pid))
+		return;
+
+	dev =3D filp->minor->dev;
+	mutex_lock(&dev->filelist_mutex);
+	old =3D rcu_replace_pointer(filp->pid, pid, 1);
+	mutex_unlock(&dev->filelist_mutex);
+
+	if (pid !=3D old) {
+		get_pid(pid);
+		synchronize_rcu();
+		put_pid(old);
+	}
+}
+
 /**
  * drm_release_noglobal - release method for DRM file
  * @inode: device inode
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 7c9d66ee917d..305b18d9d7b6 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -775,6 +775,9 @@ long drm_ioctl_kernel(struct file *file, drm_ioctl_t *f=
unc, void *kdata,
 	struct drm_device *dev =3D file_priv->minor->dev;
 	int retcode;
=20
+	/* Update drm_file owner if fd was passed along. */
+	drm_file_update_pid(file_priv);
+
 	if (drm_dev_is_unplugged(dev))
 		return -ENODEV;
=20
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouvea=
u/nouveau_drm.c
index fd99ec0f4257..17cd392acd69 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -1111,7 +1111,10 @@ nouveau_drm_open(struct drm_device *dev, struct drm_=
file *fpriv)
 	}
=20
 	get_task_comm(tmpname, current);
-	snprintf(name, sizeof(name), "%s[%d]", tmpname, pid_nr(fpriv->pid));
+	rcu_read_lock();
+	snprintf(name, sizeof(name), "%s[%d]",
+		 tmpname, pid_nr(rcu_dereference(fpriv->pid)));
+	rcu_read_unlock();
=20
 	if (!(cli =3D kzalloc(sizeof(*cli), GFP_KERNEL))) {
 		ret =3D -ENOMEM;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/v=
mwgfx_gem.c
index f2985337aa53..3853d9bb9ab8 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -251,6 +251,7 @@ static int vmw_debugfs_gem_info_show(struct seq_file *m=
, void *unused)
 	list_for_each_entry(file, &dev->filelist, lhead) {
 		struct task_struct *task;
 		struct drm_gem_object *gobj;
+		struct pid *pid;
 		int id;
=20
 		/*
@@ -260,8 +261,9 @@ static int vmw_debugfs_gem_info_show(struct seq_file *m=
, void *unused)
 		 * Therefore, we need to protect this ->comm access using RCU.
 		 */
 		rcu_read_lock();
-		task =3D pid_task(file->pid, PIDTYPE_TGID);
-		seq_printf(m, "pid %8d command %s:\n", pid_nr(file->pid),
+		pid =3D rcu_dereference(file->pid);
+		task =3D pid_task(pid, PIDTYPE_TGID);
+		seq_printf(m, "pid %8d command %s:\n", pid_nr(pid),
 			   task ? task->comm : "<unknown>");
 		rcu_read_unlock();
=20
diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
index d780fd151789..b8be69b551af 100644
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -251,8 +251,15 @@ struct drm_file {
 	/** @master_lookup_lock: Serializes @master. */
 	spinlock_t master_lookup_lock;
=20
-	/** @pid: Process that opened this file. */
-	struct pid *pid;
+	/**
+	 * @pid: Process that is using this file.
+	 *
+	 * Must only be dereferenced under a rcu_read_lock or equivalent.
+	 *
+	 * Updates are guarded with dev->filelist_mutex and reference must be
+	 * dropped after a RCU grace period to accommodate lockless readers.
+	 */
+	struct pid __rcu *pid;
=20
 	/** @magic: Authentication magic, see @authenticated. */
 	drm_magic_t magic;
@@ -397,6 +404,8 @@ static inline bool drm_is_render_client(const struct dr=
m_file *file_priv)
 	return file_priv->minor->type =3D=3D DRM_MINOR_RENDER;
 }
=20
+void drm_file_update_pid(struct drm_file *);
+
 int drm_open(struct inode *inode, struct file *filp);
 ssize_t drm_read(struct file *filp, char __user *buffer,
 		 size_t count, loff_t *offset);
--=20
2.34.1

