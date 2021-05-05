From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 3/3] mm: memcg/slab: Disable cache merging for KMALLOC_NORMAL caches
Date: Wed,  5 May 2021 16:06:10 -0400
Message-ID: <20210505200610.13943-4-longman@redhat.com>
References: <20210505200610.13943-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620245204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=GObYidJPOxqa39RCGKtF8EH7OG9xQ65JoyiaTRpSe4I=;
        b=ROGDr5sx74lXWOuxtpKSPuFc+I9mD7gQJZ8nzP30UygAQiFuKGhpz7eAP/75pplyjU9ebK
        wNyQvIuf5yYBOkGrDhPTJyaccxyx6uy2+rbeLz8DOoBsKGIySGGtdlg/Tvi6VnjkhqGn0P
        KCeSNZfORxjSSbfqapAz3VT4MQyxiDE=
In-Reply-To: <20210505200610.13943-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The KMALLOC_NORMAL (kmalloc-<n>) caches are for unaccounted objects only
when CONFIG_MEMCG_KMEM is enabled. To make sure that this condition
remains true, we will have to prevent KMALOC_NORMAL caches to merge
with other kmem caches. This is now done by setting its refcount to -1
right after its creation.

Suggested-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/slab_common.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index bbaf41a7c77e..a0ff8e1d8b67 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -841,6 +841,13 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 					kmalloc_info[idx].name[type],
 					kmalloc_info[idx].size, flags, 0,
 					kmalloc_info[idx].size);
+
+	/*
+	 * If CONFIG_MEMCG_KMEM is enabled, disable cache merging for
+	 * KMALLOC_NORMAL caches.
+	 */
+	if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_NORMAL))
+		kmalloc_caches[type][idx]->refcount = -1;
 }
 
 /*
-- 
2.18.1

