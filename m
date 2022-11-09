From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 02/13] drm: Track clients by tgid and not tid
Date: Wed,  9 Nov 2022 16:11:30 +0000
Message-ID: <20221109161141.2987173-3-tvrtko.ursulin@linux.intel.com>
References: <20221109161141.2987173-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1668010326; x=1699546326;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=65danGbq1zwJ9FB6InBTjiB49NsQltjw5lK60A9yBPk=;
 b=PGulbsctNSegjvseCEBkkXrNM2j4Lb+1XMl+J5Cy3HSewbZQrsZeeWMS
 kl8kRoHuCkV/A5AY96+YhXVaD4wItkyU9O5PMCrBNz0w8d3gWV0CpBTYu
 7S2LCvsbdSQEZUKNybpyZBQrJgsp1Kwy88yqJ/49GLcRuuEi/FQIrxnVP
 dSML4PNnFGoDLY6Lp88yjyqesVnvGGtLxi8JjAkQIID732aflwNz4coHn
 C2cJbxnUIxIaD0LfD+WSqTrRyMWcohvgtBa81B/dR6BNdkq2vBMe8tQ/Y
 82yeLZwSXk4Dtk4ZiBsHJ3U4TILn4mUrm/kjZdhU1W5NRPGtImDIsjWvd Q==;
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
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Alex Deucher <alexander.deucher@amd.com>, linux-graphics-maintainer@vmware.com, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>, Zack Rusin <zackr@vmware.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Thread group id (aka pid from userspace point of view) is a more
interesting thing to show as an owner of a DRM fd, so track and show that
instead of the thread id.

In the next patch we will make the owner updated post file descriptor
handover, which will also be tgid based to avoid ping-pong when multiple
threads access the fd.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Zack Rusin <zackr@vmware.com>
Cc: linux-graphics-maintainer@vmware.com
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian K=C3=B6nig" <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 2 +-
 drivers/gpu/drm/drm_debugfs.c           | 4 ++--
 drivers/gpu/drm/drm_file.c              | 2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c     | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/=
amdgpu/amdgpu_gem.c
index 8ef31d687ef3..4b940f8bd72b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -967,7 +967,7 @@ static int amdgpu_debugfs_gem_info_show(struct seq_file=
 *m, void *unused)
 		 * Therefore, we need to protect this ->comm access using RCU.
 		 */
 		rcu_read_lock();
-		task =3D pid_task(file->pid, PIDTYPE_PID);
+		task =3D pid_task(file->pid, PIDTYPE_TGID);
 		seq_printf(m, "pid %8d command %s:\n", pid_nr(file->pid),
 			   task ? task->comm : "<unknown>");
 		rcu_read_unlock();
diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index ee445f4605ba..42f657772025 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -80,7 +80,7 @@ static int drm_clients_info(struct seq_file *m, void *dat=
a)
 	seq_printf(m,
 		   "%20s %5s %3s master a %5s %10s\n",
 		   "command",
-		   "pid",
+		   "tgid",
 		   "dev",
 		   "uid",
 		   "magic");
@@ -94,7 +94,7 @@ static int drm_clients_info(struct seq_file *m, void *dat=
a)
 		bool is_current_master =3D drm_is_current_master(priv);
=20
 		rcu_read_lock(); /* locks pid_task()->comm */
-		task =3D pid_task(priv->pid, PIDTYPE_PID);
+		task =3D pid_task(priv->pid, PIDTYPE_TGID);
 		uid =3D task ? __task_cred(task)->euid : GLOBAL_ROOT_UID;
 		seq_printf(m, "%20s %5d %3d   %c    %c %5d %10u\n",
 			   task ? task->comm : "<unknown>",
diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index ba5041137b29..5cde5014cea1 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -156,7 +156,7 @@ struct drm_file *drm_file_alloc(struct drm_minor *minor)
 	if (!file)
 		return ERR_PTR(-ENOMEM);
=20
-	file->pid =3D get_pid(task_pid(current));
+	file->pid =3D get_pid(task_tgid(current));
 	file->minor =3D minor;
=20
 	/* for compatibility root is always authenticated */
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/v=
mwgfx_gem.c
index ce609e7d758f..f2985337aa53 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -260,7 +260,7 @@ static int vmw_debugfs_gem_info_show(struct seq_file *m=
, void *unused)
 		 * Therefore, we need to protect this ->comm access using RCU.
 		 */
 		rcu_read_lock();
-		task =3D pid_task(file->pid, PIDTYPE_PID);
+		task =3D pid_task(file->pid, PIDTYPE_TGID);
 		seq_printf(m, "pid %8d command %s:\n", pid_nr(file->pid),
 			   task ? task->comm : "<unknown>");
 		rcu_read_unlock();
--=20
2.34.1

