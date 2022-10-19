From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 06/17] drm: Only track clients which are providing
 drm_cgroup_ops
Date: Wed, 19 Oct 2022 18:32:43 +0100
Message-ID: <20221019173254.3361334-7-tvrtko.ursulin@linux.intel.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1666200820; x=1697736820;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=lqVOHpteUQeCev/lgNedZY6IzAYCvefhlH9jg3GlMDs=;
 b=HH2z8HyCxlt7wXD+AhG9l/lTPGz59Aafmp+gMFXbmV+tl9K7ed3tivrJ
 GCwibrt+qK4clG5XGOE4MuwkDoGAl4Cua+JTvzAWPWnxEGQcN3cV82nfF
 Uf4RulJYZ3/uIrNmWSR6tlojd63ZqjIG3ldmqU8deTD8AV1ejNH2rVlKD
 Ne7CBnLbYMjBYrBjF+VJNzepgrj1GkaQFUjjszW0yO50hZ2t03w81JoqY
 KFTws1n3Ev8om6gmhQpaJfdLe9gKDHE5GRI4uLcROb8Iza7m2kgaOFGC/
 2w7CiXFV0jBMi3DpgpZAHSrPjIE6vrwkbPB5QGQo0wcIY3tQU48oOgsA1 w==;
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

To reduce the number of tracking going on, especially with drivers which
will not support any sort of control from the drm cgroup controller side,
lets express the funcionality as opt-in and use the presence of
drm_cgroup_ops as activation criteria.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/drm_cgroup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_cgroup.c b/drivers/gpu/drm/drm_cgroup.c
index 0fbb88f08cef..7ed9c7150cae 100644
--- a/drivers/gpu/drm/drm_cgroup.c
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -16,6 +16,9 @@ void drm_clients_close(struct drm_file *file_priv)
 
 	lockdep_assert_held(&dev->filelist_mutex);
 
+	if (!dev->driver->cg_ops)
+		return;
+
 	clients = xa_load(&drm_pid_clients, pid);
 	list_del_rcu(&file_priv->clink);
 	if (atomic_dec_and_test(&clients->num)) {
@@ -40,6 +43,9 @@ int drm_clients_open(struct drm_file *file_priv)
 
 	lockdep_assert_held(&dev->filelist_mutex);
 
+	if (!dev->driver->cg_ops)
+		return 0;
+
 	clients = xa_load(&drm_pid_clients, pid);
 	if (!clients) {
 		clients = kmalloc(sizeof(*clients), GFP_KERNEL);
-- 
2.34.1

