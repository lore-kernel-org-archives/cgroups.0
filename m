From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 11/17] drm: Add over budget signalling callback
Date: Wed, 19 Oct 2022 18:32:48 +0100
Message-ID: <20221019173254.3361334-12-tvrtko.ursulin@linux.intel.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1666200837; x=1697736837;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=SCLxQXssqCGWpksvQ3lmggIlRVu0wTOV5RqTAwzpGxU=;
 b=ZABVaW9fe7DHJi9Rl9ktD4UZAhwzPrNI2CESZ78eYdoKTePpXtT1Ex3Z
 6hMSKjkNZ0QZSRXD5VM7xrFBwRjXMDbUI5MQievLKo2risA1Sl9UcgMff
 heIfpGkvb//m5qcuvtTm0/zqhlVPqXB02mazdU9KOReRICH4g/vfypB/k
 VB5e2QAJmqoDqe+46YJSnnJoKQ29KhGFf59l5ZdFKAIHTb9mFCncOXKBW
 w7PPBShO7glKixSsiehqRQFKWTdkQms2gAslF/D9nt81JNPt4khE/u/v9
 7r12wy/jBIX1jJx3/ilVK1aBVdlCXoRrB4yZFadGFlE8m2I0/Da6b7ikh w==;
In-Reply-To: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
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
To: Intel-gfx@lists.freedesktop.org
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
index e0cadb5e5659..e36bc4333924 100644
--- a/drivers/gpu/drm/drm_cgroup.c
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -230,3 +230,24 @@ u64 drm_pid_get_active_time_us(struct pid *pid)
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
index f25e09ed5feb..7ad09fd0a404 100644
--- a/include/drm/drm_clients.h
+++ b/include/drm/drm_clients.h
@@ -38,5 +38,6 @@ static inline void drm_clients_migrate(struct drm_file *file_priv)
 unsigned int drm_pid_priority_levels(struct pid *pid, bool *non_uniform);
 void drm_pid_update_priority(struct pid *pid, int priority);
 u64 drm_pid_get_active_time_us(struct pid *pid);
+void drm_pid_signal_budget(struct pid *pid, u64 usage, u64 budget);
 
 #endif
diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
index 0f1802df01fe..07dec956ebfb 100644
--- a/include/drm/drm_drv.h
+++ b/include/drm/drm_drv.h
@@ -192,6 +192,14 @@ struct drm_cgroup_ops {
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
+	void (*signal_budget) (struct drm_file *, u64 used, u64 budget);
 };
 
 /**
-- 
2.34.1

