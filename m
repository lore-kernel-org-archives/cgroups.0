From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC 10/17] drm: Add ability to query drm cgroup GPU time
Date: Wed, 19 Oct 2022 18:32:47 +0100
Message-ID: <20221019173254.3361334-11-tvrtko.ursulin@linux.intel.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666200850; x=1697736850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=57xevMaPNuTYw9loIK3v8HjbtAVBJSLqQ4lTiTCwMqQ=;
  b=b403/DjIO2r0FckCx6SOM0koAAHJZ2j5vZVUjwN7GcB6jJf6KNBKeme3
   opYJEwTVl6Ge+palbio+0/ishxAb71+4mJiJILJnrJHMRv2DPN70P7zP4
   KW2AiNyfdnBjyxQw8eevt6AKaCztGm6N0F1BMKd68k3F4ADNmdJQ1QvTT
   fKsESVkZiBuoDyiUF7/iH+1c5Ozzh0ZBDtQka7YH64PPIafL3TAZt5EDu
   5NaUXct4Hga8uQjwgkx5vkx7jeRV06UYkUony3vaJ8cbl61i8xwtmkg2j
   k1bRLEd3er4WtEKSC7WpM29VRiVeh4OJ0YEyYjX7g1jfgqb2D8qVHH2Fi
   w==;
In-Reply-To: <20221019173254.3361334-1-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

From: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a driver callback and core helper which allow querying the time spent
on GPUs for processes belonging to a group.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/gpu/drm/drm_cgroup.c | 24 ++++++++++++++++++++++++
 include/drm/drm_clients.h    |  1 +
 include/drm/drm_drv.h        |  9 +++++++++
 3 files changed, 34 insertions(+)

diff --git a/drivers/gpu/drm/drm_cgroup.c b/drivers/gpu/drm/drm_cgroup.c
index 59b730ed1334..e0cadb5e5659 100644
--- a/drivers/gpu/drm/drm_cgroup.c
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -206,3 +206,27 @@ void drm_pid_update_priority(struct pid *pid, int priority)
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(drm_pid_update_priority);
+
+u64 drm_pid_get_active_time_us(struct pid *pid)
+{
+	struct drm_pid_clients *clients;
+	u64 total = 0;
+
+	rcu_read_lock();
+	clients = xa_load(&drm_pid_clients, (unsigned long)pid);
+	if (clients) {
+		struct drm_file *fpriv;
+
+		list_for_each_entry_rcu(fpriv, &clients->file_list, clink) {
+			const struct drm_cgroup_ops *cg_ops =
+				fpriv->minor->dev->driver->cg_ops;
+
+			if (cg_ops && cg_ops->active_time_us)
+				total += cg_ops->active_time_us(fpriv);
+		}
+	}
+	rcu_read_unlock();
+
+	return total;
+}
+EXPORT_SYMBOL_GPL(drm_pid_get_active_time_us);
diff --git a/include/drm/drm_clients.h b/include/drm/drm_clients.h
index 3a0b1cdb338f..f25e09ed5feb 100644
--- a/include/drm/drm_clients.h
+++ b/include/drm/drm_clients.h
@@ -37,5 +37,6 @@ static inline void drm_clients_migrate(struct drm_file *file_priv)
 
 unsigned int drm_pid_priority_levels(struct pid *pid, bool *non_uniform);
 void drm_pid_update_priority(struct pid *pid, int priority);
+u64 drm_pid_get_active_time_us(struct pid *pid);
 
 #endif
diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
index 2371d73e12cf..0f1802df01fe 100644
--- a/include/drm/drm_drv.h
+++ b/include/drm/drm_drv.h
@@ -183,6 +183,15 @@ struct drm_cgroup_ops {
 	 * priorities of already running workloads.
 	 */
 	void (*update_priority) (struct drm_file *, int priority);
+
+	/**
+	 * @active_time_us:
+	 *
+	 * Optional callback for reporting the GPU time consumed by this client.
+	 *
+	 * Used by the DRM core when queried by the DRM cgroup controller.
+	 */
+	u64 (*active_time_us) (struct drm_file *);
 };
 
 /**
-- 
2.34.1

