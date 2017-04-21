From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH 13/14] sched: Make cpu/cpuacct threaded controllers
Date: Fri, 21 Apr 2017 10:04:11 -0400
Message-ID: <1492783452-12267-14-git-send-email-longman@redhat.com>
References: <1492783452-12267-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 373F2E0739
In-Reply-To: <1492783452-12267-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, Waiman Long <longman@redhat.com>

Make cpu and cpuacct cgroup controllers usable within a threaded cgroup.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/sched/core.c    | 1 +
 kernel/sched/cpuacct.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 78dfcaa..9d8beda 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7432,6 +7432,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.legacy_cftypes	= cpu_legacy_files,
 	.dfl_cftypes	= cpu_files,
 	.early_init	= true,
+	.threaded	= true,
 #ifdef CONFIG_CGROUP_CPUACCT
 	/*
 	 * cpuacct is enabled together with cpu on the unified hierarchy
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index fc1cf13..853d18a 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -414,4 +414,5 @@ struct cgroup_subsys cpuacct_cgrp_subsys = {
 	.css_free	= cpuacct_css_free,
 	.legacy_cftypes	= files,
 	.early_init	= true,
+	.threaded	= true,
 };
-- 
1.8.3.1

