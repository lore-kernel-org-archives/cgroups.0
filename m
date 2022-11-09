From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 09/13] drm/cgroup: Only track clients which are
 providing drm_cgroup_ops
Date: Wed,  9 Nov 2022 16:11:37 +0000
Message-ID: <20221109161141.2987173-10-tvrtko.ursulin@linux.intel.com>
References: <20221109161141.2987173-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1668010351; x=1699546351;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=QhCzUoXOe6qmLG6Pf4Ep1QDjdcywTWaTd4/r+6EDODU=;
 b=Q9FgpF1cYvi8lL9dpD61uEyCQmwsPF2wAOwoRd+zdv8jH0r2BoZxgCba
 XPfKbvSgFbYZQPtPePHtoBFI4HQeZskSS6S6Y5Okh+W6XZC3vZwReb+O3
 snhROCaXclJZe/ETQ5FlfwXIc0Sx1pa8FfdslIR3Bf3tPjqnz0bTM17fF
 /6O/b0VWJu1FAUqHUFq0JHdYcLp67Yp1RGKoG5+/H3AJDzy/DpeEk4OlF
 PPlU2tK/FuN0eywdkpxa54Ir7vYZWRRBXKuzuYvdgW3clHGKZfjUD8IXB
 IbNZjNbSkhL/BFR5jr31GlAamQuEhRLSzchaRIiSbf10kn2noT/Tl4NUK A==;
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
Content-Type: text/plain; charset="us-ascii"
To: Intel-gfx@lists.freedesktop.org
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
index e3854741c584..d3050c744e3e 100644
--- a/drivers/gpu/drm/drm_cgroup.c
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -35,6 +35,9 @@ void drm_clients_close(struct drm_file *file_priv)
 
 	lockdep_assert_held(&dev->filelist_mutex);
 
+	if (!dev->driver->cg_ops)
+		return;
+
 	pid = rcu_access_pointer(file_priv->pid);
 	clients = xa_load(&drm_pid_clients, (unsigned long)pid);
 	if (WARN_ON_ONCE(!clients))
@@ -66,6 +69,9 @@ int drm_clients_open(struct drm_file *file_priv)
 
 	lockdep_assert_held(&dev->filelist_mutex);
 
+	if (!dev->driver->cg_ops)
+		return 0;
+
 	pid = (unsigned long)rcu_access_pointer(file_priv->pid);
 	clients = xa_load(&drm_pid_clients, pid);
 	if (!clients) {
@@ -101,6 +107,9 @@ drm_clients_migrate(struct drm_file *file_priv,
 
 	lockdep_assert_held(&dev->filelist_mutex);
 
+	if (!dev->driver->cg_ops)
+		return;
+
 	existing_clients = xa_load(&drm_pid_clients, new);
 	clients = xa_load(&drm_pid_clients, old);
 
-- 
2.34.1

