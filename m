From: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: [PATCH 2/4] cpumask: make "all" alias global and not just RCU
Date: Sun,  8 Nov 2020 11:08:14 -0500
Message-ID: <20201108160816.896881-3-paul.gortmaker@windriver.com>
References: <20201108160816.896881-1-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFSsm2jr4JRhYEyFiwGRdWnuSdL6qjQnvQIKhWnnw4c=;
 b=Q+3BTfcoO1dVl/lKvIYqc76ucV+kf9zOLmXzNMe+a96WEYwrOFaTFjhYWd6b+hVwt7Cj4UvzhqeQCZSwNwUAymMBcrEmo2B3kZkbN92vtYBPz8yAFKMBevye2Fl++/sRZDbAE2DJljU2KhW12v9vkfwiuCLT81AMgzvbMhjlgOY=
In-Reply-To: <20201108160816.896881-1-paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

It is probably better that we don't have subsystem specific
abbreviations or aliases for generic CPU list specifications.

Hence we move the "all" from RCU out to lib/ so that it can be
used in any instance where CPU lists are being parsed.

Signed-off-by: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
---
 Documentation/admin-guide/kernel-parameters.rst |  7 +++++++
 Documentation/admin-guide/kernel-parameters.txt |  4 +---
 kernel/rcu/tree_plugin.h                        | 13 ++++---------
 lib/cpumask.c                                   |  6 ++++++
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index 6d421694d98e..ef98ca700946 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -68,6 +68,13 @@ For example one can add to the command line following parameter:
 
 where the final item represents CPUs 100,101,125,126,150,151,...
 
+The following convenience aliases are also accepted and used:
+
+        foo_cpus=all
+
+is equivalent to "foo_cpus=0-N" -- where "N" is the numerically last CPU on
+the system, thus avoiding looking up the value in "/sys/devices/system/cpu"
+in advance on each deployed system.
 
 
 This document may not be entirely up to date and comprehensive. The command
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 526d65d8573a..96eed72f02a2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4023,9 +4023,7 @@
 				see CONFIG_RAS_CEC help text.
 
 	rcu_nocbs=	[KNL]
-			The argument is a cpu list, as described above,
-			except that the string "all" can be used to
-			specify every CPU on the system.
+			The argument is a cpu list, as described above.
 
 			In kernels built with CONFIG_RCU_NOCB_CPU=y, set
 			the specified list of CPUs to be no-callback CPUs.
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index fd8a52e9a887..b18f89f94fd3 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1463,20 +1463,15 @@ static void rcu_cleanup_after_idle(void)
 
 /*
  * Parse the boot-time rcu_nocb_mask CPU list from the kernel parameters.
- * The string after the "rcu_nocbs=" is either "all" for all CPUs, or a
- * comma-separated list of CPUs and/or CPU ranges.  If an invalid list is
- * given, a warning is emitted and all CPUs are offloaded.
+ * If the list is invalid, a warning is emitted and all CPUs are offloaded.
  */
 static int __init rcu_nocb_setup(char *str)
 {
 	alloc_bootmem_cpumask_var(&rcu_nocb_mask);
-	if (!strcasecmp(str, "all"))
+	if (cpulist_parse(str, rcu_nocb_mask)) {
+		pr_warn("rcu_nocbs= bad CPU range, all CPUs set\n");
 		cpumask_setall(rcu_nocb_mask);
-	else
-		if (cpulist_parse(str, rcu_nocb_mask)) {
-			pr_warn("rcu_nocbs= bad CPU range, all CPUs set\n");
-			cpumask_setall(rcu_nocb_mask);
-		}
+	}
 	return 1;
 }
 __setup("rcu_nocbs=", rcu_nocb_setup);
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 5eb002237404..15599cdf5db6 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -2,6 +2,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/bitops.h>
+#include <linux/string.h>
 #include <linux/cpumask.h>
 #include <linux/export.h>
 #include <linux/memblock.h>
@@ -104,6 +105,11 @@ EXPORT_SYMBOL(cpumask_next_wrap);
  */
 int cpulist_parse(const char *buf, struct cpumask *dstp)
 {
+	if (!strcmp(buf, "all")) {
+		cpumask_setall(dstp);
+		return 0;
+	}
+
 	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
 }
 EXPORT_SYMBOL(cpulist_parse);
-- 
2.25.1

