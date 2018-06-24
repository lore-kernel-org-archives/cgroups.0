From: Waiman Long <longman@redhat.com>
Subject: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective on cgroup v2 root
Date: Sun, 24 Jun 2018 15:30:38 +0800
Message-ID: <1529825440-9574-8-git-send-email-longman@redhat.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529825440-9574-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Waiman Long <longman@redhat.com>

Because of the fact that setting the "cpuset.sched.partition" in
a direct child of root can remove CPUs from the root's effective CPU
list, it makes sense to know what CPUs are left in the root cgroup for
scheduling purpose. So the "cpuset.cpus.effective" control file is now
exposed in the v2 cgroup root.

For consistency, the "cpuset.mems.effective" control file is exposed
as well.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++--
 kernel/cgroup/cpuset.c                  | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index f4efa40..f7cde15 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1529,7 +1529,7 @@ Cpuset Interface Files
 	and won't be affected by any CPU hotplug events.
 
   cpuset.cpus.effective
-	A read-only multiple values file which exists on non-root
+	A read-only multiple values file which exists on all
 	cpuset-enabled cgroups.
 
 	It lists the onlined CPUs that are actually granted to this
@@ -1569,7 +1569,7 @@ Cpuset Interface Files
 	and won't be affected by any memory nodes hotplug events.
 
   cpuset.mems.effective
-	A read-only multiple values file which exists on non-root
+	A read-only multiple values file which exists on all
 	cpuset-enabled cgroups.
 
 	It lists the onlined memory nodes that are actually granted to
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e545848..9097e9d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2216,14 +2216,12 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 		.name = "cpus.effective",
 		.seq_show = cpuset_common_seq_show,
 		.private = FILE_EFFECTIVE_CPULIST,
-		.flags = CFTYPE_NOT_ON_ROOT,
 	},
 
 	{
 		.name = "mems.effective",
 		.seq_show = cpuset_common_seq_show,
 		.private = FILE_EFFECTIVE_MEMLIST,
-		.flags = CFTYPE_NOT_ON_ROOT,
 	},
 
 	{
-- 
1.8.3.1

