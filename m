From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 08/12] drm/cgroup: Only track clients which are
 providing drm_cgroup_ops
Date: Thu, 12 Jan 2023 16:56:05 +0000
Message-ID: <20230112165609.1083270-9-tvrtko.ursulin@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1673542670; x=1705078670;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=O4XaQU0KHXm7hstqYZ0YTz10nkjZFCF6V51/eW89DXg=;
 b=jYyZYn2zW68/11Gak4NLJRe0kMQSLz74ZFOB5HqL3Lk0byh4KrBKXjaz
 4QMqZx7ct5KHlijWjaz5nOZ32Yhm46RcZUJbfeizJ6u7yto+5cSqwd3eK
 LlLY4Y2+8/Suy7ghewQ74qhUmQvi+6r8LW2y1AwErM2amWYA2jrAw2Li9
 GJ1PqTCuA7H5uR6ZfofharXJqy70VwU5bjOAoybMeptyH1y0roU+CZJS7
 WFEjjFwhbWZQjZUn8g5oHht7g7Mbvl+4V9tR/nS30EeRHqbjkNGyCcn2c
 68K4qOjhdjNmHjXJUzDhTlzdAiQkHOwHvSvd2MGud3B6lOdEdxmSaIAwW A==;
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

To reduce the number of tracking going on, especially with drivers which
will not support any sort of control from the drm cgroup controller side,
lets express the funcionality as opt-in and use the presence of
drm_cgroup_ops as activation criteria.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/drm_cgroup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/drm_cgroup.c b/drivers/gpu/drm/drm_cgroup.c
index ef951421bba6..09249f795af3 100644
--- a/drivers/gpu/drm/drm_cgroup.c
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -36,6 +36,9 @@ void drm_clients_close(struct drm_file *file_priv)
 
 	lockdep_assert_held(&dev->filelist_mutex);
 
+	if (!dev->driver->cg_ops)
+		return;
+
 	pid = rcu_access_pointer(file_priv->pid);
 	clients = xa_load(&drm_pid_clients, (unsigned long)pid);
 	if (drm_WARN_ON_ONCE(dev, !clients))
@@ -67,6 +70,9 @@ int drm_clients_open(struct drm_file *file_priv)
 
 	lockdep_assert_held(&dev->filelist_mutex);
 
+	if (!dev->driver->cg_ops)
+		return 0;
+
 	pid = (unsigned long)rcu_access_pointer(file_priv->pid);
 	clients = xa_load(&drm_pid_clients, pid);
 	if (!clients) {
@@ -102,6 +108,9 @@ drm_clients_migrate(struct drm_file *file_priv,
 
 	lockdep_assert_held(&dev->filelist_mutex);
 
+	if (!dev->driver->cg_ops)
+		return;
+
 	existing_clients = xa_load(&drm_pid_clients, (unsigned long)new);
 	clients = xa_load(&drm_pid_clients, (unsigned long)old);
 
-- 
2.34.1

