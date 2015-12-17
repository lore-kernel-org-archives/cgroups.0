From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/2] cgroup: clean up the kernel configuration menu nomenclature
Date: Thu, 17 Dec 2015 17:19:56 -0500
Message-ID: <1450390797-4748-2-git-send-email-hannes@cmpxchg.org>
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

The config options for the different cgroup controllers use various
terms: resource controller, cgroup subsystem, etc. Simplify this to
"controller", which is clear enough in the cgroup context.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 init/Kconfig | 65 ++++++++++++++++++++++++------------------------------------
 1 file changed, 26 insertions(+), 39 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 16840b4..ed324f5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -958,23 +958,22 @@ menuconfig CGROUPS
 if CGROUPS
 
 config CGROUP_DEBUG
-	bool "Example debug cgroup subsystem"
+	bool "Example controller"
 	default n
 	help
-	  This option enables a simple cgroup subsystem that
-	  exports useful debugging information about the cgroups
-	  framework.
+	  This option enables a simple controller that exports
+	  debugging information about the cgroups framework.
 
-	  Say N if unsure.
+	  Say N.
 
 config CGROUP_FREEZER
-	bool "Freezer cgroup subsystem"
+	bool "Freezer controller"
 	help
 	  Provides a way to freeze and unfreeze all tasks in a
 	  cgroup.
 
 config CGROUP_PIDS
-	bool "PIDs cgroup subsystem"
+	bool "PIDs controller"
 	help
 	  Provides enforcement of process number limits in the scope of a
 	  cgroup. Any attempt to fork more processes than is allowed in the
@@ -990,13 +989,13 @@ config CGROUP_PIDS
 	  attach to a cgroup.
 
 config CGROUP_DEVICE
-	bool "Device controller for cgroups"
+	bool "Device controller"
 	help
-	  Provides a cgroup implementing whitelists for devices which
-	  a process in the cgroup can mknod or open.
+	  Provides a cgroup controller implementing whitelists for
+	  devices which a process in the cgroup can mknod or open.
 
 config CPUSETS
-	bool "Cpuset support"
+	bool "Cpuset controller"
 	help
 	  This option will let you create and manage CPUSETs which
 	  allow dynamically partitioning a system into sets of CPUs and
@@ -1011,41 +1010,29 @@ config PROC_PID_CPUSET
 	default y
 
 config CGROUP_CPUACCT
-	bool "Simple CPU accounting cgroup subsystem"
+	bool "Simple CPU accounting controller"
 	help
-	  Provides a simple Resource Controller for monitoring the
+	  Provides a simple controller for monitoring the
 	  total CPU consumed by the tasks in a cgroup.
 
 config PAGE_COUNTER
        bool
 
 config MEMCG
-	bool "Memory Resource Controller for Control Groups"
+	bool "Memory controller"
 	select PAGE_COUNTER
 	select EVENTFD
 	help
-	  Provides a memory resource controller that manages both anonymous
-	  memory and page cache. (See Documentation/cgroups/memory.txt)
+	  Provides control over the memory footprint of tasks in a cgroup.
 
 config MEMCG_SWAP
-	bool "Memory Resource Controller Swap Extension"
+	bool "Swap controller"
 	depends on MEMCG && SWAP
 	help
-	  Add swap management feature to memory resource controller. When you
-	  enable this, you can limit mem+swap usage per cgroup. In other words,
-	  when you disable this, memory resource controller has no cares to
-	  usage of swap...a process can exhaust all of the swap. This extension
-	  is useful when you want to avoid exhaustion swap but this itself
-	  adds more overheads and consumes memory for remembering information.
-	  Especially if you use 32bit system or small memory system, please
-	  be careful about enabling this. When memory resource controller
-	  is disabled by boot option, this will be automatically disabled and
-	  there will be no overhead from this. Even when you set this config=y,
-	  if boot option "swapaccount=0" is set, swap will not be accounted.
-	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
-	  size is 4096bytes, 512k per 1Gbytes of swap.
+	  Provides control over the swap space consumed by tasks in a cgroup.
+
 config MEMCG_SWAP_ENABLED
-	bool "Memory Resource Controller Swap Extension enabled by default"
+	bool "Swap controller enabled by default"
 	depends on MEMCG_SWAP
 	default y
 	help
@@ -1059,12 +1046,12 @@ config MEMCG_SWAP_ENABLED
 	  then swapaccount=0 does the trick).
 
 config CGROUP_HUGETLB
-	bool "HugeTLB Resource Controller for Control Groups"
+	bool "HugeTLB controller"
 	depends on HUGETLB_PAGE
 	select PAGE_COUNTER
 	default n
 	help
-	  Provides a cgroup Resource Controller for HugeTLB pages.
+	  Provides a cgroup controller for HugeTLB pages.
 	  When you enable this, you can put a per cgroup limit on HugeTLB usage.
 	  The limit is enforced during page fault. Since HugeTLB doesn't
 	  support page reclaim, enforcing the limit at page fault time implies
@@ -1075,17 +1062,17 @@ config CGROUP_HUGETLB
 	  that we cannot use the controller with huge page less than 3 pages.
 
 config CGROUP_PERF
-	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
+	bool "Perf controller"
 	depends on PERF_EVENTS && CGROUPS
 	help
-	  This option extends the per-cpu mode to restrict monitoring to
-	  threads which belong to the cgroup specified and run on the
+	  This option extends the perf per-cpu mode to restrict monitoring
+	  to threads which belong to the cgroup specified and run on the
 	  designated cpu.
 
 	  Say N if unsure.
 
 menuconfig CGROUP_SCHED
-	bool "Group CPU scheduler"
+	bool "CPU controller"
 	default n
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
@@ -1123,7 +1110,7 @@ config RT_GROUP_SCHED
 endif #CGROUP_SCHED
 
 config BLK_CGROUP
-	bool "Block IO controller"
+	bool "IO controller"
 	depends on BLOCK
 	default n
 	---help---
@@ -1145,7 +1132,7 @@ config BLK_CGROUP
 	See Documentation/cgroups/blkio-controller.txt for more information.
 
 config DEBUG_BLK_CGROUP
-	bool "Enable Block IO controller debugging"
+	bool "IO controller debugging"
 	depends on BLK_CGROUP
 	default n
 	---help---
-- 
2.6.4
