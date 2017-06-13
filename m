From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH-cgroup 3/5] cgroup: Make Kconfig prompt of debug cgroup more accurate
Date: Tue, 13 Jun 2017 17:18:03 -0400
Message-ID: <1497388685-31207-4-git-send-email-longman@redhat.com>
References: <1497388685-31207-1-git-send-email-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com C960D30312C
In-Reply-To: <1497388685-31207-1-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The Kconfig prompt and description of the debug cgroup controller
more accurate by saying that it is for debug purpose only and its
interfaces are unstable.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 init/Kconfig          | 7 +++++--
 kernel/cgroup/debug.c | 6 ++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 1d3475f..5f9d139 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1205,11 +1205,14 @@ config CGROUP_BPF
 	  inet sockets.
 
 config CGROUP_DEBUG
-	bool "Example controller"
+	bool "Debug controller"
 	default n
+	depends on DEBUG_KERNEL
 	help
 	  This option enables a simple controller that exports
-	  debugging information about the cgroups framework.
+	  debugging information about the cgroups framework. This
+	  controller is for control cgroup debugging only. Its
+	  interfaces are not stable.
 
 	  Say N.
 
diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 1c209aa..cbe77a2 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -1,3 +1,9 @@
+/*
+ * Debug controller
+ *
+ * WARNING: This controller is for cgroup core debugging only.
+ * Its interfaces are unstable and subject to changes at any time.
+ */
 #include <linux/ctype.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-- 
1.8.3.1
