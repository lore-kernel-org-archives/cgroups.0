From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] mm, memcg: Remove obsolete memcg_free_kmem()
Date: Fri,  1 Oct 2021 15:09:37 -0400
Message-ID: <20211001190938.14050-3-longman@redhat.com>
References: <20211001190938.14050-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633115421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=4NNmOdozgW34250h3i+XZDY/eQfLDbJdb5QbTC9VPyU=;
        b=OWCUKVzgJjApLLcSlSARA0N48z6Vx1xtqEFqQQSi8uiFBumD0zvRu8RV4qXay/4Ro1P6a3
        Zk5iAgoZBqP5ZLPS6K8O9yvsS99pakcbD8U0CeM+k6tT5uZoD0hwjwmWWMh0rqkMz33e0X
        gWI2DWltxizz9z1/wyBMYMyNZaeRRWA=
In-Reply-To: <20211001190938.14050-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Since commit d648bcc7fe65 ("mm: kmem: make memcg_kmem_enabled()
irreversible"), the only thing memcg_free_kmem() does is to call
memcg_offline_kmem() when the memcg is still online. However,
memcg_offline_kmem() is only called from mem_cgroup_css_free() which
cannot be reached if the memcg hasn't been offlined first. As this
function now serves no purpose, we should just remove it.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4568363062c1..8177f253a127 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3673,13 +3673,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 
 	memcg_free_cache_id(kmemcg_id);
 }
-
-static void memcg_free_kmem(struct mem_cgroup *memcg)
-{
-	/* css_alloc() failed, offlining didn't happen */
-	if (unlikely(memcg->kmem_state == KMEM_ONLINE))
-		memcg_offline_kmem(memcg);
-}
 #else
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
@@ -3688,9 +3681,6 @@ static int memcg_online_kmem(struct mem_cgroup *memcg)
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 }
-static void memcg_free_kmem(struct mem_cgroup *memcg)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 static int memcg_update_kmem_max(struct mem_cgroup *memcg,
@@ -5325,7 +5315,6 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	cancel_work_sync(&memcg->high_work);
 	mem_cgroup_remove_from_trees(memcg);
 	free_shrinker_info(memcg);
-	memcg_free_kmem(memcg);
 	mem_cgroup_free(memcg);
 }
 
-- 
2.18.1

