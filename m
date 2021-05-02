From: Waiman Long <longman@redhat.com>
Subject: [PATCH 2/2] mm: memcg/slab: Don't create unfreeable slab
Date: Sun,  2 May 2021 14:07:55 -0400
Message-ID: <20210502180755.445-2-longman@redhat.com>
References: <20210502180755.445-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619978921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=kEFyh88t8RjL4Ya/tUcmCMYYCtAJ4jkovquK5V2cmso=;
        b=ZerIt5R+MVsZ06BNy13VlnPNW9HpjJqVswSmBbFdlqJcNDucTrfNSgOl8bHCTszi8HIvnr
        APYdJDDDwyazFyXMeivVIHqYAHG9WZgG71PSVFLVTpwEFxnRfq/iMlYmlsrbjkr2TYchuh
        sm7jkr2RU/KoqaKvIxc0/27tNnm644c=
In-Reply-To: <20210502180755.445-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Waiman Long <longman@redhat.com>

The obj_cgroup array (memcg_data) embedded in the page structure is
allocated at the first instance an accounted memory allocation happens.
With the right size object, it is possible that the allocated obj_cgroup
array comes from the same slab that requires memory accounting. If this
happens, the slab will never become empty again as there is at least one
object left (the obj_cgroup array) in the slab.

With instructmentation code added to detect this situation, I got 76
hits on the kmalloc-192 slab when booting up a test kernel on a VM.
So this can really happen.

To avoid the creation of these unfreeable slabs, a check is added to
memcg_alloc_page_obj_cgroups() to detect that and double the size
of the array in case it happens to make sure that it comes from a
different kmemcache.

This change, however, does not completely eliminate the presence
of unfreeable slabs which can still happen if a circular obj_cgroup
array dependency is formed.

Fixes: 286e04b8ed7a ("mm: memcg/slab: allocate obj_cgroups for non-root slab pages")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 mm/memcontrol.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b0695d3aa530..44852ac048c3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2876,12 +2876,24 @@ int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 	 */
 	objects = max(objs_per_slab_page(s, page),
 		      (int)(sizeof(struct rcu_head)/sizeof(void *)));
-
+retry:
 	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
 			   page_to_nid(page));
 	if (!vec)
 		return -ENOMEM;
 
+	/*
+	 * The allocated vector should not come from the same slab.
+	 * Otherwise, this slab will never become empty. Double the size
+	 * in this case to make sure that the vector comes from a different
+	 * kmemcache.
+	 */
+	if (unlikely(virt_to_head_page(vec) == page)) {
+		kfree(vec);
+		objects *= 2;
+		goto retry;
+	}
+
 	memcg_data = (unsigned long) vec | MEMCG_DATA_OBJCGS;
 	if (new_page) {
 		/*
-- 
2.18.1

