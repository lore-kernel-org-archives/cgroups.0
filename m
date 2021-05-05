From: Waiman Long <longman@redhat.com>
Subject: [PATCH v4 1/3] mm: memcg/slab: Properly set up gfp flags for objcg pointer array
Date: Wed,  5 May 2021 16:06:08 -0400
Message-ID: <20210505200610.13943-2-longman@redhat.com>
References: <20210505200610.13943-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620245202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=sp6zs1ct6ZutkKpokv+nsMB40a5kSzzW57yCb7izaMY=;
        b=beBzr20NUfxwX7T1Tsi3oIU8SIrKkFubOw4JZoCONgPzFtLX3yeZ1skLbYZUhCe3TuXn3p
        Ed0LpBAOhAqQsV0UBc2ar9pvR7cuGJzihE5NeFq+LEWPCQM6b1FV8OplwIcB5NomrFLI6H
        T7DsXz1sgPJisZv1+VjqJHFHpLr3nZk=
In-Reply-To: <20210505200610.13943-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Waiman Long <longman@redhat.com>

Since the merging of the new slab memory controller in v5.9, the page
structure may store a pointer to obj_cgroup pointer array for slab pages.
Currently, only the __GFP_ACCOUNT bit is masked off. However, the array
is not readily reclaimable and doesn't need to come from the DMA buffer.
So those GFP bits should be masked off as well.

Do the flag bit clearing at memcg_alloc_page_obj_cgroups() to make sure
that it is consistently applied no matter where it is called.

Fixes: 286e04b8ed7a ("mm: memcg/slab: allocate obj_cgroups for non-root slab pages")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
---
 mm/memcontrol.c | 8 ++++++++
 mm/slab.h       | 1 -
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c100265dc393..5e3b4f23b830 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2863,6 +2863,13 @@ static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * The allocated objcg pointers array is not accounted directly.
+ * Moreover, it should not come from DMA buffer and is not readily
+ * reclaimable. So those GFP bits should be masked off.
+ */
+#define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
+
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 				 gfp_t gfp, bool new_page)
 {
@@ -2870,6 +2877,7 @@ int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 	unsigned long memcg_data;
 	void *vec;
 
+	gfp &= ~OBJCGS_CLEAR_MASK;
 	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
 			   page_to_nid(page));
 	if (!vec)
diff --git a/mm/slab.h b/mm/slab.h
index 18c1927cd196..b3294712a686 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -309,7 +309,6 @@ static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 	if (!memcg_kmem_enabled() || !objcg)
 		return;
 
-	flags &= ~__GFP_ACCOUNT;
 	for (i = 0; i < size; i++) {
 		if (likely(p[i])) {
 			page = virt_to_head_page(p[i]);
-- 
2.18.1

