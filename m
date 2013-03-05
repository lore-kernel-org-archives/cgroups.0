From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH] perf: remove include of cgroup.h from perf_event.h
Date: Tue, 5 Mar 2013 11:38:08 +0800
Message-ID: <513568A0.6020804@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, Tejun Heo <tj@kernel.org>

Move struct perf_cgroup_info and perf_cgroup to kernel/perf/core.c,
and then we can remove include of cgroup.h.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/perf_event.h | 18 +-----------------
 kernel/events/core.c       | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e47ee46..8737e1c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -21,7 +21,6 @@
  */
 
 #ifdef CONFIG_PERF_EVENTS
-# include <linux/cgroup.h>
 # include <asm/perf_event.h>
 # include <asm/local64.h>
 #endif
@@ -299,22 +298,7 @@ struct swevent_hlist {
 #define PERF_ATTACH_GROUP	0x02
 #define PERF_ATTACH_TASK	0x04
 
-#ifdef CONFIG_CGROUP_PERF
-/*
- * perf_cgroup_info keeps track of time_enabled for a cgroup.
- * This is a per-cpu dynamically allocated data structure.
- */
-struct perf_cgroup_info {
-	u64				time;
-	u64				timestamp;
-};
-
-struct perf_cgroup {
-	struct				cgroup_subsys_state css;
-	struct				perf_cgroup_info *info;	/* timing info, one per cpu */
-};
-#endif
-
+struct perf_cgroup;
 struct ring_buffer;
 
 /**
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..5976a2a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -37,6 +37,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
+#include <linux/cgroup.h>
 
 #include "internal.h"
 
@@ -234,6 +235,20 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
 #ifdef CONFIG_CGROUP_PERF
 
 /*
+ * perf_cgroup_info keeps track of time_enabled for a cgroup.
+ * This is a per-cpu dynamically allocated data structure.
+ */
+struct perf_cgroup_info {
+	u64				time;
+	u64				timestamp;
+};
+
+struct perf_cgroup {
+	struct cgroup_subsys_state	css;
+	struct perf_cgroup_info		*info;
+};
+
+/*
  * Must ensure cgroup is pinned (css_get) before calling
  * this function. In other words, we cannot call this function
  * if there is no cgroup event for the current CPU context.
-- 
1.8.0.2
