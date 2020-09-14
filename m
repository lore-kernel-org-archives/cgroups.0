From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 3/3] mm/memcg: Unify swap and memsw page counters
Date: Sun, 13 Sep 2020 22:44:52 -0400
Message-ID: <20200914024452.19167-4-longman@redhat.com>
References: <20200914024452.19167-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600051523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=+lAeArrGnV/U+syM1+KcWlJ8jKPBVWf17BzUlWjyOt4=;
        b=dhYauM8N3r55e3G3TewVXxAFtcwg01mcYLGSYNC3V39kjJwaHGxIG/Myli6KbILJ+ugohc
        8A4Bu2rAt9YmC3czjJ/6KI2xu0QM5LMCfv+5RH89r1K2SMBcaPYhEh+syt8//wmXUrkwDY
        I2ISwIL5LM28PYXajHDk8uspnudTXpo=
In-Reply-To: <20200914024452.19167-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The swap page counter is v2 only while memsw is v1 only. As v1 and v2
controllers cannot be active at the same time, there is no point to keep
both swap and memsw page counters in mem_cgroup. The previous patch has
made sure that memsw page counter is updated and accessed only when in
v1 code paths. So it is now safe to alias the v1 memsw page counter to v2
swap page counter. This saves 14 long's in the size of mem_cgroup. This
is a saving of 112 bytes for 64-bit archs.

While at it, also document which page counters are used in v1 and/or v2.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 13 ++++++++-----
 mm/memcontrol.c            |  3 ---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d0b036123c6a..6ef4a552e09d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -215,13 +215,16 @@ struct mem_cgroup {
 	struct mem_cgroup_id id;
 
 	/* Accounted resources */
-	struct page_counter memory;
-	struct page_counter swap;
+	struct page_counter memory;		/* Both v1 & v2 */
+
+	union {
+		struct page_counter swap;	/* v2 only */
+		struct page_counter memsw;	/* v1 only */
+	};
 
 	/* Legacy consumer-oriented counters */
-	struct page_counter memsw;
-	struct page_counter kmem;
-	struct page_counter tcpmem;
+	struct page_counter kmem;		/* v1 only */
+	struct page_counter tcpmem;		/* v1 only */
 
 	/* Range enforcement for interrupt charges */
 	struct work_struct high_work;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ca36bed588d1..188901f3a3db 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5281,13 +5281,11 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		memcg->use_hierarchy = true;
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
-		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 	} else {
 		page_counter_init(&memcg->memory, NULL);
 		page_counter_init(&memcg->swap, NULL);
-		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
 		page_counter_init(&memcg->tcpmem, NULL);
 		/*
@@ -5416,7 +5414,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
-	page_counter_set_max(&memcg->memsw, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
 	page_counter_set_min(&memcg->memory, 0);
-- 
2.18.1

