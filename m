From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()
Date: Mon, 25 Apr 2022 11:55:05 -0400
Message-ID: <20220425155505.1292896-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650902123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PVSYP5Mpz/Q9il9/k10rbzttz20c1zE5kV+uNj/q4Vs=;
        b=ZiwkWS92wKZzwc8apWDTcJ/sC2FbK0qtuttlw6XoEsy1WRLuYLld/H+4ldmuYRnLQnzqSR
        r342uCbi3uCElfDxKbkh3MZrLgT3W2TgGKkWnlMsJgKALI8RGZpCzMacWZmfKETJtylTaH
        s94lrSgj5C2e6LcrTo4eEc1IUp66A8o=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com, Waiman Long <longman@redhat.com>, stable@vger.kernel.org

There are 3 places where the cpu and node masks of the top cpuset can
be initialized in the order they are executed:
 1) start_kernel -> cpuset_init()
 2) start_kernel -> cgroup_init() -> cpuset_bind()
 3) kernel_init_freeable() -> do_basic_setup() -> cpuset_init_smp()

The first cpuset_init() function just sets all the bits in the masks.
The last one executed is cpuset_init_smp() which sets up cpu and node
masks suitable for v1, but not v2.  cpuset_bind() does the right setup
for both v1 and v2.

For systems with cgroup v2 setup, cpuset_bind() is called once. For
systems with cgroup v1 setup, cpuset_bind() is called twice. It is
first called before cpuset_init_smp() in cgroup v2 mode.  Then it is
called again when cgroup v1 filesystem is mounted in v1 mode after
cpuset_init_smp().

  [    2.609781] cpuset_bind() called - v2 = 1
  [    3.079473] cpuset_init_smp() called
  [    7.103710] cpuset_bind() called - v2 = 0

As a result, cpu and memory node hot add may fail to update the cpu and
node masks of the top cpuset to include the newly added cpu or node in
a cgroup v2 environment.

smp_init() is called after the first two init functions.  So we don't
have a complete list of active cpus and memory nodes until later in
cpuset_init_smp() which is the right time to set up effective_cpus
and effective_mems.

To fix this problem, the potentially incorrect cpus_allowed &
mems_allowed setup in cpuset_init_smp() are removed.  For cgroup v2
systems, the initial cpuset_bind() call will set them up correctly.
For cgroup v1 systems, the second call to cpuset_bind() will do the
right setup.

cc: stable@vger.kernel.org
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9390bfd9f1cd..6bd8f5ef40fe 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3390,8 +3390,9 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
  */
 void __init cpuset_init_smp(void)
 {
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_MEMORY];
+	/*
+	 * cpus_allowd/mems_allowed will be properly set up in cpuset_bind().
+	 */
 	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
 
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
-- 
2.27.0

