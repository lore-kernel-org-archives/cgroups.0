From: Waiman Long <longman@redhat.com>
Subject: [PATCH v13 09/11] cpuset: Expose cpus.effective and mems.effective on cgroup v2 root
Date: Fri, 12 Oct 2018 13:55:49 -0400
Message-ID: <1539366951-8498-10-git-send-email-longman@redhat.com>
References: <1539366951-8498-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539366951-8498-1-git-send-email-longman@redhat.com>
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
index 0465c23..533e85c 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1631,7 +1631,7 @@ Cpuset Interface Files
 	and won't be affected by any CPU hotplug events.
 
   cpuset.cpus.effective
-	A read-only multiple values file which exists on non-root
+	A read-only multiple values file which exists on all
 	cpuset-enabled cgroups.
 
 	It lists the onlined CPUs that are actually granted to this
@@ -1671,7 +1671,7 @@ Cpuset Interface Files
 	and won't be affected by any memory nodes hotplug events.
 
   cpuset.mems.effective
-	A read-only multiple values file which exists on non-root
+	A read-only multiple values file which exists on all
 	cpuset-enabled cgroups.
 
 	It lists the onlined memory nodes that are actually granted to
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c52074e..a3b81d4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2560,14 +2560,12 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
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

