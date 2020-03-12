From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: [PATCH 3/6] mm, memcg: Prevent memory.low load/store tearing
Date: Thu, 12 Mar 2020 17:33:01 +0000
Message-ID: <448206f44b0fa7be9dad2ca2601d2bcb2c0b7844.1584034301.git.chris@chrisdown.name>
References: <cover.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wi04zoB+1lwUS/JkrIWiJtz6qrlQUGWxV2d3AofBbt4=;
        b=qdHoaPhxQicwt6H3R0TCGLXYf5k3L9ooFg374fONxjv8C3rvNxgZwp+11xl3vl5riH
         0+LwXAumxpp4RyUzxzdWqtEjG5BG9CDRPl4N6+xAtMsl5UUdZ8hz2enRswBOwYzfdka9
         XGBadlITdSJeRvdGcod95gw7PRehSEFfoQdJU=
Content-Disposition: inline
In-Reply-To: <cover.1584034301.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

This can be set concurrently with reads, which may cause the wrong value
to be propagated.

Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-team-b10kYP2dOMg@public.gmane.org
---
 mm/memcontrol.c   | 4 ++--
 mm/page_counter.c | 9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aca2964ea494..c85a304fa4a1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6262,7 +6262,7 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 		return MEMCG_PROT_NONE;
 
 	emin = memcg->memory.min;
-	elow = memcg->memory.low;
+	elow = READ_ONCE(memcg->memory.low);
 
 	parent = parent_mem_cgroup(memcg);
 	/* No parent means a non-hierarchical mode on v1 memcg */
@@ -6291,7 +6291,7 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 	if (elow && parent_elow) {
 		unsigned long low_usage, siblings_low_usage;
 
-		low_usage = min(usage, memcg->memory.low);
+		low_usage = min(usage, READ_ONCE(memcg->memory.low));
 		siblings_low_usage = atomic_long_read(
 			&parent->memory.children_low_usage);
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 50184929b61f..18b7f779f2e2 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -17,6 +17,7 @@ static void propagate_protected_usage(struct page_counter *c,
 				      unsigned long usage)
 {
 	unsigned long protected, old_protected;
+	unsigned long low;
 	long delta;
 
 	if (!c->parent)
@@ -34,8 +35,10 @@ static void propagate_protected_usage(struct page_counter *c,
 			atomic_long_add(delta, &c->parent->children_min_usage);
 	}
 
-	if (c->low || atomic_long_read(&c->low_usage)) {
-		if (usage <= c->low)
+	low = READ_ONCE(c->low);
+
+	if (low || atomic_long_read(&c->low_usage)) {
+		if (usage <= low)
 			protected = usage;
 		else
 			protected = 0;
@@ -231,7 +234,7 @@ void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages)
 {
 	struct page_counter *c;
 
-	counter->low = nr_pages;
+	WRITE_ONCE(counter->low, nr_pages);
 
 	for (c = counter; c; c = c->parent)
 		propagate_protected_usage(c, atomic_long_read(&c->usage));
-- 
2.25.1

