From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v2 2/2] cgroup: get rid of populate for memcg
Date: Thu, 22 Mar 2012 22:19:23 +0400
Message-ID: <1332440363-2754-3-git-send-email-glommer@parallels.com>
References: <1332440363-2754-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332440363-2754-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

The last man standing justifying the need for populate() is the
sock memcg initialization functions. Now that we are able to pass
a struct mem_cgroup instead of a struct cgroup to the socket
initialization, there is nothing that stops us from initializing
everything in create().

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d43bfa0..efa29b8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4584,7 +4584,7 @@ static int mem_control_numa_stat_open(struct inode *unused, struct file *file)
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
-static int register_kmem_files(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
+static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	return mem_cgroup_sockets_init(memcg, ss);
 };
@@ -4594,7 +4594,7 @@ static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
 	mem_cgroup_sockets_destroy(memcg);
 }
 #else
-static int register_kmem_files(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
+static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	return 0;
 }
@@ -4932,7 +4932,9 @@ mem_cgroup_create(struct cgroup *cont)
 	atomic_set(&memcg->refcnt, 1);
 	memcg->move_charge_at_immigrate = 0;
 	mutex_init(&memcg->thresholds_lock);
-	return &memcg->css;
+
+	if (!memcg_init_kmem(memcg, &mem_cgroup_subsys))
+		return &memcg->css;
 free_out:
 	__mem_cgroup_free(memcg);
 	return ERR_PTR(error);
@@ -4954,13 +4956,6 @@ static void mem_cgroup_destroy(struct cgroup *cont)
 	mem_cgroup_put(memcg);
 }
 
-static int mem_cgroup_populate(struct cgroup_subsys *ss,
-				struct cgroup *cont)
-{
-	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	return register_kmem_files(memcg, ss);
-}
-
 #ifdef CONFIG_MMU
 /* Handlers for move charge at task migration. */
 #define PRECHARGE_COUNT_AT_ONCE	256
@@ -5468,7 +5463,6 @@ struct cgroup_subsys mem_cgroup_subsys = {
 	.create = mem_cgroup_create,
 	.pre_destroy = mem_cgroup_pre_destroy,
 	.destroy = mem_cgroup_destroy,
-	.populate = mem_cgroup_populate,
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.attach = mem_cgroup_move_task,
-- 
1.7.7.6
