From: Waiman Long <longman@redhat.com>
Subject: [PATCH 3/3] mm/memcg: Unify swap and memsw page counters
Date: Thu, 20 Aug 2020 09:03:50 -0400
Message-ID: <20200820130350.3211-4-longman@redhat.com>
References: <20200820130350.3211-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597928658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=CJnfEEPsHTayufcqPRv869AJ8y4aZylFQ/z6R8psu84=;
        b=UPxACiMBxNxZKKUPQFu+PLJNdf7byO6EDqF1XmvvgISBNLd4RcyIIY3j1O05xec/rlwGOg
        Lo5AscxcF7r31vtNX+sv3ib4NmEcgDCHJ/daVBpFbn2Jfuf3+/11mVQMu6FbJfJ9EsuTyF
        gqIjrQX6qCANDD9GEET7IWzHHgzU2Lg=
In-Reply-To: <20200820130350.3211-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>, Waiman Long <longman@redhat.com>

The swap page counter is v2 only while memsw is v1 only. As v1 and v2
controllers cannot be active at the same time, there is no point to keep
both swap and memsw page counters in mem_cgroup. The previous patch has
made sure that memsw page counter is updated and accessed only when in
v1 code paths. So it is now safe to alias the v1 memsw page counter to v2
swap page counter. This saves 14 long's in the size of mem_cgroup. This
is a saving of 112 bytes for 64-bit archs.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/memcontrol.h | 3 +--
 mm/memcontrol.c            | 8 +++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d0b036123c6a..d2a819d7db70 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -216,10 +216,9 @@ struct mem_cgroup {
 
 	/* Accounted resources */
 	struct page_counter memory;
-	struct page_counter swap;
+	struct page_counter swap;	/* memsw (memory+swap) for v1 */
 
 	/* Legacy consumer-oriented counters */
-	struct page_counter memsw;
 	struct page_counter kmem;
 	struct page_counter tcpmem;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d219dca5239f..04c3794cdc98 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -68,6 +68,11 @@
 
 #include <trace/events/vmscan.h>
 
+/*
+ * The v1 memsw page counter is aliased to the v2 swap page counter.
+ */
+#define memsw	swap
+
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
@@ -5279,13 +5284,11 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
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
@@ -5414,7 +5417,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
-	page_counter_set_max(&memcg->memsw, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
 	page_counter_set_min(&memcg->memory, 0);
-- 
2.18.1

