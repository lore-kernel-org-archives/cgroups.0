From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [PATCH 03/17] drm/i915: Track page table backing store
 usage
Date: Wed, 12 Jul 2023 12:45:51 +0100
Message-ID: <20230712114605.519432-4-tvrtko.ursulin@linux.intel.com>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1689162463; x=1720698463;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=75FdISXFIBIdArdQdqTeYKagFkSfhuce1VMLySmuSgc=;
 b=cLJgQ5okhZ4ykY/xLxGHoRZpe2Hh9lq2VkknK+mWz7/yejXd6kVf07Jb
 lEAp59fGB4I/Ykhtv33WlipvdCskT0IO/iccYHgjNclMwFhk13nrpyuxT
 zC+M3i5bux5kLbmvmIyvj62HoJCFkfM4/BIM4cowidvCdt0toXsT9q1Ig
 5dqhBBs+UhsFr7UMr7sJn7/zW2y5gQafi663YbLhl3SLBuqpt7wc1f5p9
 FnY/uAKNHF2v4aEyaROEp6DW9eCiAmY2tV2pBx+tTceCBmX0R4+kO9E9V
 xfUvSaV50M8L8tgBmwFCU7Zg8xOf1yG1gHYKm7H/0KXKq+EjBHiYr2re4 Q==;
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
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Account page table backing store against the owning client memory usage
stats.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Aravind Iddamsetty <aravind.iddamsetty@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_gtt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.c b/drivers/gpu/drm/i915/gt/intel_gtt.c
index 731d9f2bbc56..065099362a98 100644
--- a/drivers/gpu/drm/i915/gt/intel_gtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gtt.c
@@ -58,6 +58,9 @@ struct drm_i915_gem_object *alloc_pt_lmem(struct i915_address_space *vm, int sz)
 	if (!IS_ERR(obj)) {
 		obj->base.resv = i915_vm_resv_get(vm);
 		obj->shares_resv_from = vm;
+
+		if (vm->fpriv)
+			i915_drm_client_add_object(vm->fpriv->client, obj);
 	}
 
 	return obj;
@@ -79,6 +82,9 @@ struct drm_i915_gem_object *alloc_pt_dma(struct i915_address_space *vm, int sz)
 	if (!IS_ERR(obj)) {
 		obj->base.resv = i915_vm_resv_get(vm);
 		obj->shares_resv_from = vm;
+
+		if (vm->fpriv)
+			i915_drm_client_add_object(vm->fpriv->client, obj);
 	}
 
 	return obj;
-- 
2.39.2

