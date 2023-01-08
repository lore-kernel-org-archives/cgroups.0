From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: fix a few kernel-doc warnings & coding style
Date: Sat,  7 Jan 2023 18:12:17 -0800
Message-ID: <20230108021217.15491-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Lma7iRko69ZPpeW5xrn6KMqpGCw11zniVvr/dJegD0Q=; b=a8N02rIfT7KykuX+7Xs0Up/JV0
        P56+5z3gyWyUG/JcsolpKVzPnqT02M2l4Un+4yHhAWQf9oSVOHzJ4zOgnIe86xsg96ah1QiXT0t3S
        RTq5fxAmJjZEZc2XHB3EYI6dqHNx3tLU60wFOhPnWYZudM1SY1Uhk5Agcbrgf4FfuMgXzsPejw+ut
        liLmGDIw0EHZGQuoWZiY6LigcDB4nXvnpq+8jKuPyaZm3YTKtM9+ufcNukOGmrwBhU8XnWQFSoHSp
        Q182LUdfObJh7sJKFTOQWJs7OZLrU5HxxerxES952WwgL40ZztozDGLA7zZ7TOoEWUs4lbYoVvuxR
        vbln4wQQ==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Fix kernel-doc notation warnings:

kernel/cgroup/cpuset.c:1309: warning: Excess function parameter 'cpuset' description in 'update_parent_subparts_cpumask'
kernel/cgroup/cpuset.c:3909: warning: expecting prototype for cpuset_mem_spread_node(). Prototype was for cpuset_spread_node() instead

Also drop a blank line before EXPORT_SYMBOL_GPL() to be consistent
with kernel coding style.

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 kernel/cgroup/cpuset.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -- a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1267,7 +1267,7 @@ static int update_flag(cpuset_flagbits_t
 		       int turning_on);
 /**
  * update_parent_subparts_cpumask - update subparts_cpus mask of parent cpuset
- * @cpuset:  The cpuset that requests change in partition root state
+ * @cs:      The cpuset that requests change in partition root state
  * @cmd:     Partition root state change command
  * @newmask: Optional new cpumask for partcmd_update
  * @tmp:     Temporary addmask and delmask
@@ -3879,8 +3879,7 @@ bool __cpuset_node_allowed(int node, gfp
 }
 
 /**
- * cpuset_mem_spread_node() - On which node to begin search for a file page
- * cpuset_slab_spread_node() - On which node to begin search for a slab page
+ * cpuset_spread_node() - On which node to begin search for a page
  *
  * If a task is marked PF_SPREAD_PAGE or PF_SPREAD_SLAB (as for
  * tasks in a cpuset with is_spread_page or is_spread_slab set),
@@ -3904,12 +3903,14 @@ bool __cpuset_node_allowed(int node, gfp
  * is passed an offline node, it will fall back to the local node.
  * See kmem_cache_alloc_node().
  */
-
 static int cpuset_spread_node(int *rotor)
 {
 	return *rotor = next_node_in(*rotor, current->mems_allowed);
 }
 
+/**
+ * cpuset_mem_spread_node() - On which node to begin search for a file page
+ */
 int cpuset_mem_spread_node(void)
 {
 	if (current->cpuset_mem_spread_rotor == NUMA_NO_NODE)
@@ -3919,6 +3920,9 @@ int cpuset_mem_spread_node(void)
 	return cpuset_spread_node(&current->cpuset_mem_spread_rotor);
 }
 
+/**
+ * cpuset_slab_spread_node() - On which node to begin search for a slab page
+ */
 int cpuset_slab_spread_node(void)
 {
 	if (current->cpuset_slab_spread_rotor == NUMA_NO_NODE)
@@ -3927,7 +3931,6 @@ int cpuset_slab_spread_node(void)
 
 	return cpuset_spread_node(&current->cpuset_slab_spread_rotor);
 }
-
 EXPORT_SYMBOL_GPL(cpuset_mem_spread_node);
 
 /**
