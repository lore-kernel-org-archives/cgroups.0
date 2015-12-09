From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 7/8] mm: memcontrol: account "kmem" consumers in cgroup2
 memory controller
Date: Wed, 9 Dec 2015 14:30:38 +0300
Message-ID: <20151209113037.GS11488@esperanza>
References: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
 <1449599665-18047-8-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1449599665-18047-8-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Dec 08, 2015 at 01:34:24PM -0500, Johannes Weiner wrote:
> The original cgroup memory controller has an extension to account slab
> memory (and other "kernel memory" consumers) in a separate "kmem"
> counter, once the user set an explicit limit on that "kmem" pool.
> 
> However, this includes various consumers whose sizes are directly
> linked to userspace activity. Accounting them as an optional "kmem"
> extension is problematic for several reasons:
> 
> 1. It leaves the main memory interface with incomplete semantics. A
>    user who puts their workload into a cgroup and configures a memory
>    limit does not expect us to leave holes in the containment as big
>    as the dentry and inode cache, or the kernel stack pages.
> 
> 2. If the limit set on this random historical subgroup of consumers is
>    reached, subsequent allocations will fail even when the main memory
>    pool available to the cgroup is not yet exhausted and/or has
>    reclaimable memory in it.
> 
> 3. Calling it 'kernel memory' is misleading. The dentry and inode
>    caches are no more 'kernel' (or no less 'user') memory than the
>    page cache itself. Treating these consumers as different classes is
>    a historical implementation detail that should not leak to users.
> 
> So, in addition to page cache, anonymous memory, and network socket
> memory, account the following memory consumers per default in the
> cgroup2 memory controller:
> 
>      - threadinfo
>      - task_struct
>      - task_delay_info
>      - pid
>      - cred
>      - mm_struct
>      - vm_area_struct and vm_region (nommu)
>      - anon_vma and anon_vma_chain
>      - signal_struct
>      - sighand_struct
>      - fs_struct
>      - files_struct
>      - fdtable and fdtable->full_fds_bits
>      - dentry and external_name
>      - inode for all filesystems.
> 
> This should give us reasonable memory isolation for most common
> workloads out of the box.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

The patch looks good to me, but I think we still need to add a boot-time
knob to disable kmem accounting, as we do for sockets:

From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH] mm: memcontrol: allow to disable kmem accounting for cgroup2

Kmem accounting might incur overhead that some users can't put up with.
Besides, the implementation is still considered unstable. So let's
provide a way to disable it for those users who aren't happy with it.

To disable kmem accounting for cgroup2, pass cgroup.memory=nokmem at
boot time.

Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1bda3bbb7db..1b7a85dc6013 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -602,6 +602,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	cgroup.memory=	[KNL] Pass options to the cgroup memory controller.
 			Format: <string>
 			nosocket -- Disable socket memory accounting.
+			nokmem -- Disable kernel memory accounting.
 
 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6faea81e66d7..6a5572241dc6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -83,6 +83,9 @@ struct mem_cgroup *root_mem_cgroup __read_mostly;
 /* Socket memory accounting disabled? */
 static bool cgroup_memory_nosocket;
 
+/* Kernel memory accounting disabled? */
+static bool cgroup_memory_nokmem;
+
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
 int do_swap_account __read_mostly;
@@ -2898,8 +2901,8 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 	 * onlined after this point, because it has at least one child
 	 * already.
 	 */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) ||
-	    memcg_kmem_online(parent))
+	if (memcg_kmem_online(parent) ||
+	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nokmem))
 		ret = memcg_online_kmem(memcg);
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
@@ -5587,6 +5590,8 @@ static int __init cgroup_memory(char *s)
 			continue;
 		if (!strcmp(token, "nosocket"))
 			cgroup_memory_nosocket = true;
+		if (!strcmp(token, "nokmem"))
+			cgroup_memory_nokmem = true;
 	}
 	return 0;
 }
