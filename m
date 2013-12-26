From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [RFC PATCH 2/3] x86: Add Cache QoS Monitoring support to x86 perf uncore
Date: Thu, 26 Dec 2013 13:34:38 -0800
Message-ID: <1388093679-26952-3-git-send-email-peter.p.waskiewicz.jr@intel.com>
References: <1388093679-26952-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1388093679-26952-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, x86@kernel.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, peter.p.waskiewicz.jr@intel.com

This patch adds the MSRs and masks for CQM to the x86 uncore.

The actual scheduling functions using the MSRs will be included
in the next patch when the new cgroup subsystem is added, as there
are dependencies on structs from the cgroup.

Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index a80ab71..f788145 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -412,6 +412,19 @@
 
 #define NHMEX_W_PMON_GLOBAL_FIXED_EN		(1ULL << 31)
 
+#ifdef CONFIG_CGROUP_CACHEQOS
+/* Intel Cache QoS Monitoring uncore support */
+#define IA32_QM_EVTSEL				0xc8d
+#define IA32_QM_CTR				0xc8e
+#define IA32_PQR_ASSOC				0xc8f
+
+#define IA32_QM_EVTSEL_EVTID_READ_OCC		0x01
+#define IA32_QM_CTR_ERR				(0x03llu << 62)
+#define IA32_RMID_PQR_MASK			0x3ff
+#define IA32_QM_EVTSEL_RMID_POSITION		32
+
+#endif /* CONFIG_CGROUP_CACHEQOS */
+
 struct intel_uncore_ops;
 struct intel_uncore_pmu;
 struct intel_uncore_box;
-- 
1.8.3.1
