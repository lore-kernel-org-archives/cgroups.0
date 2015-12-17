From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 2/2] cgroup: put controller Kconfig options in meaningful order
Date: Thu, 17 Dec 2015 17:19:57 -0500
Message-ID: <1450390797-4748-3-git-send-email-hannes@cmpxchg.org>
References: <1450390797-4748-1-git-send-email-hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450390797-4748-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

To make it easier to quickly find what's needed list the basic
resource controllers of cgroup2 first - io, memory, cpu - while
pushing the more exotic and/or legacy controllers to the bottom.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 init/Kconfig | 214 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 107 insertions(+), 107 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index ed324f5..fdb5ecb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -957,64 +957,6 @@ menuconfig CGROUPS
 
 if CGROUPS
 
-config CGROUP_DEBUG
-	bool "Example controller"
-	default n
-	help
-	  This option enables a simple controller that exports
-	  debugging information about the cgroups framework.
-
-	  Say N.
-
-config CGROUP_FREEZER
-	bool "Freezer controller"
-	help
-	  Provides a way to freeze and unfreeze all tasks in a
-	  cgroup.
-
-config CGROUP_PIDS
-	bool "PIDs controller"
-	help
-	  Provides enforcement of process number limits in the scope of a
-	  cgroup. Any attempt to fork more processes than is allowed in the
-	  cgroup will fail. PIDs are fundamentally a global resource because it
-	  is fairly trivial to reach PID exhaustion before you reach even a
-	  conservative kmemcg limit. As a result, it is possible to grind a
-	  system to halt without being limited by other cgroup policies. The
-	  PIDs cgroup subsystem is designed to stop this from happening.
-
-	  It should be noted that organisational operations (such as attaching
-	  to a cgroup hierarchy will *not* be blocked by the PIDs subsystem),
-	  since the PIDs limit only affects a process's ability to fork, not to
-	  attach to a cgroup.
-
-config CGROUP_DEVICE
-	bool "Device controller"
-	help
-	  Provides a cgroup controller implementing whitelists for
-	  devices which a process in the cgroup can mknod or open.
-
-config CPUSETS
-	bool "Cpuset controller"
-	help
-	  This option will let you create and manage CPUSETs which
-	  allow dynamically partitioning a system into sets of CPUs and
-	  Memory Nodes and assigning tasks to run only within those sets.
-	  This is primarily useful on large SMP or NUMA systems.
-
-	  Say N if unsure.
-
-config PROC_PID_CPUSET
-	bool "Include legacy /proc/<pid>/cpuset file"
-	depends on CPUSETS
-	default y
-
-config CGROUP_CPUACCT
-	bool "Simple CPU accounting controller"
-	help
-	  Provides a simple controller for monitoring the
-	  total CPU consumed by the tasks in a cgroup.
-
 config PAGE_COUNTER
        bool
 
@@ -1045,31 +987,40 @@ config MEMCG_SWAP_ENABLED
 	  select this option (if, for some reason, they need to disable it
 	  then swapaccount=0 does the trick).
 
-config CGROUP_HUGETLB
-	bool "HugeTLB controller"
-	depends on HUGETLB_PAGE
-	select PAGE_COUNTER
+config BLK_CGROUP
+	bool "IO controller"
+	depends on BLOCK
 	default n
-	help
-	  Provides a cgroup controller for HugeTLB pages.
-	  When you enable this, you can put a per cgroup limit on HugeTLB usage.
-	  The limit is enforced during page fault. Since HugeTLB doesn't
-	  support page reclaim, enforcing the limit at page fault time implies
-	  that, the application will get SIGBUS signal if it tries to access
-	  HugeTLB pages beyond its limit. This requires the application to know
-	  beforehand how much HugeTLB pages it would require for its use. The
-	  control group is tracked in the third page lru pointer. This means
-	  that we cannot use the controller with huge page less than 3 pages.
+	---help---
+	Generic block IO controller cgroup interface. This is the common
+	cgroup interface which should be used by various IO controlling
+	policies.
 
-config CGROUP_PERF
-	bool "Perf controller"
-	depends on PERF_EVENTS && CGROUPS
-	help
-	  This option extends the perf per-cpu mode to restrict monitoring
-	  to threads which belong to the cgroup specified and run on the
-	  designated cpu.
+	Currently, CFQ IO scheduler uses it to recognize task groups and
+	control disk bandwidth allocation (proportional time slice allocation)
+	to such task groups. It is also used by bio throttling logic in
+	block layer to implement upper limit in IO rates on a device.
 
-	  Say N if unsure.
+	This option only enables generic Block IO controller infrastructure.
+	One needs to also enable actual IO controlling logic/policy. For
+	enabling proportional weight division of disk bandwidth in CFQ, set
+	CONFIG_CFQ_GROUP_IOSCHED=y; for enabling throttling policy, set
+	CONFIG_BLK_DEV_THROTTLING=y.
+
+	See Documentation/cgroups/blkio-controller.txt for more information.
+
+config DEBUG_BLK_CGROUP
+	bool "IO controller debugging"
+	depends on BLK_CGROUP
+	default n
+	---help---
+	Enable some debugging help. Currently it exports additional stat
+	files in a cgroup which can be useful for debugging.
+
+config CGROUP_WRITEBACK
+	bool
+	depends on MEMCG && BLK_CGROUP
+	default y
 
 menuconfig CGROUP_SCHED
 	bool "CPU controller"
@@ -1109,40 +1060,89 @@ config RT_GROUP_SCHED
 
 endif #CGROUP_SCHED
 
-config BLK_CGROUP
-	bool "IO controller"
-	depends on BLOCK
+config CGROUP_PIDS
+	bool "PIDs controller"
+	help
+	  Provides enforcement of process number limits in the scope of a
+	  cgroup. Any attempt to fork more processes than is allowed in the
+	  cgroup will fail. PIDs are fundamentally a global resource because it
+	  is fairly trivial to reach PID exhaustion before you reach even a
+	  conservative kmemcg limit. As a result, it is possible to grind a
+	  system to halt without being limited by other cgroup policies. The
+	  PIDs cgroup subsystem is designed to stop this from happening.
+
+	  It should be noted that organisational operations (such as attaching
+	  to a cgroup hierarchy will *not* be blocked by the PIDs subsystem),
+	  since the PIDs limit only affects a process's ability to fork, not to
+	  attach to a cgroup.
+
+config CGROUP_FREEZER
+	bool "Freezer controller"
+	help
+	  Provides a way to freeze and unfreeze all tasks in a
+	  cgroup.
+
+config CGROUP_HUGETLB
+	bool "HugeTLB controller"
+	depends on HUGETLB_PAGE
+	select PAGE_COUNTER
 	default n
-	---help---
-	Generic block IO controller cgroup interface. This is the common
-	cgroup interface which should be used by various IO controlling
-	policies.
+	help
+	  Provides a cgroup controller for HugeTLB pages.
+	  When you enable this, you can put a per cgroup limit on HugeTLB usage.
+	  The limit is enforced during page fault. Since HugeTLB doesn't
+	  support page reclaim, enforcing the limit at page fault time implies
+	  that, the application will get SIGBUS signal if it tries to access
+	  HugeTLB pages beyond its limit. This requires the application to know
+	  beforehand how much HugeTLB pages it would require for its use. The
+	  control group is tracked in the third page lru pointer. This means
+	  that we cannot use the controller with huge page less than 3 pages.
 
-	Currently, CFQ IO scheduler uses it to recognize task groups and
-	control disk bandwidth allocation (proportional time slice allocation)
-	to such task groups. It is also used by bio throttling logic in
-	block layer to implement upper limit in IO rates on a device.
+config CPUSETS
+	bool "Cpuset controller"
+	help
+	  This option will let you create and manage CPUSETs which
+	  allow dynamically partitioning a system into sets of CPUs and
+	  Memory Nodes and assigning tasks to run only within those sets.
+	  This is primarily useful on large SMP or NUMA systems.
 
-	This option only enables generic Block IO controller infrastructure.
-	One needs to also enable actual IO controlling logic/policy. For
-	enabling proportional weight division of disk bandwidth in CFQ, set
-	CONFIG_CFQ_GROUP_IOSCHED=y; for enabling throttling policy, set
-	CONFIG_BLK_DEV_THROTTLING=y.
+	  Say N if unsure.
 
-	See Documentation/cgroups/blkio-controller.txt for more information.
+config PROC_PID_CPUSET
+	bool "Include legacy /proc/<pid>/cpuset file"
+	depends on CPUSETS
+	default y
 
-config DEBUG_BLK_CGROUP
-	bool "IO controller debugging"
-	depends on BLK_CGROUP
+config CGROUP_DEVICE
+	bool "Device controller"
+	help
+	  Provides a cgroup controller implementing whitelists for
+	  devices which a process in the cgroup can mknod or open.
+
+config CGROUP_CPUACCT
+	bool "Simple CPU accounting controller"
+	help
+	  Provides a simple controller for monitoring the
+	  total CPU consumed by the tasks in a cgroup.
+
+config CGROUP_PERF
+	bool "Perf controller"
+	depends on PERF_EVENTS && CGROUPS
+	help
+	  This option extends the perf per-cpu mode to restrict monitoring
+	  to threads which belong to the cgroup specified and run on the
+	  designated cpu.
+
+	  Say N if unsure.
+
+config CGROUP_DEBUG
+	bool "Example controller"
 	default n
-	---help---
-	Enable some debugging help. Currently it exports additional stat
-	files in a cgroup which can be useful for debugging.
+	help
+	  This option enables a simple controller that exports
+	  debugging information about the cgroups framework.
 
-config CGROUP_WRITEBACK
-	bool
-	depends on MEMCG && BLK_CGROUP
-	default y
+	  Say N.
 
 endif # CGROUPS
 
-- 
2.6.4
