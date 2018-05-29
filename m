From: Waiman Long <longman@redhat.com>
Subject: [PATCH v9 7/7] cpuset: Allow reporting of sched domain generation info
Date: Tue, 29 May 2018 09:41:34 -0400
Message-ID: <1527601294-3444-8-git-send-email-longman@redhat.com>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527601294-3444-1-git-send-email-longman@redhat.com>
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
 kernel/cgroup/cpuset.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9513f90..71fb2d0 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -820,6 +820,12 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	}
 	BUG_ON(nslot != ndoms);
 
+#ifdef CONFIG_DEBUG_KERNEL
+	for (i = 0; i < ndoms; i++)
+		pr_debug("generate_sched_domains dom %d: %*pbl\n", i,
+			 cpumask_pr_args(doms[i]));
+#endif
+
 done:
 	kfree(csa);
 
-- 
1.8.3.1

