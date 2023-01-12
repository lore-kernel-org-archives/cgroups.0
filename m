From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 07/12] drm/cgroup: Add over budget signalling
 callback
Date: Thu, 12 Jan 2023 16:56:04 +0000
Message-ID: <20230112165609.1083270-8-tvrtko.ursulin@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1673542668; x=1705078668;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=Q3zWAjP64jG9FhONvHni1RwGOKYO5eUnyqNVQmfnHLs=;
 b=TcpGc6YHcnPPd59f6fI0XEswROU4vt0Z8ydqxhO+mY/zQlLUfZLGOEAd
 6QIxUj9KPJwru9BQFXXYYPOCDMJaONmUGi7jc8TVtghAF+/0nJC4vdEYZ
 9g4JuOQRyoHOQvjrUsJbjNoaJXQ+TJD/d6EvgD3KaVWAy6aONNeHKIGhV
 9gyuKktSY0LwLaT5TFMaZSVbYxkX6Rs8oZt+rhcwmQsIkN+7yTqfe1HIv
 56DxykBandpi+d3JOCBu4F2SStyc6swFTGP4nglP7XR0qYjY+x50ct9k9
 Vy1UWIuoyX+OJ0fnbtceHlkKs/E9UC1Mn7TZONvKPUhzUTYCcHyOGAJXu g==;
In-Reply-To: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
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
Content-Type: text/plain; charset="us-ascii"
To: Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Add a new callback via which the drm cgroup controller is notifying the
drm core that a certain process is above its allotted GPU time.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/drm_cgroup.c | 21 +++++++++++++++++++++
 include/drm/drm_clients.h    |  1 +
 include/drm/drm_drv.h        |  8 ++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/gpu/drm/drm_cgroup.c b/drivers/gpu/drm/drm_cgroup.c
index bc1e34f1a552..ef951421bba6 100644
--- a/drivers/gpu/drm/drm_cgroup.c
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -162,3 +162,24 @@ u64 drm_pid_get_active_time_us(struct pid *pid)
 	return total;
 }
 EXPORT_SYMBOL_GPL(drm_pid_get_active_time_us);
+
+void drm_pid_signal_budget(struct pid *pid, u64 usage, u64 budget)
+{
+	struct drm_pid_clients *clients;
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
+			if (cg_ops && cg_ops->signal_budget)
+				cg_ops->signal_budget(fpriv, usage, budget);
+		}
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(drm_pid_signal_budget);
diff --git a/include/drm/drm_clients.h b/include/drm/drm_clients.h
index 7e0c0cf14f25..f3571caa35f8 100644
--- a/include/drm/drm_clients.h
+++ b/include/drm/drm_clients.h
@@ -42,5 +42,6 @@ drm_clients_migrate(struct drm_file *file_priv,
 #endif
 
 u64 drm_pid_get_active_time_us(struct pid *pid);
+void drm_pid_signal_budget(struct pid *pid, u64 usage, u64 budget);
 
 #endif
diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
index f5f0e088e1fe..0945e562821a 100644
--- a/include/drm/drm_drv.h
+++ b/include/drm/drm_drv.h
@@ -174,6 +174,14 @@ struct drm_cgroup_ops {
 	 * Used by the DRM core when queried by the DRM cgroup controller.
 	 */
 	u64 (*active_time_us) (struct drm_file *);
+
+	/**
+	 * @signal_budget:
+	 *
+	 * Optional callback used by the DRM core to forward over/under GPU time
+	 * messages sent by the DRM cgroup controller.
+	 */
+	int (*signal_budget) (struct drm_file *, u64 used, u64 budget);
 };
 
 /**
-- 
2.34.1

