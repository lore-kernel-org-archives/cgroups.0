From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: Remove redundant cpu/node masks setup in cpuset_init_smp()
Date: Sun, 24 Apr 2022 22:09:26 -0400
Message-ID: <20220425020926.1264611-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650852607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IWt3Bi21zseUs/ls2Wi4USmCY2Ri5eVFWeb4jdyhkTo=;
        b=OUIiyn3SXc0B9Nrscx1i9n88mUKK/2od6hX1NiwMSXT57W3lakndtjlklOdHftZerf86qx
        +A04pZDCC4Gk7oE1ksPLoH3ScvN+3SW+Az0PeE+iPUxrKlBbi+995lhx7aDQUvfrMSym1p
        Q82lTPQXExvc25t6zHd1B83w9PbD/ak=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There are 3 places where the cpu and node masks of the top cpuset can
be initialized in the order they are executed:
 1) start_kernel -> cpuset_init()
 2) start_kernel -> cgroup_init() -> cpuset_bind()
 3) kernel_init_freeable() -> do_basic_setup() -> cpuset_init_smp()

The first cpuset_init() function just sets all the bits in the masks.
The last one executed is cpuset_init_smp() which sets up cpu and node
masks suitable for v1, but not v2.  cpuset_bind() does the right setup
for both v1 and v2 assuming that effective_mems and effective_cpus have
been set up properly which is not strictly the case here. As a result,
cpu and memory node hot add may fail to update the cpu and node masks
of the top cpuset to include the newly added cpu or node in a cgroup
v2 environment.

To fix this problem, the redundant cpus_allowed and mems_allowed
mask setup in cpuset_init_smp() are removed. The effective_cpus and
effective_mems setup there are moved to cpuset_bind().

cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9390bfd9f1cd..a2e15a43397e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2961,6 +2961,9 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
 	percpu_down_write(&cpuset_rwsem);
 	spin_lock_irq(&callback_lock);
 
+	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
+	top_cpuset.effective_mems = node_states[N_MEMORY];
+
 	if (is_in_v2_mode()) {
 		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
 		top_cpuset.mems_allowed = node_possible_map;
@@ -3390,13 +3393,6 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
  */
 void __init cpuset_init_smp(void)
 {
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_MEMORY];
-	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
-
-	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
-	top_cpuset.effective_mems = node_states[N_MEMORY];
-
 	register_hotmemory_notifier(&cpuset_track_online_nodes_nb);
 
 	cpuset_migrate_mm_wq = alloc_ordered_workqueue("cpuset_migrate_mm", 0);
-- 
2.27.0

