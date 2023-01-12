From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 05/12] drm/cgroup: Allow safe external access to
 file_priv
Date: Thu, 12 Jan 2023 16:56:02 +0000
Message-ID: <20230112165609.1083270-6-tvrtko.ursulin@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1673542664; x=1705078664;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=gA5/njLr6I387+ufsBDRnAQjKtZ0ST5kVZFmIu51Hl0=;
 b=WMxL+05WuMdNO8HFv2yaxm09iKu7acXYdGgQit2ugbJwAhJCH6PSCl8f
 RYH5Ojq4uHFeqH6il4obAJ61op74GMI3m1ZRPEMTPGv+TIUgvYiubRl2n
 rgOfyFhmMlq2m2KJz+Pf5irOwPAk44fE7C8wwYN43SfkmFhFShhf4yCD/
 UQjcRDdmISJTL3XvY8XRgt6l7t3oS1bpmq4EdUIfTE2wLsBTfT41ZP8ci
 N/JbAhD1MZrBJt+gv04LoaxcKlQtD8oculXuwAIxCeuCc0GQxOKaTHC8N
 QT7NR0L7fz1Q5H2bBwKLxb8LuPV4k1/9cQtepCB0fVGAIQBA4Pcl6uppN w==;
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

Entry points from the cgroup subsystem into the drm cgroup controller will
need to walk the file_priv structures associated with registered clients
and since those are not RCU protected lets add a hack for now to make this
safe.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/drm_cgroup.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/drm_cgroup.c b/drivers/gpu/drm/drm_cgroup.c
index d91512a560ff..46b012d2be42 100644
--- a/drivers/gpu/drm/drm_cgroup.c
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -18,6 +18,13 @@ __del_clients(struct drm_pid_clients *clients,
 	if (atomic_dec_and_test(&clients->num)) {
 		xa_erase(&drm_pid_clients, pid);
 		kfree_rcu(clients, rcu);
+
+		/*
+		 * FIXME: file_priv is not RCU protected so we add this hack
+		 * to avoid any races with code which walks clients->file_list
+		 * and accesses file_priv.
+		 */
+		synchronize_rcu();
 	}
 }
 
-- 
2.34.1

