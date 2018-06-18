From: Waiman Long <longman@redhat.com>
Subject: [PATCH v10 9/9] cpuset: Allow reporting of sched domain generation info
Date: Mon, 18 Jun 2018 12:14:09 +0800
Message-ID: <1529295249-5207-11-git-send-email-longman@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529295249-5207-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Waiman Long <longman@redhat.com>

This patch enables us to report sched domain generation information.

If DYNAMIC_DEBUG is enabled, issuing the following command

  echo "file cpuset.c +p" > /sys/kernel/debug/dynamic_debug/control

and setting loglevel to 8 will allow the kernel to show what scheduling
domain changes are being made.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ed80663..2943d7c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -836,6 +836,23 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	return ndoms;
 }
 
+#ifdef CONFIG_DEBUG_KERNEL
+static inline void debug_print_domains(cpumask_var_t *doms, int ndoms)
+{
+	int i;
+	char buf[200];
+	char *ptr, *end = buf + sizeof(buf) - 1;
+
+	for (i = 0, ptr = buf, *end = '\0'; i < ndoms; i++)
+		ptr += snprintf(ptr, end - ptr, "dom%d=%*pbl ", i,
+				cpumask_pr_args(doms[i]));
+
+	pr_debug("Generated %d domains: %s\n", ndoms, buf);
+}
+#else
+static inline void debug_print_domains(cpumask_var_t *doms, int ndoms) { }
+#endif
+
 /*
  * Rebuild scheduler domains.
  *
@@ -871,6 +888,7 @@ static void rebuild_sched_domains_locked(void)
 
 	/* Generate domain masks and attrs */
 	ndoms = generate_sched_domains(&doms, &attr);
+	debug_print_domains(doms, ndoms);
 
 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
-- 
1.8.3.1

