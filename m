From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC v2 7/7] drm/i915: Add context priority & priority offset to debugfs
Date: Thu,  1 Feb 2018 11:53:15 -0800
Message-ID: <20180201195315.4956-8-matthew.d.roper@intel.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201195315.4956-1-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Update i915_context_status to include priority information.

Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/gpu/drm/i915/i915_debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 3849ded354e3..e9d8e20155b1 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1915,6 +1915,9 @@ static int i915_context_status(struct seq_file *m, void *unused)
 		seq_putc(m, ctx->remap_slice ? 'R' : 'r');
 		seq_putc(m, '\n');
 
+		seq_printf(m, "Priority %d (prio offset = %d)\n",
+			   ctx->priority, ctx->priority_offset);
+
 		for_each_engine(engine, dev_priv, id) {
 			struct intel_context *ce = &ctx->engine[engine->id];
 
-- 
2.14.3
