From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 09/17] cgroup/drm: Introduce weight based drm
 cgroup control
Date: Wed, 19 Oct 2022 18:32:46 +0100
Message-ID: <20221019173254.3361334-10-tvrtko.ursulin@linux.intel.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1666200830; x=1697736830;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=1PhDcr2XGs8uIfUaec8gKHHe5Qyfm3zBRnEHtyvj3RQ=;
 b=gPTX8Fib6dr4sRo0I9aak04vrPrJ0slMrfEcVi62vtsqWBVsgmlzKJIC
 7ELraeRyKhDovF7CJoffdMV9UorLoI3uMuaN4WBZfwKr9BWCl6dmHQ336
 eWRXwQfAhXkYS0Q8ORcNZYIxKdHtypXP4C9e515wTZpHdv2iSWXTvFuAr
 xLV7tplOI966yCqMBcsBwksIZwRG7wxbEgeDJjl/bxA5mvgCMfb3O4zaA
 /5ncZGhVlsScElumHfdrs+cR7lc2Wl94X8EOxPL9M3S3ealRFzqRKOeFp
 XUdJAsuh5qi7a5NRv4lHTuv4K9ur2AcGx097T61oJ5/cnwjtzC070P3qP w==;
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

Similar to CPU scheduling, implement a concept of weight in the drm cgroup
controller.

Uses the same range and default as the CPU controller - CGROUP_WEIGHT_MIN,
CGROUP_WEIGHT_DFL and CGROUP_WEIGHT_MAX.

Later each cgroup is assigned a time budget proportionaly based on the
relative weights of it's siblings. This time budget is in turn split by
the group's children and so on.

Children of the root cgroup will be exempt from split budgets and
therefore compete for the GPU time independently and without weight based
control.

This will be used to implement a soft, or best effort signal from drm
cgroup to drm core notifying about groups which are over their allotted
budget.

No guarantees that the limit can be enforced are provided or implied.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 kernel/cgroup/drm.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/kernel/cgroup/drm.c b/kernel/cgroup/drm.c
index 01954c3a2087..4b6f88d8236e 100644
--- a/kernel/cgroup/drm.c
+++ b/kernel/cgroup/drm.c
@@ -17,6 +17,7 @@ struct drm_cgroup_state {
 
 	int priority;
 	int effective_priority;
+	unsigned int weight;
 };
 
 static DEFINE_MUTEX(drmcg_mutex);
@@ -163,6 +164,33 @@ drmcs_write_priority(struct cgroup_subsys_state *css, struct cftype *cftype,
 	return 0;
 }
 
+static u64
+drmcs_read_weight(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	struct drm_cgroup_state *drmcs = css_to_drmcs(css);
+
+	return drmcs->weight;
+}
+
+static int
+drmcs_write_weight(struct cgroup_subsys_state *css, struct cftype *cftype,
+		   u64 weight)
+{
+	struct drm_cgroup_state *drmcs = css_to_drmcs(css);
+	int ret;
+
+	if (weight < CGROUP_WEIGHT_MIN || weight > CGROUP_WEIGHT_MAX)
+		return -ERANGE;
+
+	ret = mutex_lock_interruptible(&drmcg_mutex);
+	if (ret)
+		return ret;
+	drmcs->weight = weight;
+	mutex_unlock(&drmcg_mutex);
+
+	return 0;
+}
+
 static int drmcs_online(struct cgroup_subsys_state *css)
 {
 	struct drm_cgroup_state *drmcs = css_to_drmcs(css);
@@ -210,6 +238,8 @@ drmcs_alloc(struct cgroup_subsys_state *parent_css)
 	if (!drmcs)
 		return ERR_PTR(-ENOMEM);
 
+	drmcs->weight = CGROUP_WEIGHT_DFL;
+
 	return &drmcs->css;
 }
 
@@ -230,6 +260,12 @@ struct cftype files[] = {
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_s64 = drmcs_read_effective_priority,
 	},
+	{
+		.name = "weight",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = drmcs_read_weight,
+		.write_u64 = drmcs_write_weight,
+	},
 	{ } /* Zero entry terminates. */
 };
 
-- 
2.34.1

