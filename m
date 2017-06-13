From: Waiman Long <longman@redhat.com>
Subject: [PATCH-cgroup 5/5] cgroup: Enable debug controller only with cgroup_debug boot option
Date: Tue, 13 Jun 2017 17:18:05 -0400
Message-ID: <1497388685-31207-6-git-send-email-longman@redhat.com>
References: <1497388685-31207-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 87BB3723A1
In-Reply-To: <1497388685-31207-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Waiman Long <longman@redhat.com>

As suggested by Tejun, the debug controller will be activated only when
the "cgroup_debug" option is specified in the kernel boot command line.
Hopefully, that will discourage people from using the debug controller
for any purpose other than cgroup core debugging.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/debug.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 82e5cbd..be901c0 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -320,3 +320,23 @@ struct cgroup_subsys debug_cgrp_subsys = {
 	.dfl_cftypes	= debug_files,
 	.threaded	= true,
 };
+
+/*
+ * Disable the debug controller by hiding the debug cgroup control files
+ * if the kernel boot parameter "cgroup_debug" isn't set.
+ */
+static bool cgroup_debug_enable __initdata;
+static int __init enable_cgroup_debug(char *str)
+{
+	cgroup_debug_enable = true;
+	return 1;
+}
+__setup("cgroup_debug", enable_cgroup_debug);
+
+static int __init debug_init(void)
+{
+	if (!cgroup_debug_enable)
+		debug_files[0].name[0] = '\0';
+	return 0;
+}
+core_initcall(debug_init);
-- 
1.8.3.1

