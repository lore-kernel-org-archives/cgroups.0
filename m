From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] mm/memcg: Remove obsolete memcg_free_kmem()
Date: Tue,  5 Oct 2021 16:24:50 -0400
Message-ID: <20211005202450.11775-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633465521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=fphjzfCNo4ZpuqMZyls+oQxve30/shqr62DPT4ol2Kk=;
        b=R42K2PpGzQebBVmX66VxdDAkkaUE/P80NDBx9vTPx/PcKaUvUu0CoCldRNTIP/+WrsKOQr
        MQ+XwznikhSUCCD7cpOM+gIZ5s0q0mtXuNuTB+bQHekCk8NL9zaGbj/Enslg4Mc9V7dXgZ
        MjUkYgFG40JEFdHPXgXQQETAduCjI6s=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Since commit d648bcc7fe65 ("mm: kmem: make memcg_kmem_enabled()
irreversible"), the only thing memcg_free_kmem() does is to call
memcg_offline_kmem() when the memcg is still online which can happen when
online_css() fails due to -ENOMEM. However, the name memcg_free_kmem()
is confusing and it is more clear and straight forward to call
memcg_offline_kmem() directly from mem_cgroup_css_free().

Suggested-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6da5020a8656..96a93c608d80 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3656,13 +3656,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 
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
@@ -3671,9 +3664,6 @@ static int memcg_online_kmem(struct mem_cgroup *memcg)
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 }
-static void memcg_free_kmem(struct mem_cgroup *memcg)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 static int memcg_update_kmem_max(struct mem_cgroup *memcg,
@@ -5308,7 +5298,9 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	cancel_work_sync(&memcg->high_work);
 	mem_cgroup_remove_from_trees(memcg);
 	free_shrinker_info(memcg);
-	memcg_free_kmem(memcg);
+
+	/* Need to offline kmem if online_css() fails */
+	memcg_offline_kmem(memcg);
 	mem_cgroup_free(memcg);
 }
 
-- 
2.18.1

