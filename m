From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/51] memcg: add mem_cgroup_root_css
Date: Fri, 22 May 2015 17:13:20 -0400
Message-ID: <1432329245-5844-7-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Br3a07iQeVVaxJaSGiMIITDMkHEaEF4RjQZKEv1jdnc=;
        b=jP+jXF28z5JPQQ4ajXnU5YNdaqyNn5762AtydyFxfHuhGkj8AATHN3ZakSBVSzV0ip
         MHaDevkSC2EYr3qc+Q76qV+nxKwUWNsUvaoVUJh+JfIbYkSzvnhM9I1/6xm/r6H+tzNA
         9iFoL9PZgiP3oXM/40u36Y3XNmmuxsuYOYHvL7fe++AABcKJiM7DH6OXD6mXngEW18dI
         i5H0K1qqtqokps7/5oc9kq+J3zTcndyqh7+0XYO21PwsDIGB2QjTZlJEOL0C/PWE986o
         g7zcJHtnuICKAXnBtrIEVp7uFZzt7JwvUct8FiidpedgFfg55+BMr01gPdqTk/Jh1BDw
         HAEQ==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

Add global mem_cgroup_root_css which points to the root memcg css.
This will be used by cgroup writeback support.  If memcg is disabled,
it's defined as ERR_PTR(-EINVAL).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
aCc: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h | 4 ++++
 mm/memcontrol.c            | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5fe6411..294498f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -68,6 +68,8 @@ enum mem_cgroup_events_index {
 };
 
 #ifdef CONFIG_MEMCG
+extern struct cgroup_subsys_state *mem_cgroup_root_css;
+
 void mem_cgroup_events(struct mem_cgroup *memcg,
 		       enum mem_cgroup_events_index idx,
 		       unsigned int nr);
@@ -196,6 +198,8 @@ void mem_cgroup_split_huge_fixup(struct page *head);
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
+#define mem_cgroup_root_css ((struct cgroup_subsys_state *)ERR_PTR(-EINVAL))
+
 static inline void mem_cgroup_events(struct mem_cgroup *memcg,
 				     enum mem_cgroup_events_index idx,
 				     unsigned int nr)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c23c1a3..b22a92b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -77,6 +77,7 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 static struct mem_cgroup *root_mem_cgroup __read_mostly;
+struct cgroup_subsys_state *mem_cgroup_root_css __read_mostly;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
@@ -4441,6 +4442,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	/* root ? */
 	if (parent_css == NULL) {
 		root_mem_cgroup = memcg;
+		mem_cgroup_root_css = &memcg->css;
 		page_counter_init(&memcg->memory, NULL);
 		memcg->high = PAGE_COUNTER_MAX;
 		memcg->soft_limit = PAGE_COUNTER_MAX;
-- 
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
