From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: [PATCH RFC 1/2] mm: kmem: optimize get_obj_cgroup_from_current()
Date: Tue, 20 Dec 2022 10:27:44 -0800
Message-ID: <20221220182745.1903540-2-roman.gushchin@linux.dev>
References: <20221220182745.1903540-1-roman.gushchin@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671560883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1c+efmi7i1PNMb6NmmQf0Ro/sE7SMscFhY/KBS3yOLk=;
        b=Wx7bQ5ioJAD+g491R7nSJvJ8QTYMx+OPD/+3NQf2xDyjGmSAIeS5xvA6vaaypoUUowSvau
        T38EBM/MyoOs0D9shUHdyPMcOMxI88n+BDtB5+ZeMySUKoKja9i+0tgo8ESPYw+WmPupoG
        JdpUiHXhDx7tLpgzdmFRX6vTZ0dwRYM=
In-Reply-To: <20221220182745.1903540-1-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Manually inline memcg_kmem_bypass() and active_memcg() to speed up
get_obj_cgroup_from_current() by avoiding duplicate in_task() checks
and active_memcg() readings.

Also add a likely() macro to __get_obj_cgroup_from_memcg():
obj_cgroup_tryget() should succeed at almost all times except
a very unlikely race with the memcg deletion path.

Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
---
 mm/memcontrol.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bafd3cde4507..82828c51d2ea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1047,19 +1047,6 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
 
-static __always_inline bool memcg_kmem_bypass(void)
-{
-	/* Allow remote memcg charging from any context. */
-	if (unlikely(active_memcg()))
-		return false;
-
-	/* Memcg to charge can't be determined. */
-	if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
-		return true;
-
-	return false;
-}
-
 /**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
@@ -3004,7 +2991,7 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		objcg = rcu_dereference(memcg->objcg);
-		if (objcg && obj_cgroup_tryget(objcg))
+		if (likely(objcg && obj_cgroup_tryget(objcg)))
 			break;
 		objcg = NULL;
 	}
@@ -3013,16 +3000,23 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 
 __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
-	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 
-	if (memcg_kmem_bypass())
-		return NULL;
+	if (in_task()) {
+		memcg = current->active_memcg;
+
+		/* Memcg to charge can't be determined. */
+		if (likely(!memcg) && (!current->mm || (current->flags & PF_KTHREAD)))
+			return NULL;
+	} else {
+		memcg = this_cpu_read(int_active_memcg);
+		if (likely(!memcg))
+			return NULL;
+	}
 
 	rcu_read_lock();
-	if (unlikely(active_memcg()))
-		memcg = active_memcg();
-	else
+	if (!memcg)
 		memcg = mem_cgroup_from_task(current);
 	objcg = __get_obj_cgroup_from_memcg(memcg);
 	rcu_read_unlock();
-- 
2.39.0

