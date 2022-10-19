From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: [RFC 15/17] drm/i915: Migrate client to new owner on
 context create
Date: Wed, 19 Oct 2022 18:32:52 +0100
Message-ID: <20221019173254.3361334-16-tvrtko.ursulin@linux.intel.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1666200850; x=1697736850;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=U7LArZuNthshDvVK5CBxK7+jHExXUGsLdkjMMWrwBEw=;
 b=gXYdHEub5QAcILq7vdZUkihNC9iLYNUYQwSflxUXzQ83HsNB4zS2rIM8
 Ydm4JJtiwDCo+s0TFJfBUkZGkftaHaGvg0P4In3i/Hbf8oQjkUvSOmcGM
 pj4Po5bcJURxQjoel5E7AQcF1qn0Vcb9GJA9l8PDnV9fHrD1OhZp0+eAW
 3gftW/wHg9tlnRGI0s4DOgVC8wmxc7FF/mRaDEwEoGXh8lbXxptbKc9fT
 9qxwTvpSD/lkSWA+bnQbAikMGBMnT6nJ6/gTzLj67mBRHkBPAeJQoR2BK
 obW0Suj4z4Ou3IFiUaR1sae7avuT7i23JUk+L7L61H9abdhnRAPcnzZ2c Q==;
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

Some usage models pass a drm file descriptor from a creating process to
the client which will actually use it.

Use the core drm helper on GEM context create to account for this and
ensure client's resource usage is tracked in the correct cgroup.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 1e29b1e6d186..5f6af306e147 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -69,6 +69,7 @@
 #include <linux/nospec.h>
 
 #include <drm/drm_cache.h>
+#include <drm/drm_clients.h>
 #include <drm/drm_syncobj.h>
 
 #include "gt/gen6_ppgtt.h"
@@ -2300,6 +2301,8 @@ int i915_gem_context_create_ioctl(struct drm_device *dev, void *data,
 	args->ctx_id = id;
 	drm_dbg(&i915->drm, "HW context %d created\n", args->ctx_id);
 
+	drm_clients_migrate(file);
+
 	return 0;
 
 err_pc:
-- 
2.34.1

