From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] mm, memcg: Ensure valid memcg from objcg within a RCU critical section
Date: Fri,  1 Oct 2021 15:09:38 -0400
Message-ID: <20211001190938.14050-4-longman@redhat.com>
References: <20211001190938.14050-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633115422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=eTKxhjw7Yo5S8XqVnMv4HlnJDXI4fKHSCti6PPjnd+Y=;
        b=hPTBwKSyaP/5/I9uCiYpDCGZjbIEJtru0UPT0TuP5z+27AXdMJ2SZjqI/DrIvCdnlp70uT
        7LYVZ68i0wRwYErFasxScxQQMcg0POm9shUg6d9x9aYixRnmLaNMkXZ2FdOPc6/8qvh3eB
        PqN1bddhq18hGLlJ/sy6QiQHIr58/Co=
In-Reply-To: <20211001190938.14050-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

To ensure that a to-be-offlined memcg fetched from objcg remains
valid (has non-zero reference count) within a RCU critical section,
a synchronize_rcu() call is inserted at the end of memcg_offline_kmem().

With that change, we no longer need to use css_tryget()
in get_mem_cgroup_from_objcg() as the final css_put() in
css_killed_work_fn() would not have been called yet.

The obj_cgroup_uncharge_pages() function is simplifed to perform
the whole uncharge operation within a RCU critical section saving a
css_get()/css_put() pair.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8177f253a127..1dbb37d96e49 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2769,10 +2769,8 @@ static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
-retry:
 	memcg = obj_cgroup_memcg(objcg);
-	if (unlikely(!css_tryget(&memcg->css)))
-		goto retry;
+	css_get(&memcg->css);
 	rcu_read_unlock();
 
 	return memcg;
@@ -2947,13 +2945,14 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 {
 	struct mem_cgroup *memcg;
 
-	memcg = get_mem_cgroup_from_objcg(objcg);
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		page_counter_uncharge(&memcg->kmem, nr_pages);
 	refill_stock(memcg, nr_pages);
 
-	css_put(&memcg->css);
+	rcu_read_unlock();
 }
 
 /*
@@ -3672,6 +3671,13 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 	memcg_drain_all_list_lrus(kmemcg_id, parent);
 
 	memcg_free_cache_id(kmemcg_id);
+
+	/*
+	 * To ensure that a to-be-offlined memcg fetched from objcg remains
+	 * valid within a RCU critical section, we need to wait here until
+	 * the a grace period has elapsed.
+	 */
+	synchronize_rcu();
 }
 #else
 static int memcg_online_kmem(struct mem_cgroup *memcg)
-- 
2.18.1

