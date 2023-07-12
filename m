From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [PATCH 15/17] cgroup/drm: Expose GPU utilisation
Date: Wed, 12 Jul 2023 12:46:03 +0100
Message-ID: <20230712114605.519432-16-tvrtko.ursulin@linux.intel.com>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1689162484; x=1720698484;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=r3UFb8OqF06fv2F6gJ/iTXwHgvZZy1ZJFg6pTLkEphg=;
 b=FROj5r341+hKSuZGUBt0JFNfzzfrCzqVRfjwtm1JaAEY2HeIqhHuL3jG
 D1phZ98Ri5ycKQVIc2URvaG/ZOPq6G6QZKwM9kdZNEfATSKXiumGQdsXv
 9FzvaHPm93O5DBQ6+IDckW0y1X7xBXQhCxCsjsYc8epWXUEtVowcqT2ye
 OyeSlsA7bIcCauYMFOTw0qDrDCXgIP+x749TrHhFzspvTbdK+eKnX7bNx
 /5Lfai01aETJMeVJ+JEp+TURrTcWrDBRLgIe+VQJdD1MUg/qa3xaqxSSz
 mIqMMDzG8pDev57B0qw9dDPi3uKAMELjFenr3BE6OB02iuWETEeTpuzBP g==;
In-Reply-To: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
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
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Eero Tamminen <eero.t.tamminen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

To support container use cases where external orchestrators want to make
deployment and migration decisions based on GPU load and capacity, we can
expose the GPU load as seen by the controller in a new drm.active_us
field. This field contains a monotonic cumulative time cgroup has spent
executing GPU loads, as reported by the DRM drivers being used by group
members.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Eero Tamminen <eero.t.tamminen@intel.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  3 +++
 kernel/cgroup/drm.c                     | 26 ++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index da350858c59f..bbe986366f4a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2445,6 +2445,9 @@ will be respected.
 DRM scheduling soft limits interface files
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
+  drm.active_us
+	GPU time used by the group recursively including all child groups.
+
   drm.weight
 	Standard cgroup weight based control [1, 10000] used to configure the
 	relative distributing of GPU time between the sibling groups.
diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index b244e3d828cc..7c20d4ebc634 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -25,6 +25,8 @@ struct drm_cgroup_state {
 	bool over;
 	bool over_budget;
 
+	u64 total_us;
+
 	u64 per_s_budget_us;
 	u64 prev_active_us;
 	u64 active_us;
@@ -117,6 +119,20 @@ drmcs_write_weight(struct cgroup_subsys_state *css, struct cftype *cftype,
 	return 0;
 }
 
+static u64
+drmcs_read_total_us(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	struct drm_cgroup_state *drmcs = css_to_drmcs(css);
+	u64 val;
+
+	/* Mutex being overkill unless arch cannot atomically read u64.. */
+	mutex_lock(&drmcg_mutex);
+	val = drmcs->total_us;
+	mutex_unlock(&drmcg_mutex);
+
+	return val;
+}
+
 static bool __start_scanning(unsigned int period_us)
 {
 	struct drm_cgroup_state *root = &root_drmcs.drmcs;
@@ -169,11 +185,14 @@ static bool __start_scanning(unsigned int period_us)
 		parent = css_to_drmcs(node->parent);
 
 		active = drmcs_get_active_time_us(drmcs);
-		if (period_us && active > drmcs->prev_active_us)
+		if (period_us && active > drmcs->prev_active_us) {
 			drmcs->active_us += active - drmcs->prev_active_us;
+			drmcs->total_us += drmcs->active_us;
+		}
 		drmcs->prev_active_us = active;
 
 		parent->active_us += drmcs->active_us;
+		parent->total_us += drmcs->active_us;
 		parent->sum_children_weights += drmcs->weight;
 
 		css_put(node);
@@ -551,6 +570,11 @@ struct cftype files[] = {
 		.read_u64 = drmcs_read_weight,
 		.write_u64 = drmcs_write_weight,
 	},
+	{
+		.name = "active_us",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = drmcs_read_total_us,
+	},
 	{ } /* Zero entry terminates. */
 };
 
-- 
2.39.2

